import QtQuick              2.3
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import QGroundControl                       1.0
import QGroundControl.ScreenToolsController 1.0
import QGroundControl.SettingsManager       1.0

ApplicationWindow {
    id: _root
    property int _borderWidth: 1
    visible: true
    width: 910 * ScreenToolsController.ratio
    height: 618 * ScreenToolsController.ratio

    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    flags: Qt.FramelessWindowHint | Qt.Window//Qt.CustomizeWindowHint

    color: "#000000"

    function bootApp(mode) {
        QGroundControl.settingsManager.appSettings.setBootAppMode(mode)
        QGroundControl.settingsManager.appSettings.enterApp = true
        _root.close();
    }

    Rectangle {
        id: titleBar
        color: "#053540"
        width: parent.width
        height: 72 * ScreenToolsController.ratio

        anchors.left: parent.left
        anchors.top: parent.top

        Image {
            id: iconField
            source: "qrc:/res/resources/icons/BeiLi.png"

            width: 44 * ScreenToolsController.ratio
            height: 44 * ScreenToolsController.ratio

            sourceSize.width: width
            sourceSize.height: height

            anchors.left: parent.left
            anchors.leftMargin: 30 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: titleTextField
            text: qsTr("北京理工大学")
            anchors.left: iconField.right
            anchors.leftMargin: 10 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter

            font.family: "MicrosoftYaHei"
            font.weight: Font.Normal
            font.pixelSize: 24 * ScreenToolsController.ratioFont

            horizontalAlignment: Text.AlignLeft

            color: "#FFFFFF"
        }

        Rectangle {
            id: closeBtn
            property bool hovered: false
            color: hovered ? "#e81123" : "transparent"
            anchors.top: parent.top
            anchors.right: parent.right
            height: parent.height - 2
            width: 1.2 * height

            Image {
                id: closeImage
                source: "qrc:/qmlimages/BeiLi_2/icon_close.png"

                width: 20 * ScreenToolsController.ratio
                height: 20 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height

                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: {
                    _root.close()
                }
            }
        }

        Rectangle {
            id: minBtn
            property bool hovered: false
            color: hovered ? "#7bbfcf" : "transparent"
            anchors.top: parent.top
            anchors.right: closeBtn.left
            height: parent.height - 2
            width: 1.2 * height

            Image {
                id: minImage
                source: "qrc:/qmlimages/BeiLi_2/icon_min.png"

                width: 20 * ScreenToolsController.ratio
                height: 20 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height

                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: {
                    _root.showMinimized()
                    //_root.hide()
                }
            }
        }
    }

    Rectangle {
        color: "#eeeeee"

        anchors.top: titleBar.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: _borderWidth
        anchors.left: parent.left
        anchors.leftMargin: _borderWidth
        anchors.right: parent.right
        anchors.rightMargin: _borderWidth


        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 30 * ScreenToolsController.ratio
            spacing: 30 * ScreenToolsController.ratio
            Rectangle {
                property bool checked: false
                id: section_1
                width: 410 * ScreenToolsController.ratio
                height: 410 * ScreenToolsController.ratio
                radius: 8 * ScreenToolsController.ratio
                border.color: checked ? "green" : "#E1E1E1"
                border.width: checked ? 2 * ScreenToolsController.ratio : 1
                Image {
                    id: section_1_image
                    source: "qrc:/qmlimages/BeiLi_2/image_mission_normal.png"
                    anchors.left: parent.left
                    anchors.leftMargin: section_1.border.width
                    anchors.right: parent.right
                    anchors.rightMargin: section_1.border.width
                    anchors.top: parent.top
                    anchors.topMargin: section_1.border.width
                    height: 320  * ScreenToolsController.ratio
                }

                Text {
                    id: section_1_titel
                    text: qsTr("智能巡检")
                    anchors.top: section_1_image.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Normal
                    font.pixelSize: 24 * ScreenToolsController.ratioFont
                    color: "#333333"
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        section_2.checked = false
                        section_1.checked = !section_1.checked
                    }
                    onClicked: {
                        console.log(qsTr("智能巡检"))
                        bootApp(1)
                    }
                }
            }

            Rectangle {
                property bool checked: false
                id: section_2
                width: 410 * ScreenToolsController.ratio
                height: 410 * ScreenToolsController.ratio
                border.color: checked ? "green" : "#E1E1E1"
                border.width: checked ? 2 * ScreenToolsController.ratio : 1
                radius: 8 * ScreenToolsController.ratio
                Image {
                    id: section_2_image
                    source: "qrc:/qmlimages/BeiLi_2/image_mission_multi.png"
                    anchors.left: parent.left
                    anchors.leftMargin: section_2.border.width
                    anchors.right: parent.right
                    anchors.rightMargin: section_2.border.width
                    anchors.top: parent.top
                    anchors.topMargin: section_2.border.width
                    height: 320  * ScreenToolsController.ratio
                }

                Text {
                    id: section_2_titel
                    text: qsTr("集群控制")
                    anchors.top: section_2_image.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Normal
                    font.pixelSize: 24 * ScreenToolsController.ratioFont
                    color: "#333333"
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        section_1.checked = false
                        section_2.checked = !section_2.checked
                    }
                    onClicked: {
                        console.log(qsTr("集群控制"))
                        bootApp(2)
                    }
                }
            }
        }

        Rectangle {
            id: splitLine

            height: 1 * ScreenToolsController.ratio

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 75 * ScreenToolsController.ratio

            color: "#E1E1E1"
        }

        Rectangle {
            color: "transparent"

            anchors.left: parent.left
            anchors.top: splitLine.bottom
            anchors.right: parent.right
            anchors.bottom: parent.bottom

            Text {
                id: versionTextField
                text: qsTr("版本号：") + QGroundControl.settingsManager.appSettings.appVersion
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                anchors.verticalCenter: parent.verticalCenter

                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 16 * ScreenToolsController.ratioFont
                color: "#999999"
            }

            Rectangle {
                property bool hovered: false
                id: section_3
                color: "transparent"

                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.left: versionTextField.right
                anchors.leftMargin: 100

                Text {
                    id: section_3_titel
                    text: qsTr("开发者模式")

                    anchors.right: section_3_image.left
                    anchors.rightMargin: 4 * ScreenToolsController.ratioFont
                    anchors.verticalCenter: parent.verticalCenter

                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Normal
                    font.pixelSize: 16 * ScreenToolsController.ratioFont
                    color: "#999999"

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: section_3.hovered = true
                        onExited: section_3.hovered = false
                        onClicked: {
                            console.log(section_3_titel.text)
                            bootApp(0)
                        }
                    }
                }

                Image {
                    id: section_3_image
                    source: section_3.hovered ? "qrc:/qmlimages/BeiLi_2/icon_enter_banned.png" : "qrc:/qmlimages/BeiLi_2/icon_enter.png"
                    width: 24 * ScreenToolsController.ratio
                    height: 24 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height

                    anchors.right: parent.right
                    anchors.rightMargin: 25 * ScreenToolsController.ratio
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: section_3.hovered = true
                        onExited: section_3.hovered = false
                        onClicked: {
                            console.log(section_3_titel.text)
                            bootApp(0)
                        }
                    }
                }
            }
        }
    }

}
