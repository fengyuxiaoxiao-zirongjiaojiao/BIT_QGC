#pragma once
// MESSAGE BIND_FLYER_PLANE PACKING

#define MAVLINK_MSG_ID_BIND_FLYER_PLANE 228

MAVPACKED(
typedef struct __mavlink_bind_flyer_plane_t {
 char token[64]; /*<  token.*/
 char uav_number[50]; /*<  uav number.*/
}) mavlink_bind_flyer_plane_t;

#define MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN 114
#define MAVLINK_MSG_ID_BIND_FLYER_PLANE_MIN_LEN 114
#define MAVLINK_MSG_ID_228_LEN 114
#define MAVLINK_MSG_ID_228_MIN_LEN 114

#define MAVLINK_MSG_ID_BIND_FLYER_PLANE_CRC 35
#define MAVLINK_MSG_ID_228_CRC 35

#define MAVLINK_MSG_BIND_FLYER_PLANE_FIELD_TOKEN_LEN 64
#define MAVLINK_MSG_BIND_FLYER_PLANE_FIELD_UAV_NUMBER_LEN 50

#if MAVLINK_COMMAND_24BIT
#define MAVLINK_MESSAGE_INFO_BIND_FLYER_PLANE { \
    228, \
    "BIND_FLYER_PLANE", \
    2, \
    {  { "token", NULL, MAVLINK_TYPE_CHAR, 64, 0, offsetof(mavlink_bind_flyer_plane_t, token) }, \
         { "uav_number", NULL, MAVLINK_TYPE_CHAR, 50, 64, offsetof(mavlink_bind_flyer_plane_t, uav_number) }, \
         } \
}
#else
#define MAVLINK_MESSAGE_INFO_BIND_FLYER_PLANE { \
    "BIND_FLYER_PLANE", \
    2, \
    {  { "token", NULL, MAVLINK_TYPE_CHAR, 64, 0, offsetof(mavlink_bind_flyer_plane_t, token) }, \
         { "uav_number", NULL, MAVLINK_TYPE_CHAR, 50, 64, offsetof(mavlink_bind_flyer_plane_t, uav_number) }, \
         } \
}
#endif

/**
 * @brief Pack a bind_flyer_plane message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param token  token.
 * @param uav_number  uav number.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
                               const char *token, const char *uav_number)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN];

    _mav_put_char_array(buf, 0, token, 64);
    _mav_put_char_array(buf, 64, uav_number, 50);
        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN);
#else
    mavlink_bind_flyer_plane_t packet;

    mav_array_memcpy(packet.token, token, sizeof(char)*64);
    mav_array_memcpy(packet.uav_number, uav_number, sizeof(char)*50);
        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_BIND_FLYER_PLANE;
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_BIND_FLYER_PLANE_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_CRC);
}

/**
 * @brief Pack a bind_flyer_plane message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param token  token.
 * @param uav_number  uav number.
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
                               mavlink_message_t* msg,
                                   const char *token,const char *uav_number)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN];

    _mav_put_char_array(buf, 0, token, 64);
    _mav_put_char_array(buf, 64, uav_number, 50);
        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN);
#else
    mavlink_bind_flyer_plane_t packet;

    mav_array_memcpy(packet.token, token, sizeof(char)*64);
    mav_array_memcpy(packet.uav_number, uav_number, sizeof(char)*50);
        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_BIND_FLYER_PLANE;
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_CRC);
}

/**
 * @brief Encode a bind_flyer_plane struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param bind_flyer_plane C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_bind_flyer_plane_t* bind_flyer_plane)
{
    return mavlink_msg_bind_flyer_plane_pack(system_id, component_id, msg, bind_flyer_plane->token, bind_flyer_plane->uav_number);
}

/**
 * @brief Encode a bind_flyer_plane struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param bind_flyer_plane C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_bind_flyer_plane_t* bind_flyer_plane)
{
    return mavlink_msg_bind_flyer_plane_pack_chan(system_id, component_id, chan, msg, bind_flyer_plane->token, bind_flyer_plane->uav_number);
}

/**
 * @brief Send a bind_flyer_plane message
 * @param chan MAVLink channel to send the message
 *
 * @param token  token.
 * @param uav_number  uav number.
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_bind_flyer_plane_send(mavlink_channel_t chan, const char *token, const char *uav_number)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN];

    _mav_put_char_array(buf, 0, token, 64);
    _mav_put_char_array(buf, 64, uav_number, 50);
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE, buf, MAVLINK_MSG_ID_BIND_FLYER_PLANE_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_CRC);
#else
    mavlink_bind_flyer_plane_t packet;

    mav_array_memcpy(packet.token, token, sizeof(char)*64);
    mav_array_memcpy(packet.uav_number, uav_number, sizeof(char)*50);
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE, (const char *)&packet, MAVLINK_MSG_ID_BIND_FLYER_PLANE_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_CRC);
#endif
}

/**
 * @brief Send a bind_flyer_plane message
 * @param chan MAVLink channel to send the message
 * @param struct The MAVLink struct to serialize
 */
static inline void mavlink_msg_bind_flyer_plane_send_struct(mavlink_channel_t chan, const mavlink_bind_flyer_plane_t* bind_flyer_plane)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    mavlink_msg_bind_flyer_plane_send(chan, bind_flyer_plane->token, bind_flyer_plane->uav_number);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE, (const char *)bind_flyer_plane, MAVLINK_MSG_ID_BIND_FLYER_PLANE_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_CRC);
#endif
}

#if MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This varient of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_bind_flyer_plane_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  const char *token, const char *uav_number)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char *buf = (char *)msgbuf;

    _mav_put_char_array(buf, 0, token, 64);
    _mav_put_char_array(buf, 64, uav_number, 50);
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE, buf, MAVLINK_MSG_ID_BIND_FLYER_PLANE_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_CRC);
#else
    mavlink_bind_flyer_plane_t *packet = (mavlink_bind_flyer_plane_t *)msgbuf;

    mav_array_memcpy(packet->token, token, sizeof(char)*64);
    mav_array_memcpy(packet->uav_number, uav_number, sizeof(char)*50);
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE, (const char *)packet, MAVLINK_MSG_ID_BIND_FLYER_PLANE_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_CRC);
#endif
}
#endif

#endif

// MESSAGE BIND_FLYER_PLANE UNPACKING


/**
 * @brief Get field token from bind_flyer_plane message
 *
 * @return  token.
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_get_token(const mavlink_message_t* msg, char *token)
{
    return _MAV_RETURN_char_array(msg, token, 64,  0);
}

/**
 * @brief Get field uav_number from bind_flyer_plane message
 *
 * @return  uav number.
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_get_uav_number(const mavlink_message_t* msg, char *uav_number)
{
    return _MAV_RETURN_char_array(msg, uav_number, 50,  64);
}

/**
 * @brief Decode a bind_flyer_plane message into a struct
 *
 * @param msg The message to decode
 * @param bind_flyer_plane C-struct to decode the message contents into
 */
static inline void mavlink_msg_bind_flyer_plane_decode(const mavlink_message_t* msg, mavlink_bind_flyer_plane_t* bind_flyer_plane)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    mavlink_msg_bind_flyer_plane_get_token(msg, bind_flyer_plane->token);
    mavlink_msg_bind_flyer_plane_get_uav_number(msg, bind_flyer_plane->uav_number);
#else
        uint8_t len = msg->len < MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN? msg->len : MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN;
        memset(bind_flyer_plane, 0, MAVLINK_MSG_ID_BIND_FLYER_PLANE_LEN);
    memcpy(bind_flyer_plane, _MAV_PAYLOAD(msg), len);
#endif
}
