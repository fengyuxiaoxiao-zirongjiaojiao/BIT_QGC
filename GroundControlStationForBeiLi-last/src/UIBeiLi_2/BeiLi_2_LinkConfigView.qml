import QtQuick              2.3
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtQuick.Controls 1.4
import QtGraphicalEffects 1.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenToolsController 1.0
import QGroundControl.UIBeiLi               1.0

Rectangle {
    id: _root
    /* 可以直接通过设置customWidth和customHeight设置该控件的大小，并且可伸缩自适应 */
    property var customWidth: 434
    property var customHeight: 538

    property real _widthRatio: (customWidth * ScreenToolsController.ratio) / 414
    property real _heightRatio: (customHeight * ScreenToolsController.ratio) / 538

    width: customWidth * _widthRatio
    height: customHeight * _heightRatio
    radius: 5 * ScreenToolsController.ratio
    color: "#07424F"
    opacity: 0.8

    MouseArea {
        anchors.fill: parent
        hoverEnabled: false
        onPressed: {}
        onClicked: {}
        onReleased: {}
        onWheel: {}
    }

    Rectangle {
        id: localLink
        property bool hovered: false
        property bool checked: true
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 20 * _widthRatio
        width: 80 * _widthRatio
        height: 50 * _heightRatio
        color: "transparent"

        Text {
            text: qsTr("手动连接")
            anchors.centerIn: parent
            color: "#FFFFFF"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.family: "MicrosoftYaHei"
            font.weight: Font.Normal
            font.pixelSize: 16 * ScreenToolsController.ratio
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true
            onExited: parent.hovered = false
            onClicked: {
                cloundLink.checked = false
                parent.checked = true
            }
        }
    }

    Rectangle {
        id: cloundLink
        property bool hovered: false
        property bool checked: false
        anchors.top: parent.top
        anchors.left: localLink.right
        anchors.leftMargin: 10 * _widthRatio
        width: 80 * _widthRatio
        height: 50 * _heightRatio
        color: "transparent"

        Text {
            text: qsTr("云连接")
            anchors.centerIn: parent
            color: "#FFFFFF"

            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.family: "MicrosoftYaHei"
            font.weight: Font.Normal
            font.pixelSize: 16 * ScreenToolsController.ratio
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: parent.hovered = true
            onExited: parent.hovered = false
            onClicked: {
                localLink.checked = false
                parent.checked = true
            }
        }
    }

    Rectangle {
        id: splitLine
        anchors.top: parent.top
        anchors.topMargin: 50 * _heightRatio
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#118E9B"
        height: 1
    }

    Rectangle {
        id: underLine
        color: "#08D3E5"
        width: 79 * _widthRatio
        height: 4 * _heightRatio
        anchors.verticalCenter: splitLine.verticalCenter
        anchors.horizontalCenter: {
            if (cloundLink.checked) return cloundLink.horizontalCenter
            else return localLink.horizontalCenter
        }
        visible: cloundLink.checked || localLink.checked
    }

    Item {
        id: stacklayout
        property int currentIndex: localLink.checked ? 0 : 1
        anchors.top: underLine.bottom
        anchors.topMargin: -2 * _heightRatio
        anchors.left: parent.left
        anchors.leftMargin: 10 * _widthRatio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * _heightRatio
        anchors.right: parent.right
        anchors.rightMargin: 10 * _widthRatio

        Rectangle {
            id: localTab
            visible: stacklayout.currentIndex === 0
            anchors.fill: parent
            color: "#0A444F"
            //border.color: "#80BFE8"

            QGCFlickable {
                id: flickableLocal
                clip:               true
                anchors.top:        parent.top
                topMargin: 20 * _heightRatio
                bottomMargin: 20 * _heightRatio
                width:              parent.width
                height:             parent.height
                contentHeight:      settingsColumn.height
                contentWidth:       parent.width
                flickableDirection: Flickable.VerticalFlick
                indicatorColor: Qt.rgba(0,0,0,0)
                ScrollBar.vertical: ScrollBar {
                    id: flickableLocalScrillbar
                    parent: flickableLocal.parent
                    anchors.top: flickableLocal.top
                    anchors.right: flickableLocal.right
                    anchors.bottom: flickableLocal.bottom
                    width: 10 * _widthRatio
                    contentItem: Rectangle {
                        implicitWidth: flickableLocalScrillbar.width
                        radius: flickableLocalScrillbar.width / 2
                        color: "#08D3E5"
                        opacity: flickableLocalScrillbar.hovered ? 1 : 0.5
                    }
                }

                ExclusiveGroup { id: buttonGroup }
                Column {
                    id:                 settingsColumn
                    width:              parent.width
                    spacing:            20 * _heightRatio
                    Repeater {
                        model: QGroundControl.linkManager.linkConfigurations
                        delegate: LinkConfigItem {
                            anchors.horizontalCenter:   settingsColumn.horizontalCenter
                            linkconfigure: object
                            exclusiveGroup: buttonGroup
                            customWidth: 400
                        }
                    }
                    LinkConfigItem {
                        anchors.horizontalCenter:   settingsColumn.horizontalCenter
                        linkconfigure: null
                        isAdd: true
                        isEdit: true
                        exclusiveGroup: buttonGroup
                        customWidth: 400
                    }
                }
            }

        }

        Rectangle {
            id: cloudTab
            visible: stacklayout.currentIndex === 1
            anchors.fill: parent
            color: "#0A444F"
            //border.color: "#80BFE8"
            QGCFlickable {
                id: flickableCloud
                clip:               true
                anchors.top:        parent.top
                topMargin: 20 * _heightRatio
                bottomMargin: 20 * _heightRatio
                width:              parent.width
                height:             parent.height
                contentHeight:      settingsCloundColumn.height
                contentWidth:       parent.width
                flickableDirection: Flickable.VerticalFlick
                indicatorColor: Qt.rgba(0,0,0,0)
                ScrollBar.vertical: ScrollBar {
                    id: flickableCloudScrillbar
                    parent: flickableCloud.parent
                    anchors.top: flickableCloud.top
                    anchors.right: flickableCloud.right
                    anchors.bottom: flickableCloud.bottom
                    width: 10 * _widthRatio
                    contentItem: Rectangle {
                        implicitWidth: flickableCloudScrillbar.width
                        radius: flickableCloudScrillbar.width / 2
                        color: "#08D3E5"
                        opacity: flickableCloudScrillbar.hovered ? 1 : 0.5
                    }
                }

                //ExclusiveGroup { id: buttonGroup1 }
                Column {
                    id:                 settingsCloundColumn
                    width:              parent.width
                    spacing:            20 * _heightRatio
                    Repeater {
                        model: QGroundControl.httpAPIManager.getUAVInfoManager().firstUAVs
                        delegate: LinkConfigItemClound {
                            anchors.horizontalCenter:   settingsCloundColumn.horizontalCenter
                            uavInfo: QGroundControl.httpAPIManager.getUAVInfoManager().firstUAVs.get(index)
                            //exclusiveGroup: buttonGroup1
                            customWidth: 400
                        }
                    }
                    Repeater {
                        model: QGroundControl.httpAPIManager.getUAVInfoManager().secondUAVs
                        delegate: LinkConfigItemClound {
                            anchors.horizontalCenter:   settingsCloundColumn.horizontalCenter
                            uavInfo: QGroundControl.httpAPIManager.getUAVInfoManager().secondUAVs.get(index)
                            //exclusiveGroup: buttonGroup1
                            customWidth: 400
                        }
                    }
                    Repeater {
                        model: QGroundControl.httpAPIManager.getUAVInfoManager().thirdUAVs
                        delegate: LinkConfigItemClound {
                            anchors.horizontalCenter:   settingsCloundColumn.horizontalCenter
                            uavInfo: QGroundControl.httpAPIManager.getUAVInfoManager().thirdUAVs.get(index)
                            //exclusiveGroup: buttonGroup1
                        }
                    }
                    Repeater {
                        model: QGroundControl.httpAPIManager.getUAVInfoManager().fourthUAVs
                        delegate: LinkConfigItemClound {
                            anchors.horizontalCenter:   settingsCloundColumn.horizontalCenter
                            uavInfo: QGroundControl.httpAPIManager.getUAVInfoManager().fourthUAVs.get(index)
                            //exclusiveGroup: buttonGroup1
                            customWidth: 400
                        }
                    }
                }
            }

            Text {
                anchors.centerIn:   parent
                text:               qsTr("未登录")
                color:              "#B2F9FF"
                font.family:        "MicrosoftYaHei"
                font.weight:        Font.Bold
                font.pixelSize:     20 * ScreenToolsController.ratio
                visible:            !QGroundControl.httpAPIManager.getUserManager().isLogin
            }
        }
    }

}
