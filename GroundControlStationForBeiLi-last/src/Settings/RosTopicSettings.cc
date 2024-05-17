
#include "RosTopicSettings.h"

#include <QQmlEngine>
#include <QtQml>

DECLARE_SETTINGGROUP(RosTopic, "RosTopic")
{
    qmlRegisterUncreatableType<RosTopicSettings>("QGroundControl.SettingsManager", 1, 0, "RosTopicSettings", "Reference only");
}

DECLARE_SETTINGSFACT(RosTopicSettings, rosTopicServerConnectEnabled)
DECLARE_SETTINGSFACT(RosTopicSettings, rosTopicServerHostAddress)
DECLARE_SETTINGSFACT(RosTopicSettings, rosTopicServerPort)
