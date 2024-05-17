#include "AirspaceApplyManager.h"
#include "HttpApi.h"
#include "HttpAPIManager.h"

AirspaceApplyManager::AirspaceApplyManager(QObject *parent) : QObject(parent)
{

}

AirspaceApplyManager::~AirspaceApplyManager()
{

}
#if 0
bool HttpApi::addAirspaceApplyInfo(const QString &airspaceFile, const QString &uavId, const QString &instruction, const QString &airspacePoints)
{
    QString url = QString("%1%2").arg(SERVER_URL).arg(AIRSPACE_ADD_PATH);
    QString data = "airspaceFile" + airspaceFile + "&uavId" + uavId + "&instruction" + instruction + "&airspacePoints" + airspacePoints;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        return true;
    }
    QMessageBox::critical(nullptr,QObject::tr("Error"),
                          json_doc["message"].toString());
    return false;
}
#endif
bool HttpApi::addAirspaceApplyInfoMultiPart(const QString &airspaceFile, const QString &uavId, const QString &instruction, const QList<QGeoCoordinate> &airspacePoints)
{
    QHttpMultiPart multiPart(QHttpMultiPart::FormDataType);

    QHttpPart airspaceFilePart;
    airspaceFilePart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/png")); // TODO
    QFile file(airspaceFile);
    airspaceFilePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"airspaceFile\";\
                                                                               filename=\"" + file.fileName() + "\""));
    file.open(QIODevice::ReadOnly);
    airspaceFilePart.setBodyDevice(&file);
    multiPart.append(airspaceFilePart);

    QHttpPart uavIdPart;
    uavIdPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"uavId\""));
    uavIdPart.setBody(uavId.toUtf8());
    multiPart.append(uavIdPart);

    QHttpPart instructionPart;
    uavIdPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"instruction\""));
    uavIdPart.setBody(instruction.toUtf8());
    multiPart.append(instructionPart);

    QString points = "[";
    for(int i = 0; i < airspacePoints.size(); i++) {
        QGeoCoordinate coord = airspacePoints.at(i);
        QString point = QString("{lng:%1,lat:%2}").arg(QString::number(coord.longitude(), 'f', 6)).arg(QString::number(coord.latitude(), 'f', 6));
        points.append(point);

        if (i < airspacePoints.size() - 1) {
            points.append(",");
        }
    }
    points.append("]");

    QHttpPart airspacePointsPart;
    airspacePointsPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"airspacePoints\""));
    airspacePointsPart.setBody(points.toUtf8());
    multiPart.append(airspacePointsPart);

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(AIRSPACE_ADD_PATH);
    QByteArray result;
    if (!HttpApi::httpRequest(url, multiPart, result)) {
        return false;
    }
    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        return true;
    }
    else {
        QMessageBox::critical(nullptr,QObject::tr("Error"),
                              json_doc["message"].toString());
    }
    return false;
}

bool HttpApi::queryAirspaceNoFlyZone(QList<AirSpaceInfo> &airspaceInfos, const QGeoCoordinate &position, int radius, const QString &type)
{
    airspaceInfos.clear();

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(AIRSPACE_QUERY_NOFLYZONE);
    QString data = "longitude=" + QString::number(position.longitude()) + "&latitude=" + QString::number(position.latitude()) + "&radius=" + QString::number(radius);
    if (!type.isEmpty()) data += "&type=" + type;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::auditAirspaceApply(const QString &id, const QString &audit)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(AIRSPACE_UPDATE_PATH);
    QString data = "id=" + id + "&audit" + audit;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}

bool HttpApi::queryAirspaceApplyInfo(AirspaceApplyInfoList &airspaceApplyInfos, const QString &pageNum, const QString &pageSize, const QString &sortField, const QString &sortOrder, const QString &audit, const QString &applicantId, const QString &uavId)
{
    airspaceApplyInfos.clear();

    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(AIRSPACE_QUERY_PATH);
    QString data;
    if (!pageNum.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageNum=" + pageNum; }
    if (!pageSize.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "pageSize=" + pageSize; }
    if (!sortField.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "sortField=" + sortField; }
    if (!sortOrder.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "sortOrder=" + sortOrder; }
    if (!audit.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "audit=" + audit; }
    if (!applicantId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "applicantId=" + applicantId; }
    if (!uavId.isEmpty()) { data += data.isEmpty() ? "" : "&"; data += "uavId=" + uavId; }
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    QJsonDocument json_doc = QJsonDocument::fromJson(result);
    if (json_doc["errcode"].toInt() == NO_ERROR) {
        QJsonObject dt = json_doc["data"].toObject();
        if (!dt.isEmpty()) {
            airspaceApplyInfos.setTotal(dt["total"].toInt());
            airspaceApplyInfos.setSize(dt["size"].toInt());
            airspaceApplyInfos.setCurrent(dt["current"].toInt());
            airspaceApplyInfos.setSearchCount(dt["searchCount"].toBool());
            airspaceApplyInfos.setPages(dt["pages"].toInt());
            QJsonArray records = dt["records"].toArray();
            for (int i = 0; i < records.size(); i++) {
                AirspaceApplyInfo airspaceApplyInfo;
                QJsonObject record = records.at(i).toObject();
                airspaceApplyInfo.createdTime = record["created_time"].toString();
                airspaceApplyInfo.uavId = record["uav_id"].toInt();
                airspaceApplyInfo.airspaceFileUrl = record["airspace_file_url"].toString();
                airspaceApplyInfo.idCard = record["id_card"].toString();
                QJsonArray airspacePoints = record["airspace_points"].toArray();
                for (int j= 0; j < airspacePoints.size(); j++) {
                    QJsonObject point = airspacePoints.at(j).toObject();
                    QGeoCoordinate coord;
                    coord.setLongitude(point["lng"].toDouble());
                    coord.setLatitude(point["lat"].toDouble());
                    airspaceApplyInfo.airspacePoints.append(coord);
                }
                airspaceApplyInfo.applicantId = record["applicant_id"].toInt();
                airspaceApplyInfo.audit = record["audit"].toString();
                airspaceApplyInfo.instruction = record["instruction"].toString();
                airspaceApplyInfo.name = record["name"].toString();
                airspaceApplyInfo.id = record["id"].toInt();
                airspaceApplyInfo.uavModel = record["uav_model"].toString();
                airspaceApplyInfo.eNumber = record["e_number"].toString();
                airspaceApplyInfo.username = record["username"].toString();

                airspaceApplyInfos.append(airspaceApplyInfo);
            }
        }
        return true;
    }
    return false;
}

bool HttpApi::deleteAirspaceApplyInfo(const QString &id)
{
    QString serverUrl = qgcApp()->toolbox()->httpAPIManager()->getServerURL();
    QString url = QString("%1%2").arg(serverUrl).arg(AIRSPACE_DELETE_PATH);
    QString data = "id=" + id;
    QByteArray result;
    bool ok = HttpApi::httpRequest(url, HttpApi::RequestMethod::REQ_POST, data, result, getHttpApiService()->userManager()->userInfo().token);
    qDebug() << __FILE__ << __func__ << __LINE__ << ok << QString::fromUtf8(result);
    qDebug() << "===========================================================================";

    return ok;
}
