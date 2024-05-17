/**************************************************
** Author      : 徐建文
** CreateTime  : 2021-10-29 09:02:00
** ModifyTime  : 2021-10-29 18:02:17
** Email       : Vincent_xjw@163.com
** Description : 无人机管理
***************************************************/
#ifndef UAVINFOMANAGER_H
#define UAVINFOMANAGER_H
#include <QObject>
#include <QTimer>
#include <QQmlEngine>
#include <QMetaType>
#include "QmlObjectListModel.h"
#include "HttpApiDataDefine.h"
#include "LinkManager.h"
#include "TCPLink.h"
#include "QGCApplication.h"
#include "SettingsManager.h"

class QmlUAVInfo : public QObject
{
    Q_OBJECT
public:
    explicit QmlUAVInfo() {
        _onLine = false;
        _link = nullptr;
        QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
        qRegisterMetaType<QmlUAVInfo*>("QmlUAVInfo*");

        TCPConfiguration* tcpConfig = new TCPConfiguration("");
        tcpConfig->setDynamic(true);
        tcpConfig->setHost(qgcApp()->toolbox()->settingsManager()->httpServerSettings()->serverIp()->rawValueString());
        tcpConfig->setPort(qgcApp()->toolbox()->settingsManager()->httpServerSettings()->groundControlStationPort()->rawValue().toInt());
        SharedLinkConfigurationPtr config = qgcApp()->toolbox()->linkManager()->addConfiguration(tcpConfig);
        _linkConfig = tcpConfig;
    }
    ~QmlUAVInfo() {
        if (_linkConfig && _linkConfig->isLinked()) {
            _linkConfig->link()->disconnect();
        }
    }
    Q_PROPERTY(int  systemId                                READ systemId          WRITE setSystemId  NOTIFY onSystemIdChanged)
    Q_PROPERTY(bool onLine                                  READ onLine            WRITE setOnLine    NOTIFY onLineChanged)
    Q_PROPERTY(LinkConfiguration*      linkConfig           READ linkConfig                           CONSTANT)
    Q_PROPERTY(QString      uavGroupName                    READ uavGroupName                         CONSTANT)
    Q_PROPERTY(QString      nickName                        READ nickName                             CONSTANT)

    int systemId() { return _systemId; }
    bool onLine() { return _onLine; }
    LinkConfiguration* linkConfig() { return _linkConfig; }

    void setOnLine(bool online) {
        if (_onLine != online) {
            _onLine = online;
            // 添加判断，如果当前地面站已连接了飞机且当前飞机掉线了，就断开地面站的连接
            if (!online && linkConfig()->isLinked()) {
                // 需要弹窗提示断开地面站的连接
                //linkConfig()->link()->disconnect();
            }
            emit onLineChanged();
        }
    }

    void setSystemId(int systemId) {
        if (_systemId != systemId) {
            _systemId = systemId;
            _linkConfig->setId(QString::number(systemId));
            _linkConfig->setName(QString("%1%2").arg(QStringLiteral("远程飞机")).arg(systemId));
            emit onSystemIdChanged();
        }
    }

    void setUAVInfo(UAVInfo info) {
        _info = info;
        setSystemId(_info.systemId);
    }
    UAVInfo getUAVInfo() {
        return _info;
    }

    void setUAVCurrentState(UAVCurrentState state) {
        _currentState = state;
    }

    UAVCurrentState getUAVCurrentState() {
        return _currentState;
    }

    QString uavGroupName(void) { return _info.uavGroupName; }
    QString nickName(void) { return _info.nickname; }
signals:
    void onLineChanged();
    void onSystemIdChanged();

private:
    bool _onLine;
    int _systemId;
    LinkInterface *_link;
    UAVInfo _info;
    UAVCurrentState _currentState;
    TCPConfiguration* _linkConfig;
};

class DeptUAVInfo : public QObject
{
    Q_OBJECT
public:
    DeptUAVInfo(QObject *parent = nullptr) : QObject(parent) {
        _uavGroupId = -1;
        _uavGroupName = "";
    }
    DeptUAVInfo(int uavGroupId, const QString &uavGroupName){
            _uavGroupId = uavGroupId;
            _uavGroupName = uavGroupName;
        }
    ~DeptUAVInfo() { _uavs.clearAndDeleteContents(); }

    void setUavGroupId(int id) { _uavGroupId = id; }
    int uavGroupId(void) { return _uavGroupId; }
    void setUavGroupName(const QString &name) { _uavGroupName = name; }
    QString uavGroupName(void) { return _uavGroupName; }
    void setUavInfo(QmlUAVInfo *uav) { _uavs.append(uav); }
    QmlObjectListModel* uavs() { return &_uavs; }
private:
    int _uavGroupId;
    QString _uavGroupName;
    QmlObjectListModel _uavs;
};

class UAVInfoManager : public QObject
{
    Q_OBJECT
public:
    explicit UAVInfoManager(QObject *parent = nullptr);
    ~UAVInfoManager();
    Q_PROPERTY(QmlObjectListModel*  firstUAVs       READ firstUAVs       CONSTANT)
    Q_PROPERTY(QmlObjectListModel*  secondUAVs      READ secondUAVs      CONSTANT)
    Q_PROPERTY(QmlObjectListModel*  thirdUAVs       READ thirdUAVs       CONSTANT)
    Q_PROPERTY(QmlObjectListModel*  fourthUAVs      READ fourthUAVs      CONSTANT)

    QmlObjectListModel *firstUAVs(void);
    QmlObjectListModel *secondUAVs(void);
    QmlObjectListModel *thirdUAVs(void);
    QmlObjectListModel *fourthUAVs(void);

    bool contains(DeptUAVInfo *deptUAVInfo, int systemId);
    bool contains(QmlObjectListModel *uavs, int systemId);
    QmlUAVInfo *getUAVInfo(DeptUAVInfo *deptUAVInfo, int systemId);

    QString getVideoStreamUrl(int systemId);

    Q_INVOKABLE bool haveCloundLinked();
signals:

public slots:
    void onLoginChanged(bool isLogin);
private slots:
    void _updateUAVInfo();
private:
    bool _getUAVCurrentState(int id, const UAVCurrentStateList &currentStates, UAVCurrentState &currentState);

    QTimer _timer;
    DeptUAVInfo _deptUAVInfoFirst;
    DeptUAVInfo _deptUAVInfoSecond;
    DeptUAVInfo _deptUAVInfoThird;
    DeptUAVInfo _deptUAVInfoFourth;
    QList<DeptUAVInfo*> _deptUAVInfoList;
};
#endif // UAVINFOMANAGER_H
