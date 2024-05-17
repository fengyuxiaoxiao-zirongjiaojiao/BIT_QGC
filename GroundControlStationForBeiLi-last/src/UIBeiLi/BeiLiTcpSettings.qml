import QtQuick 2.0
import QtQuick.Controls 2.14
import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id:                 tcpLinkSettings
    property bool isEdit: false

    function saveSettings() {
        if(editConfig) {
            editConfig.host = hostField.text
            editConfig.port = parseInt(portField.text)
            editConfig.id = parseInt(idField.text)
        }
    }
    Row {
        spacing:        10 * ScreenToolsController.ratio

        Text {
            text: qsTr("主机地址:")
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: "#08D3E5"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        TextField {
            id:         hostField
            text:       linkConfig && linkConfig.linkType === LinkConfiguration.TypeTcp ? linkConfig.host : ""
            width: 90 * _widthRatio
            height: 30 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: hostField.readOnly ? "#08D3E5" : "#293538"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            readOnly: !isEdit
            padding: 0

            background: Rectangle {
                color: hostField.readOnly ? "transparent" : "white"
                radius: hostField.readOnly ? 0 : 4
                border.color: hostField.readOnly ? "transparent" : "#80BFE8"
                border.width: hostField.readOnly ? 0 : 1
            }
        }

        Text {
            text: qsTr("端口:")
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: "#08D3E5"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        TextField {
            id:         portField
            text:       linkConfig && linkConfig.linkType === LinkConfiguration.TypeTcp ? linkConfig.port.toString() : ""
            width: 60 * _widthRatio
            height: 30 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: portField.readOnly ? "#08D3E5" : "#293538"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            readOnly: !isEdit
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            padding: 0

            background: Rectangle {
                color: portField.readOnly ? "transparent" : "white"
                radius: portField.readOnly ? 0 : 4
                border.color: portField.readOnly ? "transparent" : "#80BFE8"
                border.width: portField.readOnly ? 0 : 1
            }
        }

        Text {
            text: qsTr("ID:")
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: "#08D3E5"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        TextField {
            id:         idField
            text:       linkConfig && linkConfig.linkType === LinkConfiguration.TypeTcp ? linkConfig.id.toString() : "-1"
            width: 40 * _widthRatio
            height: 30 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: idField.readOnly ? "#08D3E5" : "#293538"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            readOnly: !isEdit
            inputMethodHints: Qt.ImhFormattedNumbersOnly
            padding: 0

            background: Rectangle {
                color: idField.readOnly ? "transparent" : "white"
                radius: idField.readOnly ? 0 : 4
                border.color: idField.readOnly ? "transparent" : "#80BFE8"
                border.width: idField.readOnly ? 0 : 1
            }
        }
    }

}
