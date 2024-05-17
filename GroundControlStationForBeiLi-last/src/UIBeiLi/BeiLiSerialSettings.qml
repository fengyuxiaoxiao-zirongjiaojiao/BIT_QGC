import QtQuick 2.0
import QtQuick.Controls 2.14
import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: serialLinkRoot
    property bool isEdit: false

    Row {
        spacing:        10 * _widthRatio
        Text {
            id: serialPort
            text: qsTr("串口:")
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
            id: linkserialPortEdit
            width: 120 * _widthRatio
            height: 30 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: !isEdit ? "#08D3E5" : "#293538"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            readOnly: true
            visible: !isEdit
            text: (linkConfig && linkConfig.linkType === LinkConfiguration.TypeSerial) ? linkConfig.portDisplayName : ""
            padding: 0

            background: Rectangle {
                color: linkserialPortEdit.readOnly ? "transparent" : "white"
                radius: linkserialPortEdit.readOnly ? 0 : 4
                border.color: linkserialPortEdit.readOnly ? "transparent" : "#80BFE8"
                border.width: linkserialPortEdit.readOnly ? 0 : 1
            }

        }

        BeiLiComboBox {
            id: commPortCombo
            visible: isEdit
            width: 120 * _widthRatio
            height: 30 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter
            function updateCommPortCombo() {
                var index
                var serialPorts = [ ]
                for (var i=0; i<QGroundControl.linkManager.serialPortStrings.length; i++) {
                    serialPorts.push(QGroundControl.linkManager.serialPortStrings[i])
                }
                if (editConfig != null) {
                    if (editConfig.portDisplayName === "" && QGroundControl.linkManager.serialPorts.length > 0) {
                        editConfig.portName = QGroundControl.linkManager.serialPorts[0]
                    }
                    index = serialPorts.indexOf(editConfig.portDisplayName)
                    if (index === -1) {
                        serialPorts.push(editConfig.portName)
                        index = serialPorts.indexOf(editConfig.portName)
                    }
                } else {
                    index = 0
                }
                commPortCombo.model = serialPorts
                commPortCombo.currentIndex = index
            }

            onActivated: {
                if (index != -1 && editConfig) {
                    if (index >= QGroundControl.linkManager.serialPortStrings.length) {
                        // This item was adding at the end, must use added text as name
                        editConfig.portName = commPortCombo.textAt(index)
                    } else {
                        editConfig.portName = QGroundControl.linkManager.serialPorts[index]
                    }
                    linkserialPortEdit.text = editConfig.portDisplayName
                }
            }
            Component.onCompleted: {
                updateCommPortCombo()
            }

            onVisibleChanged: {
                if (visible) {
                    updateCommPortCombo()
                }
            }
        }

        Text {
            id: baudRate
            text: qsTr("波特率:")
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
            id: linkbaudRateEdit
            width: 100 * _widthRatio
            height: 30 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: !isEdit ? "#08D3E5" : "#293538"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            readOnly: !isEdit
            text: linkConfig ? String(linkConfig.baud) : ""
            visible: !isEdit
            padding: 0

            background: Rectangle {
                color: linkbaudRateEdit.readOnly ? "transparent" : "white"
                radius: linkbaudRateEdit.readOnly ? 0 : 4
                border.color: linkbaudRateEdit.readOnly ? "transparent" : "#80BFE8"
                border.width: linkbaudRateEdit.readOnly ? 0 : 1
            }

        }

        BeiLiComboBox {
            id:             baudCombo
            width:          100 * _widthRatio
            height:         30 * ScreenToolsController.ratio
            visible: isEdit
            model:          QGroundControl.linkManager.serialBaudRates
            anchors.verticalCenter: parent.verticalCenter
            function updateBaud() {
                var baud = "57600"
                if(editConfig != null) {
                    baud = editConfig.baud.toString()
                }
                var index = baudCombo.find(baud)
                if (index === -1) {
                    console.warn(qsTr("Baud rate name not in combo box"), baud)
                } else {
                    baudCombo.currentIndex = index
                }
            }

            onActivated: {
                if (index != -1) {
                    editConfig.baud = parseInt(QGroundControl.linkManager.serialBaudRates[index])
                    linkbaudRateEdit.text = String(editConfig.baud)
                }
            }
            Component.onCompleted: {
                updateBaud()
            }
            onVisibleChanged: {
                if (visible) updateBaud()
            }
        }
    }
}// serialLink

