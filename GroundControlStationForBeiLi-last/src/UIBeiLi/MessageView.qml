import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import QGroundControl                       1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.ControlCenterManager  1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: root
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property int smallHeight: 186 * ScreenToolsController.ratio
    property int largeHeight: 500 * ScreenToolsController.ratio
    property bool isExpand: false
    property var controlCenterMsg: QGroundControl.controlCenterManager.messageList
    width: 472 * ScreenToolsController.ratio
    height: smallHeight

    function formatMessage(message) {
        //message = message.replace(new RegExp("<#E>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
        //message = message.replace(new RegExp("<#I>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
        //message = message.replace(new RegExp("<#N>", "g"), "color: " + qgcPal.text + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
        message = message.replace(new RegExp("<#E>", "g"), "color: #e75d27"  + "; font: " + (14 * ScreenToolsController.ratio) + "px monospace;"); // error
        message = message.replace(new RegExp("<#I>", "g"), "color: #00ff00"  + "; font: " + (14 * ScreenToolsController.ratio) + "px monospace;"); // info
        message = message.replace(new RegExp("<#N>", "g"), "color: #ffffff"  + "; font: " + (14 * ScreenToolsController.ratio) + "px monospace;"); // notice
        return message;
    }

    Component.onCompleted: {
        if (_activeVehicle) {
            uavMessageText.text = formatMessage(_activeVehicle.formattedMessages)
            //-- Hack to scroll to last message
            for (var i = 0; i < _activeVehicle.messageCount; i++)
                uavMessageFlick.flick(0,-5000)
        }
    }

    Connections {
        target: _activeVehicle
        onNewFormattedMessage :{
            uavMessageText.append(formatMessage(formattedMessage))
            //-- Hack to scroll down
            uavMessageFlick.flick(0,-500)

            if (root.visible) {
                //console.log("onNewFormattedMessage", _activeVehicle.newMessageCount)
                _activeVehicle.resetMessages()
            }
        }
    }

    Connections {
        target: QGroundControl.multiVehicleManager
        onActiveVehicleChanged: {
            if (_activeVehicle) {
                uavMessageText.clear()
                //console.log("onActiveVehicleChanged", uavMessageText.length)
                uavMessageText.text = formatMessage(_activeVehicle.formattedMessages)
                //-- Hack to scroll to last message
                for (var i = 0; i < _activeVehicle.messageCount; i++)
                    uavMessageFlick.flick(0,-5000)
            }
        }
    }

    onVisibleChanged: {
        if (root.visible && _activeVehicle) {
            //console.log("onVisibleChanged", _activeVehicle.newMessageCount)
            _activeVehicle.resetMessages()
        }
    }

    onIsExpandChanged: {
        if (isExpand) {
            height = largeHeight
        } else {
            height = smallHeight
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {}
        onWheel: {}
    }

    Rectangle {
        id: contenxtView
        anchors.fill: parent
        color: "#146574"
        opacity: 0.8

        Button {
            id: closeBtn
            width: 58 * ScreenToolsController.ratio
            height: 30 * ScreenToolsController.ratio
            text: qsTr("关闭")
            anchors.top: parent.top
            anchors.topMargin: 10 * ScreenToolsController.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ScreenToolsController.ratio
            padding: 0
            background: Rectangle {
                color: "transparent"
            }

            BorderImage {
                source: "qrc:/qmlimages/BeiLi/btn_videoclose_normal.png"
                width: closeBtn.width; height: closeBtn.height
            }

            contentItem: Text {
                text: closeBtn.text
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 18 * ScreenToolsController.ratio
                color: "#08D3E5"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            onClicked: {
                root.visible = false
            }
        }

        Button {
            id: expandBtn
            width: 58 * ScreenToolsController.ratio
            height: 30 * ScreenToolsController.ratio
            text: isExpand ? qsTr("收缩") : qsTr("展开")
            anchors.top: parent.top
            anchors.topMargin: 10 * ScreenToolsController.ratio
            anchors.right: closeBtn.left
            padding: 0
            background: Rectangle {
                color: "transparent"
            }

            BorderImage {
                source: "qrc:/qmlimages/BeiLi/btn_expand_normal.png"
                width: expandBtn.width; height: expandBtn.height
            }

            contentItem: Text {
                text: expandBtn.text
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 18 * ScreenToolsController.ratio
                color: "#08D3E5"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            onClicked: {
                isExpand = !isExpand
            }
        }
    }

    TabBar {
        id: tabBar
        anchors.top: parent.top
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 126 * ScreenToolsController.ratio
        spacing: 10 * ScreenToolsController.ratio
        height: 40 * ScreenToolsController.ratio
        background: Rectangle {
            color: "transparent"
        }

        TabButton {
            id: uavMsg
            property int index: 0
            width: 130 * ScreenToolsController.ratio
            height: 46 * ScreenToolsController.ratio
            text: qsTr("飞控消息")
            anchors.left: parent.left
            anchors.top: parent.top
            background: Rectangle {
                color: "#0A444F"
                border.color: "#80BFE8"
                radius: 6 * ScreenToolsController.ratio
                opacity: tabBar.currentIndex === uavMsg.index ? 1 : 0.5
            }

            contentItem: Text {
                text: uavMsg.text
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratio
                color: tabBar.currentIndex === uavMsg.index ? "#B2F9FF" : "#08D3E5"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

        }
        TabButton {
            id: ctrCenterMsg
            width: 130 * ScreenToolsController.ratio
            height: 46 * ScreenToolsController.ratio
            text: qsTr("控制中心")
            anchors.left: uavMsg.right
            anchors.top: parent.top
            anchors.leftMargin: tabBar.spacing
            property int index: 1
            background: Rectangle {
                color: "#0A444F"
                border.color: "#80BFE8"
                radius: 6 * ScreenToolsController.ratio
                opacity: tabBar.currentIndex === ctrCenterMsg.index ? 1 : 0.5
            }

            contentItem: Text {
                text: ctrCenterMsg.text
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratio
                color: tabBar.currentIndex === ctrCenterMsg.index ? "#B2F9FF" : "#08D3E5"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }
    }
    StackLayout {
        width: parent.width;
        currentIndex: tabBar.currentIndex;
        anchors.top: tabBar.bottom
        anchors.topMargin: -2
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        Rectangle {
            id: uavTab
            Layout.alignment: Qt.AlignCenter
            color: "#0A444F"
            border.color: "#80BFE8"
            Flickable {
                id:                 uavMessageFlick
                anchors.fill:       parent
                contentHeight:      uavMessageText.height
                contentWidth:       uavMessageText.width
                pixelAligned:       true
                //flickableDirection: Flickable.AutoFlickIfNeeded
                boundsBehavior: Flickable.StopAtBounds
                clip:           true // 防止文本超出边框范围
                flickableDirection: Flickable.VerticalFlick
                ScrollBar.vertical: ScrollBar {
                    id: uavMessageFlickScrillbar
                    parent: uavMessageFlick.parent
                    anchors.top: uavMessageFlick.top
                    anchors.right: uavMessageFlick.right
                    anchors.bottom: uavMessageFlick.bottom
                    width: 10 * ScreenToolsController.ratio
                    contentItem: Rectangle {
                        implicitWidth: uavMessageFlickScrillbar.width
                        radius: uavMessageFlickScrillbar.width / 2
                        color: "#08D3E5"
                        opacity: uavMessageFlickScrillbar.hovered ? 1 : 0.5
                    }
                }
                TextEdit {
                    id:             uavMessageText
                    textMargin:     6 * ScreenToolsController.ratio
                    readOnly:       true
                    textFormat:     TextEdit.RichText
                    color:          "#B2F9FF"
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 16 * ScreenToolsController.ratio
                    selectByMouse: true
                }
            }

            Text {
                anchors.centerIn:   parent
                text:               qsTr("No Messages")
                color:              "#B2F9FF"
                font.family:        "MicrosoftYaHei"
                font.weight:        Font.Bold
                font.pixelSize:     20 * ScreenToolsController.ratio
                visible:            uavMessageText.length === 0
            }
        }

        Rectangle {
            id: ctrCenterTab
            Layout.alignment: Qt.AlignCenter
            color: "#0A444F"
            border.color: "#80BFE8"
            Flickable {
                id:                 ctrCenterFlick
                anchors.fill:       parent
                height:             parent.height
                width:              parent.width
                contentHeight:      settingsColumn.height
                contentWidth:       parent.width
                pixelAligned:       true
                //flickableDirection: Flickable.AutoFlickIfNeeded
                boundsBehavior: Flickable.StopAtBounds
                clip:           true // 防止文本超出边框范围
                flickableDirection: Flickable.VerticalFlick
                ScrollBar.vertical: ScrollBar {
                    id: ctrCenterFlickScrillbar
                    parent: ctrCenterFlick.parent
                    anchors.top: ctrCenterFlick.top
                    anchors.right: ctrCenterFlick.right
                    anchors.bottom: ctrCenterFlick.bottom
                    width: 10 * ScreenToolsController.ratio
                    contentItem: Rectangle {
                        implicitWidth: ctrCenterFlickScrillbar.width
                        radius: ctrCenterFlickScrillbar.width / 2
                        color: "#08D3E5"
                        opacity: ctrCenterFlickScrillbar.hovered ? 1 : 0.5
                    }
                }

                Column {
                    id:                 settingsColumn
                    width:              parent.width
                    anchors.left: parent.left
                    anchors.leftMargin: 10 * ScreenToolsController.ratio
                    //spacing:            4
                    Repeater {
                        id: controlCenterRepeater
                        model: controlCenterMsg
                        delegate: Text {
                            text:               String("<font style=\"color: %1; font: %2pt monospace;\">%3</font><br/>").arg(qgcPal.text).arg(ScreenTools.defaultFontPointSize.toFixed(0) - 1).arg(modelData)
                            color:              "#B2F9FF"
                            font.family:        "MicrosoftYaHei"
                            font.weight:        Font.Bold
                            textFormat:         Text.RichText
                            font.pixelSize:     16 * ScreenToolsController.ratio
                        }
                    }
                }
            }

            Text {
                anchors.centerIn:   parent
                text:               qsTr("No Messages")
                color:              "#B2F9FF"
                font.family:        "MicrosoftYaHei"
                font.weight:        Font.Bold
                font.pixelSize:     20 * ScreenToolsController.ratio
                visible:            controlCenterRepeater.count === 0
            }
        }
    }

    Rectangle {
        id: mask
        width: 128 * ScreenToolsController.ratio
        height: 4 //* ScreenToolsController.ratio
        color: "#0A444F"
        anchors.top: tabBar.bottom
        anchors.topMargin: -2 //* ScreenToolsController.ratio
        anchors.left: tabBar.left
        anchors.leftMargin: tabBar.currentIndex === 0 ? 1 : (1 + 10 * ScreenToolsController.ratio + 130 * ScreenToolsController.ratio)
    }


//    ParallelAnimation {
//        id: aniStart

//        NumberAnimation {
//            target: contenxtView
//            property: "x"
//            duration: 200
//            easing.type: Easing.InOutQuad
//        }
//    }

}
