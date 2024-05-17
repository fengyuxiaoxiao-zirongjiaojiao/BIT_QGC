/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleGPS2FactGroup.h"
#include "Vehicle.h"
#include "QGCGeo.h"

const char* VehicleGPS2FactGroup::_latFactName =                 "lat";
const char* VehicleGPS2FactGroup::_lonFactName =                 "lon";
const char* VehicleGPS2FactGroup::_mgrsFactName =                "mgrs";
const char* VehicleGPS2FactGroup::_hdopFactName =                "hdop";
const char* VehicleGPS2FactGroup::_vdopFactName =                "vdop";
const char* VehicleGPS2FactGroup::_courseOverGroundFactName =    "courseOverGround";
const char* VehicleGPS2FactGroup::_countFactName =               "count";
const char* VehicleGPS2FactGroup::_lockFactName =                "lock";

VehicleGPS2FactGroup::VehicleGPS2FactGroup(QObject* parent)
    : FactGroup(1000, ":/json/Vehicle/GPSFact.json", parent)
    , _latFact              (0, _latFactName,               FactMetaData::valueTypeDouble)
    , _lonFact              (0, _lonFactName,               FactMetaData::valueTypeDouble)
    , _mgrsFact             (0, _mgrsFactName,              FactMetaData::valueTypeString)
    , _hdopFact             (0, _hdopFactName,              FactMetaData::valueTypeDouble)
    , _vdopFact             (0, _vdopFactName,              FactMetaData::valueTypeDouble)
    , _courseOverGroundFact (0, _courseOverGroundFactName,  FactMetaData::valueTypeDouble)
    , _countFact            (0, _countFactName,             FactMetaData::valueTypeInt32)
    , _lockFact             (0, _lockFactName,              FactMetaData::valueTypeInt32)
{
    _addFact(&_latFact,                 _latFactName);
    _addFact(&_lonFact,                 _lonFactName);
    _addFact(&_mgrsFact,                _mgrsFactName);
    _addFact(&_hdopFact,                _hdopFactName);
    _addFact(&_vdopFact,                _vdopFactName);
    _addFact(&_courseOverGroundFact,    _courseOverGroundFactName);
    _addFact(&_lockFact,                _lockFactName);
    _addFact(&_countFact,               _countFactName);

    _latFact.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _lonFact.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _mgrsFact.setRawValue("");
    _hdopFact.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _vdopFact.setRawValue(std::numeric_limits<float>::quiet_NaN());
    _courseOverGroundFact.setRawValue(std::numeric_limits<float>::quiet_NaN());
}

void VehicleGPS2FactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    switch (message.msgid) {
    case MAVLINK_MSG_ID_GPS2_RAW:
        _handleGps2Raw(message);
        break;
    default:
        break;
    }
}

void VehicleGPS2FactGroup::_handleGps2Raw(mavlink_message_t& message)
{
    mavlink_gps2_raw_t gps2Raw;
    mavlink_msg_gps2_raw_decode(&message, &gps2Raw);


    lat()->setRawValue              (gps2Raw.lat * 1e-7);
    lon()->setRawValue              (gps2Raw.lon * 1e-7);
    mgrs()->setRawValue             (convertGeoToMGRS(QGeoCoordinate(gps2Raw.lat * 1e-7, gps2Raw.lon * 1e-7)));
    count()->setRawValue            (gps2Raw.satellites_visible == 255 ? 0 : gps2Raw.satellites_visible);
    hdop()->setRawValue             (gps2Raw.eph == UINT16_MAX ? qQNaN() : gps2Raw.eph / 100.0);
    vdop()->setRawValue             (gps2Raw.epv == UINT16_MAX ? qQNaN() : gps2Raw.epv / 100.0);
    courseOverGround()->setRawValue (gps2Raw.cog == UINT16_MAX ? qQNaN() : gps2Raw.cog / 100.0);
    lock()->setRawValue             (gps2Raw.fix_type);
}
