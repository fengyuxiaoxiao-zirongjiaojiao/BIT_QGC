/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


/// @file
/// @author Gus Grubba <gus@auterion.com>

#include "ScreenToolsController.h"
#include <QFontDatabase>
#include <QScreen>
#include <QFontMetrics>

#include "SettingsManager.h"

#if defined(__ios__)
#include <sys/utsname.h>
#endif

ScreenToolsController::ScreenToolsController()
{
    connect(QGuiApplication::primaryScreen(), &QScreen::geometryChanged, this, &ScreenToolsController::_onChanged);
    connect(QGuiApplication::primaryScreen(), &QScreen::logicalDotsPerInchChanged, this, &ScreenToolsController::_onChanged);

    _onChanged();
}

bool
ScreenToolsController::hasTouch() const
{
    return QTouchDevice::devices().count() > 0 || isMobile();
}

QString
ScreenToolsController::iOSDevice() const
{
#if defined(__ios__)
    struct utsname systemInfo;
    uname(&systemInfo);
    return QString(systemInfo.machine);
#else
    return QString();
#endif
}

QString
ScreenToolsController::fixedFontFamily() const
{
    return QFontDatabase::systemFont(QFontDatabase::FixedFont).family();
}

QString
ScreenToolsController::normalFontFamily() const
{
    //-- See App.SettinsGroup.json for index
    int langID = qgcApp()->toolbox()->settingsManager()->appSettings()->language()->rawValue().toInt();
    if(langID == 6 /*Korean*/) {
        return QString("fonts/NanumGothic-Regular");
    } else {
        return QString("opensans");
    }
}

QString
ScreenToolsController::boldFontFamily() const
{
    //-- See App.SettinsGroup.json for index
    int langID = qgcApp()->toolbox()->settingsManager()->appSettings()->language()->rawValue().toInt();
    if(langID == 6 /*Korean*/) {
        return QString("NanumGothic-Bold");
    } else {
        return QString("opensans-demibold");
    }
}

void ScreenToolsController::_onChanged()
{
    qreal refDpi = 96.;
    qreal refWidth = 1920.;
    qreal refHeight = 1080.;

    QRect rect = QGuiApplication::primaryScreen()->geometry();
    qreal width = rect.width();
    qreal height = rect.height();
    qreal dpi = QGuiApplication::primaryScreen()->logicalDotsPerInch();
    m_ratio = height/refHeight;//qMin(height/refHeight, width/refWidth);
    m_ratioFont = qMin(height*refDpi/(dpi*refHeight), width*refDpi/(dpi*refWidth));

    emit ratioChanged();
    emit ratioFontChanged();
}

double ScreenToolsController::defaultFontDescent(int pointSize) const
{
    return QFontMetrics(QFont(normalFontFamily(), pointSize)).descent();
}
