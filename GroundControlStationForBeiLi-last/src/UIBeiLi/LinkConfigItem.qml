import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14
import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: root
    property var customWidth: 428
    property real _widthRatio: (customWidth * ScreenToolsController.ratio) / 428

    property bool isEdit: false
    property bool isAdd: false
    property var text: linkconfigure ? linkconfigure.name : ""
    property var linkconfigure: undefined
    property bool isLinked: linkconfigure ? linkconfigure.isLinked : false

    property var linkConfig: linkconfigure
    property var editConfig: null

    property bool checked: false
    property ExclusiveGroup exclusiveGroup: null //对外开放一个ExclusiveGroup接口，用于绑定同个组

    property int connectCount: QGroundControl.multiVehicleManager.vehicles.count
    property bool enableLink: (QGroundControl.settingsManager.appSettings.bootAppMode === 1) ? (linkConfig && (connectCount===0 || isLinked)) : linkConfig

    onExclusiveGroupChanged: {
        if (exclusiveGroup) {
            exclusiveGroup.bindCheckable(root)
        }
    }

    onCheckedChanged: {
        if (!checked && isEdit && !isAdd) {
            isEdit = false
            editLinkBtn.checked = false
        }

        if (isAdd) {
            linkConfig = null
            linkconfigure = null
            editConfig = null
            isEdit = true
            createConfig()
        }
    }

    visible:                    linkconfigure ? !linkconfigure.dynamic : true
    width: customWidth * _widthRatio
    height: {
        if (checked) {
            if (udpSettings.visible) {
                if (isAdd) return 110 * ScreenToolsController.ratio + udpSettings.height
                else if (isEdit) return 160 * ScreenToolsController.ratio + udpSettings.height
                else return 132 * ScreenToolsController.ratio + udpSettings.height
            } else {
                if (isAdd) return 132 * ScreenToolsController.ratio
                else return 194 * ScreenToolsController.ratio
            }
        } else {
            return 64 * ScreenToolsController.ratio
        }
    }

    function createConfig() {
        // Create new link configuration
        if(true/*ScreenTools.isSerialAvailable*/) {
            editConfig = QGroundControl.linkManager.createConfiguration(LinkConfiguration.TypeSerial, "Unnamed")
        } else {
            editConfig = QGroundControl.linkManager.createConfiguration(LinkConfiguration.TypeUdp,    "Unnamed")
        }
        serialSettings.updateSerialSettings()
        tcpSettings.updateTcpSettings()
        udpSettings.updateUdpSettings()
        logReplaySettings.updateLogReplaySettings()
    }

    onIsEditChanged: {
        if (isEdit) {
            // If editing, create copy for editing
            if(linkConfig) {
                editConfig = QGroundControl.linkManager.startConfigurationEditing(linkConfig)
            } else {
                createConfig()
            }
        } else {
            if(editConfig) {
                QGroundControl.linkManager.cancelConfigurationEditing(editConfig)
                editConfig = null
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#003b4b"
        radius: 8 * ScreenToolsController.ratio
        border.width: 1
        border.color: "#0AC9DA"

        Rectangle {
            id: titleRect
            anchors.left: parent.left
            anchors.top: parent.top
            width: parent.width
            height: 64 * ScreenToolsController.ratio
            color: checked ? "#0F6878" : "transparent"
            radius: 8 * ScreenToolsController.ratio
            border.width: 1
            border.color: "#0AC9DA"
            visible: {
                if (root.checked && isAdd) return false
                else return true
            }
            Image {
                id: bg
                property bool hovered: false
                anchors.fill: parent
                visible: !checked
                source: bg.hovered ? "qrc:/qmlimages/BeiLi/link_btn_hovered.png" : "qrc:/qmlimages/BeiLi/link_btn_normal.png"
                width: parent.width
                height: parent.height
                sourceSize.width: width
                sourceSize.height: height
            }

            Image {
                id: titleIcon
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20 * _widthRatio
                source: "qrc:/qmlimages/BeiLi/link_img_uav.png"
                visible: !isAdd
                width: 20 * ScreenToolsController.ratio
                height: 20 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
            }

            Image {
                id: addIcon
                anchors.centerIn: parent
                visible: isAdd
                source: "qrc:/qmlimages/BeiLi/link_icon_add.png"
                width: 24 * ScreenToolsController.ratio
                height: 24 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
            }

            Text {
                text: root.text
                anchors.left: titleIcon.right
                anchors.leftMargin: 10 * _widthRatio
                anchors.verticalCenter: parent.verticalCenter
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratio
                color: "#B2F9FF"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
                visible: !isAdd
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: bg.hovered = true
                onExited: bg.hovered = false
                onClicked: {
                    root.checked = !root.checked
                }
            }

            Button {
                id: linkBtn
                width: 25 * ScreenToolsController.ratio
                height: 25 * ScreenToolsController.ratio
                anchors.right: editLinkBtn.left
                anchors.rightMargin: 20 * _widthRatio
                anchors.verticalCenter: parent.verticalCenter
                enabled: enableLink
                visible: !isAdd
                background: Rectangle {
                    color: "transparent"
                }

                BorderImage {
                    id: name
                    source: {
                        if (isLinked) {
                            return !linkBtn.enabled ? "qrc:/qmlimages/BeiLi/link_icon_link_disabled.png" : linkBtn.hovered ? "qrc:/qmlimages/BeiLi/link_icon_link_hovered.png" : "qrc:/qmlimages/BeiLi/link_icon_link_normal.png"
                        } else {
                            return !linkBtn.enabled ? "qrc:/qmlimages/BeiLi/link_icon_unlink_disabled.png" : linkBtn.hovered ? "qrc:/qmlimages/BeiLi/link_icon_unlink_hovered.png" : "qrc:/qmlimages/BeiLi/link_icon_unlink_normal.png"
                        }
                    }
                    width: linkBtn.width; height: linkBtn.height
                }

                onClicked: {
                    if (isLinked) {
                        linkConfig.link.disconnect()
                    } else{
                        QGroundControl.linkManager.createConnectedLink(linkConfig)
                    }
                }
            }

            Button {
                id: editLinkBtn
                width: 25 * ScreenToolsController.ratio
                height: 25 * ScreenToolsController.ratio
                checkable: true
                anchors.right: deleteLinkBtn.left
                anchors.rightMargin: 20 * _widthRatio
                anchors.verticalCenter: parent.verticalCenter
                enabled:  !isLinked
                visible: !isAdd
                background: Rectangle {
                    color: "transparent"
                }

                BorderImage {
                    source: !editLinkBtn.enabled ? "qrc:/qmlimages/BeiLi/link_icon_edited_disabled.png" : (editLinkBtn.hovered || editLinkBtn.checked ? "qrc:/qmlimages/BeiLi/link_icon_edited_hovered.png" : "qrc:/qmlimages/BeiLi/link_icon_edited_normal.png")
                    width: editLinkBtn.width; height: editLinkBtn.height
                }

                onCheckedChanged: {
                    root.isEdit = editLinkBtn.checked
                    if (editLinkBtn.checked) root.checked = true
                }
            }

            Button {
                id: deleteLinkBtn
                width: 25 * ScreenToolsController.ratio
                height: 25 * ScreenToolsController.ratio
                anchors.right: parent.right
                anchors.rightMargin: 20 * _widthRatio
                anchors.verticalCenter: parent.verticalCenter
                enabled: !isLinked && linkConfig && !linkConfig.dynamic
                visible: !isAdd
                background: Rectangle {
                    color: "transparent"
                }

                BorderImage {
                    source: !deleteLinkBtn.enabled ? "qrc:/qmlimages/BeiLi/link_icon_delete_disabled.png" : (deleteLinkBtn.hovered ? "qrc:/qmlimages/BeiLi/link_icon_delete_hovered.png" : "qrc:/qmlimages/BeiLi/link_icon_delete_normal.png")
                    width: deleteLinkBtn.width; height: deleteLinkBtn.height
                }

                onClicked: {
                    if (linkConfig) {
                        QGroundControl.linkManager.removeConfiguration(linkConfig)
                    }
                }
            }
        }

        Rectangle {
            anchors.top: titleRect.bottom
            anchors.topMargin: -6  * ScreenToolsController.ratio
            anchors.left: parent.left
            anchors.leftMargin: 1
            anchors.right: parent.right
            anchors.rightMargin: 1
            height: 6 * ScreenToolsController.ratio
            color: "#003b4b"
            visible: root.checked && !isAdd
        }

        Rectangle {
            anchors.top: isAdd ? parent.top : titleRect.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            visible: checked
            color: "transparent"

            Text {
                id: linkName
                text: qsTr("名称:")
                anchors.top: parent.top
                anchors.topMargin:20 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 20 * ScreenToolsController.ratio
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 14 * ScreenToolsController.ratio
                color: "#08D3E5"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            TextField {
                id: nameField
                width: 190 * _widthRatio
                height: 30 * ScreenToolsController.ratio
                anchors.left: linkName.right
                anchors.leftMargin: 8 * _widthRatio
                anchors.verticalCenter: linkName.verticalCenter
                text: {
                    var config = isEdit ? editConfig : linkConfig
                    return config ? config.name : ""
                }
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 14 * ScreenToolsController.ratio
                color: !isEdit ? "#08D3E5" : "#293538"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                focus: true
                selectByMouse: true
                readOnly: !isEdit
                padding: 0

                background: Rectangle {
                    color: nameField.readOnly ? "transparent" : "white"
                    radius: nameField.readOnly ? 0 : 4
                    border.color: nameField.readOnly ? "transparent" : "#80BFE8"
                    border.width: nameField.readOnly ? 0 : 1
                }

            }

            Text {
                id: linkType
                text: qsTr("类型:")
                anchors.left:  nameField.right
                anchors.leftMargin: 10 * _widthRatio
                anchors.verticalCenter: linkName.verticalCenter
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 14 * ScreenToolsController.ratio
                color: "#08D3E5"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            TextField {
                id: linkTypeEdit
                width: 70 * _widthRatio
                height: 30 * ScreenToolsController.ratio
                anchors.left: linkType.right
                anchors.leftMargin: 8 * _widthRatio
                anchors.verticalCenter: linkType.verticalCenter
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 14 * ScreenToolsController.ratio
                color: linkTypeEdit.readOnly ? "#08D3E5" : "#293538"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                focus: true
                selectByMouse: true
                readOnly: true
                text: linkConfig ? QGroundControl.linkManager.linkTypeStrings[linkConfig.linkType] : editConfig ? QGroundControl.linkManager.linkTypeStrings[editConfig.linkType] : ""
                visible: !isEdit || !isAdd
                padding: 0

                background: Rectangle {
                    color: linkTypeEdit.readOnly ? "transparent" : "white"
                    radius: linkTypeEdit.readOnly ? 0 : 4
                    border.color: linkTypeEdit.readOnly ? "transparent" : "#80BFE8"
                    border.width: linkTypeEdit.readOnly ? 0 : 1
                }

            }

            BeiLiComboBox {
                id:             linkTypeCombo
                width:          70 * _widthRatio
                height:         30 * ScreenToolsController.ratio
                visible:        isAdd
                model:          QGroundControl.linkManager.linkTypeStrings
                //anchors.verticalCenter: parent.verticalCenter
                anchors.left: linkType.right
                anchors.leftMargin: 8 * _widthRatio
                anchors.verticalCenter: linkType.verticalCenter
                function updateTypeCombo() {
                    if(linkConfig == null) {
                        linkTypeCombo.currentIndex = 0
                        //linkSettingLoader.source   = editConfig.settingsURL
                        //linkSettingLoader.visible  = true
                    }
                }

                onActivated: {
                    console.log("linkTypeCombo", index)
                    if (index != -1 && editConfig && index !== editConfig.linkType) {
                        // Destroy current panel
                        //linkSettingLoader.source = ""
                        //linkSettingLoader.visible = false
                        // Save current name
                        var name = nameField.text
                        // Discard link configuration (old type)
                        QGroundControl.linkManager.cancelConfigurationEditing(editConfig)
                        // Create new link configuration
                        editConfig = QGroundControl.linkManager.createConfiguration(index, name)
                        // Load appropriate configuration panel
                        //linkSettingLoader.source  = editConfig.settingsURL
                        //linkSettingLoader.visible = true
                        serialSettings.updateSerialSettings()
                        tcpSettings.updateTcpSettings()
                        udpSettings.updateUdpSettings()
                        logReplaySettings.updateLogReplaySettings()
                    }
                }
                Component.onCompleted: {
                    updateTypeCombo()
                }
                onVisibleChanged: {
                    if (visible) updateTypeCombo()
                }
            }

            BeiLiSerialSettings {
                id: serialSettings
                anchors.top: linkName.bottom
                anchors.topMargin: 20 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 20 * _widthRatio
                isEdit: root.isEdit
                visible: updateSerialSettings()
                function updateSerialSettings() {
                    var v = linkConfig ? linkConfig.linkType === LinkConfiguration.TypeSerial : (editConfig ? editConfig.linkType === LinkConfiguration.TypeSerial : false)
                    serialSettings.visible = v
                    return v
                }
            }

            BeiLiTcpSettings {
                id: tcpSettings
                anchors.top: linkName.bottom
                anchors.topMargin: 20 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 20 * _widthRatio
                isEdit: root.isEdit
                visible: updateTcpSettings()
                function updateTcpSettings() {
                    var v = linkConfig ? linkConfig.linkType === LinkConfiguration.TypeTcp : (editConfig ? editConfig.linkType === LinkConfiguration.TypeTcp : false)
                    tcpSettings.visible = v
                    return v
                }
            }

            BeiLiUdpSettings {
                id: udpSettings
                anchors.top: linkName.bottom
                anchors.topMargin: 20 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 20 * _widthRatio
                isEdit: root.isEdit
                visible: updateUdpSettings()
                function updateUdpSettings() {
                    var v = linkConfig ? linkConfig.linkType === LinkConfiguration.TypeUdp : (editConfig ? editConfig.linkType === LinkConfiguration.TypeUdp : false)
                    udpSettings.visible = v
                    return v
                }
            }

            BeiLiLogReplaySettings {
                id: logReplaySettings
                anchors.top: linkName.bottom
                anchors.topMargin: 20 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 20 * _widthRatio
                isEdit: root.isEdit
                visible: updateLogReplaySettings()
                function updateLogReplaySettings() {
                    var v = linkConfig ? linkConfig.linkType === LinkConfiguration.TypeLogReplay : (editConfig ? editConfig.linkType === LinkConfiguration.TypeLogReplay : false)
                    logReplaySettings.visible = v
                    return v
                }
            }

            CheckBox {
                id: autoconnectCheckBox
                anchors.left: parent.left
                anchors.leftMargin: 20 * _widthRatio
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10 * ScreenToolsController.ratio
                text: qsTr("自动连接")
                height: 20 * ScreenToolsController.ratio
                checkable: true
                checked:   {
                    var config = isEdit ? editConfig : linkConfig
                    return config ? config.autoConnect : false
                }
                enabled: isEdit
                onCheckedChanged: {
                    if(editConfig) {
                        editConfig.autoConnect = checked
                    }
                }
                Component.onCompleted: {
                    if(linkConfig)
                        checked = linkConfig.autoConnect
                }
                indicator: Rectangle {
                    id: indicatorRec
                    anchors.left: autoconnectCheckBox.left
                    anchors.verticalCenter: autoconnectCheckBox.verticalCenter
                    width: 12  * ScreenToolsController.ratio
                    height: 12 * ScreenToolsController.ratio
                    color: "transparent"
                    Image {
                        source: autoconnectCheckBox.checked ? "qrc:/qmlimages/BeiLi/login_icon_remembered_checked.png" : "qrc:/qmlimages/BeiLi/login_icon_remembered.png"
                    }
                }


                contentItem: Text {
                    anchors.verticalCenter: indicatorRec.verticalCenter
                    anchors.left: indicatorRec.right
                    anchors.leftMargin: 8 * ScreenToolsController.ratio
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    color: "#08D3E5"
                    text: autoconnectCheckBox.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: 20 * _widthRatio
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10 * ScreenToolsController.ratio
                spacing: 6 * ScreenToolsController.ratio
                Button {
                    id: saveLinkBtn
                    text: qsTr("保存")
                    width: 50 * _widthRatio
                    height: 30 * ScreenToolsController.ratio
                    visible: isEdit
                    padding: 1
                    background: Rectangle {
                        color: "#25F085"
                        radius: 4 * ScreenToolsController.ratio
                    }

                    contentItem: Text {
                        text: saveLinkBtn.text
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    onClicked: {
                        // Save editting
                        editConfig.name = nameField.text
                        if(linkConfig) {
                            if (linkConfig.linkType === LinkConfiguration.TypeTcp) {
                                tcpSettings.saveSettings()
                            }

                            QGroundControl.linkManager.endConfigurationEditing(linkConfig, editConfig)
                        } else {
                            if (editConfig.linkType === LinkConfiguration.TypeTcp) {
                                tcpSettings.saveSettings()
                            }
                            // If it was edited, it's no longer "dynamic"
                            editConfig.dynamic = false
                            QGroundControl.linkManager.endCreateConfiguration(editConfig)
                        }
                        editConfig = null
                        editLinkBtn.checked = false

                        if (isAdd) {
                            root.checked = false
                            editConfig = null
                            linkconfigure = null
                            linkConfig = null
                        }
                    }
                }
                Button {
                    id: cancelBtn
                    text: qsTr("取消")
                    width: 50 * _widthRatio
                    height: 30 * ScreenToolsController.ratio
                    visible: isEdit
                    padding: 1
                    background: Rectangle {
                        color: "#25F085"
                        radius: 4 * ScreenToolsController.ratio
                    }

                    contentItem: Text {
                        text: cancelBtn.text
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    onClicked: {
                        QGroundControl.linkManager.cancelConfigurationEditing(editConfig)
                        if (isAdd) {
                            root.checked = false
                            editConfig = null
                            linkconfigure = null
                            linkConfig = null
                        } else {
                            editLinkBtn.checked = false
                            isEdit = false
                        }
                    }
                }
            }
        }
    }



}
