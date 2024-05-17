import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14
import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _root
    width: 238 * ScreenToolsController.ratio
    height: 76 * ScreenToolsController.ratio
    property var cameraInfo
    property bool checkable: true
    property bool checked: false
    property var canonicalName: cameraInfo ? cameraInfo.canonicalName : ""
    property var sensorWidth: cameraInfo ? cameraInfo.sensorWidth : 0
    property var sensorHeight: cameraInfo ? cameraInfo.sensorHeight : 0
    property var imageWidth: cameraInfo ? cameraInfo.imageWidth : 0
    property var imageHeight: cameraInfo ? cameraInfo.imageHeight : 0
    property var focalLength: cameraInfo ? cameraInfo.focalLength : 0
    property bool landscape: cameraInfo ? cameraInfo.landscape : true // 横置
    property var sceneNum: cameraInfo ? cameraInfo.sceneNum : 1   // 镜头数量
    property bool isSelected: false
    property bool removeable: true

    property ExclusiveGroup exclusiveGroup: null //对外开放一个ExclusiveGroup接口，用于绑定同个组

    onExclusiveGroupChanged: {
        if (exclusiveGroup && _root.checkable) {
            exclusiveGroup.bindCheckable(_root)
        }
    }

    onCheckedChanged: {
        //console.log("CameraInfoItem::onCheckChanged", checked)
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (_root.checkable) {
                _root.checked = true
            }
        }
    }

    Rectangle {
        color: "transparent"

        Row {
            spacing: 13 * ScreenToolsController.ratio
            Column {
                spacing: 5 * ScreenToolsController.ratio
                Item {
                    height: _root.height
                    width: 44 * ScreenToolsController.ratio
                    Rectangle {
                        radius: 4 * ScreenToolsController.ratio
                        color: "transparent"
                        border.color: "#08CCDD"
                        border.width: 1
                        width: 44 * ScreenToolsController.ratio
                        height: 44 * ScreenToolsController.ratio
                        anchors.verticalCenter: parent.verticalCenter

                        Image {
                            anchors.centerIn: parent
                            width: 24 * ScreenToolsController.ratio
                            height: 24 * ScreenToolsController.ratio
                            source: "qrc:/qmlimages/BeiLi/route_icon_mount_normal.png"
                            sourceSize.width: width
                            sourceSize.height: height
                        }
                    }
                }
            }

            Column {
                width: 80 * ScreenToolsController.ratio
                spacing: 4 * ScreenToolsController.ratio
                Row {
                    spacing: 2 * ScreenToolsController.ratio
                    Text {
                        id: canonicalNameTitle
                        text: qsTr("名称")
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    Text {
                        id: canonicalNameValue
                        text: canonicalName
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#B2F9FF"
                    }
                }
                Row {
                    spacing: 2 * ScreenToolsController.ratio
                    Text {
                        id: scensorSizeTitle
                        text: qsTr("传感器")
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    Text {
                        id: scensorSizeValue
                        text: String("%1*%2mm").arg(_root.sensorWidth).arg(_root.sensorHeight)
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#B2F9FF"
                    }
                }
                Row {
                    spacing: 2 * ScreenToolsController.ratio
                    Text {
                        id: imageSizeTitle
                        text: qsTr("分辨率")
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    Text {
                        id: imageSizeValue
                        text: String("%1*%2px").arg(_root.imageWidth).arg(_root.imageHeight)
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#B2F9FF"
                    }
                }
                Row {
                    spacing: 6 * ScreenToolsController.ratio
                    Row {
                        spacing: 2 * ScreenToolsController.ratio
                        Text {
                            id: focalLengthTitle
                            text: qsTr("焦距")
                            font.pixelSize: 10 * ScreenToolsController.ratio
                            font.family: "Microsoft YaHei"
                            font.weight: Font.Normal
                            color: "#08D3E5"
                        }
                        Text {
                            id: focalLengthValue
                            text: String("%1mm").arg(_root.focalLength)
                            font.pixelSize: 10 * ScreenToolsController.ratio
                            font.family: "Microsoft YaHei"
                            font.weight: Font.Normal
                            color: "#B2F9FF"
                        }
                    }

                    Row {
                        spacing: 2 * ScreenToolsController.ratio
                        Text {
                            id: sceneNumTitle
                            text: qsTr("镜头")
                            font.pixelSize: 10 * ScreenToolsController.ratio
                            font.family: "Microsoft YaHei"
                            font.weight: Font.Normal
                            color: "#08D3E5"
                        }
                        Text {
                            id: sceneNumValue
                            text: String("%1%2").arg(_root.sceneNum).arg(qsTr("个"))
                            font.pixelSize: 10 * ScreenToolsController.ratio
                            font.family: "Microsoft YaHei"
                            font.weight: Font.Normal
                            color: "#B2F9FF"
                        }
                    }
                }
            }

        }
    }

    Button {
        id: removeInfoBtn
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 6 * ScreenToolsController.ratio
        visible: (!_root.isSelected && _root.removeable)

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: "qrc:/qmlimages/BeiLi/camera_remove_btn.png"
            width: removeInfoBtn.width; height: removeInfoBtn.height
        }

        onClicked: {
            QGroundControl.settingsManager.cameraInfoSettings.removeCameraInfo(_root.canonicalName)
        }
    }

    Button {
        id: landscapeBtn
        text: qsTr("横置")
        width: 40 * ScreenToolsController.ratio
        height: 20 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 6 * ScreenToolsController.ratio
        visible: _root.isSelected
        checked: _root.landscape

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: landscapeBtn.checked ? "qrc:/qmlimages/BeiLi/cluster_btn01_checked.png" : landscapeBtn.hovered ? "qrc:/qmlimages/BeiLi/cluster_btn01_hovered.png" : "qrc:/qmlimages/BeiLi/cluster_btn01_normal.png"
            width: landscapeBtn.width; height: landscapeBtn.height
        }
        contentItem: Text {
            text: landscapeBtn.text
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 12 * ScreenToolsController.ratio
            color: "#B2F9FF"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        onClicked: {
            QGroundControl.settingsManager.vehicleInfoSettings.setCurCameraLandscape(!cameraInfo.landscape)
        }
    }

}
