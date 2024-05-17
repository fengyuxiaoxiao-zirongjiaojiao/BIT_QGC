#ifndef VEHICLEINFOSETTINGS_H
#define VEHICLEINFOSETTINGS_H
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <VehicleInfoMetaData.h>
#include <CameraMetaData.h>
#include <QmlObjectListModel.h>

class VehicleInfoSettings : public QObject
{
    Q_OBJECT
public:
    VehicleInfoSettings(QObject* parent = nullptr);
    Q_PROPERTY(QmlObjectListModel*  vehicleInfoList   READ vehicleInfoList      CONSTANT)
    Q_PROPERTY(QStringList       typeList    READ typeList    CONSTANT)
    Q_PROPERTY(VehicleInfoMetaData*  curVehicleInfo  READ curVehicleInfo   WRITE setCurVehicleInfo    NOTIFY curVehicleInfoChanged)
    Q_PROPERTY(CameraMetaData*  curCameraInfo        READ curCameraInfo    WRITE setCurCameraInfo     NOTIFY curCameraInfoChanged)


    QmlObjectListModel *vehicleInfoList() { return &_vehicleInfoList; }
    QStringList typeList() { return _typeList; }
    VehicleInfoMetaData *curVehicleInfo() { return _curVehicleInfoMetaData; }
    void setCurVehicleInfo(VehicleInfoMetaData *curVehicleInfo);
    Q_INVOKABLE void setCurVehicleInfoName(const QString &vehicleInfoName);

    CameraMetaData *curCameraInfo();
    void setCurCameraInfo(CameraMetaData* cameraInfo);
    Q_INVOKABLE void setCurCameraInfoName(const QString &cameraInfoName);

    Q_INVOKABLE void setCurCameraLandscape(bool landscape);

    /**
     * @brief addVehicleInfo    添加飞机信息
     * @param canonicalName     名称
     * @param brand             品牌
     * @param type              类型
     * @param durationOfFlight 续航时间
     * @param enduranceMileage 续航里程
     * @param cruisingSpeed    巡航速度
     * @param sizeWidth        飞机尺寸 长
     * @param sizeHeight       飞机尺寸 宽
     * @param weight           重量
     */
    Q_INVOKABLE void addVehicleInfo(const QString &canonicalName, const QString &brand, const QString &type, double durationOfFlight,
                                    double enduranceMileage, double cruisingSpeed, double sizeWidth, double sizeHeight, double weight);
    Q_INVOKABLE void removeVehicleInfo(const QString& name);
signals:
    void curVehicleInfoChanged();
    void curCameraInfoChanged();
    void vehicleInfosChanged();
    void curCameraLandscapeChanged(bool landscape);
private:
    void _getFileName();
    void _loadVehicleInfos();
private slots:
    void _saveVehicleInfos();

private:
    QString _fileName;
    QmlObjectListModel _vehicleInfoList;
    QStringList _typeList;
    VehicleInfoMetaData *_curVehicleInfoMetaData;
    CameraMetaData *_curCameraInfoMetaData;
};

#endif // VEHICLEINFOSETTINGS_H
