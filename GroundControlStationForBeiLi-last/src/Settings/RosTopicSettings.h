
#pragma once

#include "SettingsGroup.h"

class RosTopicSettings : public SettingsGroup
{
    Q_OBJECT
public:
    RosTopicSettings(QObject* parent = nullptr);
    DEFINE_SETTING_NAME_GROUP()

    DEFINE_SETTINGFACT(rosTopicServerConnectEnabled)
    DEFINE_SETTINGFACT(rosTopicServerHostAddress)
    DEFINE_SETTINGFACT(rosTopicServerPort)
};
