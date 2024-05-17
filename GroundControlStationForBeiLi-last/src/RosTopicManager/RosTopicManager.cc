
#include "RosTopicManager.h"
#include "QGCLoggingCategory.h"
#include "QGCApplication.h"
#include "SettingsManager.h"
#include "PositionManager.h"

#include <QDebug>

RosTopicManager::RosTopicManager(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool(app, toolbox)
{
}

RosTopicManager::~RosTopicManager()
{
    _autoConnectTimer.stop();
    foreach (RosTopic* rosTopic, _rosTopicList) {
        if (rosTopic) {
            rosTopic->deleteLater();
        }
    }
    qDebug() << __FILE__ << __func__ << __LINE__;
}

void RosTopicManager::setToolbox(QGCToolbox* toolbox)
{
    QGCTool::setToolbox(toolbox);
    _create();
    connect(&_autoConnectTimer, &QTimer::timeout, this, &RosTopicManager::_onAutoConnect);
    _autoConnectTimer.start(5000);
}

void RosTopicManager::_onAutoConnect()
{
    foreach (RosTopic* rosTopic, _rosTopicList) {
        if (rosTopic && !rosTopic->isConnected()) {
            rosTopic->connectToHostSignal();
        }
    }
}

void RosTopicManager::_create()
{
    bool enable = qgcApp()->toolbox()->settingsManager()->rosTopicSettings()->rosTopicServerConnectEnabled()->rawValue().toBool();
    int port = qgcApp()->toolbox()->settingsManager()->rosTopicSettings()->rosTopicServerPort()->rawValue().toInt();
    QString str = qgcApp()->toolbox()->settingsManager()->rosTopicSettings()->rosTopicServerHostAddress()->rawValueString();
    str = str.remove(" ");
    QStringList hostAddressList = str.split(",");
    qDebug() << __FILE__ << __func__ << __LINE__ << str << hostAddressList << port << enable;
    if (enable) {
        foreach (QString hostAddress, hostAddressList) {
           RosTopic *rosTopic = new RosTopic(hostAddress, port);
           rosTopic->connectToHostSignal();
           _rosTopicList << rosTopic;
        }
    }
}


