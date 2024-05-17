import QtQuick              2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
//import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0

import QGroundControl                       1.0
import QGroundControl.ScreenToolsController 1.0
import QGroundControl.SettingsManager       1.0
import QGroundControl.Vehicle               1.0
import QGroundControl.HttpAPIManager        1.0
import QGroundControl.UIBeiLi               1.0

Rectangle {
    id: _root
    color: "#07424F"
    opacity: 0.9
    width: 486 * ScreenToolsController.ratio
    //height: 538 * ScreenToolsController.ratio
    height: (itemColumn.height + 60 * ScreenToolsController.ratio) + titleBarField.height + splitLine.height

    property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle
    property int alt: activeVehicle ? activeVehicle.altitudeRelative.rawValue : 0
    property int speed: activeVehicle ? activeVehicle.airSpeed.rawValue : 0

    onVisibleChanged: {
        if (visible) {
            heightSlider.value = _root.alt
            heightSlider.minimumValue = Math.max(30, _root.alt - 50)
            heightSlider.maximumValue = (_root.alt + 50)

            speedSlider.value = _root.speed

            radiusSlider.value = activeVehicle ? activeVehicle.loiterRadius() : 120
            radiusSlider.minimumValue = activeVehicle ? activeVehicle.loiterRadius() - 50 : 80
            radiusSlider.maximumValue = activeVehicle ? activeVehicle.loiterRadius() + 50 : 120

            waypointSlider.value = activeVehicle ? activeVehicle.missionItemIndex.rawValue : 0 // 当前航点编号
            waypointSlider.maximumValue = activeVehicle ? activeVehicle.missionCount() : 0 // 当前航线的最大行点数
        }
    }

    Item {
        id: titleBarField
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 54 * ScreenToolsController.ratio
        Text {
            id: titleTextField
            text: qsTr("调整")
            anchors.left: parent.left
            anchors.leftMargin: 10 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter

            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 20 * ScreenToolsController.ratioFont

            horizontalAlignment: Text.AlignLeft

            color: "#FFFFFF"
        }
    }

    Rectangle {
        id: splitLine
        anchors.top: titleBarField.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#118E9B"
    }

    Column {
        id: itemColumn
        spacing: 30 * ScreenToolsController.ratio
        anchors.top: splitLine.bottom
        anchors.topMargin: 30 * ScreenToolsController.ratio
        anchors.horizontalCenter: parent.horizontalCenter
        property real sliderWidth: parent.width - (heightTitle.width + heightDown.width + heightUp.width + flyHeightEditor.width + heightConfirm.width + 10 * ScreenToolsController.ratio * 7)

        Row {
            spacing: 10 * ScreenToolsController.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: heightTitle
                text: qsTr("高度")
                anchors.verticalCenter: parent.verticalCenter

                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratioFont
                horizontalAlignment: Text.AlignLeft
                color: "#ffffff"
            }

            Image {
                id: heightDown
                property bool hovered: false
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qmlimages/BeiLi_2/img_arrow_left.png"
                width: 16 * ScreenToolsController.ratio
                height: 16 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                opacity: heightDown.hovered ? 0.8 : 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        heightSlider.value -= 1
                    }
                }
            }

            Slider {
                id: heightSlider
                width: itemColumn.sliderWidth
                anchors.verticalCenter: parent.verticalCenter
                //value: _root.alt
                stepSize: 1
                minimumValue: 30//Math.max(30, _root.alt - 50)
                maximumValue: 200//(_root.alt + 50)
            }

            Image {
                id: heightUp
                property bool hovered: false
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qmlimages/BeiLi_2/img_arrow_right.png"
                width: 16 * ScreenToolsController.ratio
                height: 16 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                opacity: heightUp.hovered ? 0.8 : 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        heightSlider.value += 1
                    }
                }
            }

            TextField {
                id: flyHeightEditor
                anchors.verticalCenter: parent.verticalCenter
                width: 64 * ScreenToolsController.ratio
                height: 28 * ScreenToolsController.ratio
                text: heightSlider.value
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratioFont
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

            ActionButton {
                id: heightConfirm
                text: qsTr("确定")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    activeVehicle.missionModeChangeAltitude(flyHeightEditor.text)
                }
            }
        } // 高度

        // 半径
        Row {
            spacing: 10 * ScreenToolsController.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text: qsTr("半径")
                anchors.verticalCenter: parent.verticalCenter

                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratioFont
                horizontalAlignment: Text.AlignLeft
                color: "#ffffff"
            }

            Image {
                id: radiusDown
                property bool hovered: false
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qmlimages/BeiLi_2/img_arrow_left.png"
                width: 16 * ScreenToolsController.ratio
                height: 16 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                opacity: radiusDown.hovered ? 0.8 : 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        radiusSlider.value -= 1
                    }
                }
            }

            Slider {
                id: radiusSlider
                width: itemColumn.sliderWidth
                anchors.verticalCenter: parent.verticalCenter
                stepSize: 1
                minimumValue: 0
                maximumValue: 200
            }

            Image {
                id: radiusUp
                property bool hovered: false
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qmlimages/BeiLi_2/img_arrow_right.png"
                width: 16 * ScreenToolsController.ratio
                height: 16 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                opacity: radiusUp.hovered ? 0.8 : 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        radiusSlider.value += 1
                    }
                }
            }

            TextField {
                id: flyRadiusEditor
                anchors.verticalCenter: parent.verticalCenter
                width: 64 * ScreenToolsController.ratio
                height: 28 * ScreenToolsController.ratio
                text: radiusSlider.value
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 16 * ScreenToolsController.ratioFont
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

            ActionButton {
                text: qsTr("确定")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    activeVehicle.setLoiterRadius(flyRadiusEditor.text)
                }
            }
        } // 半径

        // 速度
        Row {
            spacing: 10 * ScreenToolsController.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text: qsTr("速度")
                anchors.verticalCenter: parent.verticalCenter

                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratioFont
                horizontalAlignment: Text.AlignLeft
                color: "#ffffff"
            }

            Image {
                id: speedDown
                property bool hovered: false
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qmlimages/BeiLi_2/img_arrow_left.png"
                width: 16 * ScreenToolsController.ratio
                height: 16 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                opacity: speedDown.hovered ? 0.8 : 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        speedSlider.value -= 1
                    }
                }
            }

            Slider {
                id: speedSlider
                width: itemColumn.sliderWidth
                anchors.verticalCenter: parent.verticalCenter
                stepSize: 1
                minimumValue: 0
                maximumValue: 25
            }

            Image {
                id: speedUp
                property bool hovered: false
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qmlimages/BeiLi_2/img_arrow_right.png"
                width: 16 * ScreenToolsController.ratio
                height: 16 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                opacity: speedUp.hovered ? 0.8 : 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        speedSlider.value += 1
                    }
                }
            }

            TextField {
                id: flySpeedEditor
                anchors.verticalCenter: parent.verticalCenter
                width: 64 * ScreenToolsController.ratio
                height: 28 * ScreenToolsController.ratio
                text: speedSlider.value
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 16 * ScreenToolsController.ratioFont
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

            ActionButton {
                text: qsTr("确定")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    activeVehicle.setSpeed(flySpeedEditor.text)
                }
            }
        } // 速度

        // 航点
        Row {
            spacing: 10 * ScreenToolsController.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                text: qsTr("航点")
                anchors.verticalCenter: parent.verticalCenter

                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratioFont
                horizontalAlignment: Text.AlignLeft
                color: "#ffffff"
            }

            Image {
                id: waypointDown
                property bool hovered: false
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qmlimages/BeiLi_2/img_arrow_left.png"
                width: 16 * ScreenToolsController.ratio
                height: 16 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                opacity: waypointDown.hovered ? 0.8 : 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        waypointSlider.value -= 1
                    }
                }
            }

            Slider {
                id: waypointSlider
                width: itemColumn.sliderWidth
                anchors.verticalCenter: parent.verticalCenter
                stepSize: 1
                minimumValue: 0
                maximumValue: 1000
            }

            Image {
                id: waypointUp
                property bool hovered: false
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qmlimages/BeiLi_2/img_arrow_right.png"
                width: 16 * ScreenToolsController.ratio
                height: 16 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                opacity: waypointUp.hovered ? 0.8 : 1
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        waypointSlider.value += 1
                    }
                }
            }

            TextField {
                id: flyWaypointEditor
                anchors.verticalCenter: parent.verticalCenter
                width: 64 * ScreenToolsController.ratio
                height: 28 * ScreenToolsController.ratio
                text: waypointSlider.value
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 16 * ScreenToolsController.ratioFont
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

            ActionButton {
                text: qsTr("确定")
                anchors.verticalCenter: parent.verticalCenter
                onClicked: {
                    activeVehicle.setCurrentMissionSequence(flyWaypointEditor.text)
                }
            }
        } // 航点

    }
}
