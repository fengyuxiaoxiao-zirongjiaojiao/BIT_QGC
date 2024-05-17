#include "HttpAPIManager.h"
#include <QQmlEngine>

HttpAPIManager::HttpAPIManager(QGCApplication *app, QGCToolbox *toolbox)
    : QGCTool(app, toolbox)
{
    _httpapi = HttpApiPtr(new HttpApi());

    connect(getHttpApiService()->userManager(), &UserManager::isLoginChanged, getHttpApiService()->uavInfoManager(), &UAVInfoManager::onLoginChanged);
}

void HttpAPIManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<HttpAPIManager>("QGroundControl.HttpAPIManager", 1, 0, "HttpAPIManager", "Reference only");
}
