#pragma once
// MESSAGE BIND_FLYER_PLANE_ACK PACKING

#define MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK 229

MAVPACKED(
typedef struct __mavlink_bind_flyer_plane_ack_t {
 int32_t ack; /*<  ack(zero is succeeded, otherwise is falied).*/
}) mavlink_bind_flyer_plane_ack_t;

#define MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN 4
#define MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_MIN_LEN 4
#define MAVLINK_MSG_ID_229_LEN 4
#define MAVLINK_MSG_ID_229_MIN_LEN 4

#define MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_CRC 248
#define MAVLINK_MSG_ID_229_CRC 248



#if MAVLINK_COMMAND_24BIT
#define MAVLINK_MESSAGE_INFO_BIND_FLYER_PLANE_ACK { \
    229, \
    "BIND_FLYER_PLANE_ACK", \
    1, \
    {  { "ack", NULL, MAVLINK_TYPE_INT32_T, 0, 0, offsetof(mavlink_bind_flyer_plane_ack_t, ack) }, \
         } \
}
#else
#define MAVLINK_MESSAGE_INFO_BIND_FLYER_PLANE_ACK { \
    "BIND_FLYER_PLANE_ACK", \
    1, \
    {  { "ack", NULL, MAVLINK_TYPE_INT32_T, 0, 0, offsetof(mavlink_bind_flyer_plane_ack_t, ack) }, \
         } \
}
#endif

/**
 * @brief Pack a bind_flyer_plane_ack message
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 *
 * @param ack  ack(zero is succeeded, otherwise is falied).
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_ack_pack(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg,
                               int32_t ack)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN];
    _mav_put_int32_t(buf, 0, ack);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN);
#else
    mavlink_bind_flyer_plane_ack_t packet;
    packet.ack = ack;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK;
    return mavlink_finalize_message(msg, system_id, component_id, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_CRC);
}

/**
 * @brief Pack a bind_flyer_plane_ack message on a channel
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param ack  ack(zero is succeeded, otherwise is falied).
 * @return length of the message in bytes (excluding serial stream start sign)
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_ack_pack_chan(uint8_t system_id, uint8_t component_id, uint8_t chan,
                               mavlink_message_t* msg,
                                   int32_t ack)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN];
    _mav_put_int32_t(buf, 0, ack);

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), buf, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN);
#else
    mavlink_bind_flyer_plane_ack_t packet;
    packet.ack = ack;

        memcpy(_MAV_PAYLOAD_NON_CONST(msg), &packet, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN);
#endif

    msg->msgid = MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK;
    return mavlink_finalize_message_chan(msg, system_id, component_id, chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_CRC);
}

/**
 * @brief Encode a bind_flyer_plane_ack struct
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param msg The MAVLink message to compress the data into
 * @param bind_flyer_plane_ack C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_ack_encode(uint8_t system_id, uint8_t component_id, mavlink_message_t* msg, const mavlink_bind_flyer_plane_ack_t* bind_flyer_plane_ack)
{
    return mavlink_msg_bind_flyer_plane_ack_pack(system_id, component_id, msg, bind_flyer_plane_ack->ack);
}

/**
 * @brief Encode a bind_flyer_plane_ack struct on a channel
 *
 * @param system_id ID of this system
 * @param component_id ID of this component (e.g. 200 for IMU)
 * @param chan The MAVLink channel this message will be sent over
 * @param msg The MAVLink message to compress the data into
 * @param bind_flyer_plane_ack C-struct to read the message contents from
 */
static inline uint16_t mavlink_msg_bind_flyer_plane_ack_encode_chan(uint8_t system_id, uint8_t component_id, uint8_t chan, mavlink_message_t* msg, const mavlink_bind_flyer_plane_ack_t* bind_flyer_plane_ack)
{
    return mavlink_msg_bind_flyer_plane_ack_pack_chan(system_id, component_id, chan, msg, bind_flyer_plane_ack->ack);
}

/**
 * @brief Send a bind_flyer_plane_ack message
 * @param chan MAVLink channel to send the message
 *
 * @param ack  ack(zero is succeeded, otherwise is falied).
 */
#ifdef MAVLINK_USE_CONVENIENCE_FUNCTIONS

static inline void mavlink_msg_bind_flyer_plane_ack_send(mavlink_channel_t chan, int32_t ack)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char buf[MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN];
    _mav_put_int32_t(buf, 0, ack);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK, buf, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_CRC);
#else
    mavlink_bind_flyer_plane_ack_t packet;
    packet.ack = ack;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK, (const char *)&packet, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_CRC);
#endif
}

/**
 * @brief Send a bind_flyer_plane_ack message
 * @param chan MAVLink channel to send the message
 * @param struct The MAVLink struct to serialize
 */
static inline void mavlink_msg_bind_flyer_plane_ack_send_struct(mavlink_channel_t chan, const mavlink_bind_flyer_plane_ack_t* bind_flyer_plane_ack)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    mavlink_msg_bind_flyer_plane_ack_send(chan, bind_flyer_plane_ack->ack);
#else
    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK, (const char *)bind_flyer_plane_ack, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_CRC);
#endif
}

#if MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN <= MAVLINK_MAX_PAYLOAD_LEN
/*
  This varient of _send() can be used to save stack space by re-using
  memory from the receive buffer.  The caller provides a
  mavlink_message_t which is the size of a full mavlink message. This
  is usually the receive buffer for the channel, and allows a reply to an
  incoming message with minimum stack space usage.
 */
static inline void mavlink_msg_bind_flyer_plane_ack_send_buf(mavlink_message_t *msgbuf, mavlink_channel_t chan,  int32_t ack)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    char *buf = (char *)msgbuf;
    _mav_put_int32_t(buf, 0, ack);

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK, buf, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_CRC);
#else
    mavlink_bind_flyer_plane_ack_t *packet = (mavlink_bind_flyer_plane_ack_t *)msgbuf;
    packet->ack = ack;

    _mav_finalize_message_chan_send(chan, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK, (const char *)packet, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_MIN_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_CRC);
#endif
}
#endif

#endif

// MESSAGE BIND_FLYER_PLANE_ACK UNPACKING


/**
 * @brief Get field ack from bind_flyer_plane_ack message
 *
 * @return  ack(zero is succeeded, otherwise is falied).
 */
static inline int32_t mavlink_msg_bind_flyer_plane_ack_get_ack(const mavlink_message_t* msg)
{
    return _MAV_RETURN_int32_t(msg,  0);
}

/**
 * @brief Decode a bind_flyer_plane_ack message into a struct
 *
 * @param msg The message to decode
 * @param bind_flyer_plane_ack C-struct to decode the message contents into
 */
static inline void mavlink_msg_bind_flyer_plane_ack_decode(const mavlink_message_t* msg, mavlink_bind_flyer_plane_ack_t* bind_flyer_plane_ack)
{
#if MAVLINK_NEED_BYTE_SWAP || !MAVLINK_ALIGNED_FIELDS
    bind_flyer_plane_ack->ack = mavlink_msg_bind_flyer_plane_ack_get_ack(msg);
#else
        uint8_t len = msg->len < MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN? msg->len : MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN;
        memset(bind_flyer_plane_ack, 0, MAVLINK_MSG_ID_BIND_FLYER_PLANE_ACK_LEN);
    memcpy(bind_flyer_plane_ack, _MAV_PAYLOAD(msg), len);
#endif
}
