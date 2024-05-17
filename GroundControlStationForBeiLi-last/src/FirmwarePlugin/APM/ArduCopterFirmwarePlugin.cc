/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/// @file
///     @author Don Gagne <don@thegagnes.com>

#include "ArduCopterFirmwarePlugin.h"
#include "QGCApplication.h"
#include "MissionManager.h"
#include "ParameterManager.h"

bool ArduCopterFirmwarePlugin::_remapParamNameIntialized = false;
FirmwarePlugin::remapParamNameMajorVersionMap_t ArduCopterFirmwarePlugin::_remapParamName;

APMCopterMode::APMCopterMode(uint32_t mode, bool settable, bool isSimple) :
    APMCustomMode(mode, settable, isSimple)
{
    setEnumToStringMapping({
        { STABILIZE,    "Stabilize"},
        { ACRO,         "Acro"},
        { ALT_HOLD,     "Altitude Hold"},
        { AUTO,         "Auto"},
        { GUIDED,       "Guided"},
        { LOITER,       "Loiter"},
        { RTL,          "RTL"},
        { CIRCLE,       "Circle"},
        { LAND,         "Land"},
        { DRIFT,        "Drift"},
        { SPORT,        "Sport"},
        { FLIP,         "Flip"},
        { AUTOTUNE,     "Autotune"},
        { POS_HOLD,     "Position Hold"},
        { BRAKE,        "Brake"},
        { THROW,        "Throw"},
        { AVOID_ADSB,   "Avoid ADSB"},
        { GUIDED_NOGPS, "Guided No GPS"},
        { SMART_RTL,    "Smart RTL"},
        { FLOWHOLD,     "Flow Hold" },
#if 0
    // Follow me not ready for Stable
        { FOLLOW,       "Follow" },
#endif
        { ZIGZAG,       "ZigZag" },
    });

    setEnumToStringZhMapping({
        { STABILIZE,    QStringLiteral("增稳")},
        { ACRO,         QStringLiteral("特技")},
        { ALT_HOLD,     QStringLiteral("定高")},
        { AUTO,         QStringLiteral("自动")},
        { GUIDED,       QStringLiteral("引导")},
        { LOITER,       QStringLiteral("悬停")},
        { RTL,          QStringLiteral("返航")},
        { CIRCLE,       QStringLiteral("绕圈")},
        { LAND,         QStringLiteral("降落")},
        { DRIFT,        QStringLiteral("漂移")},
        { SPORT,        QStringLiteral("运动")},
        { FLIP,         QStringLiteral("翻转")},
        { AUTOTUNE,     QStringLiteral("自动调参")},
        { POS_HOLD,     QStringLiteral("定点")},
        { BRAKE,        QStringLiteral("刹车")},
        { THROW,        QStringLiteral("投掷")},
        { AVOID_ADSB,   QStringLiteral("避障")},
        { GUIDED_NOGPS, QStringLiteral("无GPS引导")},
        { SMART_RTL,    QStringLiteral("智能返航")},
        { FLOWHOLD,     QStringLiteral("光流定高")},
#if 0
    // Follow me not ready for Stable
        { FOLLOW,       QStringLiteral("跟随") },
#endif
        { ZIGZAG,       QStringLiteral("曲线") },
    });
}

ArduCopterFirmwarePlugin::ArduCopterFirmwarePlugin(void)
{
    setSupportedModes({
                          //         mode,          settable, isSimple
        APMCopterMode(APMCopterMode::STABILIZE,     true,       false),
        APMCopterMode(APMCopterMode::ACRO,          true,       false),
        APMCopterMode(APMCopterMode::ALT_HOLD,      true,       true),
        APMCopterMode(APMCopterMode::AUTO,          true,       true),
        APMCopterMode(APMCopterMode::GUIDED,        true,       false),
        APMCopterMode(APMCopterMode::LOITER,        true,       true),
        APMCopterMode(APMCopterMode::RTL,           true,       true),
        APMCopterMode(APMCopterMode::CIRCLE,        true,       false),
        APMCopterMode(APMCopterMode::LAND,          true,       true),
        APMCopterMode(APMCopterMode::DRIFT,         true,       false),
        APMCopterMode(APMCopterMode::SPORT,         true,       false),
        APMCopterMode(APMCopterMode::FLIP,          true,       false),
        APMCopterMode(APMCopterMode::AUTOTUNE,      true,       false),
        APMCopterMode(APMCopterMode::POS_HOLD,      true,       true),
        APMCopterMode(APMCopterMode::BRAKE,         true,       true),
        APMCopterMode(APMCopterMode::THROW,         true,       false),
        APMCopterMode(APMCopterMode::AVOID_ADSB,    true,       false),
        APMCopterMode(APMCopterMode::GUIDED_NOGPS,  true,       false),
        APMCopterMode(APMCopterMode::SMART_RTL,     true,       false),
        APMCopterMode(APMCopterMode::FLOWHOLD,      true,       false),
#if 0
    // Follow me not ready for Stable
        APMCopterMode(APMCopterMode::FOLLOW,        true,       false),
#endif
        APMCopterMode(APMCopterMode::ZIGZAG,        true,       false),
    });

    if (!_remapParamNameIntialized) {
        FirmwarePlugin::remapParamNameMap_t& remapV3_6 = _remapParamName[3][6];

        remapV3_6["BATT_AMP_PERVLT"] =  QStringLiteral("BATT_AMP_PERVOL");
        remapV3_6["BATT2_AMP_PERVLT"] = QStringLiteral("BATT2_AMP_PERVOL");
        remapV3_6["BATT_LOW_MAH"] =     QStringLiteral("FS_BATT_MAH");
        remapV3_6["BATT_LOW_VOLT"] =    QStringLiteral("FS_BATT_VOLTAGE");
        remapV3_6["BATT_FS_LOW_ACT"] =  QStringLiteral("FS_BATT_ENABLE");
        remapV3_6["PSC_ACCZ_P"] =       QStringLiteral("ACCEL_Z_P");
        remapV3_6["PSC_ACCZ_I"] =       QStringLiteral("ACCEL_Z_I");

        FirmwarePlugin::remapParamNameMap_t& remapV3_7 = _remapParamName[3][7];

        remapV3_7["BATT_ARM_VOLT"] =    QStringLiteral("ARMING_VOLT_MIN");
        remapV3_7["BATT2_ARM_VOLT"] =   QStringLiteral("ARMING_VOLT2_MIN");
        remapV3_7["RC7_OPTION"] =       QStringLiteral("CH7_OPT");
        remapV3_7["RC8_OPTION"] =       QStringLiteral("CH8_OPT");
        remapV3_7["RC9_OPTION"] =       QStringLiteral("CH9_OPT");
        remapV3_7["RC10_OPTION"] =      QStringLiteral("CH10_OPT");
        remapV3_7["RC11_OPTION"] =      QStringLiteral("CH11_OPT");
        remapV3_7["RC12_OPTION"] =      QStringLiteral("CH12_OPT");

        FirmwarePlugin::remapParamNameMap_t& remapV4_0 = _remapParamName[4][0];

        remapV4_0["TUNE_MIN"] = QStringLiteral("TUNE_HIGH");
        remapV3_7["TUNE_MAX"] = QStringLiteral("TUNE_LOW");

        _remapParamNameIntialized = true;
    }
}

int ArduCopterFirmwarePlugin::remapParamNameHigestMinorVersionNumber(int majorVersionNumber) const
{
    // Remapping supports up to 3.7
    return majorVersionNumber == 3 ? 7 : Vehicle::versionNotSetValue;
}

void ArduCopterFirmwarePlugin::guidedModeLand(Vehicle* vehicle)
{
    _setFlightModeAndValidate(vehicle, "Land");
}

bool ArduCopterFirmwarePlugin::multiRotorCoaxialMotors(Vehicle* vehicle)
{
    Q_UNUSED(vehicle);
    return _coaxialMotors;
}

bool ArduCopterFirmwarePlugin::multiRotorXConfig(Vehicle* vehicle)
{
    return vehicle->parameterManager()->getParameter(FactSystem::defaultComponentId, "FRAME")->rawValue().toInt() != 0;
}

#if 0
    // Follow me not ready for Stable
void ArduCopterFirmwarePlugin::sendGCSMotionReport(Vehicle* vehicle, FollowMe::GCSMotionReport& motionReport, uint8_t estimatationCapabilities)
{
    _sendGCSMotionReport(vehicle, motionReport, estimatationCapabilities);
}
#endif
