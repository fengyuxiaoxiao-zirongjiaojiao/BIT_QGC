#include "HttpApi.h"
#include "HttpAPIManager.h"

UAVInfoManager::UAVInfoManager(QObject *parent) : QObject(parent)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<UAVInfoManager*>("UAVInfoManager*");
    connect(&_timer, &QTimer::timeout, this, &UAVInfoManager::_updateUAVInfo);
    _timer.setInterval(5000);
    _deptUAVInfoList << &_deptUAVInfoFirst << &_deptUAVInfoSecond << &_deptUAVInfoThird << &_deptUAVInfoFourth;
}

UAVInfoManager::~UAVInfoManager()
{
    _timer.stop();
    for (int i = 0; i < _deptUAVInfoList.count(); i++) {
        DeptUAVInfo *deptUAVInfo = _deptUAVInfoList.at(i);
        if (deptUAVInfo) {
            deptUAVInfo->uavs()->clearAndDeleteContents();
        }
    }
    _deptUAVInfoList.clear();
}

QmlObjectListModel *UAVInfoManager::firstUAVs()
{
    return _deptUAVInfoFirst.uavs();
}

QmlObjectListModel *UAVInfoManager::secondUAVs()
{
    return _deptUAVInfoSecond.uavs();
}

QmlObjectListModel *UAVInfoManager::thirdUAVs()
{
    return _deptUAVInfoThird.uavs();
}

QmlObjectListModel *UAVInfoManager::fourthUAVs()
{
    return _deptUAVInfoFourth.uavs();
}

bool UAVInfoManager::contains(DeptUAVInfo *deptUAVInfo, int systemId)
{
    QmlObjectListModel *uavs = deptUAVInfo->uavs();
    return contains(uavs, systemId);
}

bool UAVInfoManager::contains(QmlObjectListModel *uavs, int systemId)
{
    if (uavs) {
        for (int i = 0; i < uavs->count(); i++) {
            QmlUAVInfo *u = qobject_cast<QmlUAVInfo*>(uavs->get(i));
            if (u && u->systemId() == systemId) {
                return true;
            }
        }
    }
    return false;
}

QmlUAVInfo *UAVInfoManager::getUAVInfo(DeptUAVInfo *deptUAVInfo, int systemId)
{
    QmlObjectListModel *uavs = deptUAVInfo->uavs();
    for (int i = 0; i < uavs->count(); i++) {
        QmlUAVInfo *u = qobject_cast<QmlUAVInfo*>(uavs->get(i));
        if (u && u->systemId() == systemId) {
            return u;
        }
    }
    return nullptr;
}

QString UAVInfoManager::getVideoStreamUrl(int systemId)
{
    if (systemId <= 0 || systemId > 255) return "";
    for (int i = 0; i < _deptUAVInfoList.count(); i++) {
        DeptUAVInfo *deptUAVInfo = _deptUAVInfoList.at(i);
        if (deptUAVInfo) {
            QmlUAVInfo *uavInfo = getUAVInfo(deptUAVInfo, systemId);
            if (uavInfo) {
                return uavInfo->getUAVInfo().videoStreamUrl;
            }
        }
    }
    return "";
}

bool UAVInfoManager::haveCloundLinked()
{
    for (int i = 0; i < _deptUAVInfoList.count(); i++) {
        DeptUAVInfo *deptUAVInfo = _deptUAVInfoList.at(i);
        if (deptUAVInfo) {
            QmlObjectListModel *uavs = deptUAVInfo->uavs();
            if (uavs) {
                for (int j = 0; j < uavs->count(); j++) {
                    QmlUAVInfo *u = qobject_cast<QmlUAVInfo*>(uavs->get(j));
                    if (u && u->linkConfig()->isLinked()) {
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

void UAVInfoManager::onLoginChanged(bool isLogin)
{
    if (isLogin) {
        if (!_timer.isActive()) _timer.start();
        _updateUAVInfo();
    } else {
        if (_timer.isActive()) _timer.stop();
        for (int i = 0; i < _deptUAVInfoList.count(); i++) {
            DeptUAVInfo *deptUAVInfo = _deptUAVInfoList.at(i);
            if (deptUAVInfo) {
                deptUAVInfo->uavs()->clearAndDeleteContents();
            }
        }
    }
}

void UAVInfoManager::_updateUAVInfo()
{
    if (!getHttpApiService()->userManager()->isLogin()) return;
    QList<DeptInfo> deptInfos;
    HttpApi::queryDepartmentInfo(deptInfos);

    UAVCurrentStateList currentStates;
    HttpApi::queryUAVState(currentStates, "", "", "", "", "1", "999");

    if (deptInfos.isEmpty()) return;
    DeptInfo beiLiDeptInfo;
    bool find = false;
    for (int i = 0; i < deptInfos.count(); i++) {
        if (deptInfos.at(i).deptName == "北京理工大学") {
            beiLiDeptInfo = deptInfos.at(i);
            find = true;
            qDebug() << __FILE__ << __func__ << __LINE__ << "find dept" << beiLiDeptInfo.deptName;
            break;
        }
    }
    if (!find) {
        beiLiDeptInfo = deptInfos.first();
    }

    QList<UavGroupInfo> uavGroupInfos = beiLiDeptInfo.uavGroupInfos;
    for (int i = 0; (i < uavGroupInfos.count() && i < _deptUAVInfoList.count()); i++) {
        UAVInfoList infos;
        QString uavGroupId = QString::number(uavGroupInfos.at(i).uavGroupId);
        HttpApi::queryUAVInfo(infos, "999", "1", "", "", uavGroupId);

        DeptUAVInfo *deptUavInfo = _deptUAVInfoList.at(i);
        deptUavInfo->setUavGroupId(uavGroupInfos.at(i).uavGroupId);
        deptUavInfo->setUavGroupName(uavGroupInfos.at(i).uavGroupName);
        for (int i = 0; i < infos.count(); i++) {
            int systemid = infos.at(i).systemId;
            QmlUAVInfo *info = nullptr;
            if (contains(deptUavInfo, systemid)) {
                info = getUAVInfo(deptUavInfo, systemid);
            } else {
                info = new QmlUAVInfo();
                deptUavInfo->setUavInfo(info);
            }
            info->setUAVInfo(infos.at(i));

            UAVCurrentState state;
            bool ok = _getUAVCurrentState(infos.at(i).id, currentStates, state);
            //qDebug() << __FILE__ << __func__ << __LINE__ << infos.at(i).eNumber << state.eNumber << currentStates.count() << ok;
            if (ok) {
                info->setUAVCurrentState(state);
                info->setOnLine(true);

            } else {
                info->setOnLine(false);
            }
        }
    }
}

bool UAVInfoManager::_getUAVCurrentState(int id, const UAVCurrentStateList &currentStates, UAVCurrentState &currentState)
{
    if (id < 0 && currentStates.count() <= 0) return false;
    for (int i = 0; i < currentStates.count(); i++) {
        UAVCurrentState c = currentStates.at(i);
        if (id == c.uavId) {
            currentState = c;
            return true;
        }
    }
    return false;
}

bool HttpApi::addUAVInfo(const QString &eNumber, const QString &uavModel, const QString &uavNumber, const QString &uavIdent, const QString &uavFlightNum, const QString &uavImei, const QString &maintenanceCycle)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(UAV_ADD_PATH);
    QString data = "eNumber=" + eNumber + "&uavModel=" + uavModel + "&uavNumber=" + uavNumber + "&uavIdent=" + uavIdent + "&uavFlightNum=" + uavFlightNum + "&uavImei=" + uavImei + "&maintenanceCycle=" + maintenanceCycle;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::updateUAVInfo(const QString &id, const QString &maintenanceCycle, const QString &audit, const QString &uavImei, const QString &uavFlightNum, const QString &uavIdent, const QString &uavModel, const QString &uavNumber)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(UAV_UPDATE_PATH);
    QString data = "id=" + id;
    if (!maintenanceCycle.isEmpty()) data += "&maintenanceCycle=" + maintenanceCycle;
    if (!audit.isEmpty()) data += "&audit=" + audit;
    if (!uavImei.isEmpty()) data += "&uavImei=" + uavImei;
    if (!uavFlightNum.isEmpty()) data += "&uavFlightNum=" + uavFlightNum;
    if (!uavIdent.isEmpty()) data += "&uavIdent=" + uavIdent;
    if (!uavModel.isEmpty()) data += "&uavModel=" + uavModel;
    if (!uavNumber.isEmpty()) data += "&uavNumber=" + uavNumber;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::deleteUAVInfo(const QString &id)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(UAV_DELETE_PATH);
    QString data = "id=" + id;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::queryUAVInfo(UAVInfoList &infos, const QString &pageSize, const QString &pageNum, const QString &keyWord, const QString &deptId, const QString &uavGroup, const QString &registrantId)
{
    infos.clear();

    static int total = 10;
    int num = 1;

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(UAV_QUERY_PATH);
    QString data;
    if (!pageSize.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageSize=" + pageSize; }
    else { data += data.isEmpty() ? "" : "&"; data += "pageSize=" + QString::number(total); }
    if (!pageNum.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageNum=" + pageNum; }
    else { data += data.isEmpty() ? "" : "&"; data += "pageNum=" + QString::number(num); }
    if (!keyWord.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "keyWord=" + keyWord; }
    if (!deptId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "deptId=" + deptId; }
    if (!uavGroup.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "uavGroup=" + uavGroup; }
    if (!registrantId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "registrantId=" + registrantId; }
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token, false);
    //qDebug() << __FILE__ << __func__ << __LINE__ << QString::fromUtf8(result);
    //qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (ok && json_doc["errcode"].toInt() == NO_ERROR) {
        QJsonObject dt = json_doc["data"].toObject();
        if (!dt.isEmpty()) {
            infos.setTotal(dt["total"].toInt());
            total = dt["total"].toInt();
            infos.setSize(dt["size"].toInt());
            infos.setCurrent(dt["current"].toInt());
            infos.setSearchCount(dt["searchCount"].toBool());
            infos.setPages(dt["pages"].toInt());
            QJsonArray records = dt["records"].toArray();
            for (int i = 0; i < records.size(); i++) {
                UAVInfo info;
                QJsonObject record = records.at(i).toObject();
                info.createTime = record["createTime"].toString();
                info.uavFlightNum = record["uavFlightNum"].toString();
                info.registrantId = record["registrantId"].toInt();
                info.avatar = record["avatar"].toString();
                info.uavNumber = record["uavNumber"].toString();
                info.isDelete = record["isDelete"].toString();
                info.uavImei = record["uavImei"].toString();
                info.maintenanceCycle = record["maintenanceCycle"].toString();
                info.audit = record["audit"].toString();
                info.id = record["id"].toInt();
                info.eNumber = record["eNumber"].toString();
                info.uavModel = record["uavModel"].toString();
                info.username = record["username"].toString();
                info.nickname = record["nickname"].toString();
                info.email = record["email"].toString();
                info.idImgUrl = record["idImgUrl"].toString();
                info.idCard = record["idCard"].toString();
                info.name = record["name"].toString();
                info.flightTime = record["flight_time"].toString();
                info.uavGroupName = record["uavGroupName"].toString();
                QJsonArray phs = record["permission_holder"].toArray();
                for (int j = 0; j < phs.count(); j++) {
                    info.permissionHolder.append(phs.at(j).toString());
                }
                QJsonArray pfs = record["permission_flight"].toArray();
                for (int j = 0; j < pfs.count(); j++) {
                    info.permissionFlight.append(pfs.at(j).toString());
                }
                info.ctrlId = record["ctrl_id"].toInt();
                info.systemId = record["systemId"].toInt();
                info.userType = record["userType"].toString();
                info.videoStreamUrl = record["videoStreamUrl"].toString();

                infos.append(info);
            }
        }
        return true;
    }
    return false;
}
#if 0
bool HttpApi::registUAVUserInfo(const QString &eNumber, const QString &uavNumber, const QString &uavModel, const QString &uavIdent, const QString &uavFlightNum, const QString &uavImei, const QString &username, const QString &password, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &idImgFile, const QString &maintenanceCycle)
{
    QString url = QString("%1%2").arg(SERVER_URL).arg(UAV_USER_PATH);
    QString data = "eNumber=" + eNumber;
    if (!uavNumber.isEmpty()) data += "&uavNumber=" + uavNumber;
    if (!uavModel.isEmpty()) data += "&uavModel=" + uavModel;
    if (!uavIdent.isEmpty()) data += "&uavIdent=" + uavIdent;
    if (!uavFlightNum.isEmpty()) data += "&uavFlightNum=" + uavFlightNum;
    if (!uavImei.isEmpty()) data += "&uavImei=" + uavImei;
    if (!username.isEmpty()) data += "&username=" + username;
    if (!password.isEmpty()) data += "&password=" + password;
    if (!email.isEmpty()) data += "&email=" + email;
    if (!idCard.isEmpty()) data += "&idCard=" + idCard;
    if (!type.isEmpty()) data += "&type=" + type;
    if (!name.isEmpty()) data += "&name=" + name;
    if (!idImgFile.isEmpty()) data += "&idImg=" + idImgFile;
    if (!maintenanceCycle.isEmpty()) data += "&maintenanceCycle=" + maintenanceCycle;

    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        return true;
    }
    QMessageBox::critical(nullptr,QStringLiteral("错误"),
                          json_doc["message"].toString());
    return false;
}
#endif
bool HttpApi::registUAVUserInfoMultiPart(const QString &eNumber, const QString &uavNumber, const QString &uavModel, const QString &uavIdent, const QString &uavFlightNum, const QString &uavImei, const QString &username, const QString &password, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &idImgFile, const QString &maintenanceCycle)
{
    QHttpMultiPart multiPart(QHttpMultiPart::FormDataType);

    QHttpPart eNumberPart;
    eNumberPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"eNumber\""));
    eNumberPart.setBody(eNumber.toUtf8());
    multiPart.append(eNumberPart);

    QHttpPart uavNumberPart;
    uavNumberPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"uavNumber\""));
    uavNumberPart.setBody(uavNumber.toUtf8());
    multiPart.append(uavNumberPart);

    QHttpPart uavModelPart;
    uavModelPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"uavModel\""));
    uavModelPart.setBody(uavModel.toUtf8());
    multiPart.append(uavModelPart);

    QHttpPart uavIdentPart;
    uavIdentPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"uavIdent\""));
    uavIdentPart.setBody(uavIdent.toUtf8());
    multiPart.append(uavIdentPart);

    QHttpPart uavFlightNumPart;
    uavFlightNumPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"uavFlightNum\""));
    uavFlightNumPart.setBody(uavFlightNum.toUtf8());
    multiPart.append(uavFlightNumPart);

    QHttpPart uavImeiPart;
    uavImeiPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"uavImei\""));
    uavImeiPart.setBody(uavImei.toUtf8());
    multiPart.append(uavImeiPart);

    QHttpPart usernamePart;
    usernamePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"username\""));
    usernamePart.setBody(username.toUtf8());
    multiPart.append(usernamePart);

    QString pwd = HttpApi::encrypt(password);
    QHttpPart passwordPart;
    passwordPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"password\""));
    passwordPart.setBody(pwd.toUtf8());
    multiPart.append(passwordPart);

    QHttpPart emailPart;
    emailPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"email\""));
    emailPart.setBody(email.toUtf8());
    multiPart.append(emailPart);

    QHttpPart idCardPart;
    idCardPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"idCard\""));
    idCardPart.setBody(idCard.toUtf8());
    multiPart.append(idCardPart);

    QHttpPart typePart;
    typePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"type\""));
    typePart.setBody(type.toUtf8());
    multiPart.append(typePart);

    QHttpPart namePart;
    namePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"name\""));
    namePart.setBody(name.toUtf8());
    multiPart.append(namePart);

    QHttpPart imgPart;
    imgPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/png"));
    QFile file(idImgFile);
    imgPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"idImg\";\
                                                                               filename=\"" + file.fileName() + "\""));
    file.open(QIODevice::ReadOnly);
    imgPart.setBodyDevice(&file);
    multiPart.append(imgPart);

    QHttpPart maintenanceCyclePart;
    maintenanceCyclePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"maintenanceCycle\""));
    maintenanceCyclePart.setBody(maintenanceCycle.toUtf8());
    multiPart.append(maintenanceCyclePart);

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(UAV_USER_PATH);
    QByteArray result;
    if (!HttpApi::httpRequest(url, multiPart, result)) {
        return false;
    }

    return true;
}

bool HttpApi::queryUAVCount(UAVOperationState &uavOperationState)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(UAV_COUNT_PATH);
    QString data;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        QJsonObject dt = json_doc["data"].toObject();
        if (!dt.isEmpty()) {
            uavOperationState.total = dt["total"].toInt();
            uavOperationState.approvedCount = dt["approvedCount"].toInt();
            QJsonArray uavModelCounts = dt["uavModelCount"].toArray();
            for (int i = 0; i < uavModelCounts.size(); i++) {
                UAVType type;
                QJsonObject uavModelCount = uavModelCounts.at(i).toObject();
                type.count = uavModelCount["count"].toInt();
                type.uavModel = uavModelCount["uav_model"].toString();

                uavOperationState.state.append(type);
            }
        }
        return true;
    }
    return false;
}

bool HttpApi::queryUAVState(UAVCurrentStateList &currentStates, const QString &id, const QString &lng, const QString &lat, const QString &radius, const QString &pageNum, const QString &pageSize)
{
    currentStates.clear();

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(UAV_STATE_PATH);
    QString data;
    if (!id.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "id=" + id; }
    if (!lng.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "longitude=" + lng; }
    if (!lat.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "latitude=" + lat; }
    if (!radius.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "radius=" + radius; }
    if (!pageNum.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageNum=" + pageNum; }
    if (!pageSize.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageSize=" + pageSize; }
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token, false);
    //qDebug() << __FILE__ << __func__ << __LINE__ << QString::fromUtf8(result);
    //qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (ok && json_doc["errcode"].toInt() == NO_ERROR) {
#if 0
        QJsonObject dt = json_doc["data"].toObject();
        if (!dt.isEmpty()) {
            currentStates.setTotal(dt["total"].toInt());
            currentStates.setSize(dt["size"].toInt());
            currentStates.setCurrent(dt["current"].toInt());
            currentStates.setSearchCount(dt["searchCount"].toBool());
            currentStates.setPages(dt["pages"].toInt());
            QJsonArray records = dt["records"].toArray();
            for (int i = 0; i < records.size(); i++) {
                UAVCurrentState uavCurrentState;
                QJsonObject record = records.at(i).toObject();
                uavCurrentState.speed = record["speed"].toDouble();
                uavCurrentState.createdTime = record["create_time"].toString();
                uavCurrentState.height = record["height"].toDouble();
                uavCurrentState.registrantId = record["registrant_id"].toInt();
                uavCurrentState.alt = record["alt"].toDouble();
                uavCurrentState.id = record["id"].toInt();
                uavCurrentState.eNumber = record["e_number"].toString();
                uavCurrentState.direction = record["direction"].toDouble();
                uavCurrentState.latitude = record["latitude"].toDouble();
                uavCurrentState.longitude = record["longitude"].toDouble();

                currentStates.append(uavCurrentState);
            }
        }
#else
        QJsonArray records = json_doc["data"].toArray();
        for (int i = 0; i < records.size(); i++) {
            UAVCurrentState uavCurrentState;
            QJsonObject record = records.at(i).toObject();
            uavCurrentState.speed = record["speed"].toDouble();
            uavCurrentState.createdTime = record["create_time"].toString();
            uavCurrentState.updateTime = record["updateTime"].toString();
            uavCurrentState.height = record["height"].toDouble();
            uavCurrentState.registrantId = record["registrant_id"].toInt();
            uavCurrentState.alt = record["alt"].toDouble();
            uavCurrentState.id = record["id"].toInt();
            uavCurrentState.eNumber = record["eNumber"].toString();
            uavCurrentState.direction = record["direction"].toDouble();
            uavCurrentState.latitude = record["latitude"].toDouble();
            uavCurrentState.longitude = record["longitude"].toDouble();
            uavCurrentState.uavId = record["uavId"].toInt();

            currentStates.append(uavCurrentState);
        }
#endif
        return true;
    }
    return false;
}
