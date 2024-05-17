#ifndef WEBMSGMANAGER_H
#define WEBMSGMANAGER_H

#include <QObject>
#include "QGCToolbox.h"
#include "QGCApplication.h"
#include <QGeoCoordinate>
#include <QWebChannel>
#include <QWebSocketServer>
#include "websocketclientwrapper.h"
#include "websockettransport.h"
#include "JsContext.h"
#include "MultiVehicleManager.h"
#include <PlanMasterController.h>

class WebMsgManager : public QGCTool
{
    Q_OBJECT
public:
    explicit WebMsgManager(QGCApplication* app, QGCToolbox* toolbox);
    ~WebMsgManager();

    Q_INVOKABLE void setPlanMasterController(PlanMasterController *planMasterController);

    Q_INVOKABLE void setAddWaypointAction(bool addWaypointAction);

    Q_INVOKABLE void RemoveAll();

    Q_INVOKABLE void planWaypoint(bool isPlan);

    Q_INVOKABLE void webRefresh();

    Q_INVOKABLE QGeoCoordinate getMapCenter(void) { return _mapCenter; }

    // Override from QGCTool
    virtual void setToolbox(QGCToolbox *toolbox);
signals:

private slots:
    // to cesium
    void _onVehicleAdded(Vehicle* vehicle);
    void _onVehicleRemoved(Vehicle* vehicle);
    void _onActiveVehicleChanged(Vehicle *activeVehicle);
    void _onCoordinateChanged(QGeoCoordinate coordinate);
    void _onRollChanged(QVariant value);
    void _onPitchChanged(QVariant value);
    void _onYawChanged(QVariant value);
    void _onNewMissionItemsAvailable(bool removeAllRequested);
    void _onNewKmlAvailable(ShapeFileHelper::ShapeType type);
    void _onKmlPolylineTraceModeChanged(); // 画kml的折线
    void _onKmlPolygonTraceModeChanged();  // 画kml的多边形

    void _onSendMsgTimeOut();

    void _onViewPointChanged(QGeoCoordinate coordinate);

    void _setActiveVehicle(int id);

    void _toPlanCesiumSlot() {
        /*if (!_sendToCesium)*/ _toPlanCesium();
    }

    void _onPlanWaypointFromWebSelected(int index);

    // from cesium
    void _onKmlPointFromWebChanged(int type, QGeoCoordinate coor);
    void _onAddWayPointFromWebChanged(QGeoCoordinate coor);
    void _onPlanWaypointFromWebEdited(int index, QString json);

    void _onMissionControllerDirtyChanged();

    void _onMapView3dChanged(QVariant value);
    void _onVideoSourceChanged(QVariant value);

    void _onMapCenterChanged(QGeoCoordinate coor);
private:
    QJsonObject _cameraStatus(Vehicle *vehicle);
    void _vehicleMissionToCesium(Vehicle *vehicle);
    void _activeVehicleToCesium();
    void _toPlanCesium();
    void _updateKmlToCesium();

    QWebSocketServer* _server;
    WebSocketClientWrapper* _clientWrapper;
    QWebChannel* _channel;
    JsContext* _jsContext;

    QTimer _timer;
    Vehicle* _activeVehicle;
    double _roll,_pitch,_yaw;

    bool _addWaypointAction;
    bool _isPlanView;
    bool _sendToCesium = false;
    PlanMasterController* _planMasterController;
    QGeoCoordinate _mapCenter;
};

#endif // WEBMSGMANAGER_H
