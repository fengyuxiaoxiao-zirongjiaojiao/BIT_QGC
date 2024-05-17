#include "WebMsgManager.h"
#include "KmlManager/KmlManager.h"
#include "PlanMasterController.h"
#include "SettingsManager.h"
#include "VehicleInfoSettings.h"
#include "FlightMapSettings.h"
#include <QGCApplication.h>
#include <KmlManager/KmlManager.h>
#include <VisualMissionItem.h>
#include <ComplexMissionItem.h>
#include <MissionSettingsItem.h>
#include <CorridorScanComplexItem.h>
#include <SurveyComplexItem.h>
#include <TakeoffMissionItem.h>
#include <FixedWingLandingComplexItem.h>
#include "JsonHelper.h"

WebMsgManager::WebMsgManager(QGCApplication *app, QGCToolbox *toolbox)
    : QGCTool(app, toolbox)
    , _activeVehicle(nullptr)
    , _roll (0)
    , _pitch(0)
    , _yaw  (0)
    , _isPlanView(false)
    , _planMasterController(nullptr)
{
    // setup the QWebSocketServer
    _server = new QWebSocketServer(QStringLiteral("QWebChannel Standalone Example Server"), QWebSocketServer::NonSecureMode);
    if (!_server->listen(QHostAddress::LocalHost, 9410)) {
        qFatal("Failed to open web socket server.");
        //return 1;
    }

    // wrap WebSocket clients in QWebChannelAbstractTransport objects
    _clientWrapper = new WebSocketClientWrapper(_server);

    // setup the channel
    _channel = new QWebChannel();
    QObject::connect(_clientWrapper, &WebSocketClientWrapper::clientConnected,
                     _channel, &QWebChannel::connectTo);

    // setup the core and publish it to the QWebChannel
    _jsContext = new JsContext();
    _channel->registerObject(QStringLiteral("context"), _jsContext);

    connect(&_timer, &QTimer::timeout, this, &WebMsgManager::_onSendMsgTimeOut);
}

WebMsgManager::~WebMsgManager()
{
    _timer.stop();
    delete _server;
    delete _clientWrapper;
    delete _channel;
    delete _jsContext;
}

void WebMsgManager::setPlanMasterController(PlanMasterController *planMasterController)
{
    _planMasterController = planMasterController;
    connect(_planMasterController->missionController(), &MissionController::dirtyChanged, this, &WebMsgManager::_onMissionControllerDirtyChanged);
    connect(_planMasterController->missionController(), &MissionController::containsItemsChanged, this, &WebMsgManager::_onMissionControllerDirtyChanged);
    connect(_planMasterController->missionController(), &MissionController::plannedHomePositionChanged, this, &WebMsgManager::_onMissionControllerDirtyChanged);
}

void WebMsgManager::setAddWaypointAction(bool addWaypointAction)
{
    _addWaypointAction = addWaypointAction;
    if (_jsContext) {
        double defaultHeight = qgcApp()->toolbox()->settingsManager()->appSettings()->defaultMissionItemAltitude()->rawValue().toDouble();
        _jsContext->cmdWayPoint(defaultHeight, addWaypointAction);
    }
}

void WebMsgManager::RemoveAll()
{
    if (_jsContext) {
        _jsContext->removeKml();
        _jsContext->removeWaypoint();
        _jsContext->removeFlightPath();
    }
}

void WebMsgManager::planWaypoint(bool isPlan)
{
    if (isPlan != _isPlanView) {
        _isPlanView = isPlan;
        if(_jsContext) _jsContext->planView(isPlan);
        _toPlanCesium();
    }
}

void WebMsgManager::webRefresh()
{
    if (_jsContext) {
        QmlObjectListModel *vehicles = qgcApp()->toolbox()->multiVehicleManager()->vehicles();
        for (int i = 0; i < vehicles->count(); i++) {
            Vehicle *vehicle = qobject_cast<Vehicle*>(vehicles->get(i));
            if (vehicle) {
                _jsContext->vehicleAdded(vehicle->id());
                _vehicleMissionToCesium(vehicle);
            }
        }
    }

    _activeVehicleToCesium();

    _onVideoSourceChanged(qgcApp()->toolbox()->settingsManager()->videoSettings()->videoSource()->rawValueString());

    if (_isPlanView) {
        if(_jsContext) _jsContext->planView(_isPlanView);
        _toPlanCesium();
        _updateKmlToCesium();
    }
}

void WebMsgManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);

    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<WebMsgManager>("QGroundControl.WebMsgManager", 1, 0, "WebMsgManager", "Reference only");
    connect(qgcApp()->toolbox()->multiVehicleManager(), &MultiVehicleManager::vehicleAdded, this, &WebMsgManager::_onVehicleAdded);
    connect(qgcApp()->toolbox()->multiVehicleManager(), &MultiVehicleManager::vehicleRemoved, this, &WebMsgManager::_onVehicleRemoved);
    connect(qgcApp()->toolbox()->multiVehicleManager(), &MultiVehicleManager::activeVehicleChanged, this, &WebMsgManager::_onActiveVehicleChanged);
    connect(qgcApp()->toolbox()->kmlManager(), &KmlManager::newKmlAvailable, this, &WebMsgManager::_onNewKmlAvailable);
    connect(qgcApp()->toolbox()->kmlManager(), &KmlManager::polylineTraceModeChanged, this, &WebMsgManager::_onKmlPolylineTraceModeChanged);
    connect(qgcApp()->toolbox()->kmlManager(), &KmlManager::polygonTraceModeChanged, this, &WebMsgManager::_onKmlPolygonTraceModeChanged);
    connect(qgcApp()->toolbox()->settingsManager()->flightMapSettings(), &FlightMapSettings::viewPointChanged, this, &WebMsgManager::_onViewPointChanged);
    connect(qgcApp()->toolbox()->settingsManager()->appSettings()->mapView3d(), &Fact::valueChanged, this, &WebMsgManager::_onMapView3dChanged);
    connect(qgcApp()->toolbox()->settingsManager()->videoSettings()->videoSource(), &Fact::valueChanged, this, &WebMsgManager::_onVideoSourceChanged);
    // from cesium
    connect(_jsContext, &JsContext::activeVehicleFromWebChanged, this, &WebMsgManager::_setActiveVehicle);
    connect(_jsContext, &JsContext::kmlPointFromWebChanged, this, &WebMsgManager::_onKmlPointFromWebChanged);
    connect(_jsContext, &JsContext::addWayPointFromWebChanged, this, &WebMsgManager::_onAddWayPointFromWebChanged);
    connect(_jsContext, &JsContext::planWaypointFromWebEdited, this, &WebMsgManager::_onPlanWaypointFromWebEdited);
    connect(_jsContext, &JsContext::planWaypointFromWebSelected, this, &WebMsgManager::_onPlanWaypointFromWebSelected);
    connect(_jsContext, &JsContext::mapCenterChanged, this, &WebMsgManager::_onMapCenterChanged);
}

void WebMsgManager::_onVehicleAdded(Vehicle *vehicle)
{
    if (vehicle && _jsContext) {
        _jsContext->vehicleAdded(vehicle->id());
        connect(vehicle->missionManager(), &MissionManager::newMissionItemsAvailable, this, &WebMsgManager::_onNewMissionItemsAvailable);
    }
}

void WebMsgManager::_onVehicleRemoved(Vehicle *vehicle)
{
    if (vehicle && _jsContext) {
        _jsContext->vehicleRemoved(vehicle->id());
        disconnect(vehicle->missionManager(), &MissionManager::newMissionItemsAvailable, this, &WebMsgManager::_onNewMissionItemsAvailable);
    }
}

void WebMsgManager::_onActiveVehicleChanged(Vehicle *activeVehicle)
{
    if (_activeVehicle) {
        disconnect(_activeVehicle, &Vehicle::coordinateChanged, this, &WebMsgManager::_onCoordinateChanged);
        disconnect(_activeVehicle->roll(), &Fact::valueChanged, this, &WebMsgManager::_onRollChanged);
        disconnect(_activeVehicle->pitch(), &Fact::valueChanged, this, &WebMsgManager::_onPitchChanged);
        disconnect(_activeVehicle->heading(), &Fact::valueChanged, this, &WebMsgManager::_onYawChanged);
    }
    _activeVehicle = activeVehicle;
    if (_activeVehicle) {
        connect(_activeVehicle, &Vehicle::coordinateChanged, this, &WebMsgManager::_onCoordinateChanged);
        connect(_activeVehicle->roll(), &Fact::valueChanged, this, &WebMsgManager::_onRollChanged);
        connect(_activeVehicle->pitch(), &Fact::valueChanged, this, &WebMsgManager::_onPitchChanged);
        connect(_activeVehicle->heading(), &Fact::valueChanged, this, &WebMsgManager::_onYawChanged);
        // connect(_activeVehicle->missionManager(), &MissionManager::newMissionItemsAvailable, this, &WebMsgManager::_onNewMissionItemsAvailable);
        _timer.start(1000);
        _activeVehicleToCesium();
    } else {
        _timer.stop();
    }
}

void WebMsgManager::_onCoordinateChanged(QGeoCoordinate coordinate)
{
    Q_UNUSED(coordinate)
    if (_jsContext) {
        //_jsContext->sendVehicleStatus(coordinate.latitude(), coordinate.longitude(), coordinate.altitude(), _roll, _pitch, _yaw);
    }
}

void WebMsgManager::_onRollChanged(QVariant value)
{
    _roll = value.toDouble();
}

void WebMsgManager::_onPitchChanged(QVariant value)
{
    _pitch = value.toDouble();
}

void WebMsgManager::_onYawChanged(QVariant value)
{
    _yaw = value.toDouble();
}

void WebMsgManager::_onNewMissionItemsAvailable(bool removeAllRequested)
{
    Q_UNUSED(removeAllRequested);
    MissionManager *missionManager = qobject_cast<MissionManager*>(sender());
    if (missionManager == nullptr) return;
    _vehicleMissionToCesium(missionManager->vehicle());
}

void WebMsgManager::_onNewKmlAvailable(ShapeFileHelper::ShapeType type)
{
    if (_jsContext) {
        QJsonObject obj;
        if (type == ShapeFileHelper::ShapeType::Polygon) {
            QGCMapPolygon* polygon = qgcApp()->toolbox()->kmlManager()->polygon();
            polygon->saveToJson(obj);
        } else if (type == ShapeFileHelper::ShapeType::Polyline) {
            QGCMapPolyline* polyline = qgcApp()->toolbox()->kmlManager()->polyline();
            polyline->saveToJson(obj);
        }
        if (!obj.isEmpty()) {
            QJsonDocument doc;
            doc.setObject(obj);
            _jsContext->drawKml(type, doc.toJson());
        }
    }
}

void WebMsgManager::_onKmlPolylineTraceModeChanged()
{
    if (_jsContext) {
        bool trace = qgcApp()->toolbox()->kmlManager()->polylineTraceMode();
        _jsContext->cmdKml(ShapeFileHelper::ShapeType::Polyline, trace);
    }
}

void WebMsgManager::_onKmlPolygonTraceModeChanged()
{
    if (_jsContext) {
        bool trace = qgcApp()->toolbox()->kmlManager()->polygonTraceMode();
        _jsContext->cmdKml(ShapeFileHelper::ShapeType::Polygon, trace);
    }
}

void WebMsgManager::_onSendMsgTimeOut()
{
    //double lat, double lng, double alt, double roll, double pitch, double yaw
    if (_jsContext) {
        QmlObjectListModel *vehicles = qgcApp()->toolbox()->multiVehicleManager()->vehicles();
        QJsonArray objs;
        for (int i = 0; i < vehicles->count(); i++) {
            Vehicle *vehicle = qobject_cast<Vehicle*>(vehicles->get(i));
            if (vehicle) {
                QJsonObject obj;
                obj.insert("id", vehicle->id());
                obj.insert("latitude", vehicle->latitude());
                obj.insert("longitude", vehicle->longitude());
                obj.insert("altitudeAMSL", vehicle->altitudeAMSL()->rawValue().toFloat());
                obj.insert("altitude", vehicle->altitudeRelative()->rawValue().toFloat());
                obj.insert("roll", vehicle->roll()->rawValue().toFloat());
                obj.insert("pitch", vehicle->pitch()->rawValue().toFloat());
                obj.insert("yaw", vehicle->heading()->rawValue().toFloat());
                obj.insert("isCar", vehicle->isCar());
                obj.insert("isArmed", vehicle->armed());
                obj.insert("camera", _cameraStatus(vehicle));
                objs << obj;
            }
        }
        QJsonObject rootObj;
        rootObj.insert("activeVehicle", _activeVehicle ? _activeVehicle->id() : -1);
        rootObj.insert("vehicles", objs);
        QJsonDocument doc;
        doc.setObject(rootObj);
        _jsContext->sendVehicleStatus(doc.toJson());
    }
}

void WebMsgManager::_onViewPointChanged(QGeoCoordinate coordinate)
{
    if (_jsContext) {
        QJsonObject obj;
        obj.insert("latitude", coordinate.latitude());
        obj.insert("longitude", coordinate.longitude());
        QJsonDocument doc;
        doc.setObject(obj);
        _jsContext->gotoViewPoint(doc.toJson());
    }
}

/*******
 *
 *  下面的数据来自cesium web
 * */
void WebMsgManager::_setActiveVehicle(int id)
{
    QmlObjectListModel *vehicles = qgcApp()->toolbox()->multiVehicleManager()->vehicles();
    if (vehicles) {
        for (int i = 0; i < vehicles->count(); i++) {
            Vehicle *vehicle = qobject_cast<Vehicle*>(vehicles->get(i));
            if (vehicle && vehicle->id() == id) {
                qgcApp()->toolbox()->multiVehicleManager()->setActiveVehicle(vehicle);
            }
        }
    }

}

void WebMsgManager::_onPlanWaypointFromWebSelected(int index)
{
    if (_planMasterController) {
        QmlObjectListModel* visualItems = _planMasterController->missionController()->visualItems();
        if (visualItems && (index >= 0 && index < visualItems->count())) {
            VisualMissionItem*  pVI = qobject_cast<VisualMissionItem*>(_planMasterController->missionController()->visualItems()->get(index));
            if (pVI) {
                int currentSeqNumber = pVI->sequenceNumber();
                _planMasterController->missionController()->setCurrentPlanViewSeqNum(currentSeqNumber, false);
            }
        }
    }
}

void WebMsgManager::_onKmlPointFromWebChanged(int type, QGeoCoordinate coor)
{
    if (type == ShapeFileHelper::Polyline) {
        qgcApp()->toolbox()->kmlManager()->polyline()->appendVertex(coor);
    } else if (type == ShapeFileHelper::Polygon){
        qgcApp()->toolbox()->kmlManager()->polygon()->appendVertex(coor);
    }
}

void WebMsgManager::_onAddWayPointFromWebChanged(QGeoCoordinate coor)
{
    if (_planMasterController && coor.isValid()) {
        int nextIndex = _planMasterController->missionController()->currentPlanViewVIIndex() + 1;
        VisualMissionItem *item = _planMasterController->missionController()->insertSimpleMissionItem(coor, nextIndex, true /* makeCurrentItem */);
        if (item && item->isSimpleItem() && coor.type() == QGeoCoordinate::Coordinate3D) {
            SimpleMissionItem *simItem = qobject_cast<SimpleMissionItem *>(item);
            if (simItem) {
                simItem->altitude()->setRawValue(coor.altitude());
            }
        }
    }
}

void WebMsgManager::_onPlanWaypointFromWebEdited(int index, QString json)
{
    QmlObjectListModel* visualItems = _planMasterController->missionController()->visualItems();
    if (index < 0 || index > visualItems->count() || json.isEmpty()) return;
    if (_planMasterController) {
        QJsonDocument doc = QJsonDocument::fromJson(json.toUtf8());
        //qDebug() << __FILE__ << __func__ << __LINE__ << index << doc << (doc.isEmpty() || !doc.isObject() || !doc.isArray());
        //if (doc.isEmpty() || !doc.isObject() || !doc.isArray()) return;
        if (doc.isObject()) {
            _sendToCesium = false;
            QJsonObject obj = doc.object();
            QString type = obj.value("type").toString();
            if (type == "plannedHomePosition") {
                QGeoCoordinate plannedHomePosition;
                plannedHomePosition.setLatitude(obj.value("latitude").isDouble() ? obj.value("latitude").toDouble() : obj.value("latitude").toString().toDouble());
                plannedHomePosition.setLongitude(obj.value("longitude").isDouble() ? obj.value("longitude").toDouble() : obj.value("longitude").toString().toDouble());
                plannedHomePosition.setAltitude(obj.value("altitude").isDouble() ? obj.value("altitude").toDouble() : obj.value("altitude").toString().toDouble());
                _planMasterController->missionController();
                MissionSettingsItem *settingsItem = visualItems->value<MissionSettingsItem*>(0);
                settingsItem->setCoordinate(plannedHomePosition);
            } else if (type == "SimpleItem") {
                QGeoCoordinate coordinate;
                coordinate.setLatitude(obj.value("latitude").isDouble() ? obj.value("latitude").toDouble() : obj.value("latitude").toString().toDouble());
                coordinate.setLongitude(obj.value("longitude").isDouble() ? obj.value("longitude").toDouble() : obj.value("longitude").toString().toDouble());
                coordinate.setAltitude(obj.value("altitude").isDouble() ? obj.value("altitude").toDouble() : obj.value("altitude").toString().toDouble());
                _planMasterController->missionController();
                SimpleMissionItem *simpleMissionItem = visualItems->value<SimpleMissionItem*>(index);
                simpleMissionItem->setCoordinate(coordinate);
                simpleMissionItem->altitude()->setRawValue(QVariant(coordinate.altitude()));
            } else if (type == "ComplexItem") {
                ComplexMissionItem *complexItem = visualItems->value<ComplexMissionItem*>(index);
                QString patternName = obj.value("patternName").toString();
                if (patternName != complexItem->patternName()) {
                    qCritical() << __FILE__ << __func__ << __LINE__ << QString("patternName(%1) is error in index=%2").arg(patternName).arg(index);
                    return;
                }
                if (complexItem->patternName() == CorridorScanComplexItem::name) {
                    CorridorScanComplexItem *corridorScanComplexItem = qobject_cast<CorridorScanComplexItem*>(complexItem);
                    QGCMapPolyline*  corridorPolyline = corridorScanComplexItem->corridorPolyline();
                    QJsonArray coors = obj.value(QGCMapPolyline::jsonPolylineKey).toArray();
                    QList<QGeoCoordinate> path;
                    for (int i = 0; i < coors.count(); i++) {
                        QJsonArray coor = coors.at(i).toArray();
                        if (coor.count() == 2) {
                            double latitude = coor.at(0).isDouble() ? coor.at(0).toDouble() : coor.at(0).toString().toDouble();
                            double longitude = coor.at(1).isDouble() ? coor.at(1).toDouble() : coor.at(1).toString().toDouble();
                            path << QGeoCoordinate(latitude, longitude);
                        }
                    }
                    if (!path.isEmpty()) {
                        corridorPolyline->clear();
                        corridorPolyline->appendVertices(path);
                    }
                } else if (complexItem->patternName() == SurveyComplexItem::name) {
                    SurveyComplexItem *surveyComplexItem = qobject_cast<SurveyComplexItem*>(complexItem);
                    QGCMapPolygon *surveyPolygon = surveyComplexItem->surveyAreaPolygon();
                    QJsonArray coors = obj.value(QGCMapPolygon::jsonPolygonKey).toArray();
                    QList<QGeoCoordinate> path;
                    for (int i = 0; i < coors.count(); i++) {
                        QJsonArray coor = coors.at(i).toArray();
                        if (coor.count() == 2) {
                            double latitude = coor.at(0).isDouble() ? coor.at(0).toDouble() : coor.at(0).toString().toDouble();
                            double longitude = coor.at(1).isDouble() ? coor.at(1).toDouble() : coor.at(1).toString().toDouble();
                            path << QGeoCoordinate(latitude, longitude);
                        }
                    }
                    if (!path.isEmpty()) {
                        surveyPolygon->clear();
                        surveyPolygon->appendVertices(path);
                    }
                } else if (complexItem->patternName() == FixedWingLandingComplexItem::name) {
                    FixedWingLandingComplexItem *fixedWingLandingComplexItem = qobject_cast<FixedWingLandingComplexItem*>(complexItem);
                    QJsonObject landingCoorObj = obj.value("landingCoordinate").toObject();
                    QGeoCoordinate landingCoor;
                    landingCoor.setLatitude(landingCoorObj.value("latitude").isDouble() ? landingCoorObj.value("latitude").toDouble() : landingCoorObj.value("latitude").toString().toDouble());
                    landingCoor.setLongitude(landingCoorObj.value("longitude").isDouble() ? landingCoorObj.value("longitude").toDouble() : landingCoorObj.value("longitude").toString().toDouble());
                    landingCoor.setAltitude(0);
                    fixedWingLandingComplexItem->setLandingCoordinate(landingCoor);

                    QJsonObject finalApproachCoordObj = obj.value("finalApproachCoordinate").toObject();
                    QGeoCoordinate finalApproachCoord;
                    finalApproachCoord.setLatitude(finalApproachCoordObj.value("latitude").isDouble() ? finalApproachCoordObj.value("latitude").toDouble() : finalApproachCoordObj.value("latitude").toString().toDouble());
                    finalApproachCoord.setLongitude(finalApproachCoordObj.value("longitude").isDouble() ? finalApproachCoordObj.value("longitude").toDouble() : finalApproachCoordObj.value("longitude").toString().toDouble());
                    finalApproachCoord.setAltitude(finalApproachCoordObj.value("altitude").isDouble() ? finalApproachCoordObj.value("altitude").toDouble() : finalApproachCoordObj.value("altitude").toString().toDouble());
                    fixedWingLandingComplexItem->setFinalApproachCoordinate(finalApproachCoord);
                    fixedWingLandingComplexItem->finalApproachAltitude()->setRawValue(QVariant(finalApproachCoord.altitude()));
                }
            }
        } else {

        }
        QTimer::singleShot(1000, this, SLOT(_toPlanCesiumSlot()));
    }
}
/*******
 *
 *  上面的数据来自cesium web
 * */

void WebMsgManager::_onMissionControllerDirtyChanged()
{
    //bool mapView3d = qgcApp()->toolbox()->settingsManager()->appSettings()->mapView3d()->rawValue().toBool();
    //qDebug() << __FILE__ << __func__ << __LINE__ << "_isPlanView:" << _isPlanView << mapView3d;
    _toPlanCesium();
}

void WebMsgManager::_onMapView3dChanged(QVariant value)
{
    if (value.toBool()) {
        _toPlanCesium();
        _updateKmlToCesium();
    }
}

void WebMsgManager::_onVideoSourceChanged(QVariant value)
{
    if (_jsContext) {
        QString videoSource = value.toString();
        if (videoSource == qgcApp()->toolbox()->settingsManager()->videoSettings()->rtspVideoSource()) {
            _jsContext->videoPath(qgcApp()->toolbox()->settingsManager()->videoSettings()->rtspUrl()->rawValueString());
        }
    }
}

void WebMsgManager::_onMapCenterChanged(QGeoCoordinate coor)
{
    if (_mapCenter != coor) {
        _mapCenter = coor;
    }
}

QJsonObject WebMsgManager::_cameraStatus(Vehicle *vehicle)
{
    float roll = 0, pitch = 0, yaw = 0;
    float hfov = 0, vfov = 0;
    QString   canonicalName = "";
    QString   brand = "";
    QString   model = "";
    double           sensorWidth = 0;
    double           sensorHeight = 0;
    double           imageWidth = 0;
    double           imageHeight = 0;
    double           focalLength = 0;
    bool             landscape = false;
    bool             fixedOrientation = false;
    double           minTriggerInterval = 0;
    int              sceneNum = 1;

    if (vehicle) {
        roll = vehicle->roll()->rawValue().toFloat();
        pitch = vehicle->pitch()->rawValue().toFloat();
        yaw = vehicle->heading()->rawValue().toFloat();
    }

    CameraMetaData *camera = qgcApp()->toolbox()->settingsManager()->vehicleInfoSettings()->curCameraInfo();
    if (camera) {
        hfov = camera->hfov();
        vfov = camera->vfov();
        canonicalName = camera->canonicalName;
        brand = camera->brand;
        model = camera->model;
        sensorWidth = camera->sensorWidth;
        sensorHeight = camera->sensorHeight;
        imageWidth = camera->imageWidth;
        imageHeight = camera->imageHeight;
        focalLength = camera->focalLength;
        landscape = camera->landscape;
        fixedOrientation = camera->fixedOrientation;
        minTriggerInterval = camera->minTriggerInterval;
        sceneNum = camera->sceneNum;
    }
    QJsonObject obj;
    obj.insert("roll", roll);
    obj.insert("pitch", pitch);
    obj.insert("yaw", yaw);
    obj.insert("HFOV", hfov);
    obj.insert("VFOV", vfov);
    obj.insert("canonicalName", canonicalName);
    obj.insert("brand", brand);
    obj.insert("model", model);
    obj.insert("sensorWidth", sensorWidth);
    obj.insert("sensorHeight", sensorHeight);
    obj.insert("imageWidth", imageWidth);
    obj.insert("imageHeight", imageHeight);
    obj.insert("focalLength", focalLength);
    obj.insert("landscape", landscape);
    obj.insert("fixedOrientation", fixedOrientation);
    obj.insert("minTriggerInterval", minTriggerInterval);
    obj.insert("sceneNum", sceneNum);

    return obj;
}

void WebMsgManager::_vehicleMissionToCesium(Vehicle *vehicle)
{
    if (vehicle && _jsContext) {
        QJsonArray waypoints;
        QList<MissionItem*> items = vehicle->missionManager()->missionItems();
        for (int i = 0; i < items.count(); i++) {
            MissionItem* item = items.at(i);
            if (item && item->command() < MAV_CMD_NAV_LAST) {
                QJsonObject obj;
                obj.insert("command", item->command());
                obj.insert("latitude", item->coordinate().latitude());
                obj.insert("longitude", item->coordinate().longitude());
                obj.insert("altitude", item->coordinate().altitude());
                obj.insert("sequenceNumber", item->sequenceNumber());
                obj.insert("relativeAltitude", item->relativeAltitude());
                obj.insert("param1", item->param1());
                obj.insert("param2", item->param2());
                obj.insert("param3", item->param3());
                obj.insert("param4", item->param4());
                obj.insert("param5", item->param5());
                obj.insert("param6", item->param6());
                obj.insert("param7", item->param7());
                waypoints << obj;
            }
        }
        QJsonDocument doc;

        QJsonObject docObj;
        docObj.insert("id", vehicle->id());
        docObj.insert("active", vehicle == _activeVehicle);
        docObj.insert("color", vehicle->color());
        docObj.insert("activeColor", vehicle->activeColor());
        docObj.insert("waypoints", waypoints);
        doc.setObject(docObj);
        _jsContext->drawWayPoint(doc.toJson());
        //qDebug() << doc;
    }
}

void WebMsgManager::_activeVehicleToCesium()
{
    if (_jsContext && _activeVehicle) {
        _jsContext->cmdTrackVehicle(_activeVehicle->id());
        QJsonObject obj;
        obj.insert("id", _activeVehicle->id());
        obj.insert("color", _activeVehicle->color());
        obj.insert("activeColor", _activeVehicle->activeColor());
        QJsonDocument doc;
        doc.setObject(obj);
        _jsContext->activeVehicleChanged(doc.toJson());
    }
}

void WebMsgManager::_toPlanCesium()
{
    _sendToCesium = true;
    bool mapView3d = qgcApp()->toolbox()->settingsManager()->appSettings()->mapView3d()->rawValue().toBool();
    if (_isPlanView && mapView3d) {
        QJsonDocument doc;
        QJsonArray arry;
        QmlObjectListModel* visualItems = _planMasterController->missionController()->visualItems();
        if (visualItems == nullptr) return;
        bool hasVisualItems = visualItems->count() > 1;
        if (visualItems->count() > 0) {
            MissionSettingsItem *missionSettingsItem = qobject_cast<MissionSettingsItem*>(visualItems->get(0));
            QJsonObject obj;
            obj.insert("latitude", missionSettingsItem->coordinate().latitude());
            obj.insert("longitude", missionSettingsItem->coordinate().longitude());
            obj.insert("altitude", missionSettingsItem->coordinate().altitude());
            obj.insert("command", "settings");
            obj.insert("type", "plannedHomePosition");
            obj.insert("sequenceNumber", missionSettingsItem->sequenceNumber());
            arry.insert(0, obj);
        }

        QMetaEnum metaAltitudeMode = QMetaEnum::fromType<QGroundControlQmlGlobal::AltitudeMode>();
        for (int i = 1; i < visualItems->count(); i++) {
            VisualMissionItem *visualItem = qobject_cast<VisualMissionItem*>(visualItems->get(i));
            bool isSimpleItem = visualItem->isSimpleItem();
            QJsonObject obj;
            if (isSimpleItem) {
                SimpleMissionItem *simpleMissionItem = qobject_cast<SimpleMissionItem*>(visualItem);
                QGeoCoordinate coordinate;
                QString str = simpleMissionItem->commandName();
                if (simpleMissionItem->isTakeoffItem()) {
                    TakeoffMissionItem *takeoffMissionItem = qobject_cast<TakeoffMissionItem*>(simpleMissionItem);
                    coordinate = takeoffMissionItem->launchCoordinate();
                } else if (simpleMissionItem->isLandCommand()) {
                    coordinate = simpleMissionItem->coordinate();
                } else {
                    coordinate = simpleMissionItem->coordinate();
                }
                coordinate.setAltitude(simpleMissionItem->altitude()->rawValue().toDouble());
                obj.insert("latitude", coordinate.latitude());
                obj.insert("longitude", coordinate.longitude());
                obj.insert("altitude", coordinate.altitude());
                obj.insert("altitudeMode", metaAltitudeMode.valueToKey(simpleMissionItem->altitudeMode()));
                obj.insert("command", str);
                obj.insert("type", "SimpleItem");
            } else {
                ComplexMissionItem *complexItem = qobject_cast<ComplexMissionItem*>(visualItem);
                if (complexItem->patternName() == CorridorScanComplexItem::name) {
                    CorridorScanComplexItem *corridorScanComplexItem = qobject_cast<CorridorScanComplexItem*>(complexItem);
                    QGCMapPolyline*  corridorPolyline = corridorScanComplexItem->corridorPolyline();
                    corridorPolyline->saveToJson(obj);
                    QJsonObject polygonObj;
                    QGCMapPolygon *surveyPolygon = corridorScanComplexItem->surveyAreaPolygon();
                    surveyPolygon->saveToJson(polygonObj);
                    if (!polygonObj.isEmpty()) {
                        obj.insert(polygonObj.keys().first(), polygonObj.value(polygonObj.keys().first()));
                    }
                    double distanceToSurface = corridorScanComplexItem->cameraCalc()->distanceToSurface()->rawValue().toDouble();
                    obj.insert("distanceToSurface", distanceToSurface);
                    QVariantList    visualTransectPoints = corridorScanComplexItem->visualTransectPoints();
                    QJsonValue  transectPointsJson;
                    // Save transects polyline
                    JsonHelper::saveGeoCoordinateArray(visualTransectPoints, false /* writeAltitude */, transectPointsJson);
                    obj.insert("visualTransectPoints", transectPointsJson);
                } else if (complexItem->patternName() == SurveyComplexItem::name) {
                    SurveyComplexItem *surveyComplexItem = qobject_cast<SurveyComplexItem*>(complexItem);
                    QGCMapPolygon *surveyPolygon = surveyComplexItem->surveyAreaPolygon();
                    surveyPolygon->saveToJson(obj);
                    double distanceToSurface = surveyComplexItem->cameraCalc()->distanceToSurface()->rawValue().toDouble();
                    obj.insert("distanceToSurface", distanceToSurface);
                    QVariantList    visualTransectPoints = surveyComplexItem->visualTransectPoints();
                    QJsonValue  transectPointsJson;
                    // Save transects polyline
                    JsonHelper::saveGeoCoordinateArray(visualTransectPoints, false /* writeAltitude */, transectPointsJson);
                    obj.insert("visualTransectPoints", transectPointsJson);
                } else if (complexItem->patternName() == FixedWingLandingComplexItem::name) {
                    FixedWingLandingComplexItem *fixedWingLandingComplexItem = qobject_cast<FixedWingLandingComplexItem*>(complexItem);
                    QJsonObject landingCoorObj;
                    landingCoorObj.insert("latitude", fixedWingLandingComplexItem->landingCoordinate().latitude());
                    landingCoorObj.insert("longitude", fixedWingLandingComplexItem->landingCoordinate().longitude());
                    landingCoorObj.insert("altitude", fixedWingLandingComplexItem->landingAltitude()->rawValue().toDouble());
                    obj.insert("landingCoordinate", landingCoorObj);
                    QJsonObject finalApproachCoordObj;
                    finalApproachCoordObj.insert("latitude", fixedWingLandingComplexItem->finalApproachCoordinate().latitude());
                    finalApproachCoordObj.insert("longitude", fixedWingLandingComplexItem->finalApproachCoordinate().longitude());
                    finalApproachCoordObj.insert("altitude", fixedWingLandingComplexItem->finalApproachAltitude()->rawValue().toDouble());
                    obj.insert("finalApproachCoordinate", finalApproachCoordObj);
                    obj.insert("loiterRadius", fixedWingLandingComplexItem->loiterRadius()->rawValue().toDouble());
                    obj.insert("loiterClockwise", fixedWingLandingComplexItem->loiterClockwise()->rawValue().toBool());
                    obj.insert("useLoiterToAlt", fixedWingLandingComplexItem->useLoiterToAlt()->rawValue().toBool());
                    obj.insert("finalApproachAltitudeMode", metaAltitudeMode.valueToKey(fixedWingLandingComplexItem->altitudesAreRelative() ? 1 : 2));
                    obj.insert("landingDistance", fixedWingLandingComplexItem->landingDistance()->rawValueString());
                }
                obj.insert("patternName", complexItem->patternName());
                obj.insert("type", "ComplexItem");
            }
            if (!obj.isEmpty()) {
                obj.insert("sequenceNumber", visualItem->sequenceNumber());
                arry.insert(i, obj);
            }
        }
        doc.setArray(arry);

        if (!doc.isEmpty() && _jsContext && hasVisualItems) {
            _jsContext->planWaypoint(doc.toJson());
        }
        //qDebug() << "hasVisualItems:" << hasVisualItems << doc;
    }
}

void WebMsgManager::_updateKmlToCesium()
{
    if (_jsContext) {
        ShapeFileHelper::ShapeType type;
        QGCMapPolygon* polygon = qgcApp()->toolbox()->kmlManager()->polygon();
        if (polygon && polygon->isValid()) {
            QJsonObject obj;
            polygon->saveToJson(obj);
            type = ShapeFileHelper::ShapeType::Polygon;
            if (!obj.isEmpty()) {
                QJsonDocument doc;
                doc.setObject(obj);
                _jsContext->drawKml(type, doc.toJson());
            }
        }

        QGCMapPolyline* polyline = qgcApp()->toolbox()->kmlManager()->polyline();
        if (polyline && polyline->isValid()) {
            QJsonObject obj;
            polyline->saveToJson(obj);
            type = ShapeFileHelper::ShapeType::Polyline;
            if (!obj.isEmpty()) {
                QJsonDocument doc;
                doc.setObject(obj);
                _jsContext->drawKml(type, doc.toJson());
            }
        }
    }
}
