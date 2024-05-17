#ifndef CAMERAINFOSETTINGS_H
#define CAMERAINFOSETTINGS_H
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>
#include <CameraMetaData.h>
#include <QmlObjectListModel.h>

class CameraInfoSettings : public QObject
{
    Q_OBJECT
public:
    CameraInfoSettings(QObject* parent = nullptr);
    Q_PROPERTY(QmlObjectListModel*  cameraInfoList   READ cameraInfoList      CONSTANT)
//    Q_PROPERTY(CameraMetaData*  curVehicleInfo  READ curVehicleInfo   WRITE setCurVehicleInfo    NOTIFY curVehicleInfoChanged)
    CameraMetaData *getCameraMetaData(const QString &name);

    QmlObjectListModel *cameraInfoList() { return &_cameraInfoList; }

    /**
     * @brief addCameraInfo     添加相机信息
     * @param canonicalName     相机名称
     * @param sensorWidth       传感器宽
     * @param sensorHeight      传感器高
     * @param imageWidth        图像宽
     * @param imageHeight       图像高
     * @param focalLength       焦距
     * @param sceneNum          相机个数
     */
    Q_INVOKABLE void addCameraInfo(const QString &canonicalName, double sensorWidth, double sensorHeight, double imageWidth
                                   , double imageHeight, double focalLength, int sceneNum);
    Q_INVOKABLE void removeCameraInfo(const QString& name);

    void saveCameraInfos();
signals:
    void cameraInfosChanged();

private:
    void _getFileName();
    void _loadCameraInfos();
private slots:
    void _saveCameraInfos();
    void _useDefaultCameraInfos();

private:
    QString _fileName;
    QmlObjectListModel _cameraInfoList;
};

#endif // CAMERAINFOSETTINGS_H
