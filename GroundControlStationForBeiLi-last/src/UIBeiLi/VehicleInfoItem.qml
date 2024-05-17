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

    property var vehicleInfo
    property bool checkable: true
    property bool checked: false
    property var canonicalName: vehicleInfo ? vehicleInfo.canonicalName : ""
    property var brand: vehicleInfo ? vehicleInfo.brand : ""
    property var durationOfFlight: vehicleInfo ? String("%1min/%2km").arg(vehicleInfo.durationOfFlight).arg(vehicleInfo.enduranceMileage) : ""
    property var vehicleSize: vehicleInfo ? String("%1*%2cm").arg(vehicleInfo.sizeWidth).arg(vehicleInfo.sizeHeight) : ""
    property var type: vehicleInfo ? vehicleInfo.type : ""
    property var cruisingSpeed: vehicleInfo ? String("%1m/s").arg(vehicleInfo.cruisingSpeed) : ""
    property var weight: vehicleInfo ? String("%1kg").arg(vehicleInfo.weight) : ""
    property bool isSelected
    property bool removeable

    property ExclusiveGroup exclusiveGroup: null //对外开放一个ExclusiveGroup接口，用于绑定同个组

    onExclusiveGroupChanged: {
        if (exclusiveGroup && _root.checkable) {
            exclusiveGroup.bindCheckable(_root)
        }
    }

    onCheckedChanged: {

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
                            sourceSize.width: width
                            sourceSize.height: height
                            source: "qrc:/qmlimages/BeiLi/route_icon_land_normal.png"
                        }
                    }
                }
            }

            Column {
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
                        text: _root.canonicalName
                        font.pixelSize: 10 * ScreenToolsController.ratio
                        font.family: "Microsoft YaHei"
                        font.weight: Font.Normal
                        color: "#B2F9FF"
                    }
                }

                Row {
                    spacing: 20 * ScreenToolsController.ratio
                    Column {
                        width: 80 * ScreenToolsController.ratio
                        spacing: 4 * ScreenToolsController.ratio
                        Row {
                            spacing: 2 * ScreenToolsController.ratio
                            Text {
                                id: brandTitle
                                text: qsTr("品牌")
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#08D3E5"
                            }
                            Text {
                                id: brandValue
                                text: _root.brand
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#B2F9FF"
                            }
                        }
                        Row {
                            spacing: 2 * ScreenToolsController.ratio
                            Text {
                                id: airbornePeriodTitle
                                text: qsTr("续航")
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#08D3E5"
                            }
                            Text {
                                id: airbornePeriodValue
                                text: _root.durationOfFlight
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#B2F9FF"
                            }
                        }
                        Row {
                            spacing: 2 * ScreenToolsController.ratio
                            Text {
                                id: sizeTitle
                                text: qsTr("尺寸")
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#08D3E5"
                            }
                            Text {
                                id: sizeValue
                                text: _root.vehicleSize
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#B2F9FF"
                            }
                        }
                    }

                    Column {
                        spacing: 4 * ScreenToolsController.ratio
                        Row {
                            spacing: 2 * ScreenToolsController.ratio
                            Text {
                                id: typeTitle
                                text: qsTr("类型")
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#08D3E5"
                            }
                            Text {
                                id: typeValue
                                text: _root.type
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#B2F9FF"
                            }
                        }

                        Row {
                            spacing: 2 * ScreenToolsController.ratio
                            Text {
                                id: speedTitle
                                text: qsTr("航速")
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#08D3E5"
                            }
                            Text {
                                id: speedValue
                                text: _root.cruisingSpeed
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#B2F9FF"
                            }
                        }

                        Row {
                            spacing: 2 * ScreenToolsController.ratio
                            Text {
                                id: weightTitle
                                text: qsTr("重量")
                                font.pixelSize: 10 * ScreenToolsController.ratio
                                font.family: "Microsoft YaHei"
                                font.weight: Font.Normal
                                color: "#08D3E5"
                            }
                            Text {
                                id: weightValue
                                text: _root.weight
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
    }

    Button {
        id: removeInfoBtn
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 6 * ScreenToolsController.ratio
        visible: !_root.isSelected && _root.removeable

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: "qrc:/qmlimages/BeiLi/camera_remove_btn.png"
            width: removeInfoBtn.width; height: removeInfoBtn.height
        }

        onClicked: {
            QGroundControl.settingsManager.vehicleInfoSettings.removeVehicleInfo(_root.canonicalName)
        }
    }

}
