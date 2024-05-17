import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14
import QtQuick.Layouts  1.14
import QtPositioning    5.2

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _root
    property var myGeoFenceController: geoFenceController
    Column {
        spacing: 12 * ScreenToolsController.ratio

        Row {
            spacing: 10 * ScreenToolsController.ratio

            Rectangle {
                id: geoFenceCircularBg
                color: "#0F6878"
                radius: 8 * ScreenToolsController.ratio
                width: 238 * ScreenToolsController.ratio
                height: 130 * ScreenToolsController.ratio
                Text {
                    id: geoFenceCircularTitle
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 6 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    text: qsTr("圆形围栏")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                    horizontalAlignment: Text.AlignHCenter
                }
                Button {
                    id: addGeoFenceCircularBtn
                    width: 16 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    anchors.top: parent.top
                    anchors.topMargin: 5 * ScreenToolsController.ratio
                    anchors.left: geoFenceCircularTitle.right
                    anchors.leftMargin: 10 * ScreenToolsController.ratio

                    background: Rectangle {
                        color: "transparent"
                    }
                    BorderImage {
                        source: "qrc:/qmlimages/BeiLi/camera_add_btn.png"
                        width: addGeoFenceCircularBtn.width; height: addGeoFenceCircularBtn.height
                    }

                    onClicked: {
                        var rect = Qt.rect(flightMap.centerViewport.x, flightMap.centerViewport.y, flightMap.centerViewport.width, flightMap.centerViewport.height)
                        var topLeftCoord = flightMap.toCoordinate(Qt.point(rect.x, rect.y), false /* clipToViewPort */)
                        var bottomRightCoord = flightMap.toCoordinate(Qt.point(rect.x + rect.width, rect.y + rect.height), false /* clipToViewPort */)
                        myGeoFenceController.addInclusionCircle(topLeftCoord, bottomRightCoord)
                    }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.topMargin: 26 * ScreenToolsController.ratio
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: "#084D5A"
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 26 * ScreenToolsController.ratio
                        color: "transparent"
                        Row {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                width: geoFenceCircularBg.width / 4
                                text: qsTr("编辑")
                                font.family: "MicrosoftYaHei"
                                font.weight: Font.Bold
                                font.pixelSize: 12 * ScreenToolsController.ratio
                                color: "#B2F9FF"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                width: geoFenceCircularBg.width / 4
                                text: qsTr("包容")
                                font.family: "MicrosoftYaHei"
                                font.weight: Font.Bold
                                font.pixelSize: 12 * ScreenToolsController.ratio
                                color: "#B2F9FF"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                width: geoFenceCircularBg.width / 4
                                text: qsTr("半径")
                                font.family: "MicrosoftYaHei"
                                font.weight: Font.Bold
                                font.pixelSize: 12 * ScreenToolsController.ratio
                                color: "#B2F9FF"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                width: geoFenceCircularBg.width / 4
                                text: qsTr("删除")
                                font.family: "MicrosoftYaHei"
                                font.weight: Font.Bold
                                font.pixelSize: 12 * ScreenToolsController.ratio
                                color: "#B2F9FF"
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }

                    Flickable {
                        id: flickableCircular
                        clip:               true
                        anchors.top:        parent.top
                        anchors.topMargin: 26 * ScreenToolsController.ratio
                        //anchors.bottomMargin: 20
                        width:              parent.width
                        height:             parent.height - 26 * ScreenToolsController.ratio
                        contentHeight:      settingsCloundColumn1.height
                        contentWidth:       parent.width
                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        property color indicatorColor: Qt.rgba(0,0,0,0)
                        ScrollBar.vertical: ScrollBar {
                            id: flickableCircularScrillbar
                            parent: flickableCircular.parent
                            anchors.top: flickableCircular.top
                            anchors.right: flickableCircular.right
                            anchors.bottom: flickableCircular.bottom
                            width: 10 * ScreenToolsController.ratio
                            contentItem: Rectangle {
                                implicitWidth: flickableCircularScrillbar.width
                                radius: flickableCircularScrillbar.width / 2
                                color: "#08D3E5"
                                opacity: flickableCircularScrillbar.hovered ? 1 : 0.5
                            }
                        }

                        ExclusiveGroup { id: buttonGroup1 }
                        Column {
                            id:                 settingsCloundColumn1
                            width:              parent.width
                            spacing: 1
                            Repeater {
                                model: myGeoFenceController.circles
                                BeiLiGeoFenceCircularItem {
                                    exclusiveGroup: buttonGroup1
                                    checked: object.interactive
                                    inclusion: object.inclusion
                                    radius: object.radius

                                    onClicked: {
                                        myGeoFenceController.clearAllInteractive()
                                        object.interactive = checked
                                    }

                                    onInclusionChanged: {
                                        object.inclusion = inclusion
                                    }

                                    onRemoveClicked: {
                                        myGeoFenceController.deleteCircle(index)
                                    }
                                }

                            }

                        } // Column

                    }

                }

                Rectangle {
                    visible: !isGeoFenceCircular
                    anchors.fill: parent
                    color: "#084D5A"
                    opacity: 0.8
                    radius: 8 * ScreenToolsController.ratio
                    MouseArea {
                        anchors.fill: parent
                        onPressed: {}
                        onReleased: {}
                        onClicked: {}
                        onWheel: {}
                    }
                }
            }// geoFenceCircular

            Rectangle {
                id: geoFencePolygonBg
                color: "#0F6878"
                radius: 8 * ScreenToolsController.ratio
                width: 238 * ScreenToolsController.ratio
                height: 130 * ScreenToolsController.ratio
                Text {
                    id: geoFencePolygonTitle
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 6 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    text: qsTr("多边形围栏")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                    horizontalAlignment: Text.AlignHCenter
                }
                Button {
                    id: addGeoFencePolygonBtn
                    width: 16 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio
                    anchors.top: parent.top
                    anchors.topMargin: 5 * ScreenToolsController.ratio
                    anchors.left: geoFencePolygonTitle.right
                    anchors.leftMargin: 10 * ScreenToolsController.ratio

                    background: Rectangle {
                        color: "transparent"
                    }
                    BorderImage {
                        source: "qrc:/qmlimages/BeiLi/camera_add_btn.png"
                        width: addGeoFencePolygonBtn.width; height: addGeoFencePolygonBtn.height
                    }

                    onClicked: {
                        var rect = Qt.rect(flightMap.centerViewport.x, flightMap.centerViewport.y, flightMap.centerViewport.width, flightMap.centerViewport.height)
                        var topLeftCoord = flightMap.toCoordinate(Qt.point(rect.x, rect.y), false /* clipToViewPort */)
                        var bottomRightCoord = flightMap.toCoordinate(Qt.point(rect.x + rect.width, rect.y + rect.height), false /* clipToViewPort */)
                        myGeoFenceController.addInclusionPolygon(topLeftCoord, bottomRightCoord)
                    }
                }

                Rectangle {
                    anchors.top: parent.top
                    anchors.topMargin: 26 * ScreenToolsController.ratio
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    color: "#084D5A"
                    Rectangle {
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 26 * ScreenToolsController.ratio
                        color: "transparent"
                        Row {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            Text {
                                width: geoFencePolygonBg.width / 3
                                text: qsTr("编辑")
                                font.family: "MicrosoftYaHei"
                                font.weight: Font.Bold
                                font.pixelSize: 12 * ScreenToolsController.ratio
                                color: "#B2F9FF"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                width: geoFencePolygonBg.width / 3
                                text: qsTr("包容")
                                font.family: "MicrosoftYaHei"
                                font.weight: Font.Bold
                                font.pixelSize: 12 * ScreenToolsController.ratio
                                color: "#B2F9FF"
                                horizontalAlignment: Text.AlignHCenter
                            }
                            Text {
                                width: geoFencePolygonBg.width / 3
                                text: qsTr("删除")
                                font.family: "MicrosoftYaHei"
                                font.weight: Font.Bold
                                font.pixelSize: 12 * ScreenToolsController.ratio
                                color: "#B2F9FF"
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }
                    }

                    Flickable {
                        id: flickableCameraInfo
                        clip:               true
                        anchors.top:        parent.top
                        anchors.topMargin: 26 * ScreenToolsController.ratio
                        //anchors.bottomMargin: 20
                        width:              parent.width
                        height:             parent.height - 26 * ScreenToolsController.ratio
                        contentHeight:      settingsCloundColumn.height
                        contentWidth:       parent.width
                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        property color indicatorColor: Qt.rgba(0,0,0,0)
                        ScrollBar.vertical: ScrollBar {
                            id: flickableCameraInfoScrillbar
                            parent: flickableCameraInfo.parent
                            anchors.top: flickableCameraInfo.top
                            anchors.right: flickableCameraInfo.right
                            anchors.bottom: flickableCameraInfo.bottom
                            width: 10 * ScreenToolsController.ratio
                            contentItem: Rectangle {
                                implicitWidth: flickableCameraInfoScrillbar.width
                                radius: flickableCameraInfoScrillbar.width / 2
                                color: "#08D3E5"
                                opacity: flickableCameraInfoScrillbar.hovered ? 1 : 0.5
                            }
                        }

                        ExclusiveGroup { id: buttonGroup }
                        Column {
                            id:                 settingsCloundColumn
                            width:              parent.width
                            spacing: 1
                            Repeater {
                                model: myGeoFenceController.polygons
                                BeiLiGeoFencePolygonItem {
                                    exclusiveGroup: buttonGroup
                                    checked: object.interactive
                                    inclusion: object.inclusion

                                    onClicked: {
                                        myGeoFenceController.clearAllInteractive()
                                        object.interactive = checked
                                    }

                                    onInclusionChanged: {
                                        object.inclusion = inclusion
                                    }

                                    onRemoveClicked: {
                                        myGeoFenceController.deletePolygon(index)
                                    }
                                }


                            }

                        } // Column

                    }

                }

                Rectangle {
                    visible: !isGeoFencePolygon
                    anchors.fill: parent
                    color: "#084D5A"
                    opacity: 0.8
                    radius: 8 * ScreenToolsController.ratio
                    MouseArea {
                        anchors.fill: parent
                        onPressed: {}
                        onReleased: {}
                        onClicked: {}
                        onWheel: {}
                    }
                }
            }  // geoFencePolygon

        } // Row

        Row {
            spacing: 20 * ScreenToolsController.ratio
            Rectangle {
                height: 30 * ScreenToolsController.ratio
                width: 100 * ScreenToolsController.ratio
                color: "transparent"
                CheckBox {
                    id: breachReturnPointCheckBox
                    text: qsTr("添加违规返航点")
                    anchors.verticalCenter: parent.verticalCenter
                    height: 20 * ScreenToolsController.ratio
                    checkable: true
                    checked: myGeoFenceController.breachReturnPoint.isValid
                    enabled: true
                    onCheckedChanged: {
                        if (checked) {
                            myGeoFenceController.breachReturnPoint = flightMap.center
                        } else {
                            myGeoFenceController.breachReturnPoint = QtPositioning.coordinate()
                        }
                    }
                    Component.onCompleted: {
                    }
                    indicator: Rectangle {
                        id: indicatorRec
                        anchors.left: breachReturnPointCheckBox.left
                        anchors.verticalCenter: breachReturnPointCheckBox.verticalCenter
                        width: 12 * ScreenToolsController.ratio
                        height: 12 * ScreenToolsController.ratio
                        color: "transparent"
                        Image {
                            source: breachReturnPointCheckBox.checked ? "qrc:/qmlimages/BeiLi/login_icon_remembered_checked.png" : "qrc:/qmlimages/BeiLi/login_icon_remembered.png"
                        }
                    }


                    contentItem: Text {
                        anchors.verticalCenter: indicatorRec.verticalCenter
                        anchors.left: indicatorRec.right
                        anchors.leftMargin: 8 * ScreenToolsController.ratio
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#B2F9FF"
                        text: breachReturnPointCheckBox.text
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                }
            }

            Row {
                spacing: 6 * ScreenToolsController.ratio
                Text {
                    text: qsTr("高度")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                    anchors.verticalCenter: breachReturnPointAltField.verticalCenter
                }
                BeiLiFactTextField {
                    id: breachReturnPointAltField
                    height: 30 * ScreenToolsController.ratio
                    width: 60 * ScreenToolsController.ratio
                    fact: myGeoFenceController.breachReturnAltitude
                }
            } // Row
        }
    } // Column
}
