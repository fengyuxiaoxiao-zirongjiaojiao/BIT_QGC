#pragma once
// MESSAGE VEHICLE_CONTROL PACKING

#define MAVLINK_MSG_ID_VEHICLE_CONTROL 500

MAVPACKED(
typedef struct __mavlink_vehicle_control_t {
 int32_t lng; /*< [degE7] Longitude.*/
 int32_t lat; /*< [degE7] Latitude.*/
 int16_t range; /*< [deg] work range.*/
 uint8_t command_type; /*<  */
 uint8_t mode_status; /*<  mode or status*/
 uint8_t mission_type; /*<  detect or hit*/
 uint8_t land_platform; /*<  */
 uint8_t control_mode; /*<  control mode*/
 uint8_t spare1; /*<  */
}) mavlink_vehicle_control_t;

#define MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN 16
#define MAVLINK_MSG_ID_VEHICLE_CONTROL_MIN_LEN 16
#define MAVLINK_MSG_ID_500_LEN 16
#define MAVLINK_MSG_ID_500_MIN_LEN 16

#define MAVLINK_MSG_ID_VEHICLE_CONTROL_CRC 212
#define MAVLINK_MSG_ID_500_CRC 212



#if MAVLINK_COMMAND_24BIT
#define MAVLINK_MESSAGE_INFO_VEHICLE_CONTROL { \
    500, \
    "VEHICLE_CONTROL", \
    9, \
    {  { "command_type", NULL, MAVLINK_TYPE_UINT8_T, 0, 10, offsetof(mavlink_vehicle_control_t, command_type) }, \
         { "mode_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 11, offsetof(mavlink_vehicle_control_t, mode_status) }, \
         { "mission_type", NULL, MAVLINK_TYPE_UINT8_T, 0, 12, offsetof(mavlink_vehicle_control_t, mission_type) }, \
         { "land_platform", NULL, MAVLINK_TYPE_UINT8_T, 0, 13, offsetof(mavlink_vehicle_control_t, land_platform) }, \
         { "control_mode", NULL, MAVLINK_TYPE_UINT8_T, 0, 14, offsetof(mavlink_vehicle_control_t, control_mode) }, \
         { "lng", NULL, MAVLINK_TYPE_INT32_T, 0, 0, offsetof(mavlink_vehicle_control_t, lng) }, \
         { "lat", NULL, MAVLINK_TYPE_INT32_T, 0, 4, offsetof(mavlink_vehicle_control_t, lat) }, \
         { "range", NULL, MAVLINK_TYPE_INT16_T, 0, 8, offsetof(mavlink_vehicle_control_t, range) }, \
         { "spare1", NULL, MAVLINK_TYPE_UINT8_T, 0, 15, offsetof(mavlink_vehicle_control_t, spare1) }, \
         } \
}
#else
#define MAVLINK_MESSAGE_INFO_VEHICLE_CONTROL { \
    "VEHICLE_CONTROL", \
    9, \
    {  { "command_type", NULL, MAVLINK_TYPE_UINT8_T, 0, 10, offsetof(mavlink_vehicle_control_t, command_type) }, \
         { "mode_status", NULL, MAVLINK_TYPE_UINT8_T, 0, 11, offsetof(mavlink_vehicle_control_t, mode_status) }, \
         { "mission_type", NULL, MAVLINK_TYPE_UINT8_T, 0, 12, offsetof(mavlink_vehicle_control_t, mission_type) }, \
         { "land_platform", NULL, MAVLINK_TYPE_UINT8_T, 0, 13, offsetof(mavlink_vehicle_control_t, land_platform) }, \
         { "control_mode", NULL, MAVLINK_TYPE_UINT8_T, 0, 14, offsetof(mavlink_vehicle_control_t, control_mode) }, \
         { "lng", NULL, MAVLINK_TYPE_INT32_T, 0, 0, offsetof(mavlink_vehicle_control_t, lng) }, \
         { "lat", NULL, MAVLINK_TYPE_INT32_T, 0, 4, offsetof(mavlink_vehicle_control_t, lat) }, \
         { "range", NULL, MAVLINK_TYPE_INT16_T, 0, 8, offsetof(mavlink_vehicle_control_t, range) }, \
         { "spare1", NULL, MAVLINK_TYPE_UINT8_T, 0, 15, offsetof(mavlink_vehicle_control_t, spare1) }, \
         } \
}
#endif

/**
 * @brief Pack a vehicle_control message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param command_type  
 * @param mode_status  mode or status
 * @param mission_type  detect or hit
 * @param land_platform  
 * @param control_mode  control mode
 * @param lng [degE7] Longitude.
 * @param lat [degE7] Latitude.
 * @param range [deg] work range.
 * @param spare1  
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_vehicle_control_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
                               uint8_t command_type, uint8_t mode_status, uint8_t mission_type, uint8_t land_platform, uint8_t control_mode, int32_t lng, int32_t lat, int16_t range, uint8_t spare1)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN];
    _mav_put_int32_t(buf, 0, lng);
    _mav_put_int32_t(buf, 4, lat);
    _mav_put_int16_t(buf, 8, range);
    _mav_put_uint8_t(buf, 10, command_type);
    _mav_put_uint8_t(buf, 11, mode_status);
    _mav_put_uint8_t(buf, 12, mission_type);
    _mav_put_uint8_t(buf, 13, land_platform);
    _mav_put_uint8_t(buf, 14, control_mode);
    _mav_put_uint8_t(buf, 15, spare1);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN);
#else
    mavlink_vehicle_control_t packet;
    packet.lng = lng;
    packet.lat = lat;
    packet.range = range;
    packet.command_type = command_type;
    packet.mode_status = mode_status;
    packet.mission_type = mission_type;
    packet.land_platform = land_platform;
    packet.control_mode = control_mode;
    packet.spare1 = spare1;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_VEHICLE_CONTROL;
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_VEHICLE_CONTROL_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_CRC);
}

/**
 * @brief Pack a vehicle_control message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param command_type  
 * @param mode_status  mode or status
 * @param mission_type  detect or hit
 * @param land_platform  
 * @param control_mode  control mode
 * @param lng [degE7] Longitude.
 * @param lat [degE7] Latitude.
 * @param range [deg] work range.
 * @param spare1  
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_vehicle_control_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
                               mavlink_message_t* msg,
                                   uint8_t command_type,uint8_t mode_status,uint8_t mission_type,uint8_t land_platform,uint8_t control_mode,int32_t lng,int32_t lat,int16_t range,uint8_t spare1)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN];
    _mav_put_int32_t(buf, 0, lng);
    _mav_put_int32_t(buf, 4, lat);
    _mav_put_int16_t(buf, 8, range);
    _mav_put_uint8_t(buf, 10, command_type);
    _mav_put_uint8_t(buf, 11, mode_status);
    _mav_put_uint8_t(buf, 12, mission_type);
    _mav_put_uint8_t(buf, 13, land_platform);
    _mav_put_uint8_t(buf, 14, control_mode);
    _mav_put_uint8_t(buf, 15, spare1);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN);
#else
    mavlink_vehicle_control_t packet;
    packet.lng = lng;
    packet.lat = lat;
    packet.range = range;
    packet.command_type = command_type;
    packet.mode_status = mode_status;
    packet.mission_type = mission_type;
    packet.land_platform = land_platform;
    packet.control_mode = control_mode;
    packet.spare1 = spare1;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_VEHICLE_CONTROL;
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_VEHICLE_CONTROL_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_CRC);
}

/**
 * @brief Encode a vehicle_control struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param vehicle_control C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_vehicle_control_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_vehicle_control_t* vehicle_control)
{
    return mavlink_msg_vehicle_control_pack(system_id, component_id, msg, vehicle_control->command_type, vehicle_control->mode_status, vehicle_control->mission_type, vehicle_control->land_platform, vehicle_control->control_mode, vehicle_control->lng, vehicle_control->lat, vehicle_control->range, vehicle_control->spare1);
}

/**
 * @brief Encode a vehicle_control struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param vehicle_control C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_vehicle_control_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_vehicle_control_t* vehicle_control)
{
    return mavlink_msg_vehicle_control_pack_chan(system_id, component_id, chan, msg, vehicle_control->command_type, vehicle_control->mode_status, vehicle_control->mission_type, vehicle_control->land_platform, vehicle_control->control_mode, vehicle_control->lng, vehicle_control->lat, vehicle_control->range, vehicle_control->spare1);
}

/**
 * @brief Send a vehicle_control message
 * @param chan MAVLink channel to send the message
 *
 * @param command_type  
 * @param mode_status  mode or status
 * @param mission_type  detect or hit
 * @param land_platform  
 * @param control_mode  control mode
 * @param lng [degE7] Longitude.
 * @param lat [degE7] Latitude.
 * @param range [deg] work range.
 * @param spare1  
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_vehicle_control_send(mavlink_channel_t chan, uint8_t command_type, uint8_t mode_status, uint8_t mission_type, uint8_t land_platform, uint8_t control_mode, int32_t lng, int32_t lat, int16_t range, uint8_t spare1)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN];
    _mav_put_int32_t(buf, 0, lng);
    _mav_put_int32_t(buf, 4, lat);
    _mav_put_int16_t(buf, 8, range);
    _mav_put_uint8_t(buf, 10, command_type);
    _mav_put_uint8_t(buf, 11, mode_status);
    _mav_put_uint8_t(buf, 12, mission_type);
    _mav_put_uint8_t(buf, 13, land_platform);
    _mav_put_uint8_t(buf, 14, control_mode);
    _mav_put_uint8_t(buf, 15, spare1);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_CONTROL, buf, MAVLINK_MSG_ID_VEHICLE_CONTROL_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_CRC);
#else
    mavlink_vehicle_control_t packet;
    packet.lng = lng;
    packet.lat = lat;
    packet.range = range;
    packet.command_type = command_type;
    packet.mode_status = mode_status;
    packet.mission_type = mission_type;
    packet.land_platform = land_platform;
    packet.control_mode = control_mode;
    packet.spare1 = spare1;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_CONTROL, (const char *)&packet, MAVLINK_MSG_ID_VEHICLE_CONTROL_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_CRC);
#endif
}

/**
 * @brief Send a vehicle_control message
 * @param chan MAVLink channel to send the message
 * @param struct The MAVLink struct to serialize
 */
static inline void mavlink_msg_vehicle_control_send_struct(mavlink_channel_t chan, const mavlink_vehicle_control_t* vehicle_control)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    mavlink_msg_vehicle_control_send(chan, vehicle_control->command_type, vehicle_control->mode_status, vehicle_control->mission_type, vehicle_control->land_platform, vehicle_control->control_mode, vehicle_control->lng, vehicle_control->lat, vehicle_control->range, vehicle_control->spare1);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_CONTROL, (const char *)vehicle_control, MAVLINK_MSG_ID_VEHICLE_CONTROL_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_CRC);
#endif
}

#if MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This varient of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_vehicle_control_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  uint8_t command_type, uint8_t mode_status, uint8_t mission_type, uint8_t land_platform, uint8_t control_mode, int32_t lng, int32_t lat, int16_t range, uint8_t spare1)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char *buf = (char *)msgbuf;
    _mav_put_int32_t(buf, 0, lng);
    _mav_put_int32_t(buf, 4, lat);
    _mav_put_int16_t(buf, 8, range);
    _mav_put_uint8_t(buf, 10, command_type);
    _mav_put_uint8_t(buf, 11, mode_status);
    _mav_put_uint8_t(buf, 12, mission_type);
    _mav_put_uint8_t(buf, 13, land_platform);
    _mav_put_uint8_t(buf, 14, control_mode);
    _mav_put_uint8_t(buf, 15, spare1);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_CONTROL, buf, MAVLINK_MSG_ID_VEHICLE_CONTROL_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_CRC);
#else
    mavlink_vehicle_control_t *packet = (mavlink_vehicle_control_t *)msgbuf;
    packet->lng = lng;
    packet->lat = lat;
    packet->range = range;
    packet->command_type = command_type;
    packet->mode_status = mode_status;
    packet->mission_type = mission_type;
    packet->land_platform = land_platform;
    packet->control_mode = control_mode;
    packet->spare1 = spare1;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_VEHICLE_CONTROL, (const char *)packet, MAVLINK_MSG_ID_VEHICLE_CONTROL_MIN_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN, MAVLINK_MSG_ID_VEHICLE_CONTROL_CRC);
#endif
}
#endif

#endif

// MESSAGE VEHICLE_CONTROL UNPACKING


/**
 * @brief Get field command_type from vehicle_control message
 *
 * @return  
 */
static inline uint8_t mavlink_msg_vehicle_control_get_command_type(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  10);
}

/**
 * @brief Get field mode_status from vehicle_control message
 *
 * @return  mode or status
 */
static inline uint8_t mavlink_msg_vehicle_control_get_mode_status(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  11);
}

/**
 * @brief Get field mission_type from vehicle_control message
 *
 * @return  detect or hit
 */
static inline uint8_t mavlink_msg_vehicle_control_get_mission_type(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  12);
}

/**
 * @brief Get field land_platform from vehicle_control message
 *
 * @return  
 */
static inline uint8_t mavlink_msg_vehicle_control_get_land_platform(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  13);
}

/**
 * @brief Get field control_mode from vehicle_control message
 *
 * @return  control mode
 */
static inline uint8_t mavlink_msg_vehicle_control_get_control_mode(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  14);
}

/**
 * @brief Get field lng from vehicle_control message
 *
 * @return [degE7] Longitude.
 */
static inline int32_t mavlink_msg_vehicle_control_get_lng(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int32_t(msg,  0);
}

/**
 * @brief Get field lat from vehicle_control message
 *
 * @return [degE7] Latitude.
 */
static inline int32_t mavlink_msg_vehicle_control_get_lat(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int32_t(msg,  4);
}

/**
 * @brief Get field range from vehicle_control message
 *
 * @return [deg] work range.
 */
static inline int16_t mavlink_msg_vehicle_control_get_range(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int16_t(msg,  8);
}

/**
 * @brief Get field spare1 from vehicle_control message
 *
 * @return  
 */
static inline uint8_t mavlink_msg_vehicle_control_get_spare1(const mavlink_message_t* msg)
{
    return _MAV_RETURN_uint8_t(msg,  15);
}

/**
 * @brief Decode a vehicle_control message into a struct
 *
 * @param msg The message to decode
 * @param vehicle_control C-struct to decode the message contents into
 */
static inline void mavlink_msg_vehicle_control_decode(const mavlink_message_t* msg, mavlink_vehicle_control_t* vehicle_control)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    vehicle_control->lng = mavlink_msg_vehicle_control_get_lng(msg);
    vehicle_control->lat = mavlink_msg_vehicle_control_get_lat(msg);
    vehicle_control->range = mavlink_msg_vehicle_control_get_range(msg);
    vehicle_control->command_type = mavlink_msg_vehicle_control_get_command_type(msg);
    vehicle_control->mode_status = mavlink_msg_vehicle_control_get_mode_status(msg);
    vehicle_control->mission_type = mavlink_msg_vehicle_control_get_mission_type(msg);
    vehicle_control->land_platform = mavlink_msg_vehicle_control_get_land_platform(msg);
    vehicle_control->control_mode = mavlink_msg_vehicle_control_get_control_mode(msg);
    vehicle_control->spare1 = mavlink_msg_vehicle_control_get_spare1(msg);
#else
        uint8_t len = msg->len < MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN? msg->len : MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN;
        memset(vehicle_control, 0, MAVLINK_MSG_ID_VEHICLE_CONTROL_LEN);
    memcpy(vehicle_control, _MAV_PAYLOAD(msg), len);
#endif
}
