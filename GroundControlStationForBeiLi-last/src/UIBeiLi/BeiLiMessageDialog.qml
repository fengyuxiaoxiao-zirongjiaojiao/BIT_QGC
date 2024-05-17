/**************************************************
** Author      : 徐建文
** CreateTime  : 2021年7月20日 11点30分
** ModifyTime  : 2021年7月20日 11点30分
** Email       : Vincent_xjw@163.com
** Description : 消息打印窗口
***************************************************/

import QtQuick              2.3
import QtGraphicalEffects   1.0
import QtQuick.Window 2.14
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.12
import QtQuick.Dialogs  1.3

import QGroundControl   1.0
import QGroundControl.ScreenToolsController 1.0

Window {
    id: _root
    width: 400 * ScreenToolsController.ratio
    height: 160 * ScreenToolsController.ratio
    flags: Qt.FramelessWindowHint | Qt.Dialog
    modality: Qt.ApplicationModal
    x: Screen.width/2-width/2
    y: Screen.height/2-height/2
    color:                  "#07424F"
    visible:                false
    property string text
    property string title
    property int standardButtons

    signal yesClicked()
    signal noClicked()
    signal closeClicked()
    signal cancelClicked()

    function open() {
        _root.visible = true
    }
    function close() {
        _root.visible = false
    }

    Image {
        id: _upperLeft
        source: "qrc:/qmlimages/BeiLi/form_upper_left.png"
        anchors.top: parent.top
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_upper_right.png"
        anchors.top: parent.top
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_left.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_right.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Button {
        id: closeBtn
        anchors.top: parent.top
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 10
        width: 28 * ScreenToolsController.ratio
        height: 20 * ScreenToolsController.ratio

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: closeBtn.checked || closeBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : closeBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : "qrc:/qmlimages/BeiLi/icon_close_normal.png"
            width: closeBtn.width; height: closeBtn.height
        }

        onClicked:  {
            closeClicked()
            _root.visible = false
        }
    }

    Text {
        id: contextMsg
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: closeBtn.bottom
        anchors.topMargin: 20 * ScreenToolsController.ratio
        width: _root.width - 40 * ScreenToolsController.ratio
        text: _root.text
        Layout.fillWidth:       true
        font.family:            "MicrosoftYaHei"
        font.weight:            Font.Bold
        font.pixelSize:         18 * ScreenToolsController.ratio
        color:                  "#B2F9FF"
        horizontalAlignment:    Text.AlignHCenter
        wrapMode:               Text.WordWrap
        onTextChanged: {
            var curwidth = font.pixelSize * text.length + 40 * ScreenToolsController.ratio
            var minWidth = btnNo.width * 2 + 80 * ScreenToolsController.ratio
            curwidth = minWidth < curwidth ? curwidth : minWidth
            _root.width = curwidth > Screen.width * 0.4 ? Screen.width * 0.4 : curwidth
        }
    }

    Flow {
        id: btnField
        spacing: 40 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20 * ScreenToolsController.ratio
        anchors.horizontalCenter: parent.horizontalCenter

        ActionButton {
            id: btnOk
            text: qsTr("Yes")
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 20
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.horizontalCenterOffset: -parent.width/4
            visible: (_root.standardButtons & StandardButton.Yes) === StandardButton.Yes
            onClicked: {
                yesClicked()
                _root.visible = false
            }
        }

        ActionButton {
            id: btnNo
            text: qsTr("No")
//            anchors.bottom: parent.bottom
//            anchors.bottomMargin: 20
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.horizontalCenterOffset: parent.width/4
            visible: (_root.standardButtons & StandardButton.No) === StandardButton.No
            onClicked: {
                noClicked()
                _root.visible = false
            }
        }

        ActionButton {
            id: btnCancel
            text: qsTr("Cancel")
            visible: (_root.standardButtons & StandardButton.Cancel) === StandardButton.Cancel
            onClicked: {
                cancelClicked()
                _root.visible = false
            }
        }
    }

    onActiveChanged: {
        if(active == true)
        {
            btnOk.forceActiveFocus();
        }
    }
}


