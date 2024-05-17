#include "KmlManager.h"
#include <QQmlEngine>
#include <QFileDialog>
#include "ShapeFileHelper.h"
#include <QGCApplication.h>
#include <SettingsManager.h>

KmlManager::KmlManager(QGCApplication *app, QGCToolbox *toolbox)
    : QGCTool(app, toolbox)
    , _polygon(new QGCMapPolygon())
    , _polyline(new QGCMapPolyline())
    , _polygonTraceMode(false)
{

}

bool KmlManager::createPolygon()
{
    //_polygon = new QGCMapPolygon();
    //emit polygonChanged();
    return true;
}

bool KmlManager::loadKMLFile()
{
    ShapeFileHelper sap;
    QString filers = sap.fileDialogKMLFilters().join(";;");
    QString kmlFile = QFileDialog::getOpenFileName(nullptr, tr("Select KML File"), _toolbox->settingsManager()->appSettings()->missionSavePath(), filers);
    if (kmlFile.isEmpty()) return false;
    QString errorString;
    ShapeFileHelper::ShapeType t = ShapeFileHelper::determineShapeType(kmlFile, errorString);
    if (ShapeFileHelper::ShapeType::Polygon == t) {
        bool ok = _polygon->loadKMLOrSHPFile(kmlFile);
        _mapToCenter = _polygon->center();
        emit newKmlAvailable(t);
        return ok;
    } else if (ShapeFileHelper::ShapeType::Polyline == t) {
        bool ok = _polyline->loadKMLFile(kmlFile);
        _mapToCenter = _polyline->center();
        emit newKmlAvailable(t);
        return ok;
    }
    return false;
}

void KmlManager::setPolygon(QGCMapPolygon *polygon)
{
    if (polygon != _polygon) {
        _polygon = polygon;
        emit polygonChanged();
    }
}

void KmlManager::setPolyline(QGCMapPolyline *polyline)
{
    if (polyline != _polyline) {
        _polyline = polyline;
        emit polylineChanged();
    }
}

void KmlManager::setPolygonTraceMode(bool polygonTraceMode)
{
    if (polygonTraceMode != _polygonTraceMode) {
        _polygonTraceMode = polygonTraceMode;
        emit polygonTraceModeChanged();
    }
}

void KmlManager::setPolylineTraceMode(bool polylineTraceMode)
{
    if (polylineTraceMode != _polylineTraceMode) {
        _polylineTraceMode = polylineTraceMode;
        emit polylineTraceModeChanged();
    }
}

void KmlManager::setDefaultPolygonVertices(QList<QGeoCoordinate> vertices)
{
    _defaultPolygonVertices.clear();
    _defaultPolygonVertices = vertices;
}

void KmlManager::setDefaultPolylineVertices(QList<QGeoCoordinate> vertices)
{
    _defaultPolylineVertices.clear();
    _defaultPolylineVertices = vertices;
}

void KmlManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<KmlManager>("QGroundControl.KmlManager", 1, 0, "KmlManager", "Reference only");
}
