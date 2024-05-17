#include "httpapi.h"
HttpApi *HttpApi::_httpApi = nullptr;
HttpApi::HttpApi()
{
    _httpApi = this;
    qDebug() << __FILE__ << __func__ << __LINE__ << "construct";
}

HttpApi::~HttpApi()
{
    _httpApi = nullptr;
    qDebug() << __FILE__ << __func__ << __LINE__ << "destory";
}

bool HttpApi::httpRequest(QString url, HttpApi::RequestMethod method, const QString &param_or_data, QByteArray &ret_data, const QString &authentication, bool showError)
{
    QNetworkProxy proxy;
    proxy.setType(QNetworkProxy::DefaultProxy);
    QNetworkAccessManager access_mng;
    access_mng.setProxy(proxy);
    QNetworkRequest request;
    QNetworkReply* reply = nullptr;
    switch (method) {
    case REQ_GET:
    {
        request.setUrl(QUrl(url+"?"+param_or_data));
        if (!authentication.isEmpty()) {
            request.setRawHeader("Authentication", authentication.toUtf8());//服务器要求的数据头部
        }
        reply = access_mng.get(request);
    }
        break;
    case REQ_POST:
    {
        request.setUrl(QUrl(url));
        request.setHeader(QNetworkRequest::KnownHeaders::ContentTypeHeader,
                          "application/x-www-form-urlencoded; charset=UTF-8");
        if (!authentication.isEmpty()) {
            //request.setRawHeader("Authentication", QString("APPCODE %1").arg(APPCODE).toUtf8());//服务器要求的数据头部
            request.setRawHeader("Authentication", authentication.toUtf8());//服务器要求的数据头部
        }
        reply = access_mng.post(request,  param_or_data.toUtf8());
    }
        break;
    case REQ_PUT:
    {
        request.setUrl(QUrl(url));
        request.setHeader(QNetworkRequest::KnownHeaders::ContentTypeHeader,
                          "application/x-www-form-urlencoded; charset=UTF-8");
        reply = access_mng.put(request,  param_or_data.toUtf8());
    }
        break;
    }
    if (!reply) {
        return false;
    }
    reply->ignoreSslErrors();

#if 1
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
    bool ret = false;


    if (!is_timeout && reply->error() == QNetworkReply::NoError) {
        // 没超时没错误
        ret_data = reply->readAll();
        QJsonObject json_obj = QJsonDocument::fromJson(ret_data).object();
        if (json_obj.isEmpty()) {
            ret = false;
            if (showError) QMessageBox::critical(nullptr, QStringLiteral("错误"), QStringLiteral("响应的数据为空！"));
        } else if (json_obj.contains("errcode") && json_obj["errcode"].toInt() == NO_ERROR) {
            ret = true;
        } else if (json_obj.contains("errcode") && json_obj["errcode"].toInt() != NO_ERROR) {
            if (showError) QMessageBox::critical(nullptr, QStringLiteral("错误"), json_obj["message"].toString());
            ret = false;
        } else {
            if (showError) QMessageBox::critical(nullptr, QStringLiteral("错误"), QStringLiteral("未知错误！"));
            ret = false;
        }
        //qDebug() << __FILE__ << __func__ << __LINE__ << ret_data;
    }
    else if (is_timeout && !reply->isFinished()) {
        qDebug() << __FILE__ << __func__ << __LINE__ << QStringLiteral("请求服务器失败，检查网络!");
        if (showError) {
            QMessageBox::critical(nullptr, QStringLiteral("错误"), QStringLiteral("请求服务器失败，检查网络!"));
        }
    }
    else {
        qDebug() << __FILE__ << __func__ << __LINE__ << reply->errorString();
        if (showError) {
            QMessageBox::critical(nullptr, QStringLiteral("错误"), reply->errorString());
        }
    }
    reply->deleteLater();
#endif
    return ret;
}

bool HttpApi::httpRequest(QString url, QHttpMultiPart &multi_part, QByteArray &ret_data, bool showError)
{
    QNetworkAccessManager access_mng;
    QNetworkRequest request;
    QNetworkReply* reply = nullptr;

    request.setUrl(QUrl(url));
    reply = access_mng.post(request, &multi_part);

    if (!reply) {
        return false;
    }
    reply->ignoreSslErrors();
    QTime time;
    time.start();
    bool is_timeout = false;
    while (!reply->isFinished()) {
        QApplication::processEvents();
        if (time.elapsed() > REQUEST_TIMEOUT_MS*3) {
            is_timeout = true; // 超时
            break;
        }
    }
    bool ret = false;
    if (!is_timeout && reply->error() == QNetworkReply::NoError) {
        // 没超时没错误
        ret_data = reply->readAll();
        ret = true;
    }
    else {
        if (showError) {
            QMessageBox::critical(nullptr,QObject::tr("Error"),
                              QObject::tr("Request failed,please check the net!"));
        }
    }
    reply->deleteLater();
    return ret;
}

UserManager *HttpApi::userManager()
{
    return &_userManager;
}

UAVInfoManager *HttpApi::uavInfoManager()
{
    return &_uavInfoManager;
}

AirspaceApplyManager *HttpApi::airspaceApplyManager()
{
   return  &_airspaceApplyManager;
}

FlyTaskManager *HttpApi::flyTaskManager()
{
    return &_flyTaskManager;
}

PermissionsManager *HttpApi::permissionsManager()
{
    return &_permissionsManager;
}

DepartmentManager *HttpApi::departmentManager()
{
    return &_departmentManager;
}


HttpApi *getHttpApiService()
{
    return HttpApi::_httpApi;
}
