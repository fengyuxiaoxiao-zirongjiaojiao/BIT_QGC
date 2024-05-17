#ifndef CONTROLCENTERMANAGER_H
#define CONTROLCENTERMANAGER_H

#include "QGCToolbox.h"
#include "QGCApplication.h"
#include <QTcpSocket>
#include <QTimer>
#include <mavlink_types.h>
#include <mavlink.h>

class ControlCenterManager : public QGCTool
{
    Q_OBJECT
public:
    ControlCenterManager(QGCApplication* app, QGCToolbox* toolbox);
    ~ControlCenterManager();

    Q_PROPERTY(bool                 isConnected          READ isConnected                  NOTIFY connectedChanged)
    Q_PROPERTY(QStringList          messageList          READ messageList                  NOTIFY messageCountChanged)

    Q_INVOKABLE void setAutoConnectLink(bool isAutoConnect);

    Q_INVOKABLE void openLink();

    Q_INVOKABLE void closeLink();

    // Override from QGCTool
    virtual void setToolbox(QGCToolbox *toolbox);

    bool isConnected();
    bool isAutoConnect();

    QStringList messageList() { return _messageList; }


    uint8_t getMavlinkChannel() { return _mavlinkChannel; }
    void setMavlinkChannel();
//    void freeMavlinkChannel();
    void setVersion(uint32_t version);
//    int getVersion() { return MAVLINK_VERSION; }
//    uint32_t getCurrentVersion() { return _currentVersion; }
signals:
    void connectedChanged(bool isConnected);
    void messageCountChanged();
private slots:
    void _onReadyRead();
    void _onConnected();
    void _onDisconnected();
    void _onTimeout();
    void _onUserLoginChanged(bool isLogin);
private:
    QTcpSocket *_tcpSocket;
    bool _isConnected;
    bool _isAutoConnect;
    QTimer _timer;

    bool _decodedFirstMavlinkPacket;
    mavlink_message_t _message;
    mavlink_status_t _status;
    uint32_t _currentVersion;
    uint8_t _mavlinkChannel;

    QStringList _messageList;
};
#endif // CONTROLCENTERMANAGER_H
