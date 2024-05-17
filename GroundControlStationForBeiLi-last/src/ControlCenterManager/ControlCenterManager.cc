#include "ControlCenterManager.h"
#include "HttpServer/HttpApiDataDefine.h"
#include <QDebug>
#include "HttpServer/HttpAPIManager.h"

ControlCenterManager::ControlCenterManager(QGCApplication *app, QGCToolbox *toolbox)
    : QGCTool(app, toolbox)
    , _tcpSocket(nullptr)
    , _isConnected(false)
    , _isAutoConnect(false)
    , _decodedFirstMavlinkPacket(false)
    , _message({})
    , _status({})
    , _currentVersion(100)
{
    _tcpSocket = new QTcpSocket(this);
    connect(_tcpSocket, &QTcpSocket::readyRead, this, &ControlCenterManager::_onReadyRead);
    connect(_tcpSocket, &QTcpSocket::connected, this, &ControlCenterManager::_onConnected);
    connect(_tcpSocket, &QTcpSocket::disconnected, this, &ControlCenterManager::_onDisconnected);

    connect(&_timer, &QTimer::timeout, this, &ControlCenterManager::_onTimeout);
    _timer.setInterval(5000);
    memset(&_message, 0, sizeof(_message));
    memset(&_status, 0, sizeof(_status));
    setMavlinkChannel();
}

ControlCenterManager::~ControlCenterManager()
{
    _timer.stop();
    closeLink();
    if (_tcpSocket) {
        _tcpSocket->deleteLater();
        _tcpSocket = nullptr;
    }
}

void ControlCenterManager::setAutoConnectLink(bool isAutoConnect)
{
    if (isAutoConnect != _isAutoConnect) {
        _isAutoConnect = isAutoConnect;
        if (_isAutoConnect && qgcApp()->toolbox()->httpAPIManager()->getUserManager()->isLogin()) {
            _timer.start();
        } else {
            _timer.stop();
        }
    }
}

void ControlCenterManager::openLink()
{
    closeLink();
    QString ip = qgcApp()->toolbox()->settingsManager()->httpServerSettings()->serverIp()->rawValueString();
    int port = qgcApp()->toolbox()->settingsManager()->httpServerSettings()->controlCenterPort()->rawValueString().toInt();
    _tcpSocket->connectToHost(ip, port);
}

void ControlCenterManager::closeLink()
{
    if (isConnected()) {
        _tcpSocket->close();
    }
}

void ControlCenterManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);

    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<ControlCenterManager>("QGroundControl.ControlCenterManager", 1, 0, "ControlCenterManager", "Reference only");
    setAutoConnectLink(true);
    connect(qgcApp()->toolbox()->httpAPIManager()->getUserManager(), &UserManager::isLoginChanged, this, &ControlCenterManager::_onUserLoginChanged);
}

bool ControlCenterManager::isConnected()
{
    return _isConnected;
}

bool ControlCenterManager::isAutoConnect()
{
    return _isAutoConnect;
}

void ControlCenterManager::setMavlinkChannel()
{
    uint8_t mavlinkChannel = 2;
    mavlink_reset_channel_status(mavlinkChannel);
    mavlink_status_t* mavlinkStatus = mavlink_get_channel_status(mavlinkChannel);
    mavlinkStatus->flags |= MAVLINK_STATUS_FLAG_OUT_MAVLINK1;
    _mavlinkChannel = mavlinkChannel;
}

void ControlCenterManager::setVersion(uint32_t version)
{
    uint8_t mavlinkChannel = getMavlinkChannel();
    mavlink_status_t* mavlinkStatus = mavlink_get_channel_status(mavlinkChannel);

    if (version < 200) {
        mavlinkStatus->flags |= MAVLINK_STATUS_FLAG_OUT_MAVLINK1;
    } else {
        mavlinkStatus->flags &= ~MAVLINK_STATUS_FLAG_OUT_MAVLINK1;
    }
    _currentVersion = version;
}

void ControlCenterManager::_onReadyRead()
{
    QByteArray b = _tcpSocket->readAll();

    uint8_t mavlinkChannel = getMavlinkChannel();
    for (int position = 0; position < b.size(); position++) {
        if (mavlink_parse_char(mavlinkChannel, static_cast<uint8_t>(b[position]), &_message, &_status)) {
            // got a valid message
            if (!_decodedFirstMavlinkPacket) {
                _decodedFirstMavlinkPacket = true;
                mavlink_status_t* mavlinkStatus = mavlink_get_channel_status(mavlinkChannel);
                if (!(mavlinkStatus->flags & MAVLINK_STATUS_FLAG_IN_MAVLINK1) && (mavlinkStatus->flags & MAVLINK_STATUS_FLAG_OUT_MAVLINK1)) {
                    qDebug() << __FILE__ << __func__ << __LINE__ << "Switching outbound to mavlink 2.0 due to incoming mavlink 2.0 packet:" << mavlinkStatus << mavlinkChannel << mavlinkStatus->flags;
                    mavlinkStatus->flags &= ~MAVLINK_STATUS_FLAG_OUT_MAVLINK1;
                    setVersion(200);
                }
            }

            if (_message.compid == MAV_COMP_ID_MISSIONPLANNER) return;
            //qDebug() << __FILE__ << __func__ << __LINE__ << "msgid:" << _message.msgid;

            if (_message.msgid == MAVLINK_MSG_ID_VEHICLE_CONTROL) {
                mavlink_vehicle_control_t vehicleControl;
                mavlink_msg_vehicle_control_decode(&_message, &vehicleControl);
                _messageList.clear();
                _messageList << QString("system id:%1").arg(_message.sysid);
                _messageList << QString("component id:%1").arg(_message.compid);
                _messageList << QString("command type:%1").arg(vehicleControl.command_type);// 指令类型
                _messageList << QString("mode status:%1").arg(vehicleControl.mode_status); // 控制状态
                _messageList << QString("mission type:%1").arg(vehicleControl.mission_type); // 任务类型
                _messageList << QString("land platform:%1").arg(vehicleControl.land_platform); // 平台编号
                _messageList << QString("control mode:%1").arg(vehicleControl.control_mode); // 控制模式
                _messageList << QString("lng:%1").arg(QString::number(vehicleControl.lng * 0.0000001, 'f', 8)); // 经度
                _messageList << QString("lat:%1").arg(QString::number(vehicleControl.lat * 0.0000001, 'f', 8)); // 纬度
                _messageList << QString("range:%1").arg(vehicleControl.range); // 范围
                _messageList << QString("spare1:%1").arg(vehicleControl.spare1); // 保留
                emit messageCountChanged();
                //qDebug() << __FILE__ << __func__ << __LINE__ << _messageList;
                /*const mavlink_message_info_t* msgInfo = mavlink_get_message_info(&_message);
                if (msgInfo) {
                    qDebug() << __FILE__ << __func__ << __LINE__ << "msgid:" << _message.msgid << "name:" << QString(msgInfo->name);
                    for (int i = 0; i < msgInfo->num_fields; i++) {
                        QString type = QString("?");
                        switch (msgInfo->fields[i].type) {
                            case MAVLINK_TYPE_CHAR:     type = QString("char");     break;
                            case MAVLINK_TYPE_UINT8_T:  type = QString("uint8_t");  break;
                            case MAVLINK_TYPE_INT8_T:   type = QString("int8_t");   break;
                            case MAVLINK_TYPE_UINT16_T: type = QString("uint16_t"); break;
                            case MAVLINK_TYPE_INT16_T:  type = QString("int16_t");  break;
                            case MAVLINK_TYPE_UINT32_T: type = QString("uint32_t"); break;
                            case MAVLINK_TYPE_INT32_T:  type = QString("int32_t");  break;
                            case MAVLINK_TYPE_FLOAT:    type = QString("float");    break;
                            case MAVLINK_TYPE_DOUBLE:   type = QString("double");   break;
                            case MAVLINK_TYPE_UINT64_T: type = QString("uint64_t"); break;
                            case MAVLINK_TYPE_INT64_T:  type = QString("int64_t");  break;
                        }
                        QString fieldName = msgInfo->fields[i].name;
                        qDebug() << __FILE__ << __func__ << __LINE__ << fieldName << type << msgInfo->fields[i].;
                    }
                }*/
            }


        }
    }
}

void ControlCenterManager::_onConnected()
{
    _isConnected = true;
    emit connectedChanged(true);

    _timer.stop();
}

void ControlCenterManager::_onDisconnected()
{
    _isConnected = false;
    emit connectedChanged(false);

    if (_isAutoConnect) {
        _timer.start();
    }
}

void ControlCenterManager::_onTimeout()
{
    if (!isConnected()) {
        qDebug() << __FILE__ << __func__ << __LINE__ << "try to connect server";
        openLink();
    }
}

void ControlCenterManager::_onUserLoginChanged(bool isLogin)
{
    if (isLogin) {
        openLink();
    } else {
        closeLink();
    }
}
