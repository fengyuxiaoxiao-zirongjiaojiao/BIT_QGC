import QtQuick 2.0
import QGroundControl   1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    property var icon: ""
    property var title: ""
    property var value: ""
    property var unit: ""

    height: 45 * ScreenToolsController.ratio
    width: 100 * ScreenToolsController.ratio

    Image {
        id: iconImage
        anchors.left: parent.left
        anchors.top: parent.top
        source: icon
        width: 32 * ScreenToolsController.ratio
        height: 32 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Text {
        id: titleLabel
        text: title
        anchors.horizontalCenter: iconImage.horizontalCenter
        anchors.top: iconImage.bottom
        anchors.topMargin: 0
        font.pixelSize: 10 * ScreenToolsController.ratio
        font.family: "Microsoft YaHei"
        font.weight: Font.Normal
        color: "#08D3E5"
    }

    Text {
        id: valueLabel
        text: value
        anchors.left: titleLabel.right
        anchors.leftMargin: 9 * ScreenToolsController.ratio
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 20 * ScreenToolsController.ratio
        font.family: "Microsoft YaHei"
        font.weight: Font.Normal
        color: "#B2F9FF"
    }

    Text {
        id: unitLabel
        text: unit
        visible: unit !== ""
        anchors.left: valueLabel.right
        anchors.leftMargin: 1
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 16 * ScreenToolsController.ratio
        font.family: "Microsoft YaHei"
        font.weight: Font.Normal
        color: "#B2F9FF"
    }
}
