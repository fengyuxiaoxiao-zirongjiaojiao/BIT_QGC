#include "UserManager.h"
#include "HttpServer/HttpApi.h"
#include <QFile>
#include <QDataStream>
#include "HttpAPIManager.h"

UserManager::UserManager(QObject *parent) : QObject(parent)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<UserManager*>("UserManager*");
    QSettings settings;
    QString fileName = settings.fileName();
    QFileInfo info(fileName);
    _accountInfoFileName = QString("%1/%2.dat").arg(info.absolutePath()).arg(info.baseName());
    _rememberPassword = false;
    _rememberPasswordChangeFlag = false;
    _loadAccountInfo();
}

UserManager::~UserManager()
{
    logout();
}

bool UserManager::registUser(const QString &userName, const QString &passwd, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &imgFile)
{
    return HttpApi::userRegisterMultiPart(userName, passwd, email, idCard, type, name, imgFile);
}

bool UserManager::registUAVAndUser(const QString &eNumber, const QString &uavNumber, const QString &uavModel, const QString &uavIdent, const QString &uavFlightNum, const QString &uavImei, const QString &username, const QString &password, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &idImgFile, const QString &maintenanceCycle)
{
    return HttpApi::registUAVUserInfoMultiPart(eNumber, uavNumber, uavModel, uavIdent, uavFlightNum, uavImei, username, password, email, idCard, type, name, idImgFile, maintenanceCycle);
}

bool UserManager::login(const QString &userName, const QString &passwd)
{
    UserInfo userInfo;
    bool ok = HttpApi::userLogin(3, userName, passwd, userInfo);
    _userInfo = userInfo;
    bool edit = false;
    QList<AccountInfo> accountInfos;
    if (_rememberPassword) {
        bool find = false;
        for (int i = 0; i < _accountInfos.count(); i++) {
            AccountInfo info = _accountInfos.at(i);
            if (info.account() == userName) {
                if (info.passwd() != passwd) {
                    info.setPasswd(passwd);
                    edit = true;
                }
                find = true;
            }
            accountInfos << info;
        }
        if (!find) {
            accountInfos << AccountInfo(userName, passwd);
            edit = true;
        }
    } else {
        // 删除记录的账户密码
        if (_rememberPasswordChangeFlag) {
            for (int i = 0; i < _accountInfos.count(); i++) {
                AccountInfo info = _accountInfos.at(i);
                if (info.account() != userName) {
                    accountInfos << info;
                    edit = true;
                }
            }
        }
    }

    if (edit) {
        _accountInfos = accountInfos;
        _saveAccountInfo();
    }
    _rememberPasswordChangeFlag = false;
    emit isLoginChanged(ok);
    emit userNameChanged();
    emit serialNumberChanged();
    emit descriptionChanged();
    return ok;
}

bool UserManager::logout()
{
    if (isLogin()) {
        bool ok = HttpApi::userLogout(getToken());
        if (ok) {
            _userInfo.token = "";
            emit isLoginChanged(false);
        }
        return ok;
    }
    return true;
}

bool UserManager::sendValidCode(const QString &userName, const QString &toMail)
{
    return HttpApi::sendValidCode(userName, toMail);
}

bool UserManager::changePasswd(const QString &userName, const QString &passwd, const QString &validCode)
{
    return HttpApi::changePasswd(userName, passwd, validCode);
}

bool UserManager::changePasswd(const QString &userName, const QString &passwd, const QString &oldPasswd, bool isKnowPwd)
{
    return HttpApi::changePasswd(userName, passwd, oldPasswd, isKnowPwd);
}

UserInfo UserManager::userInfo() const
{
    return _userInfo;
}

void UserManager::setUserInfo(const UserInfo &userInfo)
{
    _userInfo = userInfo;
}

bool UserManager::isLogin()
{
    if (userInfo().token.isEmpty()) return false;
    return true;
}

QStringList UserManager::accountList()
{
    QStringList accounts;
    for (int i = 0; i < _accountInfos.count(); i++) {
        accounts << _accountInfos.at(i).account();
    }
    return accounts;
}

QString UserManager::getPasswd(const QString &account)
{
    for (int i = 0; i < _accountInfos.count(); i++) {
        if (_accountInfos.at(i).account() == account) return _accountInfos.at(i).passwd();
    }
    return "";
}

void UserManager::setRememberPassword(bool rememberPassword)
{
    if (rememberPassword != _rememberPassword) {
        _rememberPassword = rememberPassword;
        _rememberPasswordChangeFlag = true;
        emit rememberPasswordChanged();
    }
}

QString UserManager::getAvatar()
{
    if (isLogin()) {
        QString url = userInfo().avatar;
        QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
        url = QString("%1%2/%3").arg(serverUrl).arg(USER_AVATAR).arg(url);
        return url;
    } else {
        return "";
    }
}

QString UserManager::getToken()
{
    return userInfo().token;
}

void UserManager::_loadAccountInfo()
{
    QFile file(_accountInfoFileName);
    if (!file.open(QIODevice::ReadOnly)) {
        qDebug() << "open file failed.";
        return;
    }
    _accountInfos.clear();
    int count = 0;
    QDataStream in(&file);
    in.setVersion(QDataStream::Qt_5_12);
    in >> _rememberPassword;
    in >> count;
    for (int i = 0; i < count; i++) {
        QByteArray account, passwd;
        in >> account >> passwd;
        _accountInfos << AccountInfo(QByteArray::fromHex(account), QByteArray::fromHex(passwd));
    }
    file.close();
    emit accountListChanged();
}

void UserManager::_saveAccountInfo()
{
    emit accountListChanged();

    QFile file(_accountInfoFileName);
    if (!file.open(QIODevice::WriteOnly)) {
        qDebug() << "open file failed.";
        return;
    }
    QDataStream out(&file);
    out.setVersion(QDataStream::Qt_5_12);
    out << _rememberPassword;
    int count = _accountInfos.count();
    out << count;
    for (int i = 0; i < count; i++) {
        AccountInfo info = _accountInfos.at(i);
        out << info.account().toUtf8().toHex() << info.passwd().toUtf8().toHex();
    }
    file.close();
}

bool HttpApi::userLogin(int type, const QString &userName, const QString &passwd, UserInfo &userInfo)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();

    QString url = QString("%1%2").arg(serverUrl).arg(USER_LOGIN_PATH);
    QString pwd = HttpApi::encrypt(passwd);
    pwd = pwd.toUtf8();
    QString data = QString("type=%1&username=%2&password=%3").arg(type).arg(userName).arg(pwd);
    QByteArray result;
    if (!HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_GET, data, result)) return false;
    //qDebug() << __FILE__ << __func__ << __LINE__ << QString::fromUtf8(result);
    //qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        QJsonObject dt = json_doc["data"].toObject();
        if (!dt.isEmpty()) {
            QJsonObject user = dt["user"].toObject();
            if (!user.isEmpty()) {
                userInfo.userId = user["userId"].toInt();
                userInfo.username = user["username"].toString();
                userInfo.password = user["password"].toString();
                userInfo.email = user["email"].toString();
                userInfo.status = user["status"].toInt();
                userInfo.createTime = user["createTime"].toString();
                userInfo.lastLoginTime = user["lastLoginTime"].toString();
                userInfo.gender = user["gender"].toInt();
                userInfo.type = user["type"].toString();
                userInfo.idCard = user["idCard"].toString();
                userInfo.name = user["name"].toString();
                userInfo.idImgUrl = user["idImgUrl"].toString();
                userInfo.description = user["description"].toString();
                userInfo.avatar = user["avatar"].toString();
                userInfo.id = user["id"].toString();
                userInfo.authCacheKey = user["authCaheKey"].toInt();
                userInfo.serialNumber = user["serialNumber"].toString();
            }
            userInfo.token = dt["token"].toString();
        }
        return true;
    }
    return false;
}

bool HttpApi::userLogout(const QString &authentication)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(USER_LOGIN_PATH);
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::DefaultProxy);
    QNetworkAccessManager access_mng;
    access_mng.setProxy(proxy);
    QNetworkRequest request;
    QNetworkReply* reply = nullptr;
    request.setUrl(QUrl(url));
    request.setRawHeader("Authentication", authentication.toUtf8());//服务器要求的数据头部
    reply = access_mng.deleteResource(request);
    if (!reply) return false;
    QTime time;
    time.start();
    bool is_timeout = false;
    while (!reply->isFinished()) {
        QApplication::processEvents();
        if (time.elapsed() > REQUEST_TIMEOUT_MS) {
            is_timeout = true; // 超时
            break;
        }
    }
    QByteArray result = reply->readAll();
    //qDebug() << __FILE__ << __func__ << __LINE__ << result;
    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        //qDebug() << __FILE__ << __func__ << __LINE__ << QString(json_doc["message"].toString());
        return true;
    }
    return false;
}

#if 0
bool HttpApi::userRegister(const QString &userName, const QString &passwd, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &imgFile)
{
    QByteArray imgData;
    QFile file(imgFile);
    if (!file.open(QFile::ReadOnly)){
        QMessageBox::critical(nullptr,QStringLiteral("错误"), QStringLiteral("打开文件失败！"));
    }
    QTextStream in(&file);
    in >> imgData;

    QString url = QString("%1%2").arg(SERVER_URL).arg(USER_REGIST_PATH);
    QString pwd = HttpApi::encrypt(passwd);
    QString data = "username=" + userName + "&password=" + pwd + "&email=" + email + "&idCard=" + idCard + "&type=" + type + "&name=" + name + "&idImg=" + imgFile;
    QByteArray result;
    if (!HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result)) return false;
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
bool HttpApi::userRegisterMultiPart(const QString &userName, const QString &passwd, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &imgFile)
{
    QHttpMultiPart multiPart(QHttpMultiPart::FormDataType);

    QHttpPart userNamePart;
    userNamePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"username\""));
    userNamePart.setBody(userName.toUtf8());
    multiPart.append(userNamePart);

    QString pwd = HttpApi::encrypt(passwd);
    QHttpPart passwdPart;
    passwdPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"password\""));
    passwdPart.setBody(pwd.toUtf8());
    multiPart.append(passwdPart);

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
    QFile file(imgFile);
    imgPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"idImg\";\
                                                                               filename=\"" + file.fileName() + "\""));
    file.open(QIODevice::ReadOnly);
    imgPart.setBodyDevice(&file);
    multiPart.append(imgPart);

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(USER_REGIST_PATH);
    QByteArray result;
    if (!HttpApi::httpRequest(url, multiPart, result)) {
        return false;
    }
    return true;
}

bool HttpApi::sendValidCode(const QString &userName, const QString &toMail)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(USER_VALIDCODE_PATH);
    QString data = "username=" + userName;
    if (!toMail.isEmpty()) {
        data += "&mailTo=" + toMail;
    }
    QByteArray result;
    if (!HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result)) return false;
    qDebug() << __FILE__ << __func__ << __LINE__ << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return true;
}

bool HttpApi::changePasswd(const QString &userName, const QString &passwd, const QString &validCode)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(USER_CHPASSWD_PATH);
    QString pwd = HttpApi::encrypt(passwd);
    QString data = QString("username=%1&password=%2&validCode=%3").arg(userName).arg(pwd).arg(validCode);
    QByteArray result;
    if (!HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result)) return false;
    qDebug() << __FILE__ << __func__ << __LINE__ << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return true;
}

bool HttpApi::changePasswd(const QString &userName, const QString &passwd, const QString &oldPasswd, bool isKnowPwd)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(USER_CHPASSWD_PATH);
    QString pwd = HttpApi::encrypt(passwd);
    QString oldPwd = HttpApi::encrypt(oldPasswd);
    QString data = QString("username=%1&password=%2&oldPassword=%3").arg(userName).arg(pwd).arg(oldPwd);
    QByteArray result;
    if (!HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result)) return false;
    qDebug() << __FILE__ << __func__ << __LINE__ << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return true;
}
QString HttpApi::encrypt(const QString &txt)
{
    QString md5;
    QByteArray encryptTxt = QCryptographicHash::hash(txt.toUtf8(), QCryptographicHash::Md5);
    encryptTxt = QCryptographicHash::hash(encryptTxt.toHex(), QCryptographicHash::Md5);
    md5.append(encryptTxt.toHex());
    return md5;
}
