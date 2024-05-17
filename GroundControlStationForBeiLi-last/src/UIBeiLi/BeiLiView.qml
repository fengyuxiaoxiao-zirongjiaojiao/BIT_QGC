import QtQuick 2.10
import QtQuick.Window 2.14
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl                       1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.SettingsManager       1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    visible: true
    width: Screen.width
    height: Screen.height
    x: 0
    y: 0
    signal showFlyView()
    signal showPlanView()

    /*Button {
        id: closeBtn
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: parent.right
        anchors.rightMargin: 20
        width: 38
        height: 30

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: closeBtn.checked || closeBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : closeBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : "qrc:/qmlimages/BeiLi/icon_close_normal.png"
            width: closeBtn.width; height: closeBtn.height
        }

        onClicked: {
            close()
        }
    }

    Button {
        id: minimumBtn
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: closeBtn.left
        anchors.rightMargin: 12
        width: 38
        height: 30

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: minimumBtn.checked || minimumBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_minimize_checked.png" : minimumBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_minimize_checked.png" : "qrc:/qmlimages/BeiLi/icon_minimize_normal.png"
            width: minimumBtn.width; height: minimumBtn.height
        }

        onClicked: {
            showMinimized()
        }
    }*/

    HudView {
        id: hudView
        anchors.top: parent.top
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
    }

    ButtonBar {
        id: buttonBar
        anchors.top: hudView.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        height: 38 * ScreenToolsController.ratio
        width: 580 * ScreenToolsController.ratio
        firstText: qsTr("集群")
        secondText: flymode.flightMode
        thirdText: qsTr("调整")
        fourthText: qsTr("视角")
        fifthText: qsTr("航线")
        current: -1

        onCurrentChanged: {
            if (current === 4) {
                showPlanView()
            } else {
                showFlyView()
            }
        }
    }

    MultiControl {
        id: multiControl
        visible: buttonBar.current === 0 && buttonBar.visible
        anchors.top: buttonBar.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        width: buttonBar.width
        height: 264 * ScreenToolsController.ratio

    }

    FlyMode {
        id: flymode
        visible: buttonBar.current === 1  && buttonBar.visible
        anchors.top: buttonBar.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: columns === 1 ? 100 : (columns === 2 ? 40 : 10)
    }

    QuickSetup {
        id: quickSetup
        visible: buttonBar.current === 2  && buttonBar.visible
        anchors.top: buttonBar.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 158 * ScreenToolsController.ratio
        width: 236 * ScreenToolsController.ratio
        height: 244 * ScreenToolsController.ratio
    }

    ViewPointChange {
        id: viewPointChange
        visible: buttonBar.current === 3  && buttonBar.visible
        anchors.top: buttonBar.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 291 * ScreenToolsController.ratio
    }

    MissionPlanView {
        id: missionPlanView
        visible: buttonBar.current === 4 && buttonBar.visible
        anchors.top: buttonBar.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        width: buttonBar.width
        height: 324 * ScreenToolsController.ratio
    }

    StateView {
        id: viewState
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: parent.width
        height: 145 * ScreenToolsController.ratio
    }

    LoginView {
        id: loginView
        visible: false
        anchors.fill: parent
        onShowWebView: {
            loginView.visible = false
            webView.visible = true
        }
    }

    MessageButton {
        id: messageBtn
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: viewState.top
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        onClicked: {
            messageView.isExpand = false
            messageView.visible = !messageView.visible
        }
    }

    Rectangle {
        id: to3DBtn
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: messageBtn.top
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        width: 64 * ScreenToolsController.ratio
        height: width
        radius: width / 2
        color: "#07424F"
        visible: true
        property var mapView3d: QGroundControl.settingsManager.appSettings.mapView3d

        Image {
            anchors.centerIn: parent
            source: QGroundControl.settingsManager.appSettings.mapView3d.value ? "qrc:/qmlimages/BeiLi/btn_view2D.png" : "qrc:/qmlimages/BeiLi/btn_view3D.png"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                QGroundControl.settingsManager.appSettings.mapView3d.value = !QGroundControl.settingsManager.appSettings.mapView3d.value
            }
        }
    }

    Rectangle {
        id: viewRvizBtn
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: to3DBtn.top
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        width: 64 * ScreenToolsController.ratio
        height: width
        radius: width / 2
        color: "#07424F"
        visible: QGroundControl.rvizManager.rvizViewEnable
        Text {
            anchors.centerIn: parent
            text: "Rviz"
            color: "#08D3E5"
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 18 * ScreenToolsController.ratio
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                QGroundControl.rvizManager.rvizViewVisible = !QGroundControl.rvizManager.rvizViewVisible
            }
        }
    }

    MessageView {
        id: messageView
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: viewState.top
        anchors.bottomMargin: 5 * ScreenToolsController.ratio
    }

    LinkConfigView {
        id: linkConfigView
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: viewState.top
        anchors.bottomMargin: 5 * ScreenToolsController.ratio
    }

//    Component.onCompleted: {
//        showMaximized()
//    }


    BeiLiWebView {
        id:                     webView
        anchors.fill:           parent
        visible:                false
    }

    // Small mission download progress bar
    Rectangle {
        id:             progressBar
        anchors.left:   parent.left
        //anchors.right:  parent.right
        anchors.top:    parent.top
        height:         4 * ScreenToolsController.ratio
        width:          _controllerProgressPct * parent.width
        color:          "#00ff00"
        visible:        false

        property bool   _controllerValid:           _planMasterController !== undefined && _planMasterController !== null
        property var    _planMasterController:      globals.planMasterControllerPlanView
        property var    _missionController:         _planMasterController.missionController
        property real   _controllerProgressPct:     _controllerValid ? _planMasterController.missionController.progressPct : 0
        on_ControllerProgressPctChanged: {
            progressBar.visible = true
            if (_controllerProgressPct === 1) {
                resetProgressTimer.start()
            }
        }
    }
    Timer {
        id: resetProgressTimer
        running: false
        repeat: false
        interval: 2000
        onTriggered: {
            progressBar.visible = false
        }
    }

    // 测试GB10x云台功能
//    Rectangle {
//        id: testGB10x
//        anchors.right: parent.right
//        anchors.rightMargin: 10
//        anchors.bottom: messageBtn.top
//        anchors.bottomMargin: 10
//        width: 200
//        height: 60

//        TextInput {
//            id: statusInput
//            anchors.left: parent.left
//            anchors.leftMargin: 10
//            anchors.verticalCenter: parent.verticalCenter
//            width: 60
//            height: 40
//        }

//        Button {
//            id: statusButton
//            anchors.left: statusInput.right
//            anchors.leftMargin: 10
//            anchors.verticalCenter: parent.verticalCenter
//            text: qsTr("确定")
//            onClicked: {
//                var activeVehicle = QGroundControl.multiVehicleManager.activeVehicle
//                if (activeVehicle) {
//                    console.log(statusInput.text)
//                    activeVehicle.setCameraStatus(statusInput.text)
//                }
//            }
//        }
//    }
}
