/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "KMLSaveDomDocument.h"
#include "QGCPalette.h"
#include "QGCApplication.h"
#include "MissionCommandTree.h"
#include "MissionCommandUIInfo.h"
#include "FactMetaData.h"
#include "ComplexMissionItem.h"
#include "QmlObjectListModel.h"

#include <QDomDocument>
#include <QStringList>

const char* KMLSaveDomDocument::polygonStyleName =   "PolygonStyle";
const char* KMLSaveDomDocument::polylineStyleName =   "PolylineStyle";

KMLSaveDomDocument::KMLSaveDomDocument()
    : KMLDomDocument(QStringLiteral("%1 KML").arg(qgcApp()->applicationName()))
{
    _addStyles();
}

void KMLSaveDomDocument::_addStyles(void)
{
    QGCPalette palette;

    QDomElement styleElement1 = createElement("Style");
    styleElement1.setAttribute("id", polylineStyleName);
    QDomElement lineStyleElement = createElement("LineStyle");
    addTextElement(lineStyleElement, "color", kmlColorString(palette.mapMissionTrajectory()));
    addTextElement(lineStyleElement, "width", "4");
    styleElement1.appendChild(lineStyleElement);

    QString kmlSurveyColorString = kmlColorString(palette.surveyPolygonInterior(), 0.5 /* opacity */);
    QDomElement styleElement2 = createElement("Style");
    styleElement2.setAttribute("id", polygonStyleName);
    QDomElement polygonStyleElement = createElement("PolyStyle");
    addTextElement(polygonStyleElement, "color", kmlSurveyColorString);
    QDomElement polygonLineStyleElement = createElement("LineStyle");
    addTextElement(polygonLineStyleElement, "color", kmlSurveyColorString);
    styleElement2.appendChild(polygonStyleElement);
    styleElement2.appendChild(polygonLineStyleElement);

    _rootDocumentElement.appendChild(styleElement1);
    _rootDocumentElement.appendChild(styleElement2);
}
