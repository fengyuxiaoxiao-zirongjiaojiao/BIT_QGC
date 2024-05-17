import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QGroundControl               1.0
import QGroundControl.HttpAPIManager 1.0
import QtGraphicalEffects 1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootLoginView
    signal showWebView()

    Rectangle {
        id: mask
        color: "#000000"
        opacity: 0.6
        anchors.fill: parent
    }

    MouseArea{
        anchors.fill: parent;
        onClicked: {}

        onPressed: {}

        onReleased: {}
    }

    Rectangle {
        id: bg
        color: "#07424F"
        radius: 8 * ScreenToolsController.ratio
        anchors.centerIn: parent
        width: 342 * ScreenToolsController.ratio
        height: 364 * ScreenToolsController.ratio

        Rectangle {
            id: loginItem
            anchors.fill: parent
            color: "transparent"
            visible: !QGroundControl.httpAPIManager.getUserManager().isLogin

            Text {
                id: titleText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 50 * ScreenToolsController.ratio
                text: qsTr("地面站系统登录")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 22 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }

            // 用户名
            Image {
                id: userIcon
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                anchors.top: titleText.bottom
                anchors.topMargin: 48 * ScreenToolsController.ratio
                source: "qrc:/qmlimages/BeiLi/login_icon_user.png"
            }
            Text {
                id: userTitle
                text: qsTr("用户名")
                anchors.left: userIcon.right
                anchors.leftMargin: 8 * ScreenToolsController.ratio
                anchors.verticalCenter: userIcon.verticalCenter
                //height: 30
                //verticalAlignment: Text.AlignVCenter
                //horizontalAlignment: Text.AlignHCenter
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 18 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }

            BeiLiComboBox {
                id:             userComboBox
                //width:          179 * ScreenToolsController.ratio
                height:         30 * ScreenToolsController.ratio
                anchors.left: userTitle.right
                anchors.leftMargin: 8
                anchors.right: parent.right
                anchors.rightMargin: 30 * ScreenToolsController.ratio
                anchors.verticalCenter: userTitle.verticalCenter
                editable: true
                alternateText: qsTr("请输入账号")

                model:          QGroundControl.httpAPIManager.getUserManager().accountList
                function updateComboBox() {
                    userComboBox.currentIndex = 0
                }

                onActivated: {
                    if (index != -1) {
                        var pwd = QGroundControl.httpAPIManager.getUserManager().getPasswd(userComboBox.currentText)
                        pwdText.text = pwd
                        rememberPwdCheckBox.checked = true
                        //console.log("pwd", userComboBox.currentText, pwd)
                    }
                }
                Component.onCompleted: {
                    updateComboBox()
                }
            }

            // 密码
            Image {
                id: pwdIcon
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                anchors.top: userIcon.bottom
                anchors.topMargin: 44 * ScreenToolsController.ratio
                source: "qrc:/qmlimages/BeiLi/login_icon_key.png"
            }
            Text {
                id: pwdTitle
                text: qsTr("密  码")
                anchors.left: pwdIcon.right
                anchors.leftMargin: 8 * ScreenToolsController.ratio
                anchors.verticalCenter: pwdIcon.verticalCenter
                //height: 30
                //verticalAlignment: Text.AlignVCenter
                //horizontalAlignment: Text.AlignHCenter
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 18 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }
            TextField {
                id: pwdText
                //width: 179 * ScreenToolsController.ratio
                height: 30 * ScreenToolsController.ratio
                anchors.left: pwdTitle.right
                anchors.leftMargin: 8 * ScreenToolsController.ratio
                anchors.verticalCenter: pwdTitle.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 30 * ScreenToolsController.ratio
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 14 * ScreenToolsController.ratio
                color: "#293538"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                focus: true
                selectByMouse: true
                echoMode: TextField.Password
                placeholderText: qsTr("请输入密码")

                background: Rectangle {
                    radius: 4 * ScreenToolsController.ratio
                    border.color: "#80BFE8"
                    border.width: 1
                }
            }

            CheckBox {
                id: rememberPwdCheckBox
                anchors.left: parent.left
                anchors.leftMargin: 30 * ScreenToolsController.ratio
                anchors.top: pwdIcon.bottom
                anchors.topMargin: 37 * ScreenToolsController.ratio
                text: qsTr("记住密码")
                width: 100 * ScreenToolsController.ratio
                height: 30 * ScreenToolsController.ratio
                checked: QGroundControl.httpAPIManager.getUserManager().rememberPassword
                onCheckedChanged: {
                    QGroundControl.httpAPIManager.getUserManager().rememberPassword = checked
                }

                indicator: Rectangle {
                    id: indicatorRec
                    anchors.left: rememberPwdCheckBox.left
                    anchors.top: rememberPwdCheckBox.top
                    width: 12 * ScreenToolsController.ratio
                    height: 12 * ScreenToolsController.ratio
                    color: "transparent"
                    Image {
                        id: name
                        source: rememberPwdCheckBox.checked ? "qrc:/qmlimages/BeiLi/login_icon_remembered_checked.png" : "qrc:/qmlimages/BeiLi/login_icon_remembered.png"
                    }
                }


                contentItem: Text {
                    anchors.verticalCenter: indicatorRec.verticalCenter
                    anchors.left: indicatorRec.right
                    anchors.leftMargin: 8 * ScreenToolsController.ratio
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 18 * ScreenToolsController.ratio
                    color: "#08D3E5"
                    text: rememberPwdCheckBox.text
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }
            }

            Button {
                id: jumpToWebBtn
                text: qsTr("跳转WEB端")
                width: 100 * ScreenToolsController.ratio
                height: 30 * ScreenToolsController.ratio
                anchors.right: parent.right
                anchors.rightMargin: 30 * ScreenToolsController.ratio
                anchors.top: parent.top
                anchors.topMargin: 224 * ScreenToolsController.ratio
                padding: 0
                background: Rectangle {
                    color: "transparent"
                    ToolSeparator {
                        id: toolSeparator
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        orientation: Qt.Horizontal
                        contentItem: Rectangle {
                            implicitWidth: jumpToWebBtn.width
                            implicitHeight: 1
                            color: jumpToWebBtn.hovered ? "#B2F9FF" : "#08D3E5"
                        }
                    }
                }
                contentItem: Text {
                    text: jumpToWebBtn.text
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 18 * ScreenToolsController.ratio
                    color: jumpToWebBtn.hovered ? "#B2F9FF" : "#08D3E5"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onClicked: {
                    showWebView()
                }
            }

            Button {
                id: loginBtn
                text: qsTr("登录")
                anchors.left: parent.left
                anchors.leftMargin: 48 * ScreenToolsController.ratio
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 50 * ScreenToolsController.ratio
                width: 246 * ScreenToolsController.ratio
                height: 38 * ScreenToolsController.ratio
                background: Rectangle {
                    color: "transparent"
                }
                BorderImage {
                    width: loginBtn.width
                    height: loginBtn.height
                    source: loginBtn.pressed ? "qrc:/qmlimages/BeiLi/login_btn_checked.png" : loginBtn.hovered ? "qrc:/qmlimages/BeiLi/login_btn_hovered.png" : "qrc:/qmlimages/BeiLi/login_btn_normal.png"
                }

                contentItem: Text {
                    text: loginBtn.text
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 18 * ScreenToolsController.ratio
                    color: "#08D3E5"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onClicked: {
                    QGroundControl.httpAPIManager.getUserManager().login(userComboBox.fieldText, pwdText.text)
                    _rootLoginView.visible = !QGroundControl.httpAPIManager.getUserManager().isLogin
                }
            }
        } // loginItem

        Rectangle {
            id: logoutItem
            anchors.fill: parent
            color: "transparent"
            visible: QGroundControl.httpAPIManager.getUserManager().isLogin

            Column {
                spacing: 20 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.topMargin: 30 * ScreenToolsController.ratio
                Rectangle {
                    color: "transparent"
                    width: 80 * ScreenToolsController.ratio
                    height: 80 * ScreenToolsController.ratio
                    anchors.horizontalCenter: parent.horizontalCenter

                    Image {
                        id: personHead
                        source: QGroundControl.httpAPIManager.getUserManager().isLogin ? (QGroundControl.httpAPIManager.getUserManager().getAvatar() ? QGroundControl.httpAPIManager.getUserManager().getAvatar() : "qrc:/qmlimages/BeiLi/img_authorized_avatar.png") : "qrc:/qmlimages/BeiLi/img_unauthorized_avatar.png"
                        anchors.centerIn: parent
                        visible: false
                        width: parent.width
                        height: parent.height
                        sourceSize.width: width
                        sourceSize.height: height
                    }
                    Image {
                        id: headMask
                        source: "qrc:/qmlimages/BeiLi/mask_avatar.png"
                        anchors.fill: parent
                        visible: false
                        width: 80 * ScreenToolsController.ratio
                        height: 80 * ScreenToolsController.ratio
                        sourceSize.width: width
                        sourceSize.height: height
                    }
                    OpacityMask {
                        id:om
                        anchors.fill: parent
                        source: personHead
                        maskSource: headMask
                    }
                    Image {
                        source: "qrc:/qmlimages/BeiLi/img_authorized_outside.png"
                        anchors.fill: parent
                        width: 80 * ScreenToolsController.ratio
                        height: 80 * ScreenToolsController.ratio
                        sourceSize.width: width
                        sourceSize.height: height
                    }
                }

                Text {
                    id: userName
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: QGroundControl.httpAPIManager.getUserManager().isLogin ? QGroundControl.httpAPIManager.getUserManager().userName : ""
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 22 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }

                Text {
                    id: userSerialNumber
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: QGroundControl.httpAPIManager.getUserManager().isLogin ? QGroundControl.httpAPIManager.getUserManager().serialNumber : ""
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }

                Text {
                    id: userDescription
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: QGroundControl.httpAPIManager.getUserManager().isLogin ? QGroundControl.httpAPIManager.getUserManager().description : ""
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }

            }

            Button {
                id: logoutBtn
                text: qsTr("退出登录")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: jumpToWebBtn2.top
                anchors.bottomMargin: 20 * ScreenToolsController.ratio
                width: 246 * ScreenToolsController.ratio
                height: 38 * ScreenToolsController.ratio
                background: Rectangle {
                    color: "transparent"
                }
                BorderImage {
                    width: logoutBtn.width
                    height: logoutBtn.height
                    source: logoutBtn.pressed ? "qrc:/qmlimages/BeiLi/login_btn_checked.png" : logoutBtn.hovered ? "qrc:/qmlimages/BeiLi/login_btn_hovered.png" : "qrc:/qmlimages/BeiLi/login_btn_normal.png"
                }

                contentItem: Text {
                    text: logoutBtn.text
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 18 * ScreenToolsController.ratio
                    color: "#08D3E5"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onClicked: {
                    // 如果云连接中有飞机未断开连接则会提示
                    if (QGroundControl.httpAPIManager.getUAVInfoManager().haveCloundLinked()) {
                        mainWindow.showMessageForLogoutDialog(qsTr("退出登录"), qsTr("退出登录将断开云连接所连接的飞机，你确认要退出登录吗？"))
                    } else {
                        QGroundControl.httpAPIManager.getUserManager().logout()
                    }
                }
            }

            Button {
                id: jumpToWebBtn2
                text: qsTr("跳转WEB端")
                width: 100 * ScreenToolsController.ratio
                height: 30 * ScreenToolsController.ratio
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30 * ScreenToolsController.ratio
                padding: 0
                background: Rectangle {
                    color: "transparent"
                    ToolSeparator {
                        id: toolSeparator2
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        orientation: Qt.Horizontal
                        contentItem: Rectangle {
                            implicitWidth: jumpToWebBtn2.width
                            implicitHeight: 1
                            color: jumpToWebBtn2.hovered ? "#B2F9FF" : "#08D3E5"
                        }
                    }
                }
                contentItem: Text {
                    text: jumpToWebBtn2.text
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 18 * ScreenToolsController.ratio
                    color: jumpToWebBtn2.hovered ? "#B2F9FF" : "#08D3E5"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                onClicked: {
                    showWebView()
                }
            }
        } // logoutItem

    }

    Button {
        anchors.top: bg.bottom
        anchors.topMargin: 30 * ScreenToolsController.ratio
        anchors.horizontalCenter: bg.horizontalCenter
        width: 36 * ScreenToolsController.ratio
        height: 36 * ScreenToolsController.ratio
        background: Rectangle {
            color: "transparent"
        }

        BorderImage {
            source: "qrc:/qmlimages/BeiLi/route_icon_close.png"
            width: parent.width; height: parent.height
        }

        onClicked: _rootLoginView.visible = false
    }

}

