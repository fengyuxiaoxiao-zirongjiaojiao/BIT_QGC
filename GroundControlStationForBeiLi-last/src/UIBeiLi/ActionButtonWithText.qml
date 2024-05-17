import QtQuick 2.0
import QtQuick.Controls 2.14
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootButton
    property var icon: ""
    property var backIcon: (pressed || checked) ? "qrc:/qmlimages/BeiLi/cluster_btn01_checked.png" : hovered ? "qrc:/qmlimages/BeiLi/cluster_btn01_hovered.png" : "qrc:/qmlimages/BeiLi/cluster_btn01_normal.png"
    property var text: ""
    property bool checked: false
    property bool pressed: false
    property bool hovered: false
    property bool checkable: false
    property bool enabled: true
    signal clicked()
    width: 44 * ScreenToolsController.ratio
    height: 66 * ScreenToolsController.ratio
    Button {
        id: control
        width: 44 * ScreenToolsController.ratio
        height: 44 * ScreenToolsController.ratio
        enabled: _rootButton.enabled
        checkable: _rootButton.checkable
        background: Rectangle {
            color: "transparent"
            width: control.width
            height: control.height
            Image {
                source: backIcon
                anchors.fill: parent
            }
        }
        BorderImage {
            source: icon
            anchors.centerIn: control
        }

        onCheckedChanged: _rootButton.checked = control.checked
        onHoveredChanged: _rootButton.hovered = control.hovered
        onPressedChanged: _rootButton.pressed = control.pressed
        onClicked: _rootButton.clicked()
    }

    Text {
        anchors.top: control.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.horizontalCenter: parent.horizontalCenter
        text: _rootButton.text
        font.family: "MicrosoftYaHei"
        font.weight: Font.Bold
        font.pixelSize: 14 * ScreenToolsController.ratio
        color: "#08D3E5"
    }
}
