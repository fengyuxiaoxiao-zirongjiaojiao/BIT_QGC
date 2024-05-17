import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _root
    property var    _planMasterController:      globals.planMasterControllerPlanView
    property var    _missionController:         _planMasterController.missionController
    property var    _controllerVehicle:         _planMasterController.controllerVehicle
//    property bool   _vehicleHasHomePosition:        _controllerVehicle.homePosition.isValid
    property bool   _showCruiseSpeed:               !_controllerVehicle.multiRotor
    property bool   _showHoverSpeed:                _controllerVehicle.multiRotor || _controllerVehicle.vtol
    property bool   _multipleFirmware:              !QGroundControl.singleFirmwareSupport
    property bool   _multipleVehicleTypes:          !QGroundControl.singleVehicleSupport
    property bool   _noMissionItemsAdded:           _missionController.visualItems.count === 1
    property bool   _allowFWVehicleTypeSelection:   _noMissionItemsAdded && !globals.activeVehicle
    property var    _currentMissionItem:        globals.currentPlanMissionItem

    Component.onCompleted: {
        if (_currentMissionItem) {
            for(var i = 0; i < _currentMissionItem.textFieldFacts.count; i++) {
                var fact = _currentMissionItem.textFieldFacts.get(i);
                if (fact) {
                    console.log(i, fact.name, fact.value)
                }
            }
        }
    }

    Flow {
        anchors.top: _root.top
        anchors.left: _root.left
        spacing: 5 * ScreenToolsController.ratio
        width: 490 * ScreenToolsController.ratio
        Rectangle {
            width: 60 * ScreenToolsController.ratio
            height: 60 * ScreenToolsController.ratio
            color: "#084D5A"
            radius: 4 * ScreenToolsController.ratio
            TextField {
                id: homeField
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30 * ScreenToolsController.ratio
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 14 * ScreenToolsController.ratio
                color: "#293538"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                focus: true
                selectByMouse: true
                readOnly: true
                text: qsTr("Home")
                padding: 0

                background: Rectangle {
                    radius: 4 * ScreenToolsController.ratio
                    border.color: "#0AC6D7"
                    border.width: 1
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: homeField.bottom
                anchors.topMargin: 9 * ScreenToolsController.ratio
                text: qsTr("命令")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }
        }

        Rectangle {
            width: 100 * ScreenToolsController.ratio
            height: 60 * ScreenToolsController.ratio
            color: "#084D5A"
            radius: 4 * ScreenToolsController.ratio
            TextField {
                id: waypointLatitudeField
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30 * ScreenToolsController.ratio
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 14 * ScreenToolsController.ratio
                color: "#293538"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                focus: true
                selectByMouse: true
                text: _currentMissionItem.coordinate.latitude.toFixed(8)
                padding: 0

                background: Rectangle {
                    radius: 4 * ScreenToolsController.ratio
                    border.color: "#0AC6D7"
                    border.width: 1
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#084D5A"
                    opacity: 0.8
                    visible: !parent.enabled
                    radius: 4 * ScreenToolsController.ratio
                    MouseArea {
                        anchors.fill: parent
                        onPressed: { }
                        onReleased: { }
                        onClicked: { }
                        onWheel: { }
                    }
                }
                onEditingFinished: {
                    _currentMissionItem.coordinate.latitude = text
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: waypointLatitudeField.bottom
                anchors.topMargin: 9 * ScreenToolsController.ratio
                text: qsTr("纬度")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }
        }

        Rectangle {
            width: 100 * ScreenToolsController.ratio
            height: 60 * ScreenToolsController.ratio
            color: "#084D5A"
            radius: 4 * ScreenToolsController.ratio
            TextField {
                id: waypointLongitudeField
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30 * ScreenToolsController.ratio
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 14 * ScreenToolsController.ratio
                color: "#293538"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                focus: true
                selectByMouse: true
                text: _currentMissionItem.coordinate.longitude.toFixed(8)
                padding: 0

                background: Rectangle {
                    radius: 4 * ScreenToolsController.ratio
                    border.color: "#0AC6D7"
                    border.width: 1
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#084D5A"
                    opacity: 0.8
                    visible: !parent.enabled
                    radius: 4 * ScreenToolsController.ratio
                    MouseArea {
                        anchors.fill: parent
                        onPressed: { }
                        onReleased: { }
                        onClicked: { }
                        onWheel: { }
                    }
                }
                onEditingFinished: {
                    _currentMissionItem.coordinate.longitude = text
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: waypointLongitudeField.bottom
                anchors.topMargin: 9 * ScreenToolsController.ratio
                text: qsTr("经度")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }
        }

        Rectangle {
            width: 60 * ScreenToolsController.ratio
            height: 60 * ScreenToolsController.ratio
            color: "#084D5A"
            radius: 4 * ScreenToolsController.ratio
            BeiLiFactTextField {
                id: waypointAltField
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30 * ScreenToolsController.ratio
                fact: _currentMissionItem.plannedHomePositionAltitude
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: waypointAltField.bottom
                anchors.topMargin: 9 * ScreenToolsController.ratio
                text: qsTr("地面海拔")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }
        }

        Rectangle {
            width: 60 * ScreenToolsController.ratio
            height: 60 * ScreenToolsController.ratio
            color: "#084D5A"
            radius: 4 * ScreenToolsController.ratio
            BeiLiFactTextField {
                id: defaultWaypointAltField
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                height: 30 * ScreenToolsController.ratio
                fact: QGroundControl.settingsManager.appSettings.defaultMissionItemAltitude
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: defaultWaypointAltField.bottom
                anchors.topMargin: 9 * ScreenToolsController.ratio
                text: qsTr("默认航高")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }
        }

        Item {
            width: 60 * ScreenToolsController.ratio
            height: 60 * ScreenToolsController.ratio
            ActionButton {
                id: setlaunchPositionBtn
                anchors.verticalCenter: parent.verticalCenter
                text: qsTr("中心")
                onClicked: {
                    if (QGroundControl.settingsManager.appSettings.mapView3d.value) {
                        _currentMissionItem.coordinate = QGroundControl.webMsgManager.getMapCenter()
                    } else {
                        _currentMissionItem.coordinate = globals.beiLiPlanView.editorMap.center
                    }
                }
            }
        }

        Loader {
            id: simpleMissionItemSection
            source: "qrc:/qml/QGroundControl/UIBeiLi/BeiLiSimpleItemSectionEditor.qml"
        }

    }
}
