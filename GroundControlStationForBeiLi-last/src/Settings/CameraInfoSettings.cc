#include "CameraInfoSettings.h"
#include <QFile>
#include <QFileInfo>
#include <QQmlEngine>
#include <QMetaType>
#include <QGCApplication.h>

CameraInfoSettings::CameraInfoSettings(QObject *parent) : QObject(parent)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<CameraInfoSettings*>("CameraInfoSettings*");
    _getFileName();
    _loadCameraInfos();
    connect(this, &CameraInfoSettings::cameraInfosChanged, this, &CameraInfoSettings::_saveCameraInfos);
}

CameraMetaData* CameraInfoSettings::getCameraMetaData(const QString &name)
{
    if (!name.isEmpty()) {
        for (int i = 0; i < _cameraInfoList.count(); i++) {
            CameraMetaData* item = _cameraInfoList.value<CameraMetaData*>(i);
            if (item && item->canonicalName.compare(name) == 0) {
                return item;
            }
        }
    }
    return nullptr;
}

void CameraInfoSettings::addCameraInfo(const QString &canonicalName, double sensorWidth, double sensorHeight, double imageWidth
                                       , double imageHeight, double focalLength, int sceneNum)
{
    if (!canonicalName.isEmpty()) {
        CameraMetaData* metaData;

        metaData = new CameraMetaData(
                    canonicalName,     // canonical name saved in plan file
                    tr("unknow brand"),         // brand
                    tr("unknow model"),         // model
                    sensorWidth,                // sensorWidth
                    sensorHeight,               // sensorHeight
                    imageWidth,                 // imageWidth
                    imageHeight,                // imageHeight
                    focalLength,                // focalLength
                    true,                       // true: landscape orientation
                    false,                      // true: camera is fixed orientation
                    0,                          // minimum trigger interval
                    tr("Custom Camera"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    sceneNum,
                    this);
        _cameraInfoList.append(metaData);
        _saveCameraInfos();
    }
}

void CameraInfoSettings::removeCameraInfo(const QString &name)
{
    for (int i = 0; i < _cameraInfoList.count(); i++) {
        CameraMetaData* item = _cameraInfoList.value<CameraMetaData*>(i);
        if (item && item->canonicalName.compare(name) == 0) {
            _cameraInfoList.removeAt(i);
            _saveCameraInfos();
            return;
        }
    }
}

void CameraInfoSettings::saveCameraInfos()
{
    _saveCameraInfos();
}

void CameraInfoSettings::_getFileName()
{
    QSettings settings;
    QString fileName = settings.fileName();
    QFileInfo info(fileName);
    _fileName = QString("%1/%2.json").arg(info.absolutePath()).arg("CameraInfo");
}

void CameraInfoSettings::_loadCameraInfos()
{
    if (_fileName.isEmpty()) _getFileName();
    QFile file(_fileName);
    if (file.exists()) {
        if (file.open(QFile::ReadOnly)) {
            QByteArray jsonRawData = file.readAll();
            file.close();
            QJsonObject jsonObj = QJsonDocument::fromJson(jsonRawData).object();
            if (!jsonObj.isEmpty() && jsonObj.contains("cameraInfo")) {
                QJsonArray cameraInfoList = jsonObj["cameraInfo"].toArray();
                for (int i = 0; i < cameraInfoList.count(); i++) {
                    QJsonObject cur_i = cameraInfoList.at(i).toObject();
                    QString         canonicalName = cur_i["canonicalName"].toString();
                    QString         cameraName = cur_i["cameraName"].toString();
                    QString         brand = cur_i["brand"].toString();
                    QString         model = cur_i["model"].toString();
                    double          sensorWidth = cur_i["sensorWidth"].toDouble();
                    double          sensorHeight = cur_i["sensorHeight"].toDouble();
                    double          imageWidth = cur_i["imageWidth"].toDouble();
                    double          imageHeight = cur_i["imageHeight"].toDouble();
                    double          focalLength = cur_i["focalLength"].toDouble();
                    bool            landscape = cur_i["landscape"].toBool();
                    bool            fixedOrientation = cur_i["fixedOrientation"].toBool();
                    double          minTriggerInterval = cur_i["minTriggerInterval"].toDouble();
                    QString         deprecatedTranslatedName = cur_i["deprecatedTranslatedName"].toString();
                    int             sceneNum = cur_i["sceneNum"].toInt();
                    if (!canonicalName.isEmpty()) {
                        CameraMetaData *cameraInfo = new CameraMetaData(canonicalName, brand, model, sensorWidth, sensorHeight,
                                                                         imageWidth, imageHeight, focalLength, landscape,
                                                                         fixedOrientation, minTriggerInterval, deprecatedTranslatedName, sceneNum);
                        _cameraInfoList.append(cameraInfo);
                    }

                }

            } else {
                _useDefaultCameraInfos();
            }
        }
    } else {
        _useDefaultCameraInfos();
    }
}

void CameraInfoSettings::_saveCameraInfos()
{
    if (_fileName.isEmpty()) _getFileName();
    if (_cameraInfoList.count() == 0) return;
    QFile file(_fileName);
    QJsonDocument jsonDoc;
    QJsonObject jsonObj;
    QJsonArray cameraInfos;
    for (int i = 0; i < _cameraInfoList.count(); i++) {
        CameraMetaData* item = _cameraInfoList.value<CameraMetaData*>(i);
        if (item) {
            QJsonObject object
            {
                {"canonicalName", item->canonicalName},
                {"brand", item->brand},
                {"model", item->model},
                {"sensorWidth", item->sensorWidth},
                {"sensorHeight", item->sensorHeight},
                {"imageWidth", item->imageWidth},
                {"imageHeight", item->imageHeight},
                {"focalLength", item->focalLength},
                {"landscape", item->landscape},
                {"fixedOrientation", item->fixedOrientation},
                {"minTriggerInterval", item->minTriggerInterval},
                {"deprecatedTranslatedName", item->deprecatedTranslatedName},
                {"sceneNum", item->sceneNum},
            };
            cameraInfos.insert(i, object);
        }
    }
    jsonObj.insert("cameraInfo", cameraInfos);
    jsonDoc.setObject(jsonObj);
    if (file.open(QFile::WriteOnly)) {
        file.write(jsonDoc.toJson());
        file.close();
    }
}

void CameraInfoSettings::_useDefaultCameraInfos()
{
    if (_cameraInfoList.count() == 0) {
        CameraMetaData* metaData;

        metaData = new CameraMetaData(
                    // Canon S100 @ 5.2mm f/2
                    "Canon S100 PowerShot",     // canonical name saved in plan file
                    tr("Canon"),                // brand
                    tr("S100 PowerShot"),       // model
                    7.6,                        // sensorWidth
                    5.7,                        // sensorHeight
                    4000,                       // imageWidth
                    3000,                       // imageHeight
                    5.2,                        // focalLength
                    true,                       // true: landscape orientation
                    false,                      // true: camera is fixed orientation
                    0,                          // minimum trigger interval
                    tr("Canon S100 PowerShot"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                      // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    //tr("Canon EOS-M 22mm f/2"),
                    "Canon EOS-M 22mm",
                    tr("Canon"),
                    tr("EOS-M 22mm"),
                    22.3,                   // sensorWidth
                    14.9,                   // sensorHeight
                    5184,                   // imageWidth
                    3456,                   // imageHeight
                    22,                     // focalLength
                    true,                   // true: landscape orientation
                    false,                  // true: camera is fixed orientation
                    0,                      // minimum trigger interval
                    tr("Canon EOS-M 22mm"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                  // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    // Canon G9X @ 10.2mm f/2
                    "Canon G9 X PowerShot",
                    tr("Canon"),
                    tr("G9 X PowerShot"),
                    13.2,                       // sensorWidth
                    8.8,                        // sensorHeight
                    5488,                       // imageWidth
                    3680,                       // imageHeight
                    10.2,                       // focalLength
                    true,                       // true: landscape orientation
                    false,                      // true: camera is fixed orientation
                    0,                          // minimum trigger interval
                    tr("Canon G9 X PowerShot"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                      // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    // Canon SX260 HS @ 4.5mm f/3.5
                    "Canon SX260 HS PowerShot",
                    tr("Canon"),
                    tr("SX260 HS PowerShot"),
                    6.17,                           // sensorWidth
                    4.55,                           // sensorHeight
                    4000,                           // imageWidth
                    3000,                           // imageHeight
                    4.5,                            // focalLength
                    true,                           // true: landscape orientation
                    false,                          // true: camera is fixed orientation
                    0,                              // minimum trigger interval
                    tr("Canon SX260 HS PowerShot"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                          // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "GoPro Hero 4",
                    tr("GoPro"),
                    tr("Hero 4"),
                    6.17,               // sensorWidth
                    4.55,               // sendsorHeight
                    4000,               // imageWidth
                    3000,               // imageHeight
                    2.98,               // focalLength
                    true,               // landscape
                    false,              // fixedOrientation
                    0,                  // minTriggerInterval
                    tr("GoPro Hero 4"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Parrot Sequioa RGB",
                    tr("Parrot"),
                    tr("Sequioa RGB"),
                    6.17,                       // sensorWidth
                    4.63,                       // sendsorHeight
                    4608,                       // imageWidth
                    3456,                       // imageHeight
                    4.9,                        // focalLength
                    true,                       // landscape
                    false,                      // fixedOrientation
                    1,                          // minTriggerInterval
                    tr("Parrot Sequioa RGB"),   // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Parrot Sequioa Monochrome",
                    tr("Parrot"),
                    tr("Sequioa Monochrome"),
                    4.8,                                // sensorWidth
                    3.6,                                // sendsorHeight
                    1280,                               // imageWidth
                    960,                                // imageHeight
                    4.0,                                // focalLength
                    true,                               // landscape
                    false,                              // fixedOrientation
                    0.8,                                // minTriggerInterval
                    tr("Parrot Sequioa Monochrome"),    // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "RedEdge",
                    tr("RedEdge"),
                    tr("RedEdge"),
                    4.8,            // sensorWidth
                    3.6,            // sendsorHeight
                    1280,           // imageWidth
                    960,            // imageHeight
                    5.5,            // focalLength
                    true,           // landscape
                    false,          // fixedOrientation
                    0,              // minTriggerInterval
                    tr("RedEdge"),  // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    // Ricoh GR II 18.3mm f/2.8
                    "Ricoh GR II",
                    tr("Ricoh"),
                    tr("GR II"),
                    23.7,               // sensorWidth
                    15.7,               // sendsorHeight
                    4928,               // imageWidth
                    3264,               // imageHeight
                    18.3,               // focalLength
                    true,               // landscape
                    false,              // fixedOrientation
                    0,                  // minTriggerInterval
                    tr("Ricoh GR II"),  // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sentera Double 4K Sensor",
                    tr("Sentera"),
                    tr("Double 4K Sensor"),
                    6.2,                // sensorWidth
                    4.65,               // sendsorHeight
                    4000,               // imageWidth
                    3000,               // imageHeight
                    5.4,                // focalLength
                    true,               // landscape
                    false,              // fixedOrientation
                    0,                  // minTriggerInterval
                    tr("Sentera Double 4K Sensor"),// SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sentera NDVI Single Sensor",
                    tr("Sentera"),
                    tr("NDVI Single Sensor"),
                    4.68,               // sensorWidth
                    3.56,               // sendsorHeight
                    1248,               // imageWidth
                    952,                // imageHeight
                    4.14,               // focalLength
                    true,               // landscape
                    false,              // fixedOrientation
                    0,                  // minTriggerInterval
                    tr("Sentera NDVI Single Sensor"),// SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    //-- http://www.sony.co.uk/electronics/interchangeable-lens-cameras/ilce-6000-body-kit#product_details_default
                    // Sony a6000 Sony 16mm f/2.8"
                    "Sony a6000 16mm",
                    tr("Sony"),
                    tr("a6000 16mm"),
                    23.5,                   // sensorWidth
                    15.6,                   // sensorHeight
                    6000,                   // imageWidth
                    4000,                   // imageHeight
                    16,                     // focalLength
                    true,                   // true: landscape orientation
                    false,                  // true: camera is fixed orientation
                    2.0,                    // minimum trigger interval
                    tr("Sony a6000 16mm"),  // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                  // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony a6000 35mm",
                    tr("Sony"),
                    tr("a6000 35mm"),
                    23.5,               // sensorWidth
                    15.6,               // sensorHeight
                    6000,               // imageWidth
                    4000,               // imageHeight
                    35,                 // focalLength
                    true,               // true: landscape orientation
                    false,              // true: camera is fixed orientation
                    2.0,                // minimum trigger interval
                    "",
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony a6300 Zeiss 21mm f/2.8",
                    tr("Sony"),
                    tr("a6300 Zeiss 21mm f/2.8"),
                    23.5,               // sensorWidth
                    15.6,               // sensorHeight
                    6000,               // imageWidth
                    4000,               // imageHeight
                    21,                 // focalLength
                    true,               // true: landscape orientation
                    false,              // true: camera is fixed orientation
                    2.0,                // minimum trigger interval
                    tr("Sony a6300 Zeiss 21mm f/2.8"),// SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony a6300 Sony 28mm f/2.0",
                    tr("Sony"),
                    tr("a6300 Sony 28mm f/2.0"),
                    23.5,                               // sensorWidth
                    15.6,                               // sensorHeight
                    6000,                               // imageWidth
                    4000,                               // imageHeight
                    28,                                 // focalLength
                    true,                               // true: landscape orientation
                    false,              // true: camera is fixed orientation
                    2.0,                                // minimum trigger interval
                    tr("Sony a6300 Sony 28mm f/2.0"),   // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony a7R II Zeiss 21mm f/2.8",
                    tr("Sony"),
                    tr("a7R II Zeiss 21mm f/2.8"),
                    35.814,                             // sensorWidth
                    23.876,                             // sensorHeight
                    7952,                               // imageWidth
                    5304,                               // imageHeight
                    21,                                 // focalLength
                    true,                               // true: landscape orientation
                    true,                               // true: camera is fixed orientation
                    2.0,                                // minimum trigger interval
                    tr("Sony a7R II Zeiss 21mm f/2.8"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony a7R II Sony 28mm f/2.0",
                    tr("Sony"),
                    tr("a7R II Sony 28mm f/2.0"),
                    35.814,             // sensorWidth
                    23.876,             // sensorHeight
                    7952,               // imageWidth
                    5304,               // imageHeight
                    28,                 // focalLength
                    true,               // true: landscape orientation
                    true,               // true: camera is fixed orientation
                    2.0,                // minimum trigger interval
                    tr("Sony a7R II Sony 28mm f/2.0"),// SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony a7r III 35mm",
                    tr("Sony"),
                    tr("a7r III 35mm"),
                    35.9,               // sensorWidth
                    24.0,               // sensorHeight
                    7952,               // imageWidth
                    5304,               // imageHeight
                    35,                 // focalLength
                    true,               // true: landscape orientation
                    false,              // true: camera is fixed orientation
                    2.0,                // minimum trigger interval
                    "",
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony a7r IV 35mm",
                    tr("Sony"),
                    tr("a7r IV 35mm"),
                    35.7,               // sensorWidth
                    23.8,               // sensorHeight
                    9504,               // imageWidth
                    6336,               // imageHeight
                    35,                 // focalLength
                    true,               // true: landscape orientation
                    false,               // true: camera is fixed orientation
                    2.0,                // minimum trigger interval
                    "",
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony DSC-QX30U @ 4.3mm f/3.5",
                    tr("Sony"),
                    tr("DSC-QX30U @ 4.3mm f/3.5"),
                    7.82,                               // sensorWidth
                    5.865,                              // sensorHeight
                    5184,                               // imageWidth
                    3888,                               // imageHeight
                    4.3,                                // focalLength
                    true,                               // true: landscape orientation
                    false,                              // true: camera is fixed orientation
                    2.0,                                // minimum trigger interval
                    tr("Sony DSC-QX30U @ 4.3mm f/3.5"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony DSC-RX0",
                    tr("Sony"),
                    tr("DSC-RX0"),
                    13.2,               // sensorWidth
                    8.8,                // sensorHeight
                    4800,               // imageWidth
                    3200,               // imageHeight
                    7.7,                // focalLength
                    true,               // true: landscape orientation
                    false,              // true: camera is fixed orientation
                    0,                  // minimum trigger interval
                    tr("Sony DSC-RX0"),// SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Sony DSC-RX1R II 35mm",
                    tr("Sony"),
                    tr("DSC-RX1R II 35mm"),
                    35.9,             // sensorWidth
                    24.0,             // sensorHeight
                    7952,               // imageWidth
                    5304,               // imageHeight
                    35,                 // focalLength
                    true,               // true: landscape orientation
                    false,              // true: camera is fixed orientation
                    2.0,                // minimum trigger interval
                    "",
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    //-- http://www.sony.co.uk/electronics/interchangeable-lens-cameras/ilce-qx1-body-kit/specifications
                    //-- http://www.sony.com/electronics/camera-lenses/sel16f28/specifications
                    //tr("Sony ILCE-QX1 Sony 16mm f/2.8"),
                    "Sony ILCE-QX1",
                    tr("Sony"),
                    tr("ILCE-QX1"),
                    23.2,                   // sensorWidth
                    15.4,                   // sensorHeight
                    5456,                   // imageWidth
                    3632,                   // imageHeight
                    16,                     // focalLength
                    true,                   // true: landscape orientation
                    false,                  // true: camera is fixed orientation
                    0,                      // minimum trigger interval
                    tr("Sony ILCE-QX1"),    // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                  // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    //-- http://www.sony.co.uk/electronics/interchangeable-lens-cameras/ilce-qx1-body-kit/specifications
                    // Sony NEX-5R Sony 20mm f/2.8"
                    "Sony NEX-5R 20mm",
                    tr("Sony"),
                    tr("NEX-5R 20mm"),
                    23.2,                   // sensorWidth
                    15.4,                   // sensorHeight
                    4912,                   // imageWidth
                    3264,                   // imageHeight
                    20,                     // focalLength
                    true,                   // true: landscape orientation
                    false,                  // true: camera is fixed orientation
                    1,                      // minimum trigger interval
                    tr("Sony NEX-5R 20mm"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);                  // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    // Sony RX100 II @ 10.4mm f/1.8
                    "Sony RX100 II 28mm",
                    tr("Sony"),
                    tr("RX100 II 28mm"),
                    13.2,                // sensorWidth
                    8.8,                 // sensorHeight
                    5472,                // imageWidth
                    3648,                // imageHeight
                    10.4,                // focalLength
                    true,                // true: landscape orientation
                    false,               // true: camera is fixed orientation
                    0,                   // minimum trigger interval
                    tr("Sony RX100 II 28mm"),// SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);               // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Yuneec CGOET",
                    tr("Yuneec"),
                    tr("CGOET"),
                    5.6405,             // sensorWidth
                    3.1813,             // sensorHeight
                    1920,               // imageWidth
                    1080,               // imageHeight
                    3.5,                // focalLength
                    true,               // true: landscape orientation
                    true,               // true: camera is fixed orientation
                    1.3,                // minimum trigger interval
                    tr("Yuneec CGOET"), // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Yuneec E10T",
                    tr("Yuneec"),
                    tr("E10T"),
                    5.6405,             // sensorWidth
                    3.1813,             // sensorHeight
                    1920,               // imageWidth
                    1080,               // imageHeight
                    23,                 // focalLength
                    true,               // true: landscape orientation
                    true,               // true: camera is fixed orientation
                    1.3,                // minimum trigger interval
                    tr("Yuneec E10T"),  // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Yuneec E50",
                    tr("Yuneec"),
                    tr("E50"),
                    6.2372,             // sensorWidth
                    4.7058,             // sensorHeight
                    4000,               // imageWidth
                    3000,               // imageHeight
                    7.2,                // focalLength
                    true,               // true: landscape orientation
                    true,               // true: camera is fixed orientation
                    1.3,                // minimum trigger interval
                    tr("Yuneec E50"),   // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Yuneec E90",
                    tr("Yuneec"),
                    tr("E90"),
                    13.3056,            // sensorWidth
                    8.656,              // sensorHeight
                    5472,               // imageWidth
                    3648,               // imageHeight
                    8.29,               // focalLength
                    true,               // true: landscape orientation
                    true,               // true: camera is fixed orientation
                    1.3,                // minimum trigger interval
                    tr("Yuneec E90"),   // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

        metaData = new CameraMetaData(
                    "Flir Duo R",
                    tr("Flir"),
                    tr("Duo R"),
                    160,                // sensorWidth
                    120,                // sensorHeight
                    1920,               // imageWidth
                    1080,               // imageHeight
                    1.9,                // focalLength
                    true,               // true: landscape orientation
                    false,              // true: camera is fixed orientation
                    0,                  // minimum trigger interval
                    tr("Flir Duo R"),   // SHOULD BE BLANK FOR NEWLY ADDED CAMERAS. Deprecated translation from older builds.
                    1,
                    this);              // parent
        _cameraInfoList.append(metaData);

    }
    _saveCameraInfos();
}
