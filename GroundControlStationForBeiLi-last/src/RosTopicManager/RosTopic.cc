#include "RosTopic.h"
#include <QDebug>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonValue>

#include <QGCApplication.h>
#include <MultiVehicleManager.h>

RosTopic::RosTopic(const QString &hostAddress, int port, QObject *parent) : QObject(parent)
  , _hostAddress(hostAddress)
  , _port(port)
  , _connected(false)
{
    _thread = new QThread;
    moveToThread(_thread);
    _tcpSocket.moveToThread(_thread);
    _thread->start();
    connect(&_tcpSocket, &QTcpSocket::readyRead, this, &RosTopic::_readBytes);
    connect(&_tcpSocket, &QTcpSocket::connected, this, &RosTopic::_onConnected);
    connect(&_tcpSocket, &QTcpSocket::disconnected, this, &RosTopic::_onDisconnected);
    connect(&_tcpSocket, SIGNAL(error(QAbstractSocket::SocketError)), this, SLOT(_onError(QAbstractSocket::SocketError)));
    connect(this, SIGNAL(connectToHostSignal()), this, SLOT(connectToHost()));
}

RosTopic::~RosTopic()
{
    disconnectToHost();
    _thread->exit();
    _thread->wait();
    _thread->deleteLater();
    qDebug() << __FILE__ << __func__ << __LINE__;
}

void RosTopic::connectToHost(const QString &hostAddress, int port)
{
    _hostAddress = hostAddress;
    _port = port;
    emit connectToHostSignal();
}

void RosTopic::connectToHost()
{
    if (_hostAddress.isEmpty() || _port <= 0) {
        qDebug() << "hostAddress error" << _hostAddress << _port ;
        return;
    }
    if (isConnected()) return;
    _tcpSocket.connectToHost(_hostAddress, _port);
    if (_tcpSocket.waitForConnected(1000))
          qDebug() << __FILE__ << __func__ << __LINE__ << "Connected!" << _hostAddress;
}

void RosTopic::disconnectToHost()
{
    if (isConnected()) {
        _tcpSocket.close();
    }
}

void RosTopic::_readBytes()
{
    QByteArray data = _tcpSocket.readAll();

    QStringList dataList = QString(data).split("End");
    int count = dataList.count();

    if (count > 0 && !dataList.first().startsWith("Start")) {
        if (!_preData.isEmpty()) {
            _preData += dataList.first();
            _preData = "Start" + _preData;
            dataList.replace(0, _preData);

            _preData.clear();
        }
    }

    if (count > 0 && !data.endsWith("End")) {
        _preData.append(dataList.last());
        dataList.removeLast();
    }

    for (int i = 0; i < dataList.count(); i++) {
        QString cur = dataList.at(i);
        if (cur.isEmpty()) continue;
        QJsonDocument doc;
        if (cur.startsWith("Start")) {
            doc = QJsonDocument::fromJson(cur.remove("Start").toUtf8());
        }
        //qDebug() << __FILE__ << __func__ << __LINE__ << doc;
        if (!doc.isEmpty() && !doc.isNull()) {
            QJsonObject root = doc.object();
            int id = -1;
            if (root.contains("id")) {
                id = root.value("id").toInt();
            }
            if (root.contains("pointCloudFrame")) {
                QJsonArray pointCloud = root["pointCloudFrame"].toArray();
                QStringList points;
                for (int i = 0; i < pointCloud.size(); i++) {
                    QJsonObject point = pointCloud.at(i).toObject();

                    QString str = QString("%1,%2,%3,%4,%5,%6")
                            .arg(point.value("x").toDouble()).arg(point.value("y").toDouble()).arg(point.value("z").toDouble())
                            .arg(point.value("r").toInt()).arg(point.value("g").toInt()).arg(point.value("b").toInt());
                    points << str;
                }

                QString pointCloudFile = points.join("\n");
            }
            if (id > 0 && root.contains("soundHeading")) {
                int angle = root.value("soundHeading").toInt();
                //qDebug() << __FILE__ << __func__ << __LINE__ << id << angle;
                QmlObjectListModel* vehicles = qgcApp()->toolbox()->multiVehicleManager()->vehicles();
                for (int i = 0; i < vehicles->count(); i++) {
                    Vehicle* vehicle = vehicles->value<Vehicle*>(i);
                    if (vehicle && vehicle->id() == id){
                        vehicle->soundHeadingFact()->setRawValue(angle);
                        break;
                    }
                }
            }
        } // doc
    } // for dataList

}

void RosTopic::_onConnected()
{
    _connected = true;
}

void RosTopic::_onDisconnected()
{
    _connected = false;
}

void RosTopic::_onError(QAbstractSocket::SocketError error)
{
    // QAbstractSocket::HostNotFoundError
    qDebug() << __FILE__ << __func__ << __LINE__ << _tcpSocket.errorString() << error;
}


