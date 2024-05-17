#ifndef ROSTOPIC_H
#define ROSTOPIC_H

#include <QObject>
#include <QTcpSocket>
#include <QThread>

class RosTopic : public QObject
{
    Q_OBJECT
public:
    explicit RosTopic(const QString& hostAddress,
                      int port, QObject *parent = nullptr);
    ~RosTopic();

    void connectToHost(const QString& hostAddress, int port);
    void disconnectToHost();
    bool isConnected() { return _connected; }
signals:
    void connectToHostSignal();

public slots:
    void connectToHost();
private slots:
    void _readBytes();
    void _onConnected();
    void _onDisconnected();
    void _onError(QAbstractSocket::SocketError);
private:

    QThread *_thread;

    QTcpSocket _tcpSocket;
    QString         _hostAddress;
    int             _port;
    bool _connected;

    QString _preData;
};

#endif // ROSTOPIC_H
