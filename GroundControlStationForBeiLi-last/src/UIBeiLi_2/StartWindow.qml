import QtQuick              2.3
import QtQuick.Window 2.14
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14

import QtQuick.Controls.Styles 1.4

import QGroundControl                       1.0
import QGroundControl.ScreenToolsController 1.0
import QGroundControl.SettingsManager       1.0
import QGroundControl.UIBeiLi               1.0

ApplicationWindow {
    id: _root
    property int _borderWidth: 1
    visible: true
    width: 960 * ScreenToolsController.ratio
    height: 680 * ScreenToolsController.ratio

    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2

    flags: Qt.FramelessWindowHint | Qt.Window//Qt.CustomizeWindowHint

    color: "transparent"

    function bootApp(mode) {
        QGroundControl.settingsManager.appSettings.setBootAppMode(mode)
        QGroundControl.settingsManager.appSettings.enterApp = true
        _root.close();
    }

    Image {
        id: bg
        source: "qrc:/qmlimages/BeiLi_2/img_bg_main.png"
        anchors.fill: parent
    }

    Image {
        id: closeBtn
        property bool hovered: false
        opacity: hovered ? 0.6 : 1

        anchors.top: parent.top
        anchors.topMargin: 50 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 100 * ScreenToolsController.ratio

        source: "qrc:/qmlimages/BeiLi_2/icon_enter_close_nor.png"

        height: 30 * ScreenToolsController.ratio
        width: 36 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true
            onExited: parent.hovered = false
            onClicked: {
                _root.close()
            }
        }
    }

    Image {
        id: minBtn
        property bool hovered: false
        opacity: hovered ? 0.6 : 1

        anchors.verticalCenter: closeBtn.verticalCenter
        anchors.right: closeBtn.left
        anchors.rightMargin: 5 * ScreenToolsController.ratio
        source: "qrc:/qmlimages/BeiLi_2/icon_enter_min_nor.png"

        width: 36 * ScreenToolsController.ratio
        height: 30 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height



        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true
            onExited: parent.hovered = false
            onClicked: {
                _root.showMinimized()
                //_root.hide()
            }
        }
    }

    Image {
        id: titleBar
        source: "qrc:/qmlimages/BeiLi_2/img_bg_name.png"

        width: 800 * ScreenToolsController.ratio
        height: 80 * ScreenToolsController.ratio

        sourceSize.width: width
        sourceSize.height: height

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 120 * ScreenToolsController.ratio

        Text {
            id: titleTextField
            text: qsTr("北京理工地面站")
            anchors.centerIn: parent

            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 40 * ScreenToolsController.ratioFont

            horizontalAlignment: Text.AlignLeft

            color: "#FFFFFF"
        }
    }

    Rectangle {
        width: parent.width
        height: 310 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 150 * ScreenToolsController.ratio
        color: "transparent"
        Row {
            anchors.centerIn: parent
            spacing: 74 * ScreenToolsController.ratio
            Image {
                property bool hovered: false
                source: hovered ? "qrc:/qmlimages/BeiLi_2/img_bg_mode_sel.png" : "qrc:/qmlimages/BeiLi_2/img_bg_mode_nor.png"
                width: 366 * ScreenToolsController.ratio
                height: 306 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height

                Image {
                    source: "qrc:/qmlimages/BeiLi_2/image_mission_normal_1.png"
                    width: 100 * ScreenToolsController.ratio
                    height: 100 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: singleVehicleModeText.top
                    anchors.bottomMargin: 27 * ScreenToolsController.ratio
                }

                Text {
                    id: singleVehicleModeText
                    text: qsTr("巡检模式")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 62 * ScreenToolsController.ratio
                    anchors.horizontalCenter: parent.horizontalCenter

                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 20 * ScreenToolsController.ratioFont

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    color: "#08D3E5"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        bootApp(1)
                    }
                }
            }

            Image {
                property bool hovered: false
                source: hovered ? "qrc:/qmlimages/BeiLi_2/img_bg_mode_sel.png" : "qrc:/qmlimages/BeiLi_2/img_bg_mode_nor.png"
                width: 366 * ScreenToolsController.ratio
                height: 306 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height

                Image {
                    source: "qrc:/qmlimages/BeiLi_2/image_mission_multi_1.png"
                    width: 100 * ScreenToolsController.ratio
                    height: 100 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: multiVehicleModeText.top
                    anchors.bottomMargin: 27 * ScreenToolsController.ratio
                }

                Text {
                    id: multiVehicleModeText
                    text: qsTr("集群模式")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 62 * ScreenToolsController.ratio
                    anchors.horizontalCenter: parent.horizontalCenter

                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 20 * ScreenToolsController.ratioFont

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    color: "#08D3E5"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        bootApp(2)
                    }
                }
            }
        }
    }

    Item {
        width: 160 * ScreenToolsController.ratio
        height: 30 * ScreenToolsController.ratio

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 100 * ScreenToolsController.ratio

        Text {
            id: versionTextField
            text: qsTr("版本号：") + QGroundControl.settingsManager.appSettings.appVersion
            anchors.centerIn: parent

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.family: "MicrosoftYaHei"
            font.weight: Font.Normal
            font.pixelSize: 16 * ScreenToolsController.ratioFont
            color: "#FFFFFF"
        }
    }

    Item {
        id: developMode
        width: 160 * ScreenToolsController.ratio
        height: 30 * ScreenToolsController.ratio

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 50 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 100 * ScreenToolsController.ratio
        property bool hovered: false

        Row {
            spacing: 4 * ScreenToolsController.ratio
            anchors.centerIn: parent
            Text {
                id: section_3_titel
                text: qsTr("开发者模式")
                anchors.verticalCenter: parent.verticalCenter
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 16 * ScreenToolsController.ratioFont
                color: "#FFFFFF"

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Image {
                id: section_3_image
                anchors.verticalCenter: parent.verticalCenter
                source: developMode.hovered ? "qrc:/qmlimages/BeiLi_2/icon_enter_banned.png" : "qrc:/qmlimages/BeiLi_2/icon_enter.png"
                width: 24 * ScreenToolsController.ratio
                height: 24 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
            }
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: developMode.hovered = true
            onExited: developMode.hovered = false
            onClicked: {
                if (QGroundControl.settingsManager.appSettings.invalidPassword()) {
                    passwordBg.showSettingPassword()
                } else {
                    passwordBg.showInputPassword()
                }
            }
        }
    }


    Item {
        id: passwordBg
        anchors.fill: parent
        visible: false
        function showSettingPassword() {
            cleanEditor()
            passwordBg.visible = true
            settingPasswordView.visible = true
            inputPasswordView.visible = false
            changePasswordView.visible = false
        }
        function showInputPassword() {
            cleanEditor()
            passwordBg.visible = true
            settingPasswordView.visible = false
            changePasswordView.visible = false
            inputPasswordView.visible = true
        }
        function showChangePasswprd() {
            cleanEditor()
            passwordBg.visible = true
            settingPasswordView.visible = false
            inputPasswordView.visible = false
            changePasswordView.visible = true
        }
        function hidePasswordView() {
            passwordBg.visible = false
            settingPasswordView.visible = false
            inputPasswordView.visible = false
            changePasswordView.visible = false
        }
        function cleanEditor() {
            settingPasswordEditor.text = ""
            inputPasswordEditor.text = ""
            changePasswordEditor.text = ""
            changePasswordEditor1.text = ""
        }

        Rectangle {
            id: passwordMask
            anchors.fill: parent
            color: "transparent"
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {}
                onExited: {}
                onClicked: {}
                onPressed: {}
                onReleased: {}
            }
        }

        // 设置密码
        Rectangle {
            id: settingPasswordView
            width: 380 * ScreenToolsController.ratio
            height: 200 * ScreenToolsController.ratio
            color: "#07424F"
            border.color: "#08D3E5"
            border.width: 2
            anchors.centerIn: parent
            radius: 10 * ScreenToolsController.ratio
            visible: false

            Text {
                id: settingPasswordText
                text: qsTr("设置密码")
                anchors.top: parent.top
                anchors.topMargin: 30 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                color: "#FEFEFE"
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 16 * ScreenToolsController.ratioFont

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                id: settingPasswordInput
                anchors.top: settingPasswordText.bottom
                anchors.topMargin: 20 *ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                color: "#07424F"
                border.color: "#08D3E5"
                border.width: 1
                width: 320 * ScreenToolsController.ratio
                height: 44 * ScreenToolsController.ratio
                radius: 5 * ScreenToolsController.ratio

                Image {
                    id: settingPasswordIcon
                    source: "qrc:/qmlimages/BeiLi_2/icon_key.png"
                    width: 16 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * ScreenToolsController.ratio
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: settingPasswordEditor
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: settingPasswordIcon.right
                    anchors.right: settingPasswordEyeIcon.left
                    placeholderText: qsTr("请设置6位数字密码")
                    echoMode: TextInput.Password

                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    color: "#FFFFFF"
                    focus: true
                    selectByMouse: true
                    // 限制只能输入6位数字
                    validator: RegExpValidator{
                        regExp: /[0-9]+/
                    }
                    maximumLength: 6

                    background: Rectangle {
                        color: "transparent"
                        border.color: "transparent"
                    }
                }

                Image {
                    id: settingPasswordEyeIcon
                    property bool hovered: false
                    source: hovered ? (settingPasswordEditor.echoMode === TextInput.Password ? "qrc:/qmlimages/BeiLi_2/icon_eye_close_hovered.png" : "qrc:/qmlimages/BeiLi_2/icon_eye_open_hovered.png") : (settingPasswordEditor.echoMode === TextInput.Password ? "qrc:/qmlimages/BeiLi_2/icon_eye_close_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_eye_open_nor.png")
                    width: 17 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.right: parent.right
                    anchors.rightMargin: 10 * ScreenToolsController.ratio
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                        onClicked: {
                            if (settingPasswordEditor.echoMode === TextInput.Password) {
                                settingPasswordEditor.echoMode = TextInput.Normal
                            } else if (settingPasswordEditor.echoMode === TextInput.Normal) {
                                settingPasswordEditor.echoMode = TextInput.Password
                            }
                        }
                    }
                }
            }

            ActionButton {
                text: qsTr("确定")
                anchors.left: settingPasswordInput.left
                anchors.top: settingPasswordInput.bottom
                anchors.topMargin: 20 * ScreenToolsController.ratio
                width: 150 * ScreenToolsController.ratio
                height: 40 * ScreenToolsController.ratio
                onClicked: {
                    if (settingPasswordEditor.length < 6) {
                        settingPasswordEditor.focus = true
                        settingPasswordEditor.text = ""
                        return
                    }

                    QGroundControl.settingsManager.appSettings.setPassword(settingPasswordEditor.text)
                    passwordBg.visible = false
                }
            }

            ActionButton {
                text: qsTr("取消")
                anchors.right: settingPasswordInput.right
                anchors.top: settingPasswordInput.bottom
                anchors.topMargin: 20 * ScreenToolsController.ratio
                width: 150 * ScreenToolsController.ratio
                height: 40 * ScreenToolsController.ratio
                onClicked: {
                    passwordBg.hidePasswordView()
                }
            }

        } // settingPasswordView

        // 输入密码进入开发者模式
        Rectangle {
            id: inputPasswordView
            width: 380 * ScreenToolsController.ratio
            height: 223 * ScreenToolsController.ratio
            color: "#07424F"
            border.color: "#08D3E5"
            border.width: 2
            anchors.centerIn: parent
            radius: 10 * ScreenToolsController.ratio
            visible: false

            Text {
                id: inputPasswordText
                text: qsTr("请输入密码")
                anchors.top: parent.top
                anchors.topMargin: 30 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                color: "#FEFEFE"
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 16 * ScreenToolsController.ratioFont

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            Text {
                id: changePasswordText
                text: qsTr("修改密码")
                anchors.top: parent.top
                anchors.topMargin: 30 * ScreenToolsController.ratio
                anchors.right: parent.right
                anchors.rightMargin: 30 * ScreenToolsController.ratio
                color: "#FFFFFF"
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 14 * ScreenToolsController.ratioFont

                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onEntered: changePasswordText.color = "#FEFEFE"
                    onExited: changePasswordText.color = "#FFFFFF"
                    onClicked: passwordBg.showChangePasswprd()
                }
            }

            Rectangle {
                id: inputPasswordInput
                anchors.top: inputPasswordText.bottom
                anchors.topMargin: 20 *ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                color: "#07424F"
                border.color: "#08D3E5"
                border.width: 1
                width: 320 * ScreenToolsController.ratio
                height: 44 * ScreenToolsController.ratio
                radius: 5 * ScreenToolsController.ratio

                Image {
                    id: inputPasswordIcon
                    source: "qrc:/qmlimages/BeiLi_2/icon_key.png"
                    width: 16 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * ScreenToolsController.ratio
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: inputPasswordEditor
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: inputPasswordIcon.right
                    anchors.right: inputPasswordEyeIcon.left
                    placeholderText: qsTr("请输入密码")
                    echoMode: TextInput.Password

                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    color: "#FFFFFF"
                    focus: true
                    selectByMouse: true
                    // 限制只能输入6位数字
                    /*validator: RegExpValidator{
                        regExp: /[0-9]+/
                    }
                    maximumLength: 6*/

                    background: Rectangle {
                        color: "transparent"
                        border.color: "transparent"
                    }
                }

                Image {
                    id: inputPasswordEyeIcon
                    property bool hovered: false
                    source: hovered ? (inputPasswordEditor.echoMode === TextInput.Password ? "qrc:/qmlimages/BeiLi_2/icon_eye_close_hovered.png" : "qrc:/qmlimages/BeiLi_2/icon_eye_open_hovered.png") : (inputPasswordEditor.echoMode === TextInput.Password ? "qrc:/qmlimages/BeiLi_2/icon_eye_close_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_eye_open_nor.png")
                    width: 17 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.right: parent.right
                    anchors.rightMargin: 10 * ScreenToolsController.ratio
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                        onClicked: {
                            if (inputPasswordEditor.echoMode === TextInput.Password) {
                                inputPasswordEditor.echoMode = TextInput.Normal
                            } else if (inputPasswordEditor.echoMode === TextInput.Normal) {
                                inputPasswordEditor.echoMode = TextInput.Password
                            }
                        }
                    }
                }
            }

            Text {
                id: inputPasswordErrorText
                text: qsTr("*密码输入错误，请重新输入")
                visible: false
                anchors.left: inputPasswordInput.left
                anchors.top: inputPasswordInput.bottom
                anchors.topMargin: 10 * ScreenToolsController.ratio
                color: "#F13E4B"
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 12 * ScreenToolsController.ratioFont

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            ActionButton {
                text: qsTr("确定")
                anchors.left: inputPasswordInput.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30 * ScreenToolsController.ratio
                width: 150 * ScreenToolsController.ratio
                height: 40 * ScreenToolsController.ratio
                onClicked: {
                    inputPasswordErrorText.visible = false
                    if (inputPasswordEditor.length < 6) {
                        inputPasswordEditor.focus = true
                        inputPasswordEditor.text = ""
                        // 提示密码错误
                        inputPasswordErrorText.visible = true
                        return
                    }

                    if (QGroundControl.settingsManager.appSettings.loginDeveloper(inputPasswordEditor.text)) {
                        passwordBg.visible = false
                        // 进入开发者界面
                        bootApp(0)
                    } else {
                        // 提示密码错误
                        inputPasswordEditor.focus = true
                        inputPasswordEditor.text = ""
                        inputPasswordErrorText.visible = true
                    }

                }
            }

            ActionButton {
                text: qsTr("取消")
                anchors.right: inputPasswordInput.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30 * ScreenToolsController.ratio
                width: 150 * ScreenToolsController.ratio
                height: 40 * ScreenToolsController.ratio
                onClicked: {
                    passwordBg.hidePasswordView()
                }
            }

        } // inputPasswordView


        // 修改密码
        Rectangle {
            id: changePasswordView
            width: 380 * ScreenToolsController.ratio
            height: 263 * ScreenToolsController.ratio
            color: "#07424F"
            border.color: "#08D3E5"
            border.width: 2
            anchors.centerIn: parent
            radius: 10 * ScreenToolsController.ratio
            visible: false

            Text {
                id: changePasswordTitleText
                text: qsTr("修改密码")
                anchors.top: parent.top
                anchors.topMargin: 30 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                color: "#FEFEFE"
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 16 * ScreenToolsController.ratioFont

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                id: changePasswordInput
                anchors.top: changePasswordTitleText.bottom
                anchors.topMargin: 20 *ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                color: "#07424F"
                border.color: "#08D3E5"
                border.width: 1
                width: 320 * ScreenToolsController.ratio
                height: 44 * ScreenToolsController.ratio
                radius: 5 * ScreenToolsController.ratio

                Image {
                    id: changePasswordIcon
                    source: "qrc:/qmlimages/BeiLi_2/icon_key.png"
                    width: 16 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * ScreenToolsController.ratio
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: changePasswordEditor
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: changePasswordIcon.right
                    anchors.right: changePasswordEyeIcon.left
                    placeholderText: qsTr("请输入原始密码")
                    echoMode: TextInput.Password

                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    color: "#FFFFFF"
                    focus: true
                    selectByMouse: true
                    // 限制只能输入6位数字
                    /*validator: RegExpValidator{
                        regExp: /[0-9]+/
                    }
                    maximumLength: 6*/

                    background: Rectangle {
                        color: "transparent"
                        border.color: "transparent"
                    }
                }

                Image {
                    id: changePasswordEyeIcon
                    property bool hovered: false
                    source: hovered ? (changePasswordEditor.echoMode === TextInput.Password ? "qrc:/qmlimages/BeiLi_2/icon_eye_close_hovered.png" : "qrc:/qmlimages/BeiLi_2/icon_eye_open_hovered.png") : (changePasswordEditor.echoMode === TextInput.Password ? "qrc:/qmlimages/BeiLi_2/icon_eye_close_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_eye_open_nor.png")
                    width: 17 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.right: parent.right
                    anchors.rightMargin: 10 * ScreenToolsController.ratio
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                        onClicked: {
                            if (changePasswordEditor.echoMode === TextInput.Password) {
                                changePasswordEditor.echoMode = TextInput.Normal
                            } else if (changePasswordEditor.echoMode === TextInput.Normal) {
                                changePasswordEditor.echoMode = TextInput.Password
                            }
                        }
                    }
                }
            }

            Text {
                id: changeInputPasswordErrorText
                text: qsTr("*密码输入错误，请重新输入")
                visible: false
                anchors.left: changePasswordInput.left
                anchors.top: changePasswordInput.bottom
                anchors.topMargin: 2 * ScreenToolsController.ratio
                color: "#F13E4B"
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 12 * ScreenToolsController.ratioFont

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            Rectangle {
                id: changePasswordInput1
                anchors.top: changePasswordInput.bottom
                anchors.topMargin: 20 *ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                color: "#07424F"
                border.color: "#08D3E5"
                border.width: 1
                width: 320 * ScreenToolsController.ratio
                height: 44 * ScreenToolsController.ratio
                radius: 5 * ScreenToolsController.ratio

                Image {
                    id: changePasswordIcon1
                    source: "qrc:/qmlimages/BeiLi_2/icon_key.png"
                    width: 16 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * ScreenToolsController.ratio
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    id: changePasswordEditor1
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: changePasswordIcon1.right
                    anchors.right: changePasswordEyeIcon1.left
                    placeholderText: qsTr("请新的密码")
                    echoMode: TextInput.Password

                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    color: "#FFFFFF"
                    focus: true
                    selectByMouse: true
                    // 限制只能输入6位数字
                    validator: RegExpValidator{
                        regExp: /[0-9]+/
                    }
                    maximumLength: 6

                    background: Rectangle {
                        color: "transparent"
                        border.color: "transparent"
                    }
                }

                Image {
                    id: changePasswordEyeIcon1
                    property bool hovered: false
                    source: hovered ? (changePasswordEditor1.echoMode === TextInput.Password ? "qrc:/qmlimages/BeiLi_2/icon_eye_close_hovered.png" : "qrc:/qmlimages/BeiLi_2/icon_eye_open_hovered.png") : (changePasswordEditor1.echoMode === TextInput.Password ? "qrc:/qmlimages/BeiLi_2/icon_eye_close_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_eye_open_nor.png")
                    width: 17 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    sourceSize.width: width
                    sourceSize.height: height
                    anchors.right: parent.right
                    anchors.rightMargin: 10 * ScreenToolsController.ratio
                    anchors.verticalCenter: parent.verticalCenter
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                        onClicked: {
                            if (changePasswordEditor1.echoMode === TextInput.Password) {
                                changePasswordEditor1.echoMode = TextInput.Normal
                            } else if (changePasswordEditor1.echoMode === TextInput.Normal) {
                                changePasswordEditor1.echoMode = TextInput.Password
                            }
                        }
                    }
                }
            }

            Text {
                id: changeInputPasswordErrorText1
                text: qsTr("*输入错误，请重新输入6位数字密码")
                visible: false
                anchors.left: changePasswordInput1.left
                anchors.top: changePasswordInput1.bottom
                anchors.topMargin: 2 * ScreenToolsController.ratio
                color: "#F13E4B"
                font.family: "MicrosoftYaHei"
                font.weight: Font.Normal
                font.pixelSize: 12 * ScreenToolsController.ratioFont

                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            ActionButton {
                text: qsTr("确定")
                anchors.left: changePasswordInput.left
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30 * ScreenToolsController.ratio
                width: 150 * ScreenToolsController.ratio
                height: 40 * ScreenToolsController.ratio
                onClicked: {
                    changeInputPasswordErrorText.visible = false
                    changeInputPasswordErrorText1.visible = false
                    if (changePasswordEditor.length < 6) {
                        changePasswordEditor.focus = true
                        changePasswordEditor.text = ""
                        changeInputPasswordErrorText.visible = true
                        return
                    }
                    if (changePasswordEditor1.length < 6) {
                        changePasswordEditor1.focus = true
                        changePasswordEditor1.text = ""
                        changeInputPasswordErrorText1.visible = true
                        return
                    }

                    if (QGroundControl.settingsManager.appSettings.changePassword(changePasswordEditor.text, changePasswordEditor1.text)) {
                        // 修改成功
                        passwordBg.hidePasswordView()
                    } else {
                        changePasswordEditor.focus = true
                        changePasswordEditor.text = ""
                        changeInputPasswordErrorText.visible = true
                    }
                }
            }

            ActionButton {
                text: qsTr("取消")
                anchors.right: changePasswordInput.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30 * ScreenToolsController.ratio
                width: 150 * ScreenToolsController.ratio
                height: 40 * ScreenToolsController.ratio
                onClicked: {
                    passwordBg.hidePasswordView()
                }
            }

        } // 修改密码

    }

}
