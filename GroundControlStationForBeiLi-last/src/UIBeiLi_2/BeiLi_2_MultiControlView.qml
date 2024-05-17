import QtQuick              2.3
import QtQuick.Window 2.14
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0

import QGroundControl                       1.0
import QGroundControl.ScreenToolsController 1.0
import QGroundControl.SettingsManager       1.0
import QGroundControl.Vehicle               1.0
import QGroundControl.HttpAPIManager        1.0

import QGroundControl.UIBeiLi               1.0

Rectangle {
    id: _rootMultiControl
    color: "#07424F"
    opacity: 0.9
    width: 414 * ScreenToolsController.ratio
    height: 538 * ScreenToolsController.ratio

    readonly property int takeoffAction:        1
    readonly property int rtlAction:            2
    readonly property int startMissionAction:   3
    readonly property int pauseAction:          4
    readonly property int forceArmAction:       5
    property var btnArr: []
    property bool isLogin: QGroundControl.httpAPIManager.getUserManager().isLogin
    function executeAction(action) {
        for (var i = 0; i < _rootMultiControl.btnArr.length; i++) {
            if (_rootMultiControl.btnArr[i].checked) {
                var id = _rootMultiControl.btnArr[i].text
                for (var j = 0; j < QGroundControl.multiVehicleManager.vehicles.count; j++) {
                    var vehicle = QGroundControl.multiVehicleManager.vehicles.get(j)
                    //console.log("vehicle.id", vehicle.id, "id", id)
                    if (String(vehicle.id) === id) {
                        if (action === takeoffAction) {
                            console.log("execute takeoff id", id)
                            vehicle.guidedModeTakeoff(vehicle.minimumTakeoffAltitude())
                        } else if (action === rtlAction) {
                            /*if (vehicle.supportsSmartRTL) */vehicle.guidedModeRTL(false)
                        } else if (action === startMissionAction) {
                            vehicle.startMission()
                        } else if (action === pauseAction) {
                            vehicle.pauseVehicle()
                        } else if (action === forceArmAction) {
                            vehicle.forceArm()
                        }
                    }
                }
            }
        }
    }

    Item {
        id: titleBarField
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 54 * ScreenToolsController.ratio
        Text {
            id: titleTextField
            text: qsTr("集群控制")
            anchors.left: parent.left
            anchors.leftMargin: 10 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter

            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 20 * ScreenToolsController.ratioFont

            horizontalAlignment: Text.AlignLeft

            color: "#FFFFFF"
        }
    }

    Rectangle {
        id: splitLine
        anchors.top: titleBarField.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#118E9B"
    }

    Rectangle {
        id: groupBox
        anchors.top: splitLine.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        color: "#053540"
        opacity: 0.9
        height: 326 * ScreenToolsController.ratio

        Column {
            anchors.centerIn: parent
            spacing: 30 * ScreenToolsController.ratio

            // Row 1
            Row {
                id: firstRow
                spacing: 20 * ScreenToolsController.ratio
                property var group: QGroundControl.httpAPIManager.getUAVInfoManager().firstUAVs
                property var  firstVehicles: QGroundControl.multiVehicleManager.firstVehicles
                property var count: firstVehicles.count

                GroupButton {
                    id: firstGroupBtn
                    width: 98 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: firstRow.group.count > 0 ? firstRow.group.get(0).uavGroupName : ""
                    enabled: firstRow.count > 0
                    checked: {
                        if (!btn1.checked) return false;
                        if (!btn2.checked) return false;
                        if (!btn3.checked) return false;
                        if (!btn4.checked) return false;
                        return true;
                    }
                }

                FlyRoundButton {
                    id: btn1
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? firstRow.firstVehicles.get(0).id : ""//enabled ? firstRow.group.get(0).systemId : ""
                    enabled: firstRow.count >= 1
                    isLinked: text !== ""//enabled ? (firstRow.group.get(0).onLine && firstRow.group.get(0).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn1)
                }

                FlyRoundButton {
                    id: btn2
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? firstRow.firstVehicles.get(1).id : ""//enabled ? firstRow.group.get(1).systemId : ""
                    enabled: firstRow.count >= 2
                    isLinked: text !== ""//enabled ? (firstRow.group.get(1).onLine && firstRow.group.get(1).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn2)
                }

                FlyRoundButton {
                    id: btn3
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? firstRow.firstVehicles.get(2).id : ""//enabled ? firstRow.group.get(2).systemId : ""
                    enabled: firstRow.count >= 3
                    isLinked: text !== ""//enabled ? (firstRow.group.get(2).onLine && firstRow.group.get(2).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn3)
                }

                FlyRoundButton {
                    id: btn4
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? firstRow.firstVehicles.get(3).id : ""//enabled ? firstRow.group.get(3).systemId : ""
                    enabled: firstRow.count >= 4
                    isLinked: text !== ""//enabled ? (firstRow.group.get(3).onLine && firstRow.group.get(3).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn4)
                }

                Connections {
                    target: firstGroupBtn

                    onCheckedChanged: {
                        if (firstGroupBtn.checked) {
                            btn1.checked = btn2.checked = btn3.checked = btn4.checked = true
                        } else {
                            if (btn1.checked && btn2.checked && btn3.checked && btn4.checked) {
                                btn1.checked = btn2.checked = btn3.checked = btn4.checked = false
                            }
                        }
                    }
                }
            } // Row 1

            // Row 2
            Row {
                id: secondRow
                spacing: 20 * ScreenToolsController.ratio
                property var group: QGroundControl.httpAPIManager.getUAVInfoManager().secondUAVs
                property var  secondVehicles: QGroundControl.multiVehicleManager.secondVehicles
                property var count: secondVehicles.count

                GroupButton {
                    id: secondGroupBtn
                    width: 98 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: secondRow.group.count > 0 ? secondRow.group.get(0).uavGroupName : ""
                    enabled: secondRow.count > 0
                    checked: {
                        if (!btn5.checked) return false;
                        if (!btn6.checked) return false;
                        if (!btn7.checked) return false;
                        if (!btn8.checked) return false;
                        return true;
                    }
                }

                FlyRoundButton {
                    id: btn5
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? secondRow.secondVehicles.get(0).id : ""//enabled ? secondRow.group.get(0).systemId : ""
                    enabled: secondRow.count >= 1
                    isLinked: text !== ""//enabled ? (secondRow.group.get(0).onLine && secondRow.group.get(0).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn5)
                }

                FlyRoundButton {
                    id: btn6
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? secondRow.secondVehicles.get(1).id : ""//enabled ? secondRow.group.get(1).systemId : ""
                    enabled: secondRow.count >= 2
                    isLinked: text !== ""//enabled ? (secondRow.group.get(1).onLine && secondRow.group.get(1).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn6)
                }

                FlyRoundButton {
                    id: btn7
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? secondRow.secondVehicles.get(2).id : ""//enabled ? secondRow.group.get(2).systemId : ""
                    enabled: secondRow.count >= 3
                    isLinked: text !== ""//enabled ? (secondRow.group.get(2).onLine && secondRow.group.get(2).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn7)
                }

                FlyRoundButton {
                    id: btn8
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? secondRow.secondVehicles.get(3).id : ""//enabled ? secondRow.group.get(3).systemId : ""
                    enabled: secondRow.count >= 4
                    isLinked: text !== ""//enabled ? (secondRow.group.get(3).onLine && secondRow.group.get(3).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn8)
                }

                Connections {
                    target: secondGroupBtn

                    onCheckedChanged: {
                        if (secondGroupBtn.checked) {
                            btn5.checked = btn6.checked = btn7.checked = btn8.checked = true
                        } else {
                            if (btn5.checked && btn6.checked && btn7.checked && btn8.checked) {
                                btn5.checked = btn6.checked = btn7.checked = btn8.checked = false
                            }
                        }
                    }
                }
            } // Row 2

            // Row 3
            Row {
                id: thirdRow
                spacing: 20 * ScreenToolsController.ratio
                property var group: QGroundControl.httpAPIManager.getUAVInfoManager().thirdUAVs
                property var  thirdVehicles: QGroundControl.multiVehicleManager.thirdVehicles
                property var count: thirdVehicles.count
                GroupButton {
                    id: thirdGroupBtn
                    width: 98 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: thirdRow.group.count > 0 ? thirdRow.group.get(0).uavGroupName : ""
                    enabled: thirdRow.count > 0
                    checked: {
                        if (!btn9.checked) return false;
                        if (!btn10.checked) return false;
                        if (!btn11.checked) return false;
                        if (!btn12.checked) return false;
                        return true;
                    }
                }

                FlyRoundButton {
                    id: btn9
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? thirdRow.thirdVehicles.get(0).id : ""//enabled ? thirdRow.group.get(0).systemId : ""
                    enabled: thirdRow.count >= 1
                    isLinked: text !== ""//enabled ? (thirdRow.group.get(0).onLine && thirdRow.group.get(0).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn9)
                }

                FlyRoundButton {
                    id: btn10
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? thirdRow.thirdVehicles.get(1).id : ""//enabled ? thirdRow.group.get(1).systemId : ""
                    enabled: thirdRow.count >= 2
                    isLinked: text !== ""//enabled ? (thirdRow.group.get(1).onLine && thirdRow.group.get(1).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn10)
                }

                FlyRoundButton {
                    id: btn11
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? thirdRow.thirdVehicles.get(2).id : ""//enabled ? thirdRow.group.get(2).systemId : ""
                    enabled: thirdRow.count >= 3
                    isLinked: text !== ""//enabled ? (thirdRow.group.get(2).onLine && thirdRow.group.get(2).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn11)
                }

                FlyRoundButton {
                    id: btn12
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? thirdRow.thirdVehicles.get(3).id : ""//enabled ? thirdRow.group.get(3).systemId : ""
                    enabled: thirdRow.count >= 4
                    isLinked: text !== ""//enabled ? (thirdRow.group.get(3).onLine && thirdRow.group.get(3).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn12)
                }

                Connections {
                    target: thirdGroupBtn

                    onCheckedChanged: {
                        if (thirdGroupBtn.checked) {
                            btn9.checked = btn10.checked = btn11.checked = btn12.checked = true
                        } else {
                            if (btn9.checked && btn10.checked && btn11.checked && btn12.checked) {
                                btn9.checked = btn10.checked = btn11.checked = btn12.checked = false
                            }
                        }
                    }
                }
            } // Row 3

            // Row 4
            Row {
                id: forthRow
                spacing: 20 * ScreenToolsController.ratio

                property var group: QGroundControl.httpAPIManager.getUAVInfoManager().fourthUAVs
                property var  fourthVehicles: QGroundControl.multiVehicleManager.fourthVehicles
                property var count: fourthVehicles.count
                GroupButton {
                    id: forthGroupBtn
                    width: 98 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: forthRow.group.count > 0 ? forthRow.group.get(0).uavGroupName : ""
                    enabled: forthRow.count > 0
                    checked: {
                        if (!btn13.checked) return false;
                        if (!btn14.checked) return false;
                        if (!btn15.checked) return false;
                        if (!btn16.checked) return false;
                        return true;
                    }
                }

                FlyRoundButton {
                    id: btn13
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? forthRow.fourthVehicles.get(0).id : ""//enabled ? forthRow.group.get(0).systemId : ""
                    enabled: forthRow.count >= 1
                    isLinked: text !== ""//enabled ? (forthRow.group.get(0).onLine && forthRow.group.get(0).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn13)
                }

                FlyRoundButton {
                    id: btn14
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? forthRow.fourthVehicles.get(1).id : ""//enabled ? forthRow.group.get(1).systemId : ""
                    enabled: forthRow.count >= 2
                    isLinked: text !== ""//enabled ? (forthRow.group.get(1).onLine && forthRow.group.get(1).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn14)
                }

                FlyRoundButton {
                    id: btn15
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? forthRow.fourthVehicles.get(2).id : ""//enabled ? forthRow.group.get(2).systemId : ""
                    enabled: forthRow.count >= 3
                    isLinked: text !== ""//enabled ? (forthRow.group.get(2).onLine && forthRow.group.get(2).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn15)
                }

                FlyRoundButton {
                    id: btn16
                    width: 44 * ScreenToolsController.ratio
                    height: 44 * ScreenToolsController.ratio
                    text: enabled ? forthRow.fourthVehicles.get(3).id : ""//enabled ? forthRow.group.get(3).systemId : ""
                    enabled: forthRow.count >= 4
                    isLinked: text !== ""//enabled ? (forthRow.group.get(3).onLine && forthRow.group.get(3).linkConfig.isLinked) : false
                    Component.onCompleted: _rootMultiControl.btnArr.push(btn16)
                }

                Connections {
                    target: forthGroupBtn

                    onCheckedChanged: {
                        if (forthGroupBtn.checked) {
                            btn13.checked = btn14.checked = btn15.checked = btn16.checked = true
                        } else {
                            if (btn13.checked && btn14.checked && btn15.checked && btn16.checked) {
                                btn13.checked = btn14.checked = btn15.checked = btn16.checked = false
                            }
                        }
                    }
                }
            } // Row 4
        } // Column
    }

    Item {
        anchors.top: groupBox.bottom
        //anchors.topMargin: 30 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Column {
            anchors.centerIn: parent
            spacing: 20 * ScreenToolsController.ratio
            Row {
                spacing: 20 * ScreenToolsController.ratio

                ActionButtonFour {
                    text: qsTr("全选")
                    property bool selected: false
                    onClicked: {
                        selected = !selected
                        for (var i = 0; i < _rootMultiControl.btnArr.length; i++) {
                            _rootMultiControl.btnArr[i].checked = selected
                        }
                    }
                }

                ActionButtonFour {
                    text: qsTr("执行")
                    onClicked: {
                        executeAction(startMissionAction)
                    }
                }

                ActionButtonFour {
                    text: qsTr("暂停")
                    onClicked: {
                        executeAction(pauseAction)
                    }
                }

            }

            Row {
                spacing: 20 * ScreenToolsController.ratio

                ActionButtonFour {
                    text: qsTr("")
                    onClicked: {  }
                }

                ActionButtonFour {
                    text: qsTr("返航")
                    onClicked: {
                        executeAction(rtlAction)
                    }
                }

                ActionButtonFour {
                    text: qsTr("起飞")
                    onClicked: {
                        executeAction(takeoffAction)
                    }
                }
            }
        }
    }

}
