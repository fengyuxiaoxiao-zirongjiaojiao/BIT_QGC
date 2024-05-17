import QtQuick          2.3
import QtQuick.Dialogs  1.2
import QtQuick.Controls 2.14

import QGroundControl                       1.0
import QGroundControl.ScreenToolsController 1.0
Item {
    id:       logReplayLinkSettings
    property bool isEdit: false

    Row {
        spacing:        10 * ScreenToolsController.ratio
        Text {
            text:       qsTr("日志文件:")
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
            id:         logField
            text:       linkConfig && linkConfig.linkType === LinkConfiguration.TypeLogReplay ? linkConfig.fileName : ""
            anchors.verticalCenter: parent.verticalCenter
            width: isEdit ? (180 * _widthRatio) : (320 * _widthRatio)
            height: 30 * ScreenToolsController.ratio
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: logField.readOnly ? "#08D3E5" : "#293538"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            readOnly: !isEdit
            padding: 0

            background: Rectangle {
                color: logField.readOnly ? "transparent" : "white"
                radius: logField.readOnly ? 0 : 4
                border.color: logField.readOnly ? "transparent" : "#80BFE8"
                border.width: logField.readOnly ? 0 : 1
            }

            onTextChanged: {
                if(editConfig) {
                    editConfig.fileName = logField.text
                }
            }
        }
        ActionButton {
            text:       qsTr("浏览")
            visible: isEdit
            onClicked: {
                fileDialog.visible = true
            }
        }
    }
    FileDialog {
        id:             fileDialog
        title:          qsTr("Please choose a file")
        folder:         shortcuts.home
        visible:        false
        selectExisting: true
        onAccepted: {
            if(editConfig) {
                editConfig.fileName = fileDialog.fileUrl.toString().replace("file:///", "")
                logField.text = editConfig.fileName
            }
            fileDialog.visible = false
        }
        onRejected: {
            fileDialog.visible = false
        }
    }
}
