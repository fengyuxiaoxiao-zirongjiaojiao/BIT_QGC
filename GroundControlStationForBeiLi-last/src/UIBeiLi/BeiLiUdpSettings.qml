import QtQuick          2.3
import QtQuick.Controls 2.14
import QtQuick.Dialogs  1.2

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

Column {
    id:                 _udpSetting
    spacing:            ScreenTools.defaultFontPixelHeight * 0.5
    anchors.margins:    ScreenTools.defaultFontPixelWidth
    property bool isEdit: false
    function saveSettings() {
        // No need
    }

    property string _currentHost: ""

    Row {
        spacing:    ScreenTools.defaultFontPixelWidth
        Text {
            text:   qsTr("监听端口:")
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14
            color: "#08D3E5"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        TextField {
            id:     portField
            width: 100
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14
            color: !isEdit ? "#08D3E5" : "#293538"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            readOnly: !isEdit
            padding: 0

            background: Rectangle {
                color: portField.readOnly ? "transparent" : "white"
                radius: portField.readOnly ? 0 : 4
                border.color: portField.readOnly ? "transparent" : "#80BFE8"
                border.width: portField.readOnly ? 0 : 1
            }

            text:   linkConfig && linkConfig.linkType === LinkConfiguration.TypeUdp ? linkConfig.localPort.toString() : ""
            inputMethodHints:       Qt.ImhFormattedNumbersOnly
            onTextChanged: {
                if(editConfig) {
                    editConfig.localPort = parseInt(portField.text)
                }
            }
        }
    }
    Item {
        height: ScreenTools.defaultFontPixelHeight / 2
        width:  parent.width
    }
    Text {
        text:   qsTr("目标主机:")
        font.family: "MicrosoftYaHei"
        font.weight: Font.Bold
        font.pixelSize: 14
        color: "#08D3E5"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    Item {
        width:  hostRow.width
        height: hostRow.height
        Row {
            id:      hostRow
            spacing: ScreenTools.defaultFontPixelWidth
            Item {
                height: 1
                width:  130
            }
            Column {
                id:         hostColumn
                spacing:    ScreenTools.defaultFontPixelHeight / 2
                Rectangle {
                    height:  1
                    width:   ScreenTools.defaultFontPixelWidth * 30
                    color:   qgcPal.button
                    visible: {
                        var config = isEdit ? editConfig : linkConfig;
                        return config && config.linkType === LinkConfiguration.TypeUdp && config.hostList.length > 0
                    }
                }
                Repeater {
                    model: {
                        var config = isEdit ? editConfig : linkConfig;
                        return config && config.linkType === LinkConfiguration.TypeUdp ? config.hostList : ""
                    }
                    delegate:
                    Button {
                        height: 24
                        width:              ScreenTools.defaultFontPixelWidth * 30
                        anchors.leftMargin: ScreenTools.defaultFontPixelWidth * 2
                        autoExclusive:      true
                        background: Rectangle {
                            color: parent.checked ? "#0F6878" : "#003b4b"
                        }
                        contentItem: Text {
                            text: modelData
                            font.family: "MicrosoftYaHei"
                            font.weight: Font.Bold
                            font.pixelSize: 18
                            color: "#08D3E5"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                        }
                        onClicked: {
                            checked = true
                            _udpSetting._currentHost = modelData
                        }
                    }
                }
                TextField {
                    id:         hostField
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 14
                    color: !isEdit ? "#08D3E5" : "#293538"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    focus:      true
                    visible:    false
                    width:      ScreenTools.defaultFontPixelWidth * 30
                    padding: 0
                    onEditingFinished: {
                        if(editConfig) {
                            if(hostField.text !== "") {
                                editConfig.addHost(hostField.text)
                                hostField.text = ""
                            }
                            hostField.visible = false
                        }
                    }
                    Keys.onReleased: {
                        if (event.key === Qt.Key_Escape) {
                            hostField.text = ""
                            hostField.visible = false
                        }
                    }
                }
                Rectangle {
                    height: 1
                    width:  ScreenTools.defaultFontPixelWidth * 30
                    color:  qgcPal.button
                }
                Item {
                    height: ScreenTools.defaultFontPixelHeight / 2
                    width:  parent.width
                }
                Item {
                    width:  ScreenTools.defaultFontPixelWidth * 30
                    height: udpButtonRow.height
                    visible: isEdit
                    Row {
                        id:         udpButtonRow
                        spacing:    ScreenTools.defaultFontPixelWidth
                        anchors.horizontalCenter: parent.horizontalCenter
                        ActionButton {
                            width:      ScreenTools.defaultFontPixelWidth * 10
                            text:       qsTr("添加")
                            onClicked: {
                                if(hostField.visible && hostField.text !== "") {
                                    editConfig.addHost(hostField.text)
                                    hostField.text = ""
                                    hostField.visible = false
                                } else
                                    hostField.visible = true
                            }
                        }
                        ActionButton {
                            width:      ScreenTools.defaultFontPixelWidth * 10
                            enabled:    _udpSetting._currentHost && _udpSetting._currentHost !== ""
                            text:       qsTr("移除")
                            onClicked: {
                                if (isEdit && editConfig) {
                                    editConfig.removeHost(_udpSetting._currentHost)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
