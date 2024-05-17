import QtQuick 2.14

import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QGroundControl               1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootQuickSetup
    property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property int alt: activeVehicle ? activeVehicle.altitudeRelative.rawValue : 0
    property int speed: activeVehicle ? activeVehicle.airSpeed.rawValue : 0

    onVisibleChanged: {
        if (visible) {
            flyWaypointEdit.text = activeVehicle.currentMissionSequence()
            flyHeightEdit.text = String(alt)
            flyAirSpeedEdit.text = String(speed)
            flyRadiusEdit.text = String(activeVehicle ? activeVehicle.loiterRadius() : 0)
        }
    }

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
        anchors.top: parent.top
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 30 * ScreenToolsController.ratio
        rows: 4
        columns: 2
        rowSpacing: 20 * ScreenToolsController.ratio
        columnSpacing: 20 * ScreenToolsController.ratio
        horizontalItemAlignment:  Grid.AlignHCenter
        verticalItemAlignment: Grid.AlignVCenter

        TextField {
            id: flyHeightEdit
            width: 64 * ScreenToolsController.ratio
            height: 28 * ScreenToolsController.ratio
            text: qsTr("0")
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 18 * ScreenToolsController.ratio
            textColor: "#293538"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly

            style: TextFieldStyle {
                background: Rectangle {
                    radius: 4 * ScreenToolsController.ratio
                    border.color: "#80BFE8"
                    border.width: 1
                }
            }
        }

        ActionButtonThree {
            id: flyHeightModifyBtn
            text: qsTr("改高度")
            onClicked: {
                activeVehicle.missionModeChangeAltitude(flyHeightEdit.text)
            }
        }

        TextField {
            id: flyRadiusEdit
            width: 64 * ScreenToolsController.ratio
            height: 28 * ScreenToolsController.ratio
            text: qsTr("0")
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 18 * ScreenToolsController.ratio
            textColor: "#293538"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly

            style: TextFieldStyle {
                background: Rectangle {
                    radius: 4 * ScreenToolsController.ratio
                    border.color: "#80BFE8"
                    border.width: 1
                }
            }
        }

        ActionButtonThree {
            id: flyRadiusModifyBtn
            text: qsTr("改半径")
            onClicked: {
                activeVehicle.setLoiterRadius(flyRadiusEdit.text)
            }
        }

        TextField {
            id: flyAirSpeedEdit
            width: 64 * ScreenToolsController.ratio
            height: 28 * ScreenToolsController.ratio
            text: qsTr("0")
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 18 * ScreenToolsController.ratio
            textColor: "#293538"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly

            style: TextFieldStyle {
                background: Rectangle {
                    radius: 4 * ScreenToolsController.ratio
                    border.color: "#80BFE8"
                    border.width: 1
                }
            }
        }

        ActionButtonThree {
            id: flyAirSpeedModifyBtn
            text: qsTr("改速度")
            onClicked: {
                activeVehicle.setSpeed(flyAirSpeedEdit.text)
            }
        }

        TextField {
            id: flyWaypointEdit
            width: 64 * ScreenToolsController.ratio
            height: 28 * ScreenToolsController.ratio
            text: qsTr("0")
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 18 * ScreenToolsController.ratio
            textColor: "#293538"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            inputMethodHints: Qt.ImhFormattedNumbersOnly

            style: TextFieldStyle {
                background: Rectangle {
                    radius: 4 * ScreenToolsController.ratio
                    border.color: "#80BFE8"
                    border.width: 1
                }
            }
        }

        ActionButtonThree {
            id: flyWaypointModifyBtn
            text: qsTr("改航点")
            onClicked: {
                activeVehicle.setCurrentMissionSequence(flyWaypointEdit.text)
            }
        }

    }
}
