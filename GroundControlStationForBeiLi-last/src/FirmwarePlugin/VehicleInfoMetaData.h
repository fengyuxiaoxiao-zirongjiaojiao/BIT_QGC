/**************************************************
** Author      : 徐建文
** CreateTime  : 2021年11月13日 15点17分
** ModifyTime  : 2021年11月13日 15点17分
** Email       : Vincent_xjw@163.com
** Description : 飞机信息类/数据结构
***************************************************/

#pragma once

#include <QObject>

/// Set of meta data which describes a information available on the vehicle
class VehicleInfoMetaData : public QObject
{
    Q_OBJECT

public:
    VehicleInfoMetaData(const QString&   canonicalName,
                   const QString&   cameraName, // 挂载的相机的名称
                   const QString&   brand, // 品牌
                   const QString&   type,// 类型
                   double           durationOfFlight,// 续航时间
                   double           enduranceMileage,// 续航里程
                   double           cruisingSpeed,// 巡航速度
                   double           sizeWidth,
                   double           sizeHeight,
                   double           weight,
                   QObject*         parent = nullptr);

    Q_PROPERTY(QString  canonicalName               MEMBER canonicalName            CONSTANT)
    Q_PROPERTY(QString  cameraName                  MEMBER cameraName               CONSTANT)
    Q_PROPERTY(QString  brand                       MEMBER brand                    CONSTANT)
    Q_PROPERTY(QString  type                        MEMBER type                     CONSTANT)
    Q_PROPERTY(double   durationOfFlight            MEMBER durationOfFlight         CONSTANT)
    Q_PROPERTY(double   enduranceMileage            MEMBER enduranceMileage         CONSTANT)
    Q_PROPERTY(double   cruisingSpeed               MEMBER cruisingSpeed            CONSTANT)
    Q_PROPERTY(double   sizeWidth                   MEMBER sizeWidth                CONSTANT)
    Q_PROPERTY(double   sizeHeight                  MEMBER sizeHeight               CONSTANT)
    Q_PROPERTY(double   weight                      MEMBER weight                   CONSTANT)

    QString         canonicalName;                  ///< Canonical name saved in plan files. Not translated.
    QString         cameraName;
    QString         brand; // 品牌
    QString         type;// 类型
    double          durationOfFlight;// 续航时间 min
    double          enduranceMileage;// 续航里程 km
    double          cruisingSpeed;// 巡航速度 m/s
    double          sizeWidth;// 尺寸-宽 cm
    double          sizeHeight;// 尺寸-高 cm
    double          weight;// 重量 kg
};
