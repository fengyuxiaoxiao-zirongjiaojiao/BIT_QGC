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
                        sourceSize.width: width
                        sourceSize.height: height
                        source: "qrc:/qmlimages/BeiLi/route_icon_land_normal.png"
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
                        text: qsTr("名称")
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
                        id: brandTitle
                        text: qsTr("品牌")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    TextField {
                        id:         brandEditor
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

                        background: Rectangle {
                            color: "white"
                            radius: 4 * ScreenToolsController.ratio
                            border.color: "#80BFE8"
                            border.width: 1
                        }
                    }

                    Text {
                        id: typeTitle
                        text: qsTr("类型")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    BeiLiComboBox {
                        id:             typeComboBox
                        width:          60 * ScreenToolsController.ratio
                        height:         30 * ScreenToolsController.ratio
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        model:          QGroundControl.settingsManager.vehicleInfoSettings.typeList
                        function updateComboBox() {
                            typeComboBox.currentIndex = 0
                        }

                        onActivated: {
                            if (index != -1) {

                            }
                        }
                        Component.onCompleted: {
                            updateComboBox()
                        }
                    }
                }
                Row {
                    spacing: 2 * ScreenToolsController.ratio
                    Text {
                        id: durationOfFlightTitle
                        text: qsTr("续航")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    TextField {
                        id:         durationOfFlightEditor
                        width: 45 * ScreenToolsController.ratio
                        height: 30 * ScreenToolsController.ratio
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#293538"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        selectByMouse: true
                        placeholderText: "min"

                        background: Rectangle {
                            color: "white"
                            radius: 4 * ScreenToolsController.ratio
                            border.color: "#80BFE8"
                            border.width: 1
                        }
                    }
                    TextField {
                        id:         enduranceMileageEditor
                        width: 45 * ScreenToolsController.ratio
                        height: 30 * ScreenToolsController.ratio
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#293538"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        selectByMouse: true
                        placeholderText: "km"

                        background: Rectangle {
                            color: "white"
                            radius: 4 * ScreenToolsController.ratio
                            border.color: "#80BFE8"
                            border.width: 1
                        }
                    }

                    Text {
                        id: cruisingSpeedTitle
                        text: qsTr("航速")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    TextField {
                        id:         cruisingSpeedEditor
                        width: 45 * ScreenToolsController.ratio
                        height: 30 * ScreenToolsController.ratio
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#293538"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        selectByMouse: true
                        placeholderText: "m/s"

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
                        id: sizeTitle
                        text: qsTr("尺寸")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    TextField {
                        id:         sizeWidthEditor
                        width: 45 * ScreenToolsController.ratio
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
                    TextField {
                        id:         sizeHeightEditor
                        width: 45 * ScreenToolsController.ratio
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

                    Text {
                        id: weightTitle
                        text: qsTr("重量")
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#08D3E5"
                    }
                    TextField {
                        id:         weightEditor
                        width: 45 * ScreenToolsController.ratio
                        height: 30 * ScreenToolsController.ratio
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#293538"
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        focus: true
                        selectByMouse: true
                        placeholderText: "kg"

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
                                QGroundControl.settingsManager.vehicleInfoSettings.addVehicleInfo(canonicalNameEditor.text, brandEditor.text, typeComboBox.currentText, durationOfFlightEditor.text,
                                                                                                  enduranceMileageEditor.text, cruisingSpeedEditor.text, sizeWidthEditor.text, sizeHeightEditor.text, weightEditor.text)
                                canonicalNameEditor.text = ""
                                brandEditor.text = ""
                                typeComboBox.currentIndex = -1
                                durationOfFlightEditor.text = ""
                                enduranceMileageEditor.text = ""
                                cruisingSpeedEditor.text = ""
                                sizeWidthEditor.text = ""
                                sizeHeightEditor.text = ""
                                weightEditor.text = ""
                            } else {

                            }
                        }
                    }
                }


            }

        }
    }


}

