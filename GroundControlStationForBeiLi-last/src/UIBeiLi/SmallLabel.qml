import QtQuick 2.0
import QGroundControl   1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    property var icon: ""
    property var title: ""
    property var value: 0.0
    property var unit: ""
    width: 100 * ScreenToolsController.ratio
    height: 18 * ScreenToolsController.ratio

    Image {
        id: iconImage
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        source: icon
        width: 20 * ScreenToolsController.ratio
        height: 20 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Text {
        id: titleLabel
        text: title
        anchors.left: iconImage.right
        anchors.leftMargin: 6 * ScreenToolsController.ratio
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 14 * ScreenToolsController.ratio
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
        font.pixelSize: 16 * ScreenToolsController.ratio
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
        font.pixelSize: 14 * ScreenToolsController.ratio
        font.family: "Microsoft YaHei"
        font.weight: Font.Normal
        color: "#B2F9FF"
    }
}
