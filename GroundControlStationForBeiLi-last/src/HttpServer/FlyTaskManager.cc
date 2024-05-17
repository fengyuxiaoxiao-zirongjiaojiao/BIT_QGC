#include "FlyTaskManager.h"
#include "HttpApi.h"
#include "HttpAPIManager.h"

FlyTaskManager::FlyTaskManager(QObject *parent) : QObject(parent)
{

}

bool HttpApi::addFlightTask(const QString &uavId, const QString &task)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(TASK_ADD_PATH);
    QString data = "uavId=" + uavId + "&task" + task;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::queryFlightTask(FlyTaskInfoList &taskInfos, const QString &pageNum, const QString &pageSize, const QString &sortField, const QString &sortOrder, const QString &uavId)
{
    taskInfos.clear();

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(TASK_QUERY_PATH);
    QString data;
    if (!pageNum.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageNum=" + pageNum; }
    if (!pageSize.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageSize=" + pageSize; }
    if (!sortField.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "sortField=" + sortField; }
    if (!sortOrder.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "sortOrder=" + sortOrder; }
    if (!uavId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "uavId=" + uavId; }
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        QJsonObject dt = json_doc["data"].toObject();
        if (!dt.isEmpty()) {
            taskInfos.setTotal(dt["total"].toInt());
            taskInfos.setSize(dt["size"].toInt());
            taskInfos.setCurrent(dt["current"].toInt());
            taskInfos.setSearchCount(dt["searchCount"].toBool());
            taskInfos.setPages(dt["pages"].toInt());
            QJsonArray records = dt["records"].toArray();
            for (int i = 0; i < records.size(); i++) {
                FlyTaskInfo flyTaskInfo;
                QJsonObject record = records.at(i).toObject();
                flyTaskInfo.flierId = record["flier_id"].toInt();
                flyTaskInfo.createdTime = record["created_time"].toString();
                flyTaskInfo.task = record["task"].toString();
                flyTaskInfo.uavId = record["uav_id"].toInt();
                flyTaskInfo.registrantId = record["registrant_id"].toInt();
                flyTaskInfo.name = record["name"].toString();
                flyTaskInfo.id = record["id"].toInt();
                flyTaskInfo.eNumber = record["e_number"].toString();
                flyTaskInfo.uavModel = record["uav_model"].toString();
                flyTaskInfo.username = record["username"].toString();

                taskInfos.append(flyTaskInfo);
            }
        }
        return true;
    }
    return false;
}
