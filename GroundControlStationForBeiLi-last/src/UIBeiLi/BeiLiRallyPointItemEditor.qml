import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

Column {
    spacing: 40 * ScreenToolsController.ratio
    property var rallyPoint: controller ? controller.currentRallyPoint : null   ///< RallyPoint object associated with editor
    property var controller: rallyPointController                               ///< RallyPointController

    Row {
        id: parameRow
        spacing: 20 * ScreenToolsController.ratio

        Rectangle {
            width: 140 * ScreenToolsController.ratio
            height: 60 * ScreenToolsController.ratio
            color: "#084D5A"
            radius: 4 * ScreenToolsController.ratio
            TextField {
                id: latitudeField
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
                readOnly: rallyPoint ? false : true
                text: rallyPoint ? rallyPoint.coordinate.latitude.toFixed(8) : ""
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
                    if (rallyPoint) {
                        rallyPoint.coordinate.latitude = text
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: latitudeField.bottom
                anchors.topMargin: 9 * ScreenToolsController.ratio
                text: qsTr("纬度")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }
        }

        Rectangle {
            width: 140 * ScreenToolsController.ratio
            height: 60 * ScreenToolsController.ratio
            color: "#084D5A"
            radius: 4 * ScreenToolsController.ratio
            TextField {
                id: longitudeField
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
                readOnly: rallyPoint ? false : true
                text: rallyPoint ? rallyPoint.coordinate.longitude.toFixed(8) : ""
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
                    if (rallyPoint) {
                        rallyPoint.coordinate.longitude = text
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: longitudeField.bottom
                anchors.topMargin: 9 * ScreenToolsController.ratio
                text: qsTr("经度")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }
        }

        Rectangle {
            width: 120 * ScreenToolsController.ratio
            height: 60 * ScreenToolsController.ratio
            color: "#084D5A"
            radius: 4 * ScreenToolsController.ratio
            TextField {
                id: altField
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
                readOnly: rallyPoint ? false : true
                text: rallyPoint ? rallyPoint.coordinate.altitude : ""
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
                    if (rallyPoint) {
                        rallyPoint.coordinate.altitude = text
                    }
                }
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: altField.bottom
                anchors.topMargin: 9 * ScreenToolsController.ratio
                text: qsTr("高度")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }
        }


        Button {
            id: deleteRallyPointItemBtn
            anchors.verticalCenter: parent.verticalCenter
            width: 24 * ScreenToolsController.ratio
            height: 24 * ScreenToolsController.ratio
            background: Rectangle {
                color: "transparent"
            }
            BorderImage {
                source: deleteRallyPointItemBtn.checked || deleteRallyPointItemBtn.pressed ? "qrc:/qmlimages/BeiLi/link_icon_delete_hovered.png" : deleteMissionItemBtn.hovered ? "qrc:/qmlimages/BeiLi/link_icon_delete_hovered.png" : "qrc:/qmlimages/BeiLi/link_icon_delete_normal.png"
                width: deleteRallyPointItemBtn.width; height: deleteRallyPointItemBtn.height
            }

            onClicked: {
                controller.removePoint(rallyPoint)
            }
        }
    } // Row

    Row {
        spacing: 5 * ScreenToolsController.ratio
        Text {
            text: qsTr("集结点个数：")
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 12 * ScreenToolsController.ratio
            color: "#B2F9FF"
        }
        Text {
            text: controller ? controller.points.count : 0
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 12 * ScreenToolsController.ratio
            color: "#B2F9FF"
        }
    }
}
