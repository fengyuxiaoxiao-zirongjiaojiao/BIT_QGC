import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14
import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenToolsController 1.0
Item {
    id: _root
    width: 238 * ScreenToolsController.ratio
    height: 145 * ScreenToolsController.ratio

    Rectangle {
        color: "transparent"

        Row {
            spacing: 13 * ScreenToolsController.ratio
            Column {
                spacing: 5 * ScreenToolsController.ratio
                Rectangle {
                    //anchors.verticalCenter: parent.verticalCenter
                    radius: 4 * ScreenToolsController.ratio
                    color: "transparent"
                    border.color: "#08CCDD"
                    border.width: 1
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio

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

            Column {
                spacing: 8 * ScreenToolsController.ratio

                Row {
                    spacing: 2 * ScreenToolsController.ratio
                    Text {
                        id: canonicalNameTitle
                        anchors.verticalCenter: parent.verticalCenter
                        text: qsTr("名   称")
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    TextField {
                        id:         canonicalNameEditor
                        height: 30 * ScreenToolsController.ratio
                        width: 150 * ScreenToolsController.ratio
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#293538"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        selectByMouse: true

                        background: Rectangle {
                            color: "white"
                            radius: 4 * ScreenToolsController.ratio
                            border.color: "#80BFE8"
                            border.width: 1
                        }
                    }
                }

                Row {
                    spacing: 2 * ScreenToolsController.ratio
                    Text {
                        id: scensorSizeTitle
                        text: qsTr("传感器")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    TextField {
                        id:         sensorWidthEditor
                        width: 74 * ScreenToolsController.ratio
                        height: 30 * ScreenToolsController.ratio
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#293538"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        selectByMouse: true
                        placeholderText: "mm"

                        background: Rectangle {
                            color: "white"
                            radius: 4 * ScreenToolsController.ratio
                            border.color: "#80BFE8"
                            border.width: 1
                        }
                    }
                    TextField {
                        id:         sensorHeightEditor
                        width: 74 * ScreenToolsController.ratio
                        height: 30 * ScreenToolsController.ratio
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#293538"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        selectByMouse: true
                        placeholderText: "mm"

                        background: Rectangle {
                            color: "white"
                            radius: 4 * ScreenToolsController.ratio
                            border.color: "#80BFE8"
                            border.width: 1
                        }
                    }
                }
                Row {
                    spacing: 2 * ScreenToolsController.ratio
                    Text {
                        id: imageSizeTitle
                        text: qsTr("分辨率")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    TextField {
                        id:         imageWidthEditor
                        width: 74 * ScreenToolsController.ratio
                        height: 30 * ScreenToolsController.ratio
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#293538"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        selectByMouse: true
                        placeholderText: "px"

                        background: Rectangle {
                            color: "white"
                            radius: 4 * ScreenToolsController.ratio
                            border.color: "#80BFE8"
                            border.width: 1
                        }
                    }
                    TextField {
                        id:         imageHeightEditor
                        width: 74 * ScreenToolsController.ratio
                        height: 30 * ScreenToolsController.ratio
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#293538"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        selectByMouse: true
                        placeholderText: "px"

                        background: Rectangle {
                            color: "white"
                            radius: 4 * ScreenToolsController.ratio
                            border.color: "#80BFE8"
                            border.width: 1
                        }
                    }
                }
                Row {
                    spacing: 6 * ScreenToolsController.ratio
                    Row {
                        spacing: 2 * ScreenToolsController.ratio
                        Text {
                            id: focalLengthTitle
                            text: qsTr("焦   距")
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 10 * ScreenToolsController.ratio
                            font.family: "Microsoft YaHei"
                            font.weight: Font.Normal
                            color: "#08D3E5"
                        }
                        TextField {
                            id:         focalLengthEditor
                            width: 50 * ScreenToolsController.ratio
                            height: 30 * ScreenToolsController.ratio
                            font.family: "MicrosoftYaHei"
                            font.weight: Font.Bold
                            font.pixelSize: 12 * ScreenToolsController.ratio
                            color: "#293538"
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            focus: true
                            selectByMouse: true
                            placeholderText: "cm"

                            background: Rectangle {
                                color: "white"
                                radius: 4 * ScreenToolsController.ratio
                                border.color: "#80BFE8"
                                border.width: 1
                            }
                        }
                    }

                    Row {
                        spacing: 2 * ScreenToolsController.ratio
                        Text {
                            id: sceneNumTitle
                            text: qsTr("镜头")
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 10 * ScreenToolsController.ratio
                            font.family: "Microsoft YaHei"
                            font.weight: Font.Normal
                            color: "#08D3E5"
                        }
                        TextField {
                            id:         sceneNumEditor
                            width: 50 * ScreenToolsController.ratio
                            height: 30 * ScreenToolsController.ratio
                            font.family: "MicrosoftYaHei"
                            font.weight: Font.Bold
                            font.pixelSize: 12 * ScreenToolsController.ratio
                            color: "#293538"
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            focus: true
                            selectByMouse: true
                            placeholderText: qsTr("个")

                            background: Rectangle {
                                color: "white"
                                radius: 4 * ScreenToolsController.ratio
                                border.color: "#80BFE8"
                                border.width: 1
                            }
                        }

                        Button {
                            id: addInfoBtn
                            width: 16 * ScreenToolsController.ratio
                            height: 16 * ScreenToolsController.ratio
                            anchors.verticalCenter: parent.verticalCenter

                            background: Rectangle {
                                color: "transparent"
                            }
                            BorderImage {
                                source: "qrc:/qmlimages/BeiLi/camera_add_btn.png"
                                width: addInfoBtn.width; height: addInfoBtn.height
                            }

                            onClicked: {
                                if (canonicalNameEditor.text !== "") {
                                    QGroundControl.settingsManager.cameraInfoSettings.addCameraInfo(canonicalNameEditor.text, sensorWidthEditor.text, sensorHeightEditor.text, imageWidthEditor.text
                                                                                                    , imageHeightEditor.text, focalLengthEditor.text, sceneNumEditor.text)
                                    canonicalNameEditor.text = ""
                                    sensorWidthEditor.text = ""
                                    sensorHeightEditor.text = ""
                                    imageWidthEditor.text = ""
                                    imageHeightEditor.text = ""
                                    focalLengthEditor.text = ""
                                    sceneNumEditor.text = ""
                                } else {

                                }
                            }
                        }
                    }
                }
            }

        }
    }


}
