/**************************************************
** Author      : 徐建文
** CreateTime  : 2021年11月13日 15点19分
** ModifyTime  : 2021年11月13日 15点19分
** Email       : Vincent_xjw@163.com
** Description : 飞机信息/数据结构
***************************************************/

#include "VehicleInfoMetaData.h"
//#include <QQmlEngine>

VehicleInfoMetaData::VehicleInfoMetaData(const QString&   canonicalName,
                                         const QString&   cameraName,
                                         const QString&   brand, // 品牌
                                         const QString&   type, // 类型
                                         double           durationOfFlight, // 续航时间
                                         double           enduranceMileage, // 续航里程
                                         double           cruisingSpeed, // 巡航速度
                                         double           sizeWidth,
                                         double           sizeHeight,
                                         double           weight,
                               QObject*         parent)
    : QObject                   (parent)
    , canonicalName             (canonicalName)
    , cameraName                (cameraName)
    , brand                     (brand)
    , type                      (type)
    , durationOfFlight          (durationOfFlight)
    , enduranceMileage          (enduranceMileage)
    , cruisingSpeed             (cruisingSpeed)
    , sizeWidth                 (sizeWidth)
    , sizeHeight                (sizeHeight)
    , weight                    (weight)
{
    //QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    //qmlRegisterUncreatableType<VehicleInfoMetaData>("QGroundControl.VehicleInfoMetaData", 1, 0, "VehicleInfoMetaData", "Reference only");
}
