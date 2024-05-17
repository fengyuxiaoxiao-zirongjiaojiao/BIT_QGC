import QtQuick              2.3
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0

import QGroundControl                       1.0
import QGroundControl.ScreenToolsController 1.0

Rectangle {
    id: _root

    property var icon
    property var iconChecked
    property var text

    property bool enabled: true
    property bool hovered: false
    property bool checked: false
    property bool oldChecked: false
    property bool checkEnabled: false
    signal clicked()

    width: 64 * ScreenToolsController.ratio
    height: 64 * ScreenToolsController.ratio
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#053540"
        opacity: 0.5
        visible: _root.checked && _root.enabled
    }

    Column {
        spacing: 5 * ScreenToolsController.ratio
        anchors.centerIn: parent
        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: _root.checked && _root.enabled ? _root.iconChecked : _root.icon
            width: 30 * ScreenToolsController.ratio
            height: 30 * ScreenToolsController.ratio
            sourceSize.width: width
            sourceSize.height: height
            opacity: parent.hovered && _root.enabled ? 0.5 : 1
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: _root.text
            opacity: _root.hovered && _root.enabled ? 0.5 : 1
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.family: "MicrosoftYaHei"
            font.weight: Font.Normal
            font.pixelSize: 12 * ScreenToolsController.ratioFont
            color: "#E6E6E6"
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: if (parent.enabled) parent.hovered = true
        onExited: if (parent.enabled) parent.hovered = false
        onPressed: {
            if (parent.enabled) {
                parent.oldChecked = parent.checked
                parent.checked = true
            }
        }
        onReleased: {
            if (parent.enabled) {
                parent.checked = parent.oldChecked
            }
        }

        onClicked:  {
            if (parent.enabled) {
                if (parent.checkEnabled) {
                    parent.checked = ! parent.checked
                }
                parent.clicked()
            }
        }
    }
}
