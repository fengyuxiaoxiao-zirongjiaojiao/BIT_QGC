/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "ArduPlaneFirmwarePlugin.h"

bool ArduPlaneFirmwarePlugin::_remapParamNameIntialized = false;
FirmwarePlugin::remapParamNameMajorVersionMap_t ArduPlaneFirmwarePlugin::_remapParamName;

APMPlaneMode::APMPlaneMode(uint32_t mode, bool settable, bool isSimple)
    : APMCustomMode(mode, settable, isSimple)
{
    setEnumToStringMapping({ 
        { MANUAL,           "Manual" },
        { CIRCLE,           "Circle" },
        { STABILIZE,        "Stabilize" },
        { TRAINING,         "Training" },
        { ACRO,             "Acro" },
        { FLY_BY_WIRE_A,    "FBW A" },
        { FLY_BY_WIRE_B,    "FBW B" },
        { CRUISE,           "Cruise" },
        { AUTOTUNE,         "Autotune" },
        { AUTO,             "Auto" },
        { RTL,              "RTL" },
        { LOITER,           "Loiter" },
        { TAKEOFF,          "Takeoff" },
        { AVOID_ADSB,       "Avoid ADSB" },
        { GUIDED,           "Guided" },
        { INITIALIZING,     "Initializing" },
        { QSTABILIZE,       "QuadPlane Stabilize" },
        { QHOVER,           "QuadPlane Hover" },
        { QLOITER,          "QuadPlane Loiter" },
        { QLAND,            "QuadPlane Land" },
        { QRTL,             "QuadPlane RTL" },
        { QAUTOTUNE,        "QuadPlane AutoTune" },
        { QACRO,            "QuadPlane Acro" },
        { THERMAL,          "Thermal"},
    });
    setEnumToStringZhMapping({
        { MANUAL,           QStringLiteral("手动") },
        { CIRCLE,           QStringLiteral("绕圈") },
        { STABILIZE,        QStringLiteral("增稳") },
        { TRAINING,         QStringLiteral("训练") },
        { ACRO,             QStringLiteral("特技") },
        { FLY_BY_WIRE_A,    QStringLiteral("FBW A") },
        { FLY_BY_WIRE_B,    QStringLiteral("FBW B") },
        { CRUISE,           QStringLiteral("巡航") },
        { AUTOTUNE,         QStringLiteral("自动调参") },
        { AUTO,             QStringLiteral("自动") },
        { RTL,              QStringLiteral("返航") },
        { LOITER,           QStringLiteral("盘旋") },
        { TAKEOFF,          QStringLiteral("起飞") },
        { AVOID_ADSB,       QStringLiteral("避障") },
        { GUIDED,           QStringLiteral("引导") },
        { INITIALIZING,     QStringLiteral("初始化") },
        { QSTABILIZE,       QStringLiteral("Q增稳") },
        { QHOVER,           QStringLiteral("Q悬停") },
        { QLOITER,          QStringLiteral("Q定点") },
        { QLAND,            QStringLiteral("Q降落") },
        { QRTL,             QStringLiteral("Q返航") },
        { QAUTOTUNE,        QStringLiteral("Q自动调参") },
        { QACRO,            QStringLiteral("Q特技") },
        { THERMAL,          QStringLiteral("Thermal") },
    });
}

ArduPlaneFirmwarePlugin::ArduPlaneFirmwarePlugin(void)
{
    setSupportedModes({
        //                       mode,              settable,   isSimple
        APMPlaneMode(APMPlaneMode::MANUAL,          true,       false),
        APMPlaneMode(APMPlaneMode::CIRCLE,          true,       false),
        APMPlaneMode(APMPlaneMode::STABILIZE,       true,       false),
        APMPlaneMode(APMPlaneMode::TRAINING,        true,       false),
        APMPlaneMode(APMPlaneMode::ACRO,            true,       false),
        APMPlaneMode(APMPlaneMode::FLY_BY_WIRE_A,   true,       false),
        APMPlaneMode(APMPlaneMode::FLY_BY_WIRE_B,   true,       false),
        APMPlaneMode(APMPlaneMode::CRUISE,          true,       false),
        APMPlaneMode(APMPlaneMode::AUTOTUNE,        true,       false),
        APMPlaneMode(APMPlaneMode::AUTO,            true,       true),
        APMPlaneMode(APMPlaneMode::RTL,             true,       true),
        APMPlaneMode(APMPlaneMode::LOITER,          true,       true),
        APMPlaneMode(APMPlaneMode::TAKEOFF,         true,       false),
        APMPlaneMode(APMPlaneMode::AVOID_ADSB,      false,      false),
        APMPlaneMode(APMPlaneMode::GUIDED,          true,       false),
        APMPlaneMode(APMPlaneMode::INITIALIZING,    false,      false),
        APMPlaneMode(APMPlaneMode::QSTABILIZE,      true,       false),
        APMPlaneMode(APMPlaneMode::QHOVER,          true,       true),
        APMPlaneMode(APMPlaneMode::QLOITER,         true,       true),
        APMPlaneMode(APMPlaneMode::QLAND,           true,       true),
        APMPlaneMode(APMPlaneMode::QRTL,            true,       true),
        APMPlaneMode(APMPlaneMode::QAUTOTUNE,       true,       false),
        APMPlaneMode(APMPlaneMode::QACRO,           true,       false),
        APMPlaneMode(APMPlaneMode::THERMAL,         true,       false),
    });

    if (!_remapParamNameIntialized) {
        FirmwarePlugin::remapParamNameMap_t& remapV3_10 = _remapParamName[3][10];

        remapV3_10["BATT_ARM_VOLT"] =    QStringLiteral("ARMING_VOLT_MIN");
        remapV3_10["BATT2_ARM_VOLT"] =   QStringLiteral("ARMING_VOLT2_MIN");

        _remapParamNameIntialized = true;
    }
}

int ArduPlaneFirmwarePlugin::remapParamNameHigestMinorVersionNumber(int majorVersionNumber) const
{
    // Remapping supports up to 3.10
    return majorVersionNumber == 3 ? 10 : Vehicle::versionNotSetValue;
}
