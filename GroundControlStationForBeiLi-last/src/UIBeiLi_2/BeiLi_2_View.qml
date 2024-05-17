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
    id: _root

    property var    _planMasterController:      globals.planMasterControllerPlanView
    property bool   _controllerValid:           _planMasterController !== undefined && _planMasterController !== null
    property bool   _controllerOffline:         _controllerValid ? _planMasterController.offline : true
    property var    _controllerSyncInProgress:  _controllerValid ? _planMasterController.syncInProgress : false

    property var activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    property bool isPlanView: globals.beiLiPlanView.visible
    property bool isFlyView: globals.beiLiFlightView.visible
    signal showFlyView()
    signal showPlanView()
    signal closeBtnClicked()

    color: "transparent"

    QtObject {
        id: videoFact
        property var    _videoSettings:             QGroundControl.settingsManager.videoSettings
        property string _videoSource:               _videoSettings.videoSource.value
        property bool   _isGst:                     QGroundControl.videoManager.isGStreamer
        property bool   _isUDP264:                  _isGst && _videoSource === _videoSettings.udp264VideoSource
        property bool   _isUDP265:                  _isGst && _videoSource === _videoSettings.udp265VideoSource
        property bool   _isRTSP:                    _isGst && _videoSource === _videoSettings.rtspVideoSource
        property bool   _isTCP:                     _isGst && _videoSource === _videoSettings.tcpVideoSource
        property bool   _isMPEGTS:                  _isGst && _videoSource === _videoSettings.mpegtsVideoSource
        property bool   _videoAutoStreamConfig:     QGroundControl.videoManager.autoStreamConfigured
        property var    _videoStreamManager:        QGroundControl.videoManager
        property bool   _videoStreamRecording:      _videoStreamManager.recording
        property bool   _videoStreamAvailable:      _videoStreamManager.hasVideo
        property bool   _videoStreamIsStreaming:    _videoStreamManager.streaming
        property bool   _videoIsShow:               _videoSource !== _videoSettings.disabledVideoSource

        function showVideo(show) {
            if (show) {
                _videoSettings.videoSource.value = _videoSettings.rtspVideoSource
            } else {
                _videoSettings.videoSource.value = _videoSettings.disabledVideoSource
            }
        }
    }

    Rectangle {
        id: titleBarField
        color: "#07424F"
        opacity: 0.9

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        height: 60 * statusBarField.thisRatio

        Image {
            id: iconField
            source: "qrc:/res/resources/icons/BeiLi.png"

            width: 44 * statusBarField.thisRatio
            height: 44 * statusBarField.thisRatio

            sourceSize.width: width
            sourceSize.height: height

            anchors.left: parent.left
            anchors.leftMargin: 20 * statusBarField.thisRatio
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: titleTextField
            text: qsTr("北京理工大学")
            anchors.left: iconField.right
            anchors.leftMargin: 10 * statusBarField.thisRatio
            anchors.verticalCenter: parent.verticalCenter

            font.family: "MicrosoftYaHei"
            font.weight: Font.Normal
            font.pixelSize: 24 * statusBarField.thisRatio

            horizontalAlignment: Text.AlignLeft

            color: "#FFFFFF"
        }

        Rectangle {
            id: statusBarField
            property bool flag: (Screen.width / (Screen.height * 1.0)) > 1.6
            property real thisRatio: statusBarField.flag ? ScreenToolsController.ratio : (Screen.width / 1920.0)
            anchors.left: parent.left
            anchors.leftMargin: statusBarField.flag ? (260 * statusBarField.thisRatio) : (240 * statusBarField.thisRatio)
            anchors.right: parent.right
            anchors.rightMargin: statusBarField.flag ? (260 * statusBarField.thisRatio) : (200 * statusBarField.thisRatio)
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            color: "#053540"
            opacity: 0.9

            Row {
                // 显示飞行状态数据
                visible: isFlyView
                spacing: statusBarField.flag ? (20 * statusBarField.thisRatio) : (4 * statusBarField.thisRatio)
                anchors.left: parent.left
                anchors.leftMargin: 20 * statusBarField.thisRatio
                anchors.verticalCenter: parent.verticalCenter
                Repeater {
                    model: [
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_electricity.png",
                            fact1: (activeVehicle && activeVehicle.batteries.count > 0) ? activeVehicle.batteries.get(0).getFact("percentRemaining") : null,
                            fact2: null,
                            unit: "%",
                            title: qsTr("电量")
                        },
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_voltage.png",
                            fact1: (activeVehicle && activeVehicle.batteries.count > 0) ? activeVehicle.batteries.get(0).getFact("voltage") : null,
                            fact2: null,
                            unit: "V",
                            title: qsTr("电压")
                        },
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_gps.png",
                            fact1: activeVehicle ? activeVehicle.gps.getFact("count") : null,
                            fact2: activeVehicle ? activeVehicle.gps.getFact("hdop") : null,
                            unit: "",
                            title: qsTr("卫星")
                        },
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_gs.png",
                            //fact1: String("%1m/s").arg(activeVehicle ? activeVehicle.groundSpeed.floatStringValue : 0),
                            fact1: activeVehicle ? activeVehicle.groundSpeed : null,
                            fact2: null,
                            unit: "m/s",
                            title: qsTr("地速")
                        },
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_relativheight.png",
                            fact1: activeVehicle ? activeVehicle.altitudeRelative : null,
                            fact2: null,
                            unit: "m",
                            title: qsTr("相对高度")
                        },
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_absolutelyheight.png",
                            fact1: activeVehicle ? activeVehicle.altitudeAMSL : null,
                            fact2: null,
                            unit: "m",
                            title: qsTr("绝对高度")
                        },
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_heading.png",
                            //fact1: String("%1°").arg(activeVehicle ? activeVehicle.heading.floatStringValue : 0),
                            fact1: activeVehicle ? activeVehicle.heading : null,
                            fact2: null,
                            unit: "°",
                            title: qsTr("航向")
                        },
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_home.png",
                            fact1: activeVehicle ? activeVehicle.distanceToHome : null,
                            fact2: null,
                            unit: "m",
                            title: qsTr("家距里")
                        },
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_loaction.png",
                            //fact1: activeVehicle ? activeVehicle.distanceToNextWP : null, // 与下一个航点的距离
                            fact1: activeVehicle ? activeVehicle.distanceToNext : null, // 与下一个目标的距离，如航点、指点的距离
                            fact2: null,
                            unit: "m",
                            title: qsTr("航点")
                        },
                        {
                            icon:"qrc:/qmlimages/BeiLi_2/icon_time.png",
                            fact1: activeVehicle ? activeVehicle.flightTimeFact : null,
                            fact2: null,
                            unit: "",
                            title: qsTr("时长")
                        }

                    ]
                    delegate: Row {
                        spacing: 4 * statusBarField.thisRatio
                        anchors.verticalCenter: parent.verticalCenter
                        width: statusBarField.flag ? (100 * ScreenToolsController.ratio) : (90 * ScreenToolsController.ratio)
                        Image {
                            source: modelData.icon
                            width: 24 * statusBarField.thisRatio//ScreenToolsController.ratio
                            height: 24 * statusBarField.thisRatio//ScreenToolsController.ratio
                            sourceSize.width: width
                            sourceSize.height: height
                        }

                        Text {
                            text: //modelData.value.floatStringValue
                                {
                                var fact1 = modelData.fact1;
                                var fact2 = modelData.fact2;
                                //console.log("time:", activeVehicle.flightTimeFact.value, activeVehicle.flightTimeFact.valueString)
                                if (fact1 !== null) {
                                    var str = (fact1.typeIsFloat || fact1.typeIsDouble) ? fact1.value.toFixed(1) : (fact1.typeIsElapsedTimeInSeconds ? fact1.valueString : fact1.value)
                                    if (fact2 !== null) {
                                        str = String("%1 %2").arg(str).arg((fact2.typeIsFloat || fact2.typeIsDouble) ? fact2.value.toFixed(1) : fact2.value)
                                    }
                                    return String("%1%2").arg(str).arg(modelData.unit)
                                }

                                return "N/A"
                            }
                            height: 24 * statusBarField.thisRatio//ScreenToolsController.ratio

                            font.family: "MicrosoftYaHei"
                            font.weight: Font.Normal
                            font.pixelSize: 18 * ScreenToolsController.ratioFont

                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter

                            color: "#FFFFFF"
                        }
                    } // end  delegate
                }
            }

            BeiLiMissionInfo {
                id: missionItemInfo
                anchors.left: parent.left
                anchors.leftMargin: 20 * ScreenToolsController.ratio
                anchors.verticalCenter: parent.verticalCenter
                visible: isPlanView
                width: parent.width
                height: parent.height
                pixelSize: 18 * ScreenToolsController.ratioFont
            }

            Rectangle {
                property bool hovered: false
                color: hovered ? "#07424F" : "transparent"
                opacity: hovered ? 0.9 : 1
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 100 * statusBarField.thisRatio
                Text {
                    id: flyModeTextField
                    text:   activeVehicle ? activeVehicle.flightModeZh : qsTr("Unknown")
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter

                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Normal
                    font.pixelSize: 18 * ScreenToolsController.ratioFont

                    horizontalAlignment: Text.AlignLeft

                    color: "#FFFFFF"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        if(activeVehicle && isFlyView) flightModeListFiled.visible = !flightModeListFiled.visible
                        else flightModeListFiled.visible = false
                        console.log(qsTr("点击了飞行模式"))
                    }
                }
            } // flightmode rectangle
        }

        Row {
            anchors.right: parent.right
            anchors.rightMargin: statusBarField.flag ? (20 * statusBarField.thisRatio) : (8 * statusBarField.thisRatio)
            anchors.verticalCenter: parent.verticalCenter
            spacing: statusBarField.flag ? (20 * statusBarField.thisRatio) : (8 * statusBarField.thisRatio)

            Image {
                id: messageImage
                property bool hovered: false
                source: "qrc:/qmlimages/BeiLi_2/icon_news.png"
                opacity: hovered ? 0.5 : 1
                width: 30 * statusBarField.thisRatio
                height: 30 * statusBarField.thisRatio
                sourceSize.width: width
                sourceSize.height: height
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        console.log(qsTr("显示消息列表"))
                        if (activeVehicle && isFlyView) messageView.visible = !messageView.visible
                        else messageView.visible = false
                    }
                }
            }

            Rectangle {
                id: loginFiled
                width: 100 * statusBarField.thisRatio
                height: 32 * statusBarField.thisRatio
                color: "transparent"
                anchors.verticalCenter: parent.verticalCenter
                property bool hovered: false

                Row {
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 10 * ScreenToolsController.ratio
                    Image {
                        id: loginFiledImage
                        source: "qrc:/qmlimages/BeiLi_2/icon_head.png"
                        opacity: loginFiled.hovered ? 0.5 : 1
                        width: 30 * statusBarField.thisRatio
                        height: 30 * statusBarField.thisRatio
                        sourceSize.width: width
                        sourceSize.height: height
                    }

                    Text {
                        id: loginFiledText
                        height: parent.height
                        text: QGroundControl.httpAPIManager.getUserManager().isLogin ? "已登录" : "未登录"
                        opacity: loginFiled.hovered ? 0.5 : 1
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter

                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Normal
                        font.pixelSize: 16 * statusBarField.thisRatio
                        color: "#FFFFFF"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked: {
                        console.log(qsTr("登录用户"))
                        loginView.visible = true
                    }
                }
            }

            Rectangle {
                // split
                height: 32 * ScreenToolsController.ratio
                anchors.verticalCenter: parent.verticalCenter
                width: 2
                color: "#6FC3CA"
            }

            Image {
                id: closeBtnImage
                property bool hovered: false
                source: "qrc:/qmlimages/BeiLi_2/icon_exit.png"
                opacity: hovered ? 0.5 : 1
                width: 30 * statusBarField.thisRatio
                height: 30 * statusBarField.thisRatio
                sourceSize.width: width
                sourceSize.height: height
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: parent.hovered = true
                    onExited: parent.hovered = false
                    onClicked:  {
                        console.log(qsTr("退出程序"))
                        closeBtnClicked()
                    }
                }
            }

        }

    } // header

    // 姿态窗
    //    AttitudeView {
    //        size: 160 * ScreenToolsController.ratio
    //        vehicle: activeVehicle
    //        anchors.top: titleBarField.bottom
    //        anchors.topMargin: 30 * ScreenToolsController.ratio
    //        anchors.left: parent.left
    //        anchors.leftMargin: 30 * ScreenToolsController.ratio
    //        visible: (QGroundControl.settingsManager.appSettings.bootAppMode === 1 && isFlyView)
    //    }
    Item {
        anchors.top: titleBarField.bottom
        anchors.topMargin: 30 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 30 * ScreenToolsController.ratio
        width: 352 * ScreenToolsController.ratio
        height: 180 * ScreenToolsController.ratio
        visible: (QGroundControl.settingsManager.appSettings.bootAppMode === 1 && isFlyView)

        Rectangle {
            color: "#07424F"
            opacity: 0.8
            anchors.fill: parent
            radius: parent.width / 2
            border.width: 2
            border.color: "#08D3E5"
        }

        Row {
            anchors.centerIn: parent
            spacing: (parent.width - 160 * 2 * ScreenToolsController.ratio) / 3
            AttitudeView {
                vehicle: activeVehicle
                size: 160 * ScreenToolsController.ratio
            }

            BeiLi_2_CompassView {
                size: 160 * ScreenToolsController.ratio
                yawAngle: activeVehicle ? activeVehicle.heading.value : 0
                microphoneAngle: activeVehicle ? activeVehicle.soundHeadingFact.value : 0
            }
        }
    }

    // 集群姿态窗
    HudView {
        id: hudView
        anchors.top: titleBarField.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        visible: (QGroundControl.settingsManager.appSettings.bootAppMode === 2 && isFlyView)
    }

    // 模式列表
    Rectangle {
        id: flightModeListFiled
        visible: false
        width: 200 * ScreenToolsController.ratio
        height: flightModeColumn.height
        anchors.top: titleBarField.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: (260 * ScreenToolsController.ratio + 100 / 2 * ScreenToolsController.ratio) - width / 2
        color: "#053540"
        opacity: 0.9
        Column {
            id: flightModeColumn
            spacing: 0
            Repeater {
                model: activeVehicle ? activeVehicle.flightModesZhForSimple : []
                Rectangle {
                    property bool hovered: false
                    property string flightMode: modelData
                    width: flightModeListFiled.width
                    height: 40 * ScreenToolsController.ratio
                    color: hovered ? "#25F085" : "transparent"
                    opacity: 0.9

                    Text {
                        text: flightMode
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Normal
                        font.pixelSize: 18 * ScreenToolsController.ratioFont
                        color: "#FFFFFF"
                    }
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: parent.hovered = true
                        onExited: parent.hovered = false
                        onClicked: activeVehicle.flightModeZh = flightMode;
                    }
                }
            }
        }
    }

    // 工具列表
    Column {
        id: toolsFiled
        anchors.top: titleBarField.bottom
        anchors.topMargin: 50 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 20 * ScreenToolsController.ratio

        spacing: 20 * ScreenToolsController.ratio
        Rectangle { // 下拉按钮
            id: openToolsBtn
            property bool hovered: false
            property bool checked: false
            visible: (globals.beiLiFlightView.videoControl.pipState.state !== globals.beiLiFlightView.videoControl.pipState.fullState)
            anchors.horizontalCenter: parent.horizontalCenter
            width: 30 * ScreenToolsController.ratio
            height: 30 * ScreenToolsController.ratio
            color: "#053540"
            opacity: 0.8
            radius: width / 2
            Image {
                anchors.centerIn: parent
                source: parent.checked ? "qrc:/qmlimages/BeiLi_2/icon_fold.png" : "qrc:/qmlimages/BeiLi_2/icon_unfold.png"
                width: 12 * ScreenToolsController.ratio
                height: 6 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                opacity: parent.hovered ? 0.5 : 1
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked:  {
                    parent.checked = ! parent.checked
                    if (!parent.checked) { // 如果下拉按钮为上拉状态，则修改列表中部分按钮的状态为unchecked
                        deviceConnectBtn.checked = false
                        changeViewPointBtn.checked = false
                        multVehicleBtn.checked = false
                        adjustParameBtn.checked = false
                    }
                }
            }
        }

        // 飞行界面的工具列表
        Rectangle {
            visible: openToolsBtn.checked && (globals.beiLiFlightView.videoControl.pipState.state !== globals.beiLiFlightView.videoControl.pipState.fullState) && isFlyView
            color: "#07424F"
            opacity: 0.9
            width: 84 * ScreenToolsController.ratio
            //height: 391 * ScreenToolsController.ratio
            height: flyViewToolsColumn.height + 20 * ScreenToolsController.ratio
            radius: 5 * ScreenToolsController.ratio

            Column {
                id: flyViewToolsColumn
                spacing: 10 * ScreenToolsController.ratio
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10 * ScreenToolsController.ratio
                BeiLi_2_ToolBtn {
                    id: deviceConnectBtn
                    icon: "qrc:/qmlimages/BeiLi_2/icon_equipment_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/icon_equipment_sel.png"
                    text: qsTr("设备")
                    checkEnabled: true
                    onClicked: {
                        changeViewPointBtn.checked = false
                        multVehicleBtn.checked = false
                        adjustParameBtn.checked = false
                    }
                }

                BeiLi_2_ToolBtn {
                    id: multVehicleBtn
                    visible: QGroundControl.settingsManager.appSettings.bootAppMode === 2
                    icon: "qrc:/qmlimages/BeiLi_2/icon_multi_vehicle_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/icon_multi_vehicle_sel.png"
                    text: qsTr("集群")
                    checkEnabled: true
                    onClicked: {
                        deviceConnectBtn.checked = false
                        changeViewPointBtn.checked = false
                        adjustParameBtn.checked = false
                    }
                }

                BeiLi_2_ToolBtn {
                    id: changeViewPointBtn
                    icon: "qrc:/qmlimages/BeiLi_2/icon_view_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/icon_view_sel.png"
                    text: qsTr("视角")
                    checkEnabled: true
                    onClicked: {
                        deviceConnectBtn.checked = false
                        multVehicleBtn.checked = false
                        adjustParameBtn.checked = false
                    }
                }

                BeiLi_2_ToolBtn {
                    id: adjustParameBtn
                    visible: QGroundControl.settingsManager.appSettings.bootAppMode === 2
                    icon: "qrc:/qmlimages/BeiLi_2/icon_adjust_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/icon_adjust_sel.png"
                    text: qsTr("调整")
                    checkEnabled: true
                    onClicked: {
                        deviceConnectBtn.checked = false
                        changeViewPointBtn.checked = false
                        multVehicleBtn.checked = false
                    }
                }

                BeiLi_2_ToolBtn {
                    id: missionPlanBtn
                    icon: "qrc:/qmlimages/BeiLi_2/icon_routes_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/icon_routes_sel.png"
                    text: qsTr("航线")
                    checkEnabled: false
                    onClicked: {
                        deviceConnectBtn.checked = false
                        changeViewPointBtn.checked = false
                        multVehicleBtn.checked = false
                        adjustParameBtn.checked = false
                        showPlanView()
                    }
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: missionPlanBtn.width / 2
                    height: 1
                    color: "#70A0A4"
                }

                BeiLi_2_ToolBtn {
                    id: showVideoBtn
                    icon: "qrc:/qmlimages/BeiLi_2/icon_video_close.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/icon_video_open.png"
                    text: qsTr("视频")
                    checkEnabled: true
                    checked: videoFact._videoIsShow
                    onCheckedChanged: {
                        deviceConnectBtn.checked = false
                        changeViewPointBtn.checked = false
                        multVehicleBtn.checked = false
                        adjustParameBtn.checked = false
                        videoFact.showVideo(checked)
                    }
                }

                BeiLi_2_ToolBtn {
                    id: pointCloundBtn
                    icon: "qrc:/qmlimages/BeiLi_2/icon_pointCloud_close.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/icon_pointCloud_open.png"
                    text: qsTr("点云")
                    checkEnabled: true
                    onCheckedChanged: {
                        deviceConnectBtn.checked = false
                        changeViewPointBtn.checked = false
                        multVehicleBtn.checked = false
                        adjustParameBtn.checked = false
                        globals.isPointCloud = checked
                    }
                }

            }

        } // 飞行界面的工具列表

        // 规划界面的工具列表
        Rectangle {
            id: missionPlanTools
            visible: openToolsBtn.checked && isPlanView
            color: "#07424F"
            opacity: 0.9
            width: 84 * ScreenToolsController.ratio
            //height: 391 * ScreenToolsController.ratio
            height: planViewToolsColumn.height + 20 * ScreenToolsController.ratio
            radius: 5 * ScreenToolsController.ratio

            Column {
                id: planViewToolsColumn
                spacing: 10 * ScreenToolsController.ratio
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10 * ScreenToolsController.ratio
                BeiLi_2_ToolBtn {
                    id: missionUploadBtn
                    icon: "qrc:/qmlimages/BeiLi_2/route_icon_upload_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/route_icon_upload_sel.png"
                    text: qsTr("上传")
                    checkEnabled: false
                    enabled: !_controllerOffline && !_controllerSyncInProgress && _planMasterController.containsItems
                    onClicked: _planMasterController.upload() // 上传当前航线到当前飞机
                }

                BeiLi_2_ToolBtn {
                    id: missionDownloadBtn
                    icon: "qrc:/qmlimages/BeiLi_2/route_icon_download_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/route_icon_download_sel.png"
                    text: qsTr("下载")
                    checkEnabled: false
                    enabled: !_controllerOffline && !_controllerSyncInProgress
                    onClicked:  {
                        if (_planMasterController.dirty) {
                            console.log("下载，是否覆盖？")
                            // 提示是否覆盖
                            //mainWindow.showComponentDialog(globals.beiLiPlanView.syncLoadFromVehicleOverwrite, qsTr("Mission overwrite"), mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                            _planMasterController.loadFromVehicle()
                        } else {
                            _planMasterController.loadFromVehicle()
                        }
                    }
                }

                BeiLi_2_ToolBtn {
                    id: missionImportBtn
                    icon: "qrc:/qmlimages/BeiLi_2/route_icon_import_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/route_icon_import_sel.png"
                    text: qsTr("导入")
                    checkEnabled: false
                    enabled: !_controllerSyncInProgress
                    onClicked: {
                        if (_planMasterController.dirty) {
                            console.log("导入，是否覆盖？")
                            // 提示是否覆盖
                            //mainWindow.showComponentDialog(globals.beiLiPlanView.syncLoadFromFileOverwrite, columnHolder._overwriteText, mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                            _planMasterController.loadFromSelectedFile()
                        } else {
                            _planMasterController.loadFromSelectedFile()
                        }
                    }
                }

                BeiLi_2_ToolBtn {
                    id: missionExportBtn
                    icon: "qrc:/qmlimages/BeiLi_2/route_icon_export_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/route_icon_export_sel.png"
                    text: qsTr("导出")
                    checkEnabled: false
                    enabled: !_controllerSyncInProgress && _planMasterController.containsItems
                    onClicked: {
                        _planMasterController.saveToSelectedFile()
                    }
                }

                BeiLi_2_ToolBtn {
                    id: missionCleanBtn
                    icon: "qrc:/qmlimages/BeiLi_2/route_icon_clear_nor.png"
                    iconChecked: "qrc:/qmlimages/BeiLi_2/route_icon_clear_sel.png"
                    text: qsTr("清除")
                    checkEnabled: false
                    onClicked: {
                        _planMasterController.removeAll()
                        QGroundControl.kmlManager.polygon.clear()
                        QGroundControl.kmlManager.polyline.clear()
                        //QGroundControl.webMsgManager.RemoveAll()
                    }
                }

            }

        } // 规划界面的工具列表
    } // 工具列表

    Rectangle {
        id: pictureAndVideoRecordPanel
        visible: globals.beiLiFlightView.videoControl.pipState.state === globals.beiLiFlightView.videoControl.pipState.fullState
        color: "#07424F"
        opacity: 0.9
        width: 84 * ScreenToolsController.ratio
        height: 158 * ScreenToolsController.ratio
        radius: 5 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Column {
            spacing: 10 * ScreenToolsController.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 10 * ScreenToolsController.ratio
            BeiLi_2_ToolBtn {
                id: takePictureBtn
                icon: "qrc:/qmlimages/BeiLi_2/icon_photograph_nor.png"
                iconChecked: "qrc:/qmlimages/BeiLi_2/icon_photograph_sel.png"
                text: qsTr("拍照")
                checkEnabled: false
                onClicked: {
                    console.log("拍照")
                    QGroundControl.videoManager.grabImage()
                }
            }

            BeiLi_2_ToolBtn {
                id: recordVideoBtn
                icon: "qrc:/qmlimages/BeiLi_2/icon_recording_nor.png"
                iconChecked: "qrc:/qmlimages/BeiLi_2/icon_recording_sel.png"
                text: qsTr("录像")
                checkEnabled: true
                checked: QGroundControl.videoManager.recording
                onClicked: {
                    console.log("录像")
                    if (QGroundControl.videoManager.recording) {
                        QGroundControl.videoManager.stopRecording()
                    } else {
                        QGroundControl.videoManager.startRecording()
                    }
                }
            }
        }// Column

    } // 拍照录像

    // 连接窗口
    BeiLi_2_LinkConfigView {
        id: linkConfigView
        anchors.top: parent.top
        anchors.topMargin: 160 * ScreenToolsController.ratio
        anchors.right: toolsFiled.left
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        visible: openToolsBtn.checked && deviceConnectBtn.checked
    }

    ViewPointChange {
        id: viewPointChange
        visible: openToolsBtn.checked && changeViewPointBtn.checked
        anchors.top: parent.top
        anchors.topMargin: 160 * ScreenToolsController.ratio
        anchors.right: toolsFiled.left
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        version: 2
    }

    BeiLi_2_MultiControlView {
        id: multiControlView
        visible: openToolsBtn.checked && multVehicleBtn.checked
        anchors.top: parent.top
        anchors.topMargin: 160 * ScreenToolsController.ratio
        anchors.right: toolsFiled.left
        anchors.rightMargin: 10 * ScreenToolsController.ratio
    }

    BeiLi_2_QuickSetupView {
        id: quickSetupView
        visible: openToolsBtn.checked && adjustParameBtn.checked
        anchors.top: parent.top
        anchors.topMargin: 160 * ScreenToolsController.ratio
        anchors.right: toolsFiled.left
        anchors.rightMargin: 10 * ScreenToolsController.ratio
    }

    BeiLi_2_MissionPlanView {
        id: missionPlanView
        visible: missionPlanTools.visible
        anchors.top: parent.top
        anchors.topMargin: 160 * ScreenToolsController.ratio
        anchors.right: toolsFiled.left
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        onShowFlyView: _root.showFlyView()
    }

    // 界面下方的一行按钮
    Row {
        id: actionBtnList
        visible: isFlyView
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30 * ScreenToolsController.ratio
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 40 * ScreenToolsController.ratio

        Rectangle {
            id: actionBtn
            property bool hovered: false
            //enabled: activeVehicle ? true : false
            enabled:    globals.beiLiFlightView._guidedController.showStartMission || globals.beiLiFlightView._guidedController.showContinueMission
            color: "#07424F"
            opacity: 0.8
            width: 72 * ScreenToolsController.ratio
            height: 72 * ScreenToolsController.ratio
            radius: 8 * ScreenToolsController.ratio

            Image {
                source: parent.enabled ? "qrc:/qmlimages/BeiLi_2/icon_action_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_action_ban.png"
                width: 44 * ScreenToolsController.ratio
                height: 44 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: {
                    //activeVehicle.startMission()
                    globals.beiLiFlightView._guidedController.closeAll()
                    if (globals.beiLiFlightView._guidedController.showStartMission) {
                        globals.beiLiFlightView._guidedController.confirmAction(globals.beiLiFlightView._guidedController.actionStartMission)
                    } else if (globals.beiLiFlightView._guidedController.showContinueMission) {
                        globals.beiLiFlightView._guidedController.confirmAction(globals.beiLiFlightView._guidedController.actionContinueMission)
                    }
                }
            }
        }

        Rectangle {
            id: rtlBtn
            property bool hovered: false
            //enabled: (activeVehicle && activeVehicle.flying) ? true : false
            enabled: globals.beiLiFlightView._guidedController.showRTL
            color: "#07424F"
            opacity: 0.8
            width: 72 * ScreenToolsController.ratio
            height: 72 * ScreenToolsController.ratio
            radius: 8 * ScreenToolsController.ratio

            Image {
                source: parent.enabled ? "qrc:/qmlimages/BeiLi_2/icon_back_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_back_ban.png"
                width: 44 * ScreenToolsController.ratio
                height: 44 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: {
                    //activeVehicle.guidedModeRTL(false)
                    globals.beiLiFlightView._guidedController.closeAll()
                    globals.beiLiFlightView._guidedController.confirmAction(globals.beiLiFlightView._guidedController.actionRTL)
                }
            }
        }

        Rectangle {
            id: pauseBtn
            property bool hovered: false
            //enabled: (activeVehicle && activeVehicle.flying) ? true : false
            enabled:    globals.beiLiFlightView._guidedController.showPause
            color: "#07424F"
            opacity: 0.8
            width: 72 * ScreenToolsController.ratio
            height: 72 * ScreenToolsController.ratio
            radius: 8 * ScreenToolsController.ratio

            Image {
                source: parent.enabled ? "qrc:/qmlimages/BeiLi_2/icon_stop_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_stop_ban.png"
                width: 24 * ScreenToolsController.ratio
                height: 32 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: {
                    //activeVehicle.pauseVehicle()
                    globals.beiLiFlightView._guidedController.closeAll()
                    globals.beiLiFlightView._guidedController.confirmAction(globals.beiLiFlightView._guidedController.actionPause)
                }
            }
        }

        Rectangle {
            id: toCarBtn
            property bool hovered: false
            property bool isCar: (activeVehicle && activeVehicle.isCar)
            enabled: (globals.beiLiFlightView._guidedController.showToCar || globals.beiLiFlightView._guidedController.showToPlan)//activeVehicle ? true : false
            color: "#07424F"
            opacity: 0.8
            width: 72 * ScreenToolsController.ratio
            height: 72 * ScreenToolsController.ratio
            radius: 8 * ScreenToolsController.ratio

            Image {
                source: {
                    if (parent.isCar) {
                        return parent.enabled ? "qrc:/qmlimages/BeiLi_2/icon_land_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_land_ban.png"
                    } else {
                        return parent.enabled ? "qrc:/qmlimages/BeiLi_2/icon_air_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_air_ban.png"
                    }
                }
                width: 44 * ScreenToolsController.ratio
                height: 44 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: {
                    //activeVehicle.isCar = !activeVehicle.isCar
                    globals.beiLiFlightView._guidedController.closeAll()
                    if (parent.isCar) {
                        globals.beiLiFlightView._guidedController.confirmAction(globals.beiLiFlightView._guidedController.actionToPlan)
                        console.log("To Plan")
                    } else {
                        globals.beiLiFlightView._guidedController.confirmAction(globals.beiLiFlightView._guidedController.actionToCar)
                        console.log("To Car")
                    }
                }
            }
        }

        Rectangle { // 回机巢
            id: gotoNestBtn
            property bool hovered: false
            enabled: globals.beiLiFlightView._guidedController.showGotoNest
            color: "#07424F"
            opacity: 0.8
            width: 72 * ScreenToolsController.ratio
            height: 72 * ScreenToolsController.ratio
            radius: 8 * ScreenToolsController.ratio

            Image {
                source: parent.enabled ? "qrc:/qmlimages/BeiLi_2/icon_gotoNest_nor.png" : "qrc:/qmlimages/BeiLi_2/icon_gotoNest_ban.png"
                width: 44 * ScreenToolsController.ratio
                height: 44 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: {
                    globals.beiLiFlightView._guidedController.closeAll()
                    globals.beiLiFlightView._guidedController.confirmAction(globals.beiLiFlightView._guidedController.actionGotoNest)
                }
            }
        }

    } // end 界面下方的一行按钮

    MessageView {
        id: messageView
        visible: false
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5 * ScreenToolsController.ratio
    }

    LoginView {
        id: loginView
        visible: false
        anchors.top: titleBarField.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        onShowWebView: {
            loginView.visible = false
            webView.visible = true
        }
    }


    BeiLiWebView {
        id:                     webView
        anchors.top: titleBarField.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible:                false
    }

}
