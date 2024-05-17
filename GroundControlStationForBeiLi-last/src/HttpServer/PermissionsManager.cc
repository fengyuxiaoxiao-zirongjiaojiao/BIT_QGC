#include "PermissionsManager.h"
#include "HttpApi.h"
#include "HttpAPIManager.h"

PermissionsManager::PermissionsManager(QObject *parent) : QObject(parent)
{

}

bool HttpApi::queryDronePilotPermissions(DronePilotPermissionsInfoList &permissionsInfos, const QString &pageNum, const QString &pageSize, const QString &sortOrder, const QString &flierId, const QString &uavId)
{
    permissionsInfos.clear();

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(PERMISSION_QUERY_PATH);
    QString data;
    if (!pageNum.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageNum=" + pageNum; }
    if (!pageSize.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageSize=" + pageSize; }
    if (!sortOrder.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "sortOrder=" + sortOrder; }
    if (!flierId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "flierId=" + flierId; }
    if (!uavId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "uavId=" + uavId; }
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        QJsonObject dt = json_doc["data"].toObject();
        if (!dt.isEmpty()) {
            permissionsInfos.setTotal(dt["total"].toInt());
            permissionsInfos.setSize(dt["size"].toInt());
            permissionsInfos.setCurrent(dt["current"].toInt());
            permissionsInfos.setSearchCount(dt["searchCount"].toBool());
            permissionsInfos.setPages(dt["pages"].toInt());
            QJsonArray records = dt["records"].toArray();
            for (int i = 0; i < records.size(); i++) {
                DronePilotPermissionsInfo permissionsInfo;
                QJsonObject record = records.at(i).toObject();
                permissionsInfo.flierId = record["flier_id"].toInt();
                permissionsInfo.createdTime = record["created_time"].toString();
                permissionsInfo.uavId = record["uav_id"].toInt();
                permissionsInfo.permissions = record["permissions"].toString();
                permissionsInfo.name = record["name"].toString();
                permissionsInfo.id = record["id"].toInt();
                permissionsInfo.avatar = record["avatar"].toString();
                permissionsInfo.eNumber = record["e_number"].toString();
                permissionsInfo.uavModel = record["uav_model"].toString();
                permissionsInfo.username = record["username"].toString();

                permissionsInfos.append(permissionsInfo);
            }
        }
        return true;
    }
    return false;
}

bool HttpApi::deleteDronePilotPermissions(const QString &flierId, const QString &uavId)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(PERMISSION_DELETE_PATH);
    QString data = "flierId=" + flierId + "&uavId" + uavId;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::updateDronePilotPermissions(const QString &permissions, const QString &flierId)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(PERMISSION_DELETE_PATH);
    QString data;
    if (!permissions.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "permissions=" + permissions; }
    if (!flierId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "flierId=" + flierId; }
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::queryDronePilotWithOrg(DronePilotRelationshipWithOrgList &relationshipWithOrgs, const QString &audit, const QString &companyId, const QString &flierId, const QString &pageSize, const QString &pageNum, const QString &sortOrder, const QString &sortField)
{
    relationshipWithOrgs.clear();

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(DRONE_PILOT_WITH_ORG_QUERY_PATH);
    QString data = "audit=" + audit;
    if (!companyId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "company_id=" + companyId; }
    if (!flierId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "flierId=" + flierId; }
    if (!pageSize.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageSize=" + pageSize; }
    if (!pageNum.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageNum=" + pageNum; }
    if (!sortOrder.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "sortOrder=" + sortOrder; }
    if (!sortField.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "sortField=" + sortField; }

    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        QJsonObject dt = json_doc["data"].toObject();
        if (!dt.isEmpty()) {
            relationshipWithOrgs.setTotal(dt["total"].toInt());
            relationshipWithOrgs.setSize(dt["size"].toInt());
            relationshipWithOrgs.setCurrent(dt["current"].toInt());
            relationshipWithOrgs.setSearchCount(dt["searchCount"].toBool());
            relationshipWithOrgs.setPages(dt["pages"].toInt());
            QJsonArray records = dt["records"].toArray();
            for (int i = 0; i < records.size(); i++) {
                DronePilotRelationshipWithOrg relationshipWithOrg;
                QJsonObject record = records.at(i).toObject();
                relationshipWithOrg.flierId = record["flier_id"].toInt();
                relationshipWithOrg.createdTime = record["created_time"].toString();
                relationshipWithOrg.companyId = record["company_id"].toInt();
                relationshipWithOrg.audit = record["audit"].toString();
                relationshipWithOrg.name = record["name"].toString();
                relationshipWithOrg.id = record["id"].toInt();
                relationshipWithOrg.username = record["username"].toString();

                relationshipWithOrgs.append(relationshipWithOrg);
            }
        }
        return true;
    }
    return false;
}

bool HttpApi::deleteDronePilotWithOrg(const QString &flierId, const QString &companyId)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(DRONE_PILOT_WITH_ORG_DELETE_PATH);
    QString data = "flierId" + flierId + "&companyId" + companyId;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::updateDronePilotWithOrg(const QString &isAgree, const QString &id)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(DRONE_PILOT_WITH_ORG_UPDATE_PATH);
    QString data = "isAgree" + isAgree + "&id" + id;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::addDronePilotWithOrg(const QString &flierId, const QString &companyId)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(DRONE_PILOT_WITH_ORG_ADD_PATH);
    QString data = "flierId" + flierId + "&companyId" + companyId;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}
