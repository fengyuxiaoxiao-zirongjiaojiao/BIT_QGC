/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "NTRIP.h"
#include "QGCLoggingCategory.h"
#include "QGCApplication.h"
#include "SettingsManager.h"
#include "PositionManager.h"
#include "NTRIPSettings.h"

#include <QDebug>

NTRIP::NTRIP(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool(app, toolbox)
{
}

NTRIP::~NTRIP()
{
    if (_rtcmMavlink) {
        delete _rtcmMavlink;
        _rtcmMavlink = nullptr;
    }
}

void NTRIP::setToolbox(QGCToolbox* toolbox)
{
    QGCTool::setToolbox(toolbox);
    
    NTRIPSettings* settings = qgcApp()->toolbox()->settingsManager()->ntripSettings();
    connect(settings->ntripServerConnectEnabled(), &Fact::valueChanged, this, &NTRIP::_NTRIPSettingsChanged);
    connect(settings->ntripServerHostAddress(), &Fact::valueChanged, this, &NTRIP::_NTRIPSettingsChanged);
    connect(settings->ntripServerPort(), &Fact::valueChanged, this, &NTRIP::_NTRIPSettingsChanged);
    connect(settings->ntripUsername(), &Fact::valueChanged, this, &NTRIP::_NTRIPSettingsChanged);
    connect(settings->ntripPassword(), &Fact::valueChanged, this, &NTRIP::_NTRIPSettingsChanged);
    connect(settings->ntripMountpoint(), &Fact::valueChanged, this, &NTRIP::_NTRIPSettingsChanged);
    connect(settings->ntripWhitelist(), &Fact::valueChanged, this, &NTRIP::_NTRIPSettingsChanged);
    _NTRIPSettingsChanged();
}


void NTRIP::_tcpError(const QString errorMsg)
{
    qgcApp()->showAppMessage(tr("NTRIP Server Error: %1").arg(errorMsg));
}

void NTRIP::_NTRIPSettingsChanged()
{
    // 断开连接，销毁对象
    if (_tcpLink) {
        disconnect(_tcpLink, &NTRIPTCPLink::error,              this, &NTRIP::_tcpError);
        disconnect(_tcpLink, &NTRIPTCPLink::RTCMDataUpdate,   _rtcmMavlink, &RTCMMavlink::RTCMDataUpdate);
        delete _tcpLink;
        _tcpLink = nullptr;
    }
    if (_rtcmMavlink) {
        delete _rtcmMavlink;
        _rtcmMavlink = nullptr;
    }

    NTRIPSettings* settings = qgcApp()->toolbox()->settingsManager()->ntripSettings();
    if (settings->ntripServerConnectEnabled()->rawValue().toBool()) {
        _rtcmMavlink = new RTCMMavlink(*_toolbox);

        _tcpLink = new NTRIPTCPLink(settings->ntripServerHostAddress()->rawValue().toString(),
                                    settings->ntripServerPort()->rawValue().toInt(),
                                    settings->ntripUsername()->rawValue().toString(),
                                    settings->ntripPassword()->rawValue().toString(),
                                    settings->ntripMountpoint()->rawValue().toString(),
                                    settings->ntripWhitelist()->rawValue().toString(),
                                    this);
        QGeoCoordinate homePosition = _tcpLink->getHomePosition();
        // 1 当前活动飞机
        Vehicle *activeVehicle = qgcApp()->toolbox()->multiVehicleManager()->activeVehicle();
        if (activeVehicle) {
            homePosition = activeVehicle->homePosition();
        } else {
            // 2 地面站定位
            QGeoCoordinate gcsPosition = qgcApp()->toolbox()->qgcPositionManager()->gcsPosition();
            if (gcsPosition.isValid()) {
                homePosition.setLatitude(gcsPosition.latitude());
                homePosition.setLongitude(gcsPosition.longitude());
            } else {
                // 3 地图中心位置
                QSettings settings;
                settings.beginGroup("FlightMapPosition");
                homePosition.setLatitude(settings.value("Latitude",    homePosition.latitude()).toDouble());
                homePosition.setLongitude(settings.value("Longitude",  homePosition.longitude()).toDouble());
            }
        }
        qCDebug(NTRIPLog) << "homePosition:" << homePosition;
        _tcpLink->setHomePosition(homePosition.latitude(), homePosition.longitude(), homePosition.type() == QGeoCoordinate::Coordinate2D ? 0 : homePosition.altitude());
        connect(_tcpLink, &NTRIPTCPLink::error,              this, &NTRIP::_tcpError,           Qt::QueuedConnection);
        connect(_tcpLink, &NTRIPTCPLink::RTCMDataUpdate,   _rtcmMavlink, &RTCMMavlink::RTCMDataUpdate);
    }
}


NTRIPTCPLink::NTRIPTCPLink(const QString& hostAddress,
                           int port,
                           const QString &username,
                           const QString &password,
                           const QString &mountpoint,
                           const QString &whitelist,
                           QObject* parent)
    : /*QThread*/QObject       (parent)
    , _hostAddress  (hostAddress)
    , _port         (port)
    , _username     (username)
    , _password     (password)
    , _mountpoint   (mountpoint)
{
    _lastnmea = QDateTime::currentDateTime();
    _lastnmea.setTime(QTime(1,1,1,1));
    //moveToThread(this);
    //start();
    for(const auto& msg: whitelist.split(',')){
        int msg_int = msg.toInt();
        if(msg_int)
            _whitelist.append(msg_int);
    }
    qCDebug(NTRIPLog) << "whitelist: " << _whitelist;
    if (!_rtcm_parsing) {
        _rtcm_parsing = new RTCMParsing();
    }
    _rtcm_parsing->reset();
    _state = NTRIPState::uninitialised;
    run();
}

NTRIPTCPLink::~NTRIPTCPLink(void)
{
    if (_socket) {
        QObject::disconnect(_socket, &QTcpSocket::readyRead, this, &NTRIPTCPLink::_readBytes);
        _socket->disconnectFromHost();
        _socket->deleteLater();
        _socket = nullptr;
    }
    //quit();
    //wait();
    if (_rtcm_parsing) {
        delete _rtcm_parsing;
        _rtcm_parsing = nullptr;
    }
}

void NTRIPTCPLink::run(void)
{
    _hardwareConnect();
    qCDebug(NTRIPLog) << __FILE__ << __func__ << __LINE__;
    //exec();
}

void NTRIPTCPLink::_hardwareConnect()
{
    _socket = new QTcpSocket();
    
    QObject::connect(_socket, &QTcpSocket::readyRead, this, &NTRIPTCPLink::_readBytes);
    QObject::connect(_socket, &QTcpSocket::connected, this, &NTRIPTCPLink::_connected);
    QObject::connect(_socket, &QTcpSocket::disconnected, this, &NTRIPTCPLink::_disconnected);
    
    _socket->connectToHost(_hostAddress, static_cast<quint16>(_port));
    
    // Give the socket a second to connect to the other side otherwise error out
    if (!_socket->waitForConnected(1000)) {
        qCDebug(NTRIPLog) << "NTRIP Socket failed to connect";
        emit error(_socket->errorString());
        delete _socket;
        _socket = nullptr;
        return;
    }
}

void NTRIPTCPLink::_parse(const QByteArray &buffer)
{
    for(const uint8_t& byte : buffer){
        if(_state == NTRIPState::waiting_for_rtcm_header){
            if(byte != RTCM3_PREAMBLE)
                continue;
            _state = NTRIPState::accumulating_rtcm_packet;
        }
        if(_rtcm_parsing->addByte(byte)){
            _state = NTRIPState::waiting_for_rtcm_header;
            QByteArray message((char*)_rtcm_parsing->message(), static_cast<int>(_rtcm_parsing->messageLength()));
            //TODO: Restore the following when upstreamed in Driver repo
            //uint16_t id = _rtcm_parsing->messageId();
            uint16_t id = ((uint8_t)message[3] << 4) | ((uint8_t)message[4] >> 4);
            if(_whitelist.empty() || _whitelist.contains(id)){
                emit RTCMDataUpdate(message);
                qCDebug(NTRIPLog) << "Sending " << id << "of size " << message.length();
            }
            else 
                qCDebug(NTRIPLog) << "Ignoring " << id;
            _rtcm_parsing->reset();
        }
    }
}

void NTRIPTCPLink::_sendNMEA()
{
    if (_socket) {
        if(_state == NTRIPState::waiting_for_rtcm_header){
            if (_lat != 0 || _lng != 0) {
                int sec = _lastnmea.secsTo(QDateTime::currentDateTime());
                if (sec > 30) {// 30秒发送一次
                    double latdms = (int)_lat + ((_lat - (int)_lat) * .6f);
                    double lngdms = (int)_lng + ((_lng - (int)_lng) * .6f);
                    QString utctime = QDateTime::currentDateTimeUtc().toString("hh:mm:ss.zzz").remove(":");
                    utctime = utctime.remove(utctime.count()-1, 1);
                    QString line = QString("$GP%1,%2,%3,%4,%5,%6,%7,%8,%9,%10,%11,%12,%13,%14,%15").arg("GGA")
                            .arg(utctime)
                            .arg(qAbs(latdms * 100), 4, 'f', 2, '0')
                            .arg(_lat < 0 ? "S" : "N")
                            .arg(qAbs(lngdms * 100), 4, 'f', 2, '0')
                            .arg(_lng < 0 ? "W" : "E")
                            .arg(1)
                            .arg(10)
                            .arg(1)
                            .arg(QString::number(_alt, 'f', 2))
                            .arg("M")
                            .arg(0).arg("M").arg("0.0").arg("0");
                    QString checkSum = _getCheckSum(line);
                    line = QString("%1*%2\r\n").arg(line).arg(checkSum);
                    _socket->write(line.toUtf8());
                    qCDebug(NTRIPLog) << __FILE__ << __func__ << __LINE__ << line;
                    _lastnmea = QDateTime::currentDateTime();
                }
            }
        }
    }
}

QString NTRIPTCPLink::_getCheckSum(const QString &str)
{
    int checkSum = 0;
    for (int i = 0; i < str.length(); i++) {
        char c = str.at(i).toLatin1();
        switch (c) {
        case '$':
            break;
        case '*':
            continue;
        default:
        {
            if (checkSum == 0) {
                checkSum = c;
            } else {
                checkSum = checkSum ^ c;
            }
            break;
        }
        }
    }
    //qDebug() << __FILE__ << __func__ << __LINE__ << checkSum << QString::number(checkSum, 16);
    return QString::number(checkSum, 16);// 返回16进制的字符串
}

void NTRIPTCPLink::_readBytes(void)
{
    if (_socket) {
        if(_state == NTRIPState::waiting_for_http_response){
            QString line = _socket->readLine();
            if (line.contains("200")){
                _state = NTRIPState::waiting_for_rtcm_header;
                _sendNMEA();
            }
            else{
                qCWarning(NTRIPLog) << "Server responded with " << line;
                // TODO: Handle failure. Reconnect? 
                // Just move into parsing mode and hope for now.
                _state = NTRIPState::waiting_for_rtcm_header;
            }
        }
        _sendNMEA();
        QByteArray bytes = _socket->readAll();
        _parse(bytes);
    }
}

void NTRIPTCPLink::_connected()
{
    // If mountpoint is specified, send an http get request for data
    if ( !_mountpoint.isEmpty()){
        qCDebug(NTRIPLog) << "Sending HTTP request";
        QString usernamePasswork = QString(_username + ":"  + _password);
        QString auth = "Authorization: Basic " + usernamePasswork.toUtf8().toBase64() + "\r\n";
        if (usernamePasswork.isEmpty()) auth = "";
        // 获取ntrip源列表
        QString line = "GET /" + _mountpoint + " HTTP/1.0\r\n"
                + "User-Agent: NTRIP QGC/1.0\r\n"
                + auth
                + "Connection: close\r\n\r\n";
        qCDebug(NTRIPLog) << __FILE__ << __func__ << __LINE__ << line;
        _socket->write(line.toUtf8());
        _state = NTRIPState::waiting_for_http_response;
    }
    // If no mountpoint is set, assume we will just get data from the tcp stream
    else{
        _state = NTRIPState::waiting_for_rtcm_header;
    }
    qCDebug(NTRIPLog) << "NTRIP Socket connected";
}

void NTRIPTCPLink::_disconnected()
{
    qCDebug(NTRIPLog) << __FILE__ << __func__ << __LINE__;
}

