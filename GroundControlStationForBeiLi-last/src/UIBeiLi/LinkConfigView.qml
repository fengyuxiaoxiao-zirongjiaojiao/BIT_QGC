import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: root

    width: 500 * ScreenToolsController.ratio
    height: 405 * ScreenToolsController.ratio

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
            padding: 0
            text: qsTr("关闭")
            anchors.top: parent.top
            anchors.topMargin: 10 * ScreenToolsController.ratio
            anchors.right: parent.right
            anchors.rightMargin: 10 * ScreenToolsController.ratio
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
            id: localLink
            property int index: 0
            width: 130 * ScreenToolsController.ratio
            height: 46 * ScreenToolsController.ratio
            text: qsTr("本地连接")
            anchors.left: parent.left
            anchors.top: parent.top
            background: Rectangle {
                color: "#0A444F"
                border.color: "#80BFE8"
                radius: 6 * ScreenToolsController.ratio
                opacity: tabBar.currentIndex === localLink.index ? 1 : 0.5
            }

            contentItem: Text {
                text: localLink.text
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratio
                color: tabBar.currentIndex === localLink.index ? "#B2F9FF" : "#08D3E5"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

        }
        TabButton {
            id: cloudLink
            width: 130 * ScreenToolsController.ratio
            height: 46 * ScreenToolsController.ratio
            text: qsTr("云连接")
            anchors.left: localLink.right
            anchors.top: parent.top
            anchors.leftMargin: tabBar.spacing
            property int index: 1
            background: Rectangle {
                color: "#0A444F"
                border.color: "#80BFE8"
                radius: 6 * ScreenToolsController.ratio
                opacity: tabBar.currentIndex === cloudLink.index ? 1 : 0.5
            }

            contentItem: Text {
                text: cloudLink.text
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 16 * ScreenToolsController.ratio
                color: tabBar.currentIndex === cloudLink.index ? "#B2F9FF" : "#08D3E5"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }
    }
    Item {
        id: stacklayout
        property int currentIndex: tabBar.currentIndex
        anchors.top: tabBar.bottom
        anchors.topMargin: -2 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio

        Rectangle {
            id: localTab
            visible: stacklayout.currentIndex === 0
            anchors.fill: parent
            color: "#0A444F"
            border.color: "#80BFE8"

            QGCFlickable {
                id: flickableLocal
                clip:               true
                anchors.top:        parent.top
                topMargin: 20 * ScreenToolsController.ratio
                bottomMargin: 20 * ScreenToolsController.ratio
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
                    width: 10 * ScreenToolsController.ratio
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
                    spacing:            20 * ScreenToolsController.ratio
                    Repeater {
                        model: QGroundControl.linkManager.linkConfigurations
                        delegate: LinkConfigItem {
                            anchors.horizontalCenter:   settingsColumn.horizontalCenter
                            linkconfigure: object
                            exclusiveGroup: buttonGroup
                        }
                    }
                    LinkConfigItem {
                        anchors.horizontalCenter:   settingsColumn.horizontalCenter
                        linkconfigure: null
                        isAdd: true
                        isEdit: true
                        exclusiveGroup: buttonGroup
                    }
                }
            }

        }

        Rectangle {
            id: cloudTab
            visible: stacklayout.currentIndex === 1
            anchors.fill: parent
            color: "#0A444F"
            border.color: "#80BFE8"
            QGCFlickable {
                id: flickableCloud
                clip:               true
                anchors.top:        parent.top
                topMargin: 20 * ScreenToolsController.ratio
                bottomMargin: 20 * ScreenToolsController.ratio
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
                    width: 10 * ScreenToolsController.ratio
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
                    spacing:            20 * ScreenToolsController.ratio
                    Repeater {
                        model: QGroundControl.httpAPIManager.getUAVInfoManager().firstUAVs
                        delegate: LinkConfigItemClound {
                            anchors.horizontalCenter:   settingsCloundColumn.horizontalCenter
                            uavInfo: QGroundControl.httpAPIManager.getUAVInfoManager().firstUAVs.get(index)
                            //exclusiveGroup: buttonGroup1
                        }
                    }
                    Repeater {
                        model: QGroundControl.httpAPIManager.getUAVInfoManager().secondUAVs
                        delegate: LinkConfigItemClound {
                            anchors.horizontalCenter:   settingsCloundColumn.horizontalCenter
                            uavInfo: QGroundControl.httpAPIManager.getUAVInfoManager().secondUAVs.get(index)
                            //exclusiveGroup: buttonGroup1
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

    Rectangle {
        id: mask
        width: 128 * ScreenToolsController.ratio
        height: 4 * ScreenToolsController.ratio
        color: "#0A444F"
        anchors.top: parent.top
        anchors.topMargin: (10 + 38) * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: tabBar.currentIndex === 0 ? 11 * ScreenToolsController.ratio : (130 + 21) * ScreenToolsController.ratio
    }

}
