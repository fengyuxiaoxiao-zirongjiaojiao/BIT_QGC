#ifndef KMLMANAGER_H
#define KMLMANAGER_H

#include <QObject>
#include "QGCToolbox.h"
#include "KMLHelper.h"
#include "ShapeFileHelper.h"
#include "QGCMapPolygon.h"
#include "QGCMapPolyline.h"

class KmlManager : public QGCTool
{
    Q_OBJECT
public:
    KmlManager(QGCApplication* app, QGCToolbox* toolbox);
    Q_PROPERTY(QGCMapPolygon*     polygon          READ polygon    WRITE setPolygon      NOTIFY polygonChanged)
    Q_PROPERTY(QGCMapPolyline*    polyline         READ polyline   WRITE setPolyline     NOTIFY polylineChanged)
    Q_PROPERTY(bool    polygonTraceMode         READ polygonTraceMode   WRITE setPolygonTraceMode     NOTIFY polygonTraceModeChanged)
    Q_PROPERTY(bool    polylineTraceMode        READ polylineTraceMode   WRITE setPolylineTraceMode     NOTIFY polylineTraceModeChanged)
    Q_PROPERTY(QList<QGeoCoordinate>   defaultPolygonVertices   READ defaultPolygonVertices   WRITE  setDefaultPolygonVertices   CONSTANT)
    Q_PROPERTY(QList<QGeoCoordinate>   defaultPolylineVertices   READ defaultPolylineVertices   WRITE  setDefaultPolylineVertices   CONSTANT)

    Q_INVOKABLE bool createPolygon();
    Q_INVOKABLE bool loadKMLFile();
    Q_INVOKABLE QGeoCoordinate mapToCenter() { return _mapToCenter; }

    QGCMapPolygon* polygon() { return _polygon; }
    void setPolygon(QGCMapPolygon *polygon);

    QGCMapPolyline* polyline() { return _polyline; }
    void setPolyline(QGCMapPolyline *polyline);

    bool polygonTraceMode() { return _polygonTraceMode; }
    void setPolygonTraceMode(bool polygonTraceMode);

    bool polylineTraceMode() { return _polylineTraceMode; }
    void setPolylineTraceMode(bool polylineTraceMode);

    QList<QGeoCoordinate> defaultPolygonVertices() { return _defaultPolygonVertices; }
    void setDefaultPolygonVertices(QList<QGeoCoordinate> vertices);

    QList<QGeoCoordinate> defaultPolylineVertices() { return _defaultPolylineVertices; }
    void setDefaultPolylineVertices(QList<QGeoCoordinate> vertices);

    // Override from QGCTool
    virtual void setToolbox(QGCToolbox *toolbox);
signals:
    void polygonChanged();
    void polylineChanged();
    void polygonTraceModeChanged();
    void polylineTraceModeChanged();
    void newKmlAvailable(ShapeFileHelper::ShapeType type);
private:
    QGCMapPolygon *_polygon;
    QGCMapPolyline *_polyline;
    bool _polygonTraceMode;
    bool _polylineTraceMode;
    QGeoCoordinate _mapToCenter;
    QList<QGeoCoordinate> _defaultPolylineVertices;
    QList<QGeoCoordinate> _defaultPolygonVertices;
};

#endif // KMLMANAGER_H
