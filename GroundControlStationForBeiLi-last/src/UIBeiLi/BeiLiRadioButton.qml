import QtQuick 2.14
import QGroundControl   1.0
import QGroundControl.ScreenToolsController 1.0

Rectangle {
    id: actionRadioButton
    property bool checked
    property bool hovered
    signal clicked()

    width: 12 * ScreenToolsController.ratio
    height: 12 * ScreenToolsController.ratio
    radius: width/2
    color: "transparent"
    border.color: actionRadioButton.checked ? Qt.rgba(37, 240, 133, 0.5)/*"#25f085"*/ : actionRadioButton.hovered ? Qt.rgba(178, 249, 255, 0.5)/*"#b2f9ff"*/ : Qt.rgba(8, 211, 229, 0.5)/*"#08d3e5"*/
    border.width: 1

    Rectangle {
        width: actionRadioButton.width / 2
        height: actionRadioButton.height / 2
        radius: width/2
        anchors.centerIn: parent
        visible: actionRadioButton.checked
        color: actionRadioButton.checked ? "#25f085" : actionRadioButton.hovered ? "#b2f9ff" : "#08d3e5"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            actionRadioButton.clicked()
            actionRadioButton.checked = !actionRadioButton.checked
        }
        onEntered: actionRadioButton.hovered = true
        onExited: actionRadioButton.hovered = false
    }
}
