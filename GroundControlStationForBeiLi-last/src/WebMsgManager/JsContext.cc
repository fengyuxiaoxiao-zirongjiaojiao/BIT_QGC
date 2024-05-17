#include "JsContext.h"
#include <QDebug>
#include <QJsonDocument>

JsContext::JsContext(QObject *parent) : QObject(parent)
{

}

void JsContext::onReceiveText(const QString &text)
{
    qDebug() << __FILE__ << __func__ << __LINE__ << "msg from html:" << text;
}

void JsContext::onReceiveKml(int type, QString kml)
{
    if (kml.isEmpty()) return;
    QJsonDocument doc = QJsonDocument::fromJson(kml.toUtf8());
    QJsonObject obj = doc.object();
    QGeoCoordinate coor(obj.value("latitude").toDouble(), obj.value("longitude").toDouble());
    if (!coor.isValid()) return;
    emit kmlPointFromWebChanged(type, coor);
}

void JsContext::onReceiveWayPoint(QString point)
{
    qDebug() << __FILE__ << __func__ << __LINE__ << point;
    QJsonDocument doc = QJsonDocument::fromJson(point.toUtf8());
    QJsonObject obj = doc.object();
    QGeoCoordinate coor;
    if (obj.contains("altitude")) {
        coor = QGeoCoordinate(obj.value("latitude").toDouble(), obj.value("longitude").toDouble(), obj.value("altitude").toDouble());
    } else {
        coor = QGeoCoordinate(obj.value("latitude").toDouble(), obj.value("longitude").toDouble());
    }
    if (!coor.isValid()) return;
    emit addWayPointFromWebChanged(coor);
}

void JsContext::onActiveVehicleChanged(int id)
{
    qDebug() << __FILE__ << __func__ << __LINE__ << id;
    emit activeVehicleFromWebChanged(id);
}

void JsContext::onPlanWaypointEdited(int index, QString json)
{
    //QJsonDocument doc = QJsonDocument::fromJson(json.toUtf8());
    //qDebug() << __FILE__ << __func__ << __LINE__ << index << doc;
    emit planWaypointFromWebEdited(index, json);
}

void JsContext::onPlanWaypointSelected(int index)
{
    emit planWaypointFromWebSelected(index);
}

void JsContext::onMapCenterChanged(QString point)
{
    QJsonDocument doc = QJsonDocument::fromJson(point.toUtf8());
    QJsonObject obj = doc.object();
    QGeoCoordinate coor = QGeoCoordinate(obj.value("latitude").toDouble(), obj.value("longitude").toDouble());
    if (!coor.isValid()) return;
    emit mapCenterChanged(coor);
}
