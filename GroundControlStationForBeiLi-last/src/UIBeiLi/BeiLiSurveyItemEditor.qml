import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _root

    Column {
        id: parameGrid
        spacing: 10 * ScreenToolsController.ratio

        Row {
            spacing: 10 * ScreenToolsController.ratio
            Rectangle {
                width: 120 * ScreenToolsController.ratio
                height: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio
                BeiLiFactTextField {
                    id: frontOverlapPct
                    fact: missionItem ? missionItem.cameraCalc.frontalOverlap : null
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    onFocusChanged: {
                        if (focus && missionItem) missionItem.cameraCalc.valueSetIsFrontalOverlap.value = 1;
                    }
                }

                BeiLiFactTextField {
                    id: frontOverlapDis
                    fact: missionItem ? missionItem.cameraCalc.adjustedFootprintFrontal : null
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    onFocusChanged: {
                        if (focus && missionItem) missionItem.cameraCalc.valueSetIsFrontalOverlap.value = 0;
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: frontOverlapPct.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("航向重叠率")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

            Rectangle {
                width: 120 * ScreenToolsController.ratio
                height: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio
                BeiLiFactTextField {
                    id: sideOverlapPct
                    fact: missionItem ? missionItem.cameraCalc.sideOverlap : null
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    onFocusChanged: {
                        if (focus && missionItem) missionItem.cameraCalc.valueSetIsSideOverlap.value = 1;
                    }
                }

                BeiLiFactTextField {
                    id: sideOverlapDis
                    fact: missionItem ? missionItem.cameraCalc.adjustedFootprintSide : null
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    onFocusChanged: {
                        if (focus && missionItem) missionItem.cameraCalc.valueSetIsSideOverlap.value = 0;
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: sideOverlapPct.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("旁向重叠率")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

            Rectangle {
                width: 150 * ScreenToolsController.ratio
                height: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio
                BeiLiFactTextField {
                    id: toleranceEdit
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 50 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    fact: missionItem ? missionItem.terrainAdjustTolerance : null
                }

                Text {
                    anchors.horizontalCenter: toleranceEdit.horizontalCenter
                    anchors.top: toleranceEdit.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("容差")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }

                BeiLiFactTextField {
                    id: climbRateEdit
                    anchors.top: parent.top
                    anchors.left: toleranceEdit.right
                    width: 50 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    fact: missionItem ? missionItem.terrainAdjustMaxClimbRate : null
                }

                Text {
                    anchors.horizontalCenter: climbRateEdit.horizontalCenter
                    anchors.top: climbRateEdit.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("爬升率")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }

                BeiLiFactTextField {
                    id: decreaseRateEdit
                    anchors.top: parent.top
                    anchors.left: climbRateEdit.right
                    width: 50 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    fact: missionItem ? missionItem.terrainAdjustMaxDescentRate : null
                }

                Text {
                    anchors.horizontalCenter: decreaseRateEdit.horizontalCenter
                    anchors.top: decreaseRateEdit.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("下降率")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#084D5A"
                    opacity: 0.8
                    visible: missionItem ? !(missionItem.followTerrain) : true
                    radius: 4 * ScreenToolsController.ratio
                    MouseArea {
                        anchors.fill: parent
                        onPressed: { }
                        onReleased: { }
                        onClicked: { }
                        onWheel: { }
                    }
                }
            }

            Rectangle {
                height: 60 * ScreenToolsController.ratio
                width: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio
                BeiLiFactTextField {
                    id: heightOffsetEdit
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    fact: missionItem ? missionItem.altOffset : null
                }

                Text {
                    anchors.horizontalCenter: heightOffsetEdit.horizontalCenter
                    anchors.top: heightOffsetEdit.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("偏置")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

        }

        Row {
            spacing: 10 * ScreenToolsController.ratio
            Rectangle {
                width: 120 * ScreenToolsController.ratio
                height: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio
                BeiLiFactTextField {
                    id: flyheightEdit
                    fact: missionItem ? missionItem.cameraCalc.distanceToSurface : null
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    onFocusChanged: {
                        if (focus && missionItem) missionItem.cameraCalc.valueSetIsDistance.value = 1;
                    }
                }
                BeiLiFactTextField {
                    id: resolutionEdit
                    fact: missionItem ? missionItem.cameraCalc.imageDensity : null
                    anchors.right: parent.right
                    anchors.top: parent.top
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    onFocusChanged: {
                        if (focus && missionItem) missionItem.cameraCalc.valueSetIsDistance.value = 0;
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: flyheightEdit.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("航高/分辨率")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

            Rectangle {
                width: 60 * ScreenToolsController.ratio
                height: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio

                BeiLiFactTextField {
                    id: flySpeed
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    fact: missionItem ? missionItem.speedSection.flightSpeed : null
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: flySpeed.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("速度")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#084D5A"
                    opacity: 0.8
                    visible: missionItem ? !missionItem.speedSection.specifyFlightSpeed : false
                    radius: 4 * ScreenToolsController.ratio
                    MouseArea {
                        anchors.fill: parent
                        onPressed: { }
                        onReleased: { }
                        onClicked: { }
                        onWheel: { }
                    }
                }
            }

            Rectangle {
                width: 60 * ScreenToolsController.ratio
                height: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio
                BeiLiFactTextField {
                    id: courseAngle
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    fact: missionItem ? missionItem.gridAngle : null
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: courseAngle.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("角度")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

            Rectangle {
                width: 60 * ScreenToolsController.ratio
                height: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio
                BeiLiFactTextField {
                    id: turnAround
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: 60 * ScreenToolsController.ratio
                    height: 30 * ScreenToolsController.ratio
                    fact: missionItem ? missionItem.turnAroundDistance : null
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: turnAround.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("拐弯距离")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

            Rectangle {
                width: 60 * ScreenToolsController.ratio
                height: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio
                BeiLiComboBox {
                    id:             isTriggerInTurnAroundComboBox
                    width:          60 * ScreenToolsController.ratio
                    height:         30 * ScreenToolsController.ratio
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    model:          selectDatas
                    property var selectDatas: [qsTr("否"), qsTr("是")]
                    function updateComboBox() {
                        var index = 0
                        if(missionItem != null) {
                            index = missionItem.cameraTriggerInTurnAround.value
                        }
                        isTriggerInTurnAroundComboBox.currentIndex = index
                    }

                    onActivated: {
                        if (index != -1 && missionItem) {
                            missionItem.cameraTriggerInTurnAround.value = index
                        }
                    }
                    Component.onCompleted: {
                        updateComboBox()
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: isTriggerInTurnAroundComboBox.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("拐弯拍照")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }


            //Rectangle {
            Column {
                spacing: 6 * ScreenToolsController.ratio
                Button {
                    id: followsTerrainBtn
                    text: qsTr("仿地")
                    width: 60 * ScreenToolsController.ratio
                    height: 27 * ScreenToolsController.ratio
                    background: Rectangle {
                        color: "#25F085"
                        opacity: followsTerrainBtn.pressed ? 0.2 : 0.5
                        radius: 6 * ScreenToolsController.ratio
                    }

                    contentItem: Text {
                        text: followsTerrainBtn.text
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#B2F9FF"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    onClicked: {
                        if (missionItem) {
                            missionItem.followTerrain = !(missionItem.followTerrain)
                        }
                    }
                }
                Button {
                    id: rotateEntryPointBtn
                    text: {
                        if (missionItem) {
                            if (missionItem.entryPoint === 0) {
                                return qsTr("左上")
                            }
                            else if (missionItem.entryPoint === 1) {
                                return qsTr("右上")
                            }
                            else if (missionItem.entryPoint === 2) {
                                return qsTr("左下")
                            }
                            else if (missionItem.entryPoint === 3) {
                                return qsTr("右下")
                            }
                        }
                        return qsTr("入点")
                    }
                    width: 60 * ScreenToolsController.ratio
                    height: 27 * ScreenToolsController.ratio
                    background: Rectangle {
                        color: "#25F085"
                        opacity: rotateEntryPointBtn.pressed ? 0.2 : 0.5
                        radius: 6 * ScreenToolsController.ratio
                    }

                    contentItem: Text {
                        text: rotateEntryPointBtn.text
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Bold
                        font.pixelSize: 12 * ScreenToolsController.ratio
                        color: "#B2F9FF"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    onClicked: {
                        if (missionItem) {
                            missionItem.rotateEntryPoint()
                        }
                    }
                }
                //}// 仿地
            }
        }
    }

    Rectangle {
        anchors.fill: parameGrid
        color: "#084D5A"
        opacity: 0.8
        visible: missionItem ? false : true
        radius: 4 * ScreenToolsController.ratio
        MouseArea {
            anchors.fill: parent
            onPressed: { }
            onReleased: { }
            onClicked: { }
            onWheel: { }
        }
    }
}
