/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "HttpServerSettings.h"

#include <QQmlEngine>
#include <QtQml>

DECLARE_SETTINGGROUP(HttpServer, "HttpServer")
{
    qmlRegisterUncreatableType<HttpServerSettings>("QGroundControl.SettingsManager", 1, 0, "HttpServerSettings", "Reference only");
}

DECLARE_SETTINGSFACT(HttpServerSettings, serverIp)
DECLARE_SETTINGSFACT(HttpServerSettings, serverPort)
DECLARE_SETTINGSFACT(HttpServerSettings, serverProtocol)
DECLARE_SETTINGSFACT(HttpServerSettings, groundControlStationPort)
DECLARE_SETTINGSFACT(HttpServerSettings, controlCenterPort)
DECLARE_SETTINGSFACT(HttpServerSettings, map3dAddr)
