#pragma once
// MESSAGE VEHICLE_INFO PACKING

#define MAVLINK_MSG_ID_VEHICLE_INFO 501

MAVPACKED(
typedef struct __mavlink_vehicle_info_t {
 float roll; /*< [rad] Roll angle*/
 float pitch; /*< [rad] Pitch angle*/
 int32_t lat; /*< [degE7] Latitude.*/
 int32_t lng; /*< [degE7] Longitude.*/
 int32_t altitude; /*< [mm] Altitude (MSL).*/
 int32_t relative_alt; /*< [m] altitude relative to home.*/
 int16_t yaw; /*< [degE2] Yaw angle 0-35999*/
 int16_t vx; /*< [cm/s] ground speed*/
 int16_t vy; /*< [cm/s] */
 int16_t vz; /*< [cm/s] glimb speed*/
 uint8_t control_mode; /*<  control mode*/
 uint8_t mode_status; /*<  mode or status*/
 uint8_t battery_remaining; /*< [%] Battery energy remaining, -1: Battery remaining energy not sent by autopilot*/
 uint8_t target_alarm; /*<  Whether the target of interest has been found*/
 uint8_t gcs_status; /*<  */
 uint8_t vehicle_status; /*<  */
}) mavlink_vehicle_info_t;

#define MAVLINK_MSG_ID_VEHICLE_INFO_LEN 38
#define MAVLINK_MSG_ID_VEHICLE_INFO_MIN_LEN 38
#define MAVLINK_MSG_ID_501_LEN 38
#define MAVLINK_MSG_ID_501_MIN_LEN 38

#define MAVLINK_MSG_ID_VEHICLE_INFO_CRC 69
#define MAVLINK_MSG_ID_501_CRC 69



#if MAVLINK_COMMAND_24BIT
#define MAVLINK_MESSAGE_INFO_VEHICLE_INFO { \
    501, \
    "VEHICLE_INFO", \
    16, \
    {  { "control_mode", NULL, MAVLINK_TYPE_UINT8_T, 0, 32, offsetof(mavlink_vehicle_info_t, control_mode) }, \
         { "mode_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 33, offsetof(mavlink_vehicle_info_t, mode_status) }, \
         { "roll", NULL, MAVLINK_TYPE_FLOAT, 0, 0, offsetof(mavlink_vehicle_info_t, roll) }, \
         { "pitch", NULL, MAVLINK_TYPE_FLOAT, 0, 4, offsetof(mavlink_vehicle_info_t, pitch) }, \
         { "yaw", NULL, MAVLINK_TYPE_INT16_T, 0, 24, offsetof(mavlink_vehicle_info_t, yaw) }, \
         { "lat", NULL, MAVLINK_TYPE_INT32_T, 0, 8, offsetof(mavlink_vehicle_info_t, lat) }, \
         { "lng", NULL, MAVLINK_TYPE_INT32_T, 0, 12, offsetof(mavlink_vehicle_info_t, lng) }, \
         { "altitude", NULL, MAVLINK_TYPE_INT32_T, 0, 16, offsetof(mavlink_vehicle_info_t, altitude) }, \
         { "relative_alt", NULL, MAVLINK_TYPE_INT32_T, 0, 20, offsetof(mavlink_vehicle_info_t, relative_alt) }, \
         { "vx", NULL, MAVLINK_TYPE_INT16_T, 0, 26, offsetof(mavlink_vehicle_info_t, vx) }, \
         { "vy", NULL, MAVLINK_TYPE_INT16_T, 0, 28, offsetof(mavlink_vehicle_info_t, vy) }, \
         { "vz", NULL, MAVLINK_TYPE_INT16_T, 0, 30, offsetof(mavlink_vehicle_info_t, vz) }, \
         { "battery_remaining", NULL, MAVLINK_TYPE_UINT8_T, 0, 34, offsetof(mavlink_vehicle_info_t, battery_remaining) }, \
         { "target_alarm", NULL, MAVLINK_TYPE_UINT8_T, 0, 35, offsetof(mavlink_vehicle_info_t, target_alarm) }, \
         { "gcs_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 36, offsetof(mavlink_vehicle_info_t, gcs_status) }, \
         { "vehicle_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 37, offsetof(mavlink_vehicle_info_t, vehicle_status) }, \
         } \
}
#else
#define MAVLINK_MESSAGE_INFO_VEHICLE_INFO { \
    "VEHICLE_INFO", \
    16, \
    {  { "control_mode", NULL, MAVLINK_TYPE_UINT8_T, 0, 32, offsetof(mavlink_vehicle_info_t, control_mode) }, \
         { "mode_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 33, offsetof(mavlink_vehicle_info_t, mode_status) }, \
         { "roll", NULL, MAVLINK_TYPE_FLOAT, 0, 0, offsetof(mavlink_vehicle_info_t, roll) }, \
         { "pitch", NULL, MAVLINK_TYPE_FLOAT, 0, 4, offsetof(mavlink_vehicle_info_t, pitch) }, \
         { "yaw", NULL, MAVLINK_TYPE_INT16_T, 0, 24, offsetof(mavlink_vehicle_info_t, yaw) }, \
         { "lat", NULL, MAVLINK_TYPE_INT32_T, 0, 8, offsetof(mavlink_vehicle_info_t, lat) }, \
         { "lng", NULL, MAVLINK_TYPE_INT32_T, 0, 12, offsetof(mavlink_vehicle_info_t, lng) }, \
         { "altitude", NULL, MAVLINK_TYPE_INT32_T, 0, 16, offsetof(mavlink_vehicle_info_t, altitude) }, \
         { "relative_alt", NULL, MAVLINK_TYPE_INT32_T, 0, 20, offsetof(mavlink_vehicle_info_t, relative_alt) }, \
         { "vx", NULL, MAVLINK_TYPE_INT16_T, 0, 26, offsetof(mavlink_vehicle_info_t, vx) }, \
         { "vy", NULL, MAVLINK_TYPE_INT16_T, 0, 28, offsetof(mavlink_vehicle_info_t, vy) }, \
         { "vz", NULL, MAVLINK_TYPE_INT16_T, 0, 30, offsetof(mavlink_vehicle_info_t, vz) }, \
         { "battery_remaining", NULL, MAVLINK_TYPE_UINT8_T, 0, 34, offsetof(mavlink_vehicle_info_t, battery_remaining) }, \
         { "target_alarm", NULL, MAVLINK_TYPE_UINT8_T, 0, 35, offsetof(mavlink_vehicle_info_t, target_alarm) }, \
         { "gcs_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 36, offsetof(mavlink_vehicle_info_t, gcs_status) }, \
         { "vehicle_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 37, offsetof(mavlink_vehicle_info_t, vehicle_status) }, \
         } \
}
#endif

/**
 * @brief Pack a vehicle_info message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param control_mode  control mode
 * @param mode_status  mode or status
 * @param roll [rad] Roll angle
 * @param pitch [rad] Pitch angle
 * @param yaw [degE2] Yaw angle 0-35999
 * @param lat [degE7] Latitude.
 * @param lng [degE7] Longitude.
 * @param altitude [mm] Altitude (MSL).
 * @param relative_alt [m] altitude relative to home.
 * @param vx [cm/s] ground speed
 * @param vy [cm/s] 
 * @param vz [cm/s] glimb speed
 * @param battery_remaining [%] Battery energy remaining, -1: Battery remaining energy not sent by autopilot
 * @param target_alarm  Whether the target of interest has been found
 * @param gcs_status  
 * @param vehicle_status  
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_vehicle_info_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
                               uint8_t control_mode, uint8_t mode_status, float roll, float pitch, int16_t yaw, int32_t lat, int32_t lng, int32_t altitude, int32_t relative_alt, int16_t vx, int16_t vy, int16_t vz, uint8_t battery_remaining, uint8_t target_alarm, uint8_t gcs_status, uint8_t vehicle_status)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_VEHICLE_INFO_LEN];
    _mav_put_float(buf, 0, roll);
    _mav_put_float(buf, 4, pitch);
    _mav_put_int32_t(buf, 8, lat);
    _mav_put_int32_t(buf, 12, lng);
    _mav_put_int32_t(buf, 16, altitude);
    _mav_put_int32_t(buf, 20, relative_alt);
    _mav_put_int16_t(buf, 24, yaw);
    _mav_put_int16_t(buf, 26, vx);
    _mav_put_int16_t(buf, 28, vy);
    _mav_put_int16_t(buf, 30, vz);
    _mav_put_uint8_t(buf, 32, control_mode);
    _mav_put_uint8_t(buf, 33, mode_status);
    _mav_put_uint8_t(buf, 34, battery_remaining);
    _mav_put_uint8_t(buf, 35, target_alarm);
    _mav_put_uint8_t(buf, 36, gcs_status);
    _mav_put_uint8_t(buf, 37, vehicle_status);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_VEHICLE_INFO_LEN);
#else
    mavlink_vehicle_info_t packet;
    packet.roll = roll;
    packet.pitch = pitch;
    packet.lat = lat;
    packet.lng = lng;
    packet.altitude = altitude;
    packet.relative_alt = relative_alt;
    packet.yaw = yaw;
    packet.vx = vx;
    packet.vy = vy;
    packet.vz = vz;
    packet.control_mode = control_mode;
    packet.mode_status = mode_status;
    packet.battery_remaining = battery_remaining;
    packet.target_alarm = target_alarm;
    packet.gcs_status = gcs_status;
    packet.vehicle_status = vehicle_status;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_VEHICLE_INFO_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_VEHICLE_INFO;
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_VEHICLE_INFO_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_CRC);
}

/**
 * @brief Pack a vehicle_info message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param control_mode  control mode
 * @param mode_status  mode or status
 * @param roll [rad] Roll angle
 * @param pitch [rad] Pitch angle
 * @param yaw [degE2] Yaw angle 0-35999
 * @param lat [degE7] Latitude.
 * @param lng [degE7] Longitude.
 * @param altitude [mm] Altitude (MSL).
 * @param relative_alt [m] altitude relative to home.
 * @param vx [cm/s] ground speed
 * @param vy [cm/s] 
 * @param vz [cm/s] glimb speed
 * @param battery_remaining [%] Battery energy remaining, -1: Battery remaining energy not sent by autopilot
 * @param target_alarm  Whether the target of interest has been found
 * @param gcs_status  
 * @param vehicle_status  
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_vehicle_info_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
                               mavlink_message_t* msg,
                                   uint8_t control_mode,uint8_t mode_status,float roll,float pitch,int16_t yaw,int32_t lat,int32_t lng,int32_t altitude,int32_t relative_alt,int16_t vx,int16_t vy,int16_t vz,uint8_t battery_remaining,uint8_t target_alarm,uint8_t gcs_status,uint8_t vehicle_status)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_VEHICLE_INFO_LEN];
    _mav_put_float(buf, 0, roll);
    _mav_put_float(buf, 4, pitch);
    _mav_put_int32_t(buf, 8, lat);
    _mav_put_int32_t(buf, 12, lng);
    _mav_put_int32_t(buf, 16, altitude);
    _mav_put_int32_t(buf, 20, relative_alt);
    _mav_put_int16_t(buf, 24, yaw);
    _mav_put_int16_t(buf, 26, vx);
    _mav_put_int16_t(buf, 28, vy);
    _mav_put_int16_t(buf, 30, vz);
    _mav_put_uint8_t(buf, 32, control_mode);
    _mav_put_uint8_t(buf, 33, mode_status);
    _mav_put_uint8_t(buf, 34, battery_remaining);
    _mav_put_uint8_t(buf, 35, target_alarm);
    _mav_put_uint8_t(buf, 36, gcs_status);
    _mav_put_uint8_t(buf, 37, vehicle_status);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_VEHICLE_INFO_LEN);
#else
    mavlink_vehicle_info_t packet;
    packet.roll = roll;
    packet.pitch = pitch;
    packet.lat = lat;
    packet.lng = lng;
    packet.altitude = altitude;
    packet.relative_alt = relative_alt;
    packet.yaw = yaw;
    packet.vx = vx;
    packet.vy = vy;
    packet.vz = vz;
    packet.control_mode = control_mode;
    packet.mode_status = mode_status;
    packet.battery_remaining = battery_remaining;
    packet.target_alarm = target_alarm;
    packet.gcs_status = gcs_status;
    packet.vehicle_status = vehicle_status;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_VEHICLE_INFO_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_VEHICLE_INFO;
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_VEHICLE_INFO_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_CRC);
}

/**
 * @brief Encode a vehicle_info struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param vehicle_info C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_vehicle_info_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_vehicle_info_t* vehicle_info)
{
    return mavlink_msg_vehicle_info_pack(system_id, component_id, msg, vehicle_info->control_mode, vehicle_info->mode_status, vehicle_info->roll, vehicle_info->pitch, vehicle_info->yaw, vehicle_info->lat, vehicle_info->lng, vehicle_info->altitude, vehicle_info->relative_alt, vehicle_info->vx, vehicle_info->vy, vehicle_info->vz, vehicle_info->battery_remaining, vehicle_info->target_alarm, vehicle_info->gcs_status, vehicle_info->vehicle_status);
}

/**
 * @brief Encode a vehicle_info struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param vehicle_info C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_vehicle_info_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_vehicle_info_t* vehicle_info)
{
    return mavlink_msg_vehicle_info_pack_chan(system_id, component_id, chan, msg, vehicle_info->control_mode, vehicle_info->mode_status, vehicle_info->roll, vehicle_info->pitch, vehicle_info->yaw, vehicle_info->lat, vehicle_info->lng, vehicle_info->altitude, vehicle_info->relative_alt, vehicle_info->vx, vehicle_info->vy, vehicle_info->vz, vehicle_info->battery_remaining, vehicle_info->target_alarm, vehicle_info->gcs_status, vehicle_info->vehicle_status);
}

/**
 * @brief Send a vehicle_info message
 * @param chan MAVLink channel to send the message
 *
 * @param control_mode  control mode
 * @param mode_status  mode or status
 * @param roll [rad] Roll angle
 * @param pitch [rad] Pitch angle
 * @param yaw [degE2] Yaw angle 0-35999
 * @param lat [degE7] Latitude.
 * @param lng [degE7] Longitude.
 * @param altitude [mm] Altitude (MSL).
 * @param relative_alt [m] altitude relative to home.
 * @param vx [cm/s] ground speed
 * @param vy [cm/s] 
 * @param vz [cm/s] glimb speed
 * @param battery_remaining [%] Battery energy remaining, -1: Battery remaining energy not sent by autopilot
 * @param target_alarm  Whether the target of interest has been found
 * @param gcs_status  
 * @param vehicle_status  
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_vehicle_info_send(mavlink_channel_t chan, uint8_t control_mode, uint8_t mode_status, float roll, float pitch, int16_t yaw, int32_t lat, int32_t lng, int32_t altitude, int32_t relative_alt, int16_t vx, int16_t vy, int16_t vz, uint8_t battery_remaining, uint8_t target_alarm, uint8_t gcs_status, uint8_t vehicle_status)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_VEHICLE_INFO_LEN];
    _mav_put_float(buf, 0, roll);
    _mav_put_float(buf, 4, pitch);
    _mav_put_int32_t(buf, 8, lat);
    _mav_put_int32_t(buf, 12, lng);
    _mav_put_int32_t(buf, 16, altitude);
    _mav_put_int32_t(buf, 20, relative_alt);
    _mav_put_int16_t(buf, 24, yaw);
    _mav_put_int16_t(buf, 26, vx);
    _mav_put_int16_t(buf, 28, vy);
    _mav_put_int16_t(buf, 30, vz);
    _mav_put_uint8_t(buf, 32, control_mode);
    _mav_put_uint8_t(buf, 33, mode_status);
    _mav_put_uint8_t(buf, 34, battery_remaining);
    _mav_put_uint8_t(buf, 35, target_alarm);
    _mav_put_uint8_t(buf, 36, gcs_status);
    _mav_put_uint8_t(buf, 37, vehicle_status);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_INFO, buf, MAVLINK_MSG_ID_VEHICLE_INFO_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_CRC);
#else
    mavlink_vehicle_info_t packet;
    packet.roll = roll;
    packet.pitch = pitch;
    packet.lat = lat;
    packet.lng = lng;
    packet.altitude = altitude;
    packet.relative_alt = relative_alt;
    packet.yaw = yaw;
    packet.vx = vx;
    packet.vy = vy;
    packet.vz = vz;
    packet.control_mode = control_mode;
    packet.mode_status = mode_status;
    packet.battery_remaining = battery_remaining;
    packet.target_alarm = target_alarm;
    packet.gcs_status = gcs_status;
    packet.vehicle_status = vehicle_status;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_INFO, (const char *)&packet, MAVLINK_MSG_ID_VEHICLE_INFO_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_CRC);
#endif
}

/**
 * @brief Send a vehicle_info message
 * @param chan MAVLink channel to send the message
 * @param struct The MAVLink struct to serialize
 */
static inline void mavlink_msg_vehicle_info_send_struct(mavlink_channel_t chan, const mavlink_vehicle_info_t* vehicle_info)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    mavlink_msg_vehicle_info_send(chan, vehicle_info->control_mode, vehicle_info->mode_status, vehicle_info->roll, vehicle_info->pitch, vehicle_info->yaw, vehicle_info->lat, vehicle_info->lng, vehicle_info->altitude, vehicle_info->relative_alt, vehicle_info->vx, vehicle_info->vy, vehicle_info->vz, vehicle_info->battery_remaining, vehicle_info->target_alarm, vehicle_info->gcs_status, vehicle_info->vehicle_status);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_INFO, (const char *)vehicle_info, MAVLINK_MSG_ID_VEHICLE_INFO_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_CRC);
#endif
}

#if MAVLINK_MSG_ID_VEHICLE_INFO_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This varient of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_vehicle_info_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint8_t control_mode, uint8_t mode_status, float roll, float pitch, int16_t yaw, int32_t lat, int32_t lng, int32_t altitude, int32_t relative_alt, int16_t vx, int16_t vy, int16_t vz, uint8_t battery_remaining, uint8_t target_alarm, uint8_t gcs_status, uint8_t vehicle_status)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char *buf = (char *)msgbuf;
    _mav_put_float(buf, 0, roll);
    _mav_put_float(buf, 4, pitch);
    _mav_put_int32_t(buf, 8, lat);
    _mav_put_int32_t(buf, 12, lng);
    _mav_put_int32_t(buf, 16, altitude);
    _mav_put_int32_t(buf, 20, relative_alt);
    _mav_put_int16_t(buf, 24, yaw);
    _mav_put_int16_t(buf, 26, vx);
    _mav_put_int16_t(buf, 28, vy);
    _mav_put_int16_t(buf, 30, vz);
    _mav_put_uint8_t(buf, 32, control_mode);
    _mav_put_uint8_t(buf, 33, mode_status);
    _mav_put_uint8_t(buf, 34, battery_remaining);
    _mav_put_uint8_t(buf, 35, target_alarm);
    _mav_put_uint8_t(buf, 36, gcs_status);
    _mav_put_uint8_t(buf, 37, vehicle_status);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_INFO, buf, MAVLINK_MSG_ID_VEHICLE_INFO_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_CRC);
#else
    mavlink_vehicle_info_t *packet = (mavlink_vehicle_info_t *)msgbuf;
    packet->roll = roll;
    packet->pitch = pitch;
    packet->lat = lat;
    packet->lng = lng;
    packet->altitude = altitude;
    packet->relative_alt = relative_alt;
    packet->yaw = yaw;
    packet->vx = vx;
    packet->vy = vy;
    packet->vz = vz;
    packet->control_mode = control_mode;
    packet->mode_status = mode_status;
    packet->battery_remaining = battery_remaining;
    packet->target_alarm = target_alarm;
    packet->gcs_status = gcs_status;
    packet->vehicle_status = vehicle_status;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_INFO, (const char *)packet, MAVLINK_MSG_ID_VEHICLE_INFO_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_LEN, MAVLINK_MSG_ID_VEHICLE_INFO_CRC);
#endif
}
#endif

#endif

// MESSAGE VEHICLE_INFO UNPACKING


/**
 * @brief Get field control_mode from vehicle_info message
 *
 * @return  control mode
 */
static inline uint8_t mavlink_msg_vehicle_info_get_control_mode(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  32);
}

/**
 * @brief Get field mode_status from vehicle_info message
 *
 * @return  mode or status
 */
static inline uint8_t mavlink_msg_vehicle_info_get_mode_status(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  33);
}

/**
 * @brief Get field roll from vehicle_info message
 *
 * @return [rad] Roll angle
 */
static inline float mavlink_msg_vehicle_info_get_roll(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  0);
}

/**
 * @brief Get field pitch from vehicle_info message
 *
 * @return [rad] Pitch angle
 */
static inline float mavlink_msg_vehicle_info_get_pitch(const mavlink_message_t* msg)
{
    return _MAV_RETURN_float(msg,  4);
}

/**
 * @brief Get field yaw from vehicle_info message
 *
 * @return [degE2] Yaw angle 0-35999
 */
static inline int16_t mavlink_msg_vehicle_info_get_yaw(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int16_t(msg,  24);
}

/**
 * @brief Get field lat from vehicle_info message
 *
 * @return [degE7] Latitude.
 */
static inline int32_t mavlink_msg_vehicle_info_get_lat(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int32_t(msg,  8);
}

/**
 * @brief Get field lng from vehicle_info message
 *
 * @return [degE7] Longitude.
 */
static inline int32_t mavlink_msg_vehicle_info_get_lng(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int32_t(msg,  12);
}

/**
 * @brief Get field altitude from vehicle_info message
 *
 * @return [mm] Altitude (MSL).
 */
static inline int32_t mavlink_msg_vehicle_info_get_altitude(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int32_t(msg,  16);
}

/**
 * @brief Get field relative_alt from vehicle_info message
 *
 * @return [m] altitude relative to home.
 */
static inline int32_t mavlink_msg_vehicle_info_get_relative_alt(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int32_t(msg,  20);
}

/**
 * @brief Get field vx from vehicle_info message
 *
 * @return [cm/s] ground speed
 */
static inline int16_t mavlink_msg_vehicle_info_get_vx(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int16_t(msg,  26);
}

/**
 * @brief Get field vy from vehicle_info message
 *
 * @return [cm/s] 
 */
static inline int16_t mavlink_msg_vehicle_info_get_vy(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int16_t(msg,  28);
}

/**
 * @brief Get field vz from vehicle_info message
 *
 * @return [cm/s] glimb speed
 */
static inline int16_t mavlink_msg_vehicle_info_get_vz(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int16_t(msg,  30);
}

/**
 * @brief Get field battery_remaining from vehicle_info message
 *
 * @return [%] Battery energy remaining, -1: Battery remaining energy not sent by autopilot
 */
static inline uint8_t mavlink_msg_vehicle_info_get_battery_remaining(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  34);
}

/**
 * @brief Get field target_alarm from vehicle_info message
 *
 * @return  Whether the target of interest has been found
 */
static inline uint8_t mavlink_msg_vehicle_info_get_target_alarm(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  35);
}

/**
 * @brief Get field gcs_status from vehicle_info message
 *
 * @return  
 */
static inline uint8_t mavlink_msg_vehicle_info_get_gcs_status(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  36);
}

/**
 * @brief Get field vehicle_status from vehicle_info message
 *
 * @return  
 */
static inline uint8_t mavlink_msg_vehicle_info_get_vehicle_status(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  37);
}

/**
 * @brief Decode a vehicle_info message into a struct
 *
 * @param msg The message to decode
 * @param vehicle_info C-struct to decode the message contents into
 */
static inline void mavlink_msg_vehicle_info_decode(const mavlink_message_t* msg, mavlink_vehicle_info_t* vehicle_info)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    vehicle_info->roll = mavlink_msg_vehicle_info_get_roll(msg);
    vehicle_info->pitch = mavlink_msg_vehicle_info_get_pitch(msg);
    vehicle_info->lat = mavlink_msg_vehicle_info_get_lat(msg);
    vehicle_info->lng = mavlink_msg_vehicle_info_get_lng(msg);
    vehicle_info->altitude = mavlink_msg_vehicle_info_get_altitude(msg);
    vehicle_info->relative_alt = mavlink_msg_vehicle_info_get_relative_alt(msg);
    vehicle_info->yaw = mavlink_msg_vehicle_info_get_yaw(msg);
    vehicle_info->vx = mavlink_msg_vehicle_info_get_vx(msg);
    vehicle_info->vy = mavlink_msg_vehicle_info_get_vy(msg);
    vehicle_info->vz = mavlink_msg_vehicle_info_get_vz(msg);
    vehicle_info->control_mode = mavlink_msg_vehicle_info_get_control_mode(msg);
    vehicle_info->mode_status = mavlink_msg_vehicle_info_get_mode_status(msg);
    vehicle_info->battery_remaining = mavlink_msg_vehicle_info_get_battery_remaining(msg);
    vehicle_info->target_alarm = mavlink_msg_vehicle_info_get_target_alarm(msg);
    vehicle_info->gcs_status = mavlink_msg_vehicle_info_get_gcs_status(msg);
    vehicle_info->vehicle_status = mavlink_msg_vehicle_info_get_vehicle_status(msg);
#else
        uint8_t len = msg->len < MAVLINK_MSG_ID_VEHICLE_INFO_LEN? msg->len : MAVLINK_MSG_ID_VEHICLE_INFO_LEN;
        memset(vehicle_info, 0, MAVLINK_MSG_ID_VEHICLE_INFO_LEN);
    memcpy(vehicle_info, _MAV_PAYLOAD(msg), len);
#endif
}
