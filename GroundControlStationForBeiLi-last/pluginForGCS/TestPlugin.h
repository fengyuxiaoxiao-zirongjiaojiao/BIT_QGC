/**************************************************
** Author      : 徐建文
** CreateTime  : 2022年8月25日 11点27分
** ModifyTime  : 2022年8月26日 11点27分
** Email       : Vincent_xjw@163.com
** Description : 测试插件
***************************************************/
#ifndef TESTPLUGIN_H
#define TESTPLUGIN_H

#include <QObject>
#include <QtPlugin>
#include <QTime>
#include "PluginInterface.h"

class TestPlugin : public QObject, PluginInterface
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID "org.BIT.GCS.Plugins.PluginInterface" FILE "TestPlugin.json")
    Q_INTERFACES(PluginInterface)

public:
    TestPlugin();
    ~TestPlugin();
    QString name() override;
    QString description() override;
    QStringList actions() override;
    void onVehicleStatusChanged(QList<PluginMetaData> status) override;
    void onActionTriggered(QString action) override;


signals:
    void sendMsgToManager(QString pluginName, QString msg) override;
    void sendSpeedToManager(int id, float speed) override;
    void sendCoordinateToManager(int id, double latitude, double longitude) override;
    void sendAltitudeToManager(int id, int altitude) override;
    void sendPauseAndFlyToAltitudeToManager(int id, int altitude) override;
    void sendPauseFlyToManager(int id) override;
    void sendTakeoffToManager(int id, int altitude) override;
    void sendRtlToManager(int id) override;
    void sendStartMissionToManager(int id) override;
    void sendMissionToManager(int id, QList<PluginMissionData> plan) override;

private:
    void _debug(const QString &msg);
    void _calc();
    void _createMissionAndRun();
    float _warp360(const float angle);
    float _warp180(const float angle);

    bool _run;
    QStringList _actionList;
    QList<PluginMetaData> _status;
    QDateTime _dateTime;
    int _currentActionIdx;
};


#endif
