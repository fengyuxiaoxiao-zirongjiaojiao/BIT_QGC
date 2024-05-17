/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "CameraMetaData.h"

CameraMetaData::CameraMetaData(const QString&   canonicalName,
                               const QString&   brand,
                               const QString&   model,
                               double           sensorWidth,
                               double           sensorHeight,
                               double           imageWidth,
                               double           imageHeight,
                               double           focalLength,
                               bool             landscape,
                               bool             fixedOrientation,
                               double           minTriggerInterval,
                               const QString&   deprecatedTranslatedName,
                               int              sceneNum,
                               QObject*         parent)
    : QObject                   (parent)
    , canonicalName             (canonicalName)
    , brand                     (brand)
    , model                     (model)
    , sensorWidth               (sensorWidth)
    , sensorHeight              (sensorHeight)
    , imageWidth                (imageWidth)
    , imageHeight               (imageHeight)
    , focalLength               (focalLength)
    , landscape                 (landscape)
    , fixedOrientation          (fixedOrientation)
    , minTriggerInterval        (minTriggerInterval)
    , deprecatedTranslatedName  (deprecatedTranslatedName)
    , sceneNum                  (sceneNum)
{

}

float CameraMetaData::hfov()
{
    if (_hfov == 0 || _vfov == 0) {
        _calcFov();
    }
    return _hfov;
}

float CameraMetaData::vfov()
{
    if (_hfov == 0 || _vfov == 0) {
        _calcFov();
    }
    return _vfov;
}

void CameraMetaData::_calcFov()
{
    if (focalLength <= 0) return;
    _hfov = (float)(qRadiansToDegrees(atan(sensorWidth / (2 * focalLength))) * 2);
    _vfov = (float)(qRadiansToDegrees(atan(sensorHeight / (2 * focalLength))) * 2);
}
