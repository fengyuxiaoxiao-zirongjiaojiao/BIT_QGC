#ifndef HTTPAPIMANAGER_H
#define HTTPAPIMANAGER_H

#include "QGCToolbox.h"
#include "HttpServer/HttpApi.h"

class HttpAPIManager : public QGCTool
{
    Q_OBJECT

public:
    HttpAPIManager(QGCApplication* app, QGCToolbox* toolbox);

    Q_INVOKABLE UserManager *getUserManager() {
        return getHttpApiService()->userManager();
    }

    Q_INVOKABLE UAVInfoManager *getUAVInfoManager() {
        return getHttpApiService()->uavInfoManager();
    }

    Q_INVOKABLE DepartmentManager *getDepartmentManager() {
        return getHttpApiService()->departmentManager();
    }

    Q_INVOKABLE QString getWebViewURL() {
        QString ip = qgcApp()->toolbox()->settingsManager()->httpServerSettings()->serverIp()->rawValueString();
        QString port = qgcApp()->toolbox()->settingsManager()->httpServerSettings()->serverPort()->rawValueString();
        QString protocol = qgcApp()->toolbox()->settingsManager()->httpServerSettings()->serverProtocol()->rawValueString();
        return QString("%1://%2:%3").arg(protocol).arg(ip).arg(port);
    }

    Q_INVOKABLE QString getMapCesiumUrl() {
        return qgcApp()->toolbox()->settingsManager()->httpServerSettings()->map3dAddr()->rawValueString();
    }

    Q_INVOKABLE QString getPointCloudCesiumUrl() {
        return QString("%1/pointCloud.html").arg(qgcApp()->toolbox()->settingsManager()->httpServerSettings()->map3dAddr()->rawValueString());
    }

    QString getServerURL() {
        return QString("%1/svr").arg(getWebViewURL());
    }


    // Override from QGCTool
    virtual void setToolbox(QGCToolbox *toolbox);

public slots:

private:
    HttpApiPtr _httpapi;

};

#endif // HTTPAPIMANAGER_H
