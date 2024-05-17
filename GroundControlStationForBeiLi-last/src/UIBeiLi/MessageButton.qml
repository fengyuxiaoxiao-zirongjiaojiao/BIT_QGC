import QtQuick 2.0

import QGroundControl                       1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenToolsController 1.0

Rectangle {
    id: messageRoot
    width: 64 * ScreenToolsController.ratio
    height: width
    radius: width / 2
    color: "#07424F"
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property int messageUnRead: 0//_activeVehicle ? _activeVehicle.newMessageCount : 0
    signal clicked()

    Image {
        id: messageIcon
        anchors.centerIn: parent
        source: "qrc:/qmlimages/BeiLi/icon_message.png"
        width: 56 * ScreenToolsController.ratio
        height: 56 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Rectangle {
        width: 16 * ScreenToolsController.ratio
        height: width
        radius: width / 2
        color: "red"
        visible: messageRoot.messageUnRead > 0 // 未读新消息
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 10 * ScreenToolsController.ratio

        Text {
            text: messageRoot.messageUnRead
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 10 * ScreenToolsController.ratio
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            messageRoot.clicked()
        }
    }
}
