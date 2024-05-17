/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "QGCToolbox.h"
#include "QmlObjectListModel.h"

#include <QThread>
#include <QTcpSocket>
#include <QTimer>
#include <QGeoCoordinate>

#include "Drivers/src/rtcm.h"
#include "RTCM/RTCMMavlink.h"



class NTRIPSettings;

class NTRIPTCPLink : public QObject//QThread
{
    Q_OBJECT

public:
    NTRIPTCPLink(const QString& hostAddress,
                 int port,
                 const QString& username,
                 const QString& password,
                 const QString& mountpoint,
                 const QString& whitelist,
                 QObject* parent);
    ~NTRIPTCPLink();

    void setHomePosition(double lat, double lng, double alt) { _lat = lat; _lng = lng; _alt = alt; }
    QGeoCoordinate getHomePosition() { return QGeoCoordinate(_lat, _lng, _alt); }
signals:
    void error(const QString errorMsg);
    void RTCMDataUpdate(QByteArray message);

protected:
    void run(void) ;//final;

private slots:
    void _readBytes(void);
    void _connected(void);
    void _disconnected(void);

private:
    enum class NTRIPState {
        uninitialised,
        waiting_for_http_response,
        waiting_for_rtcm_header,
        accumulating_rtcm_packet,
    };
    
    void _hardwareConnect(void);
    void _parse(const QByteArray &buffer);
    void _sendNMEA();
    QString _getCheckSum(const QString &str);

    QTcpSocket*     _socket =   nullptr;
    
    QString         _hostAddress;
    int             _port;
    QString         _username;
    QString         _password;
    QString         _mountpoint;
    QVector<int>    _whitelist;

    RTCMParsing *_rtcm_parsing{nullptr};
    NTRIPState _state;

    QDateTime _lastnmea;
    double _lat = 23.1673691;
    double _lng = 113.8524001;
    double _alt = 13.1;
};

class NTRIP : public QGCTool {
    Q_OBJECT
    
public:
    NTRIP(QGCApplication* app, QGCToolbox* toolbox);
    ~NTRIP();

    // QGCTool overrides
    void setToolbox(QGCToolbox* toolbox) final;

public slots:
    void _tcpError          (const QString errorMsg);
    void _NTRIPSettingsChanged();

private slots:

private:
    NTRIPTCPLink*                    _tcpLink = nullptr;
    RTCMMavlink*                     _rtcmMavlink = nullptr;
};
