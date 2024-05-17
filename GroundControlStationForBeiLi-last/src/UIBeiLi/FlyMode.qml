import QtQuick 2.0
import QGroundControl               1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootFlyMode
    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property var _flightModes: _activeVehicle ? _activeVehicle.flightModesZh : QGroundControl.multiVehicleManager.offlineEditingVehicle.flightModesZh
    property var _margin: 20 * ScreenToolsController.ratio
    property var _rows: 5
    property int columns: _flightModeRepeater.count % _rows == 0 ? (_flightModeRepeater.count/_rows) : (_flightModeRepeater.count/_rows +1)
    //width: (_margin + 74) * columns + _margin
    width: (_margin + 110 * ScreenToolsController.ratio) * columns + _margin
    height: 297 * ScreenToolsController.ratio
    property var flightMode: _activeVehicle ? _activeVehicle.flightModeZh : qsTr("模式")

    Rectangle {
        id: _bg
        anchors.fill: parent
        color: "#07424F"
        opacity: 0.8
    }

    Image {
        id: _upperLeft
        source: "qrc:/qmlimages/BeiLi/form_upper_left.png"
        anchors.top: parent.top
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_upper_right.png"
        anchors.top: parent.top
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_left.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_right.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Grid {
        id: _flightModeGrid
        anchors.top: parent.top
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: _margin
        rows: _rows
        rowSpacing: 20 * ScreenToolsController.ratio
        columnSpacing: _margin
        flow: Grid.TopToBottom
        layoutDirection: Qt.LeftToRight

        Repeater {
            id: _flightModeRepeater
            model: _flightModes
            ActionButtonFour {
                text: modelData

                onClicked: {
                    _activeVehicle.flightMode = modelData
                }
            }
        }

        ActionButtonFour {
            text: (_activeVehicle && _activeVehicle.isCar) ? qsTr("飞机模式") : qsTr("车子模式")
            enabled: _activeVehicle ? true : false
            visible: !QGroundControl.defFlytouav()
            onClicked: {
                if (_activeVehicle) {
                    _activeVehicle.isCar = !_activeVehicle.isCar
                }
            }
        }

        ActionButtonFour {
            text: qsTr("回机巢")
            enabled: _activeVehicle ? true : false
            visible: !QGroundControl.defFlytouav()
            onClicked: {
                if (_activeVehicle) {
                    _activeVehicle.goHome()
                }
            }
        }
    }


}
