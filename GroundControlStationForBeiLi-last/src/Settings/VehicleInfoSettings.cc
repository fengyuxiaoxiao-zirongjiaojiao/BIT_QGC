#include "VehicleInfoSettings.h"
#include <QFile>
#include <QFileInfo>
#include <QQmlEngine>
#include <QMetaType>
#include <QGCApplication.h>
#include <SettingsManager.h>

VehicleInfoSettings::VehicleInfoSettings(QObject *parent) : QObject(parent)
  , _curVehicleInfoMetaData(nullptr)
  , _curCameraInfoMetaData(nullptr)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<VehicleInfoSettings*>("VehicleInfoSettings*");

    _typeList << QStringLiteral("旋翼") << QStringLiteral("垂起") << QStringLiteral("固定翼") << QStringLiteral("两栖");
    _getFileName();
    _loadVehicleInfos();
    connect(this, &VehicleInfoSettings::vehicleInfosChanged, this, &VehicleInfoSettings::_saveVehicleInfos);

//    for (int i = 0; i < _vehicleInfoList.count(); i++) {
//        VehicleInfoMetaData* item = _vehicleInfoList.value<VehicleInfoMetaData*>(i);
//        if (item) {
//            qDebug() << "canonicalName" << item->canonicalName << "type" << item->type << "brand" << item->brand;
//        }
//        item->canonicalName = QString("%1%2").arg(item->canonicalName).arg(i);
//    }
    _saveVehicleInfos();
}

void VehicleInfoSettings::setCurVehicleInfo(VehicleInfoMetaData *curVehicleInfo)
{
    if (curVehicleInfo != _curVehicleInfoMetaData) {
        _curVehicleInfoMetaData = curVehicleInfo;
        setCurCameraInfo(qgcApp()->toolbox()->settingsManager()->cameraInfoSettings()->getCameraMetaData(curVehicleInfo->cameraName));
        emit curVehicleInfoChanged();
        emit vehicleInfosChanged();
    }
}

void VehicleInfoSettings::setCurVehicleInfoName(const QString &vehicleInfoName)
{
    if (!vehicleInfoName.isEmpty()) {
        for (int i = 0; i < _vehicleInfoList.count(); i++) {
            VehicleInfoMetaData* item = _vehicleInfoList.value<VehicleInfoMetaData*>(i);
            if (item && item->canonicalName.compare(vehicleInfoName) == 0) {
                setCurVehicleInfo(item);
                break;
            }
        }
    }
}

CameraMetaData *VehicleInfoSettings::curCameraInfo()
{
    return _curCameraInfoMetaData;
}

void VehicleInfoSettings::setCurCameraInfo(CameraMetaData *cameraInfo)
{
    if (cameraInfo != _curCameraInfoMetaData) {
        _curCameraInfoMetaData = cameraInfo;
        emit curCameraInfoChanged();
        emit vehicleInfosChanged();
    }
}

void VehicleInfoSettings::setCurCameraInfoName(const QString &cameraInfoName)
{
    setCurCameraInfo(qgcApp()->toolbox()->settingsManager()->cameraInfoSettings()->getCameraMetaData(cameraInfoName));
}

void VehicleInfoSettings::setCurCameraLandscape(bool landscape)
{
    if (landscape != _curCameraInfoMetaData->landscape) {
        _curCameraInfoMetaData->landscape = landscape;
        qgcApp()->toolbox()->settingsManager()->cameraInfoSettings()->saveCameraInfos();
        emit curCameraLandscapeChanged(landscape);
        emit curCameraInfoChanged();
    }
}

void VehicleInfoSettings::addVehicleInfo(const QString &canonicalName, const QString &brand, const QString &type, double durationOfFlight,
                                         double enduranceMileage, double cruisingSpeed, double sizeWidth, double sizeHeight, double weight)
{
    if (!canonicalName.isEmpty()) {
        VehicleInfoMetaData *vehicleInfo = new VehicleInfoMetaData(canonicalName, "", brand, type, durationOfFlight, enduranceMileage,
                                                                   cruisingSpeed, sizeWidth, sizeHeight, weight);
        _vehicleInfoList.append(vehicleInfo);
        _saveVehicleInfos();
    }
}

void VehicleInfoSettings::removeVehicleInfo(const QString &name)
{
    for (int i = 0; i < _vehicleInfoList.count(); i++) {
        VehicleInfoMetaData* item = _vehicleInfoList.value<VehicleInfoMetaData*>(i);
        if (item && item->canonicalName.compare(name) == 0) {
            _vehicleInfoList.removeAt(i);
            _saveVehicleInfos();
            return;
        }
    }
}

void VehicleInfoSettings::_getFileName()
{
    QSettings settings;
    QString fileName = settings.fileName();
    QFileInfo info(fileName);
    _fileName = QString("%1/%2.json").arg(info.absolutePath()).arg("VehicleInfo");
}

void VehicleInfoSettings::_loadVehicleInfos()
{
    if (_fileName.isEmpty()) _getFileName();
    QFile file(_fileName);
    if (file.open(QFile::ReadOnly)) {
        QByteArray jsonRawData = file.readAll();
        QJsonObject jsonObj = QJsonDocument::fromJson(jsonRawData).object();
        QString curVehicleInfoName;
        if (jsonObj.contains("curVehicleInfo")) {
            curVehicleInfoName = jsonObj["curVehicleInfo"].toString();
        }
        if (!jsonObj.isEmpty() && jsonObj.contains("vehicleInfo")) {
            QJsonArray vehicleInfoList = jsonObj["vehicleInfo"].toArray();
            for (int i = 0; i < vehicleInfoList.count(); i++) {
                QJsonObject cur_i = vehicleInfoList.at(i).toObject();
                QString         canonicalName = cur_i["canonicalName"].toString();
                QString         cameraName = cur_i["cameraName"].toString();
                QString         brand = cur_i["brand"].toString();
                QString         type = cur_i["type"].toString();
                double          durationOfFlight = cur_i["durationOfFlight"].toDouble();
                double          enduranceMileage = cur_i["enduranceMileage"].toDouble();
                double          cruisingSpeed = cur_i["cruisingSpeed"].toDouble();
                double          sizeWidth = cur_i["sizeWidth"].toDouble();
                double          sizeHeight = cur_i["sizeHeight"].toDouble();
                double          weight = cur_i["weight"].toDouble();
                if (!canonicalName.isEmpty()) {
                    VehicleInfoMetaData *vehicleInfo = new VehicleInfoMetaData(canonicalName, cameraName, brand, type, durationOfFlight, enduranceMileage,
                                                                               cruisingSpeed, sizeWidth, sizeHeight, weight);
                    _vehicleInfoList.append(vehicleInfo);
                    if (curVehicleInfoName.compare(canonicalName) == 0) {
                        setCurVehicleInfo(vehicleInfo);
                    }
                }

            }

        }

        file.close();
    }
}

void VehicleInfoSettings::_saveVehicleInfos()
{
    if (_fileName.isEmpty()) _getFileName();
    if (_vehicleInfoList.count() == 0) return;
    QFile file(_fileName);
    QJsonDocument jsonDoc;
    QJsonObject jsonObj;
    QString vehicleType = _typeList.join(" ");
    jsonObj.insert("vehicleType", vehicleType);
    if (_curVehicleInfoMetaData) {
        jsonObj.insert("curVehicleInfo", _curVehicleInfoMetaData->canonicalName);
    }
    QJsonArray vehicleInfos;
    for (int i = 0; i < _vehicleInfoList.count(); i++) {
        VehicleInfoMetaData* item = _vehicleInfoList.value<VehicleInfoMetaData*>(i);
        if (item) {
            QString cameraName = item->cameraName;
            if (_curVehicleInfoMetaData == item && _curCameraInfoMetaData) {
                cameraName = _curCameraInfoMetaData->canonicalName;
            }
            QJsonObject object
            {
                {"canonicalName", item->canonicalName},
                {"cameraName", cameraName},
                {"brand", item->brand},
                {"type", item->type},
                {"durationOfFlight", item->durationOfFlight},
                {"enduranceMileage", item->enduranceMileage},
                {"cruisingSpeed", item->cruisingSpeed},
                {"sizeWidth", item->sizeWidth},
                {"sizeHeight", item->sizeHeight},
                {"weight", item->weight},
            };
            vehicleInfos.insert(i, object);
        }
    }
    jsonObj.insert("vehicleInfo", vehicleInfos);
    jsonDoc.setObject(jsonObj);
    if (file.open(QFile::WriteOnly)) {
        file.write(jsonDoc.toJson());
        file.close();
    }
}
