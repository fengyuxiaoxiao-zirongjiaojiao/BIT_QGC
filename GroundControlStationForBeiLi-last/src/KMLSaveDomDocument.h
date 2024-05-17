/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "KMLDomDocument.h"


/// Used to convert a Plan to a KML document
class KMLSaveDomDocument : public KMLDomDocument
{
public:
    KMLSaveDomDocument();

    static const char* polygonStyleName;
    static const char* polylineStyleName;

private:
    void _addStyles         (void);
};
