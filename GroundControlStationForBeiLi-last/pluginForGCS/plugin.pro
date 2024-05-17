#! [0]
TEMPLATE        = lib
CONFIG         += plugin
QT             += core concurrent positioning
INCLUDEPATH    += . \
                    ../GroundControlStationForBeiLi/src/PluginManager

HEADERS         = TestPlugin.h
SOURCES         = TestPlugin.cpp
TARGET          = $$qtLibraryTarget(TestPlugin)
DESTDIR         = $$PWD/plugins
#! [0]

EXAMPLE_FILES = TestPlugin.json

# install
#target.path = $$[QT_INSTALL_EXAMPLES]/widgets/tools/echoplugin/plugins
#INSTALLS += target

CONFIG += install_ok  # Do not cargo-cult this!

QMAKE_POST_LINK += $$escape_expand(\\n) $$QMAKE_COPY \"$$DESTDIR\\*.dll\"  \"$$PWD\\..\\GroundControlStationForBeiLi\\build\\Desktop_Qt_5_14_2_MSVC2017_64bit\\staging\\plugins\\\"
