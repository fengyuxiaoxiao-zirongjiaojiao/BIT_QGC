import QtQuick 2.4
//import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl               1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.HttpAPIManager 1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootMultiControl
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

    Rectangle {
        id: _bg
        anchors.fill: parent
        color: "#07424F"
        opacity: 0.8
    }

    Image {
        id: _upperLeft
        source: "qrc:/qmlimages/BeiLi/form_upper_left.png"
        anchors.top: parent.top
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_upper_right.png"
        anchors.top: parent.top
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_left.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_right.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Button {
        id: allBtn
        anchors.top: parent.top
        anchors.topMargin: 32 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 30 * ScreenToolsController.ratio
        width: 59 * ScreenToolsController.ratio
        height: 198 * ScreenToolsController.ratio
        checkable: true
        text: qsTr("全\n\n部")
        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: allBtn.checked ? "qrc:/qmlimages/BeiLi/cluster_btn_all_checked.png" : allBtn.hovered ? "qrc:/qmlimages/BeiLi/cluster_btn_all_hovered.png" : "qrc:/qmlimages/BeiLi/cluster_btn_all_normal.png"
            width: allBtn.width; height: allBtn.height
        }
        contentItem: Text {
            text: allBtn.text
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 18 * ScreenToolsController.ratio
            color: "#B2F9FF"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        onCheckedChanged: {
            var v = false
            if (checked) {
                v = true
            }
            for (var i = 0; i < _rootMultiControl.btnArr.length; i++) {
                _rootMultiControl.btnArr[i].checked = v
            }
        }
    }

    Rectangle {
        id: firstRow
        anchors.top: parent.top
        anchors.topMargin: 32 * ScreenToolsController.ratio
        anchors.left: allBtn.right
        anchors.leftMargin: 30 * ScreenToolsController.ratio
        color: "transparent"
        width: 306 * ScreenToolsController.ratio
        height: 36 * ScreenToolsController.ratio
        property var group: QGroundControl.httpAPIManager.getUAVInfoManager().firstUAVs
        property var  firstVehicles: QGroundControl.multiVehicleManager.firstVehicles
        property var count: firstVehicles.count

        GroupButton {
            id: firstGroupBtn
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
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
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: firstGroupBtn.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? firstRow.firstVehicles.get(0).id : ""//enabled ? firstRow.group.get(0).systemId : ""
            enabled: firstRow.count >= 1
            isLinked: text !== ""//enabled ? (firstRow.group.get(0).onLine && firstRow.group.get(0).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn1)
        }

        FlyRoundButton {
            id: btn2
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn1.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? firstRow.firstVehicles.get(1).id : ""//enabled ? firstRow.group.get(1).systemId : ""
            enabled: firstRow.count >= 2
            isLinked: text !== ""//enabled ? (firstRow.group.get(1).onLine && firstRow.group.get(1).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn2)
        }

        FlyRoundButton {
            id: btn3
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn2.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? firstRow.firstVehicles.get(2).id : ""//enabled ? firstRow.group.get(2).systemId : ""
            enabled: firstRow.count >= 3
            isLinked: text !== ""//enabled ? (firstRow.group.get(2).onLine && firstRow.group.get(2).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn3)
        }

        FlyRoundButton {
            id: btn4
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn3.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
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
    }

    // 2 row
    Rectangle {
        id: secondRow
        anchors.top: firstRow.bottom
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.left: allBtn.right
        anchors.leftMargin: 30
        color: "transparent"
        width: 306 * ScreenToolsController.ratio
        height: 36 * ScreenToolsController.ratio
        property var group: QGroundControl.httpAPIManager.getUAVInfoManager().secondUAVs
        property var  secondVehicles: QGroundControl.multiVehicleManager.secondVehicles
        property var count: secondVehicles.count

        GroupButton {
            id: secondGroupBtn
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
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
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: secondGroupBtn.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? secondRow.secondVehicles.get(0).id : ""//enabled ? secondRow.group.get(0).systemId : ""
            enabled: secondRow.count >= 1
            isLinked: text !== ""//enabled ? (secondRow.group.get(0).onLine && secondRow.group.get(0).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn5)
        }

        FlyRoundButton {
            id: btn6
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn5.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? secondRow.secondVehicles.get(1).id : ""//enabled ? secondRow.group.get(1).systemId : ""
            enabled: secondRow.count >= 2
            isLinked: text !== ""//enabled ? (secondRow.group.get(1).onLine && secondRow.group.get(1).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn6)
        }

        FlyRoundButton {
            id: btn7
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn6.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? secondRow.secondVehicles.get(2).id : ""//enabled ? secondRow.group.get(2).systemId : ""
            enabled: secondRow.count >= 3
            isLinked: text !== ""//enabled ? (secondRow.group.get(2).onLine && secondRow.group.get(2).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn7)
        }

        FlyRoundButton {
            id: btn8
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn7.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
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
    }

    // 3 row
    Rectangle {
        id: thirdRow
        anchors.top: secondRow.bottom
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.left: allBtn.right
        anchors.leftMargin: 30 * ScreenToolsController.ratio
        color: "transparent"
        width: 306 * ScreenToolsController.ratio
        height: 36 * ScreenToolsController.ratio
        property var group: QGroundControl.httpAPIManager.getUAVInfoManager().thirdUAVs
        property var  thirdVehicles: QGroundControl.multiVehicleManager.thirdVehicles
        property var count: thirdVehicles.count
        GroupButton {
            id: thirdGroupBtn
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
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
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: thirdGroupBtn.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? thirdRow.thirdVehicles.get(0).id : ""//enabled ? thirdRow.group.get(0).systemId : ""
            enabled: thirdRow.count >= 1
            isLinked: text !== ""//enabled ? (thirdRow.group.get(0).onLine && thirdRow.group.get(0).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn9)
        }

        FlyRoundButton {
            id: btn10
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn9.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? thirdRow.thirdVehicles.get(1).id : ""//enabled ? thirdRow.group.get(1).systemId : ""
            enabled: thirdRow.count >= 2
            isLinked: text !== ""//enabled ? (thirdRow.group.get(1).onLine && thirdRow.group.get(1).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn10)
        }

        FlyRoundButton {
            id: btn11
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn10.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? thirdRow.thirdVehicles.get(2).id : ""//enabled ? thirdRow.group.get(2).systemId : ""
            enabled: thirdRow.count >= 3
            isLinked: text !== ""//enabled ? (thirdRow.group.get(2).onLine && thirdRow.group.get(2).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn11)
        }

        FlyRoundButton {
            id: btn12
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn11.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
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
    }

    // 4 row
    Rectangle {
        id: forthRow
        anchors.top: thirdRow.bottom
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.left: allBtn.right
        anchors.leftMargin: 30 * ScreenToolsController.ratio
        color: "transparent"
        width: 306 * ScreenToolsController.ratio
        height: 36 * ScreenToolsController.ratio
        property var group: QGroundControl.httpAPIManager.getUAVInfoManager().fourthUAVs
        property var  fourthVehicles: QGroundControl.multiVehicleManager.fourthVehicles
        property var count: fourthVehicles.count
        GroupButton {
            id: forthGroupBtn
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
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
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: forthGroupBtn.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? forthRow.fourthVehicles.get(0).id : ""//enabled ? forthRow.group.get(0).systemId : ""
            enabled: forthRow.count >= 1
            isLinked: text !== ""//enabled ? (forthRow.group.get(0).onLine && forthRow.group.get(0).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn13)
        }

        FlyRoundButton {
            id: btn14
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn13.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? forthRow.fourthVehicles.get(1).id : ""//enabled ? forthRow.group.get(1).systemId : ""
            enabled: forthRow.count >= 2
            isLinked: text !== ""//enabled ? (forthRow.group.get(1).onLine && forthRow.group.get(1).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn14)
        }

        FlyRoundButton {
            id: btn15
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn14.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
            text: enabled ? forthRow.fourthVehicles.get(2).id : ""//enabled ? forthRow.group.get(2).systemId : ""
            enabled: forthRow.count >= 3
            isLinked: text !== ""//enabled ? (forthRow.group.get(2).onLine && forthRow.group.get(2).linkConfig.isLinked) : false
            Component.onCompleted: _rootMultiControl.btnArr.push(btn15)
        }

        FlyRoundButton {
            id: btn16
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: btn15.right
            anchors.leftMargin: 20 * ScreenToolsController.ratio
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
    }

    ToolSeparator {
        id: toolSeparator
        anchors.verticalCenter: _rootMultiControl.verticalCenter
        anchors.right: takeoffBtn.left
        anchors.rightMargin: 20 * ScreenToolsController.ratio
        contentItem: Rectangle {
            implicitWidth: 1
            implicitHeight: 204 * ScreenToolsController.ratio
            color: "#118E9B"
        }
    }

    ActionButton {
        id: takeoffBtn
        anchors.top: parent.top
        anchors.topMargin: 30 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 30 * ScreenToolsController.ratio
        text: QGroundControl.defFlytouav() ? qsTr("强解锁") : qsTr("起飞")
        onClicked: {
            if (QGroundControl.defFlytouav()) {
                executeAction(forceArmAction)
            } else {
                executeAction(takeoffAction)
            }
        }
    }

    ActionButton {
        id: rtlBtn
        anchors.top: takeoffBtn.bottom
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 30 * ScreenToolsController.ratio
        text: qsTr("返航")
        onClicked: executeAction(rtlAction)
    }

    ActionButton {
        id: execBtn
        anchors.top: rtlBtn.bottom
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 30 * ScreenToolsController.ratio
        text: qsTr("执行")
        onClicked: executeAction(startMissionAction)
    }

    ActionButton {
        id: pauseBtn
        anchors.top: execBtn.bottom
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 30 * ScreenToolsController.ratio
        text: qsTr("暂停")
        onClicked: executeAction(pauseAction)
    }

}
