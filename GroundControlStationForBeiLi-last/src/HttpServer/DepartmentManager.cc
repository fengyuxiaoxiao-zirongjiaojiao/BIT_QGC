#include "DepartmentManager.h"
#include "HttpApi.h"
#include "HttpAPIManager.h"

DepartmentManager::DepartmentManager(QObject *parent) : QObject(parent)
{
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qRegisterMetaType<DepartmentManager*>("DepartmentManager*");
}


bool HttpApi::queryDepartmentInfo(QList<DeptInfo> &deptInfos)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(DEPT_QUERY_PATH);
    QString data = "";
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_GET, data, result, getHttpApiService()->userManager()->userInfo().token, false);
//    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
//    qDebug() << "===========================================================================";

    deptInfos.clear();
    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if ((!json_doc["errcode"].isUndefined() && json_doc["errcode"].toInt() == NO_ERROR) || (!json_doc["rows"].isUndefined() && !json_doc["rows"].toObject().isEmpty())) {
        QJsonObject rows = json_doc["rows"].toObject();
        if (!rows.isEmpty()) {
            QJsonArray children = rows["children"].toArray();

            for (int i = 0; i < children.count(); i++) {
                QJsonObject dep = children.at(i).toObject();
                DeptInfo deptinfo;
                deptinfo.deptId = dep["id"].toString().toInt();
                deptinfo.deptName = dep["text"].toString();

                QJsonArray depChildren = dep["children"].toArray();

                QList<UavGroupInfo> uavGroupInfos;
                for (int i = 0; i < depChildren.count(); i++) {
                    QJsonObject uavgroupinfoObject = depChildren.at(i).toObject();
                    UavGroupInfo uavGroupInfo;
                    uavGroupInfo.uavGroupId = uavgroupinfoObject["id"].toString().toInt();
                    uavGroupInfo.uavGroupName = uavgroupinfoObject["text"].toString();

                    uavGroupInfos.append(uavGroupInfo);
                }
                deptinfo.uavGroupInfos = uavGroupInfos;
                deptInfos.append(deptinfo);
            }


            /*for (int i = 0; i < deptInfos.count(); i++) {
                DeptInfo depinfo = deptInfos.at(i);
                qDebug() << depinfo.deptId << depinfo.deptName;
                for (int i = 0; i < depinfo.uavGroupInfos.count(); i++) {
                    qDebug() << depinfo.uavGroupInfos.at(i).uavGroupId << depinfo.uavGroupInfos.at(i).uavGroupName;
                }
            }*/
        }
        return true;
    }
    return ok;
}
