/**************************************************
** Author      : 徐建文
** CreateTime  : 2022年8月25日 11点22分
** ModifyTime  : 2022年8月25日 11点22分
** Email       : Vincent_xjw@163.com
** Description : 测试插件
***************************************************/
#include "TestPlugin.h"
#include <QtConcurrent>
#include <QGeoCoordinate>

TestPlugin::TestPlugin()
{
    _run = false;
    _actionList << QStringLiteral("一字型") << QStringLiteral("三角形") << QStringLiteral("|字型") << QStringLiteral("生成并上传航线");
}

TestPlugin::~TestPlugin()
{
    _run = false;
}

QString TestPlugin::name()
{
    return QStringLiteral("TestPlugin");
}

QString TestPlugin::description()
{
    emit sendMsgToManager(name(), QStringLiteral("调用了插件的描述接口哦 :)"));
    return QStringLiteral("没别的，就是测试一下插件的功能 :)");
}

QStringList TestPlugin::actions()
{
    return _actionList;
}

void TestPlugin::onVehicleStatusChanged(QList<PluginMetaData> status)
{
    //_debug(QString("vehicleStatus:%1").arg(status.count()));
    // 做个排序，方便后续计算
    for (int i = 0; i < status.count(); i++)
    {
        for (int j = 0; j < status.count() -  i - 1; j++)
        {
            if (status[j].id > status[j + 1].id)
            {
                PluginMetaData temp;
                temp = status[j + 1];
                status[j + 1] = status[j];
                status[j] = temp;
            }
        }
    }
    _status = status;

    QString str = "plugin";
    for (int i = 0; i < status.count(); i++) {
        str = QString("%1,%2").arg(str).arg(QString::number(status.at(i).id));
    }
    //_debug(str);
}

void TestPlugin::onActionTriggered(QString action)
{
    _debug(QString("triggered:%1, %2").arg(action).arg(_actionList.contains(action) ? "contains action" : "uknow action"));
    if (!_actionList.contains(action) || _status.isEmpty()) _run = false;
    _currentActionIdx = _actionList.indexOf(action);
    _run = true;
    if (_currentActionIdx == 3) {
        QtConcurrent::run(this, &TestPlugin::_createMissionAndRun);
    } else {
        QtConcurrent::run(this, &TestPlugin::_calc);
    }
}

void TestPlugin::_debug(const QString &msg)
{
    emit sendMsgToManager(name(), msg);
}

void TestPlugin::_calc()
{
    int distance = 200;
    while(_run && !_status.isEmpty()) {
        static QDateTime lastArmedDateTime = QDateTime::currentDateTime();
        int armCount = 0;
        int flyingCount = 0;

        //if (armCount != _status.count()) {
            for (int i = 0; i < _status.count(); i++) {
                //_debug(QString("%1,%2").arg(QString::number(_time.msec())).arg(QString::number(_time.msec() - lastArmedMs)));
                if (!_status.at(i).armed && lastArmedDateTime.msecsTo(QDateTime::currentDateTime()) > 5000) {
                    emit sendTakeoffToManager(_status.at(i).id, 80);
                    lastArmedDateTime = QDateTime::currentDateTime();
                }
                armCount += _status.at(i).armed ? 1 : 0;
                flyingCount += _status.at(i).flying ? 1 : 0;
            }
        //}

        if (flyingCount == _status.count() && flyingCount >= 3) {
            QGeoCoordinate coor1(_status.at(0).latitude, _status.at(0).longitude);
            QGeoCoordinate coor2(_status.at(1).latitude, _status.at(1).longitude);
            QGeoCoordinate coor3(_status.at(2).latitude, _status.at(2).longitude);
            float heading = _status.at(0).yaw;
            if (_status.at(0).altitude >= 20 /*&& qAbs(_status.at(1).altitude - _status.at(0).altitude) < 2 && qAbs(_status.at(2).altitude - _status.at(0).altitude) < 2*/) {
                if (_currentActionIdx == 0) { // -字型
                    float headingLeft = heading - 90;
                    headingLeft = _warp360(headingLeft);
                    QGeoCoordinate coorLeft = coor1.atDistanceAndAzimuth(distance, headingLeft);
                    emit sendCoordinateToManager(_status.at(1).id, coorLeft.latitude(), coorLeft.longitude());

//                    float headingRight = headingLeft + 180;
//                    headingRight = _warp360(headingRight);
//                    QGeoCoordinate coorRight = coor1.atDistanceAndAzimuth(distance, headingRight);
                    QGeoCoordinate coorRight = coor1.atDistanceAndAzimuth(distance * 2, headingLeft);
                    emit sendCoordinateToManager(_status.at(2).id, coorRight.latitude(), coorRight.longitude());

                    //_debug(QString("headingLeft:%1,headingRight:%2").arg(QString::number(headingLeft)).arg(QString::number(headingRight)));

                    int dis = coor2.distanceTo(coorLeft);
                    float speed = (_status.at(0).groundSpeed * 3 + dis) / 3;
                    if (abs(coor2.azimuthTo(coorLeft) - heading) > 40) speed = 15;
                    emit sendSpeedToManager(_status.at(1).id, qMax(15.0f, qMin(speed, 20.0f)));

                    dis = coor3.distanceTo(coorRight);
                    speed = (_status.at(0).groundSpeed * 3 + dis) / 3;
                    if (abs(coor3.azimuthTo(coorRight) - heading) > 40) speed = 15;
                    emit sendSpeedToManager(_status.at(2).id, qMax(15.0f, qMin(speed, 20.0f)));

                } else if (_currentActionIdx == 1) {// 三角形
                    QGeoCoordinate coorCenter = coor1.atDistanceAndAzimuth(-distance, heading);
                    float headingLeft = heading - 90;
                    headingLeft = _warp360(headingLeft);
                    QGeoCoordinate coorLeft = coorCenter.atDistanceAndAzimuth(distance/2, headingLeft);
                    QGeoCoordinate coorRight = coorCenter.atDistanceAndAzimuth(-distance/2, headingLeft);

                    emit sendCoordinateToManager(_status.at(1).id, coorLeft.latitude(), coorLeft.longitude());
                    emit sendCoordinateToManager(_status.at(2).id, coorRight.latitude(), coorRight.longitude());
                    //emit sendAltitudeToManager(_status.at(1).id, _status.at(0).altitude);
                    //emit sendAltitudeToManager(_status.at(2).id, _status.at(0).altitude);
                    //_debug(QString("altitude:%1").arg(_status.at(0).altitude));
                } else if (_currentActionIdx == 2) { // |字型
                    QGeoCoordinate coorLeft = coor1.atDistanceAndAzimuth(-distance, heading);
                    QGeoCoordinate coorRight = coor1.atDistanceAndAzimuth(-distance*2, heading);
                    emit sendCoordinateToManager(_status.at(1).id, coorLeft.latitude(), coorLeft.longitude());
                    emit sendCoordinateToManager(_status.at(2).id, coorRight.latitude(), coorRight.longitude());
                }

            }
        }

        QThread::msleep(800);
    }
}

void TestPlugin::_createMissionAndRun()
{
    int id = _status.at(0).id;
    QGeoCoordinate coor1(_status.at(0).latitude, _status.at(0).longitude, _status.at(0).altitude);
    QGeoCoordinate coor1_home(_status.at(0).planHomePositionLat, _status.at(0).planHomePositionLng, _status.at(0).planHomePositionAlt);
    PluginMissionData itemHome;
    itemHome.command = 16;
    itemHome.isPlanHomePosition = true;
    itemHome.altitude = coor1_home.altitude();
    itemHome.latitude = coor1_home.latitude();
    itemHome.longitude = coor1_home.longitude();

    PluginMissionData itemtakeoff;
    itemtakeoff.command = 22;
    itemtakeoff.isPlanHomePosition = false;
    itemtakeoff.altitude = 120;
    itemtakeoff.latitude = 0;
    itemtakeoff.longitude = 0;

    PluginMissionData item1;
    item1.command = 16;
    item1.isPlanHomePosition = false;
    item1.altitude = 120;
    item1.latitude = coor1_home.atDistanceAndAzimuth(300, 0).latitude();
    item1.longitude = coor1_home.atDistanceAndAzimuth(300, 0).longitude();

    PluginMissionData item2;
    item2.command = 16;
    item2.isPlanHomePosition = false;
    item2.altitude = 120;
    item2.latitude = QGeoCoordinate(item1.latitude, item1.longitude).atDistanceAndAzimuth(300, 90).latitude();
    item2.longitude = QGeoCoordinate(item1.latitude, item1.longitude).atDistanceAndAzimuth(300, 90).longitude();

    PluginMissionData item3;
    item3.command = 16;
    item3.isPlanHomePosition = false;
    item3.altitude = 120;
    item3.latitude = QGeoCoordinate(item2.latitude, item2.longitude).atDistanceAndAzimuth(300, 0).latitude();
    item3.longitude = QGeoCoordinate(item2.latitude, item2.longitude).atDistanceAndAzimuth(300, 0).longitude();

    PluginMissionData item4;
    item4.command = 20;

    PluginMissionDataList items;
    items.append(itemHome);
    items.append(itemtakeoff);
    items.append(item1);
    items.append(item2);
    items.append(item3);
    items.append(item4);
    sendMissionToManager(id, items);
    QThread::msleep(1000);
    sendStartMissionToManager(id);
    _run = false;
}

float TestPlugin::_warp360(const float angle)
{
    float res = fmodf(angle, 360.0f);
    if (res < 0) {
        res += 360.0f;
    }
    return res;
}

float TestPlugin::_warp180(const float angle)
{
    float res = _warp360(angle);
    if (res > 180.0f) {
        res -= 360.0f;
    }
    return res;
}

