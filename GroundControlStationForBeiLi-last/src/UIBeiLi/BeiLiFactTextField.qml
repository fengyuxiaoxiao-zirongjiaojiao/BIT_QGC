import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

TextField {
    id: _root

    property Fact   fact: null
    property var unitsLabel: fact ? fact.units : ""

    text: fact ? String("%1").arg(fact.valueString) : "N/A"

    font.family: "MicrosoftYaHei"
    font.weight: Font.Bold
    font.pixelSize: 14 * ScreenToolsController.ratio
    color: "#293538"
    horizontalAlignment: Text.AlignLeft
    verticalAlignment: Text.AlignVCenter
    focus: false
    selectByMouse: true
    padding: 0

    background: Rectangle {
        radius: 4 * ScreenToolsController.ratio
        border.color: "#0AC6D7"
        border.width: 1
    }

    Text {
        text: unitsLabel
        font.family: "MicrosoftYaHei"
        font.weight: Font.Bold
        font.pixelSize: 11 * ScreenToolsController.ratio
        color: "#293538"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 2 * ScreenToolsController.ratio
    }

    Rectangle {
        anchors.fill: parent
        color: "#084D5A"
        opacity: 0.8
        visible: !_root.enabled
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
        var errorString = fact.validate(text, false /* convertOnly */)
        if (errorString === "") {
            fact.value = text
        } else {
            console.log(qsTr("Invalid Value"))
        }
    }
}
