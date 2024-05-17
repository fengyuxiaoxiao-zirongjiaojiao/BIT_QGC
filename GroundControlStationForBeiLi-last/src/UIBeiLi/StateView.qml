import QtQuick 2.0
import QtQuick.Controls 2.14
import QtLocation       5.3
import QtPositioning    5.3
import QtGraphicalEffects 1.0

import QGroundControl                       1.0
import QGroundControl.Vehicle               1.0
import QGroundControl.HttpAPIManager        1.0
import QGroundControl.SettingsManager       1.0
import QGroundControl.ScreenToolsController 1.0

Rectangle {

    property var  _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property int _defaultMargin: 10 * ScreenToolsController.ratio

    property var _battery_1: _activeVehicle && _activeVehicle.batteries.count ? _activeVehicle.batteries.get(0) : undefined
    property var _current: _battery_1 ? _battery_1.current.floatStringValue : 0
    property var _voltage: _battery_1 ? _battery_1.voltage.floatStringValue : 0
    property int _percentRemaining: _battery_1 ? _battery_1.percentRemaining.value : 0
    property var _timeRemaining: /*_battery_1 ? _battery_1.timeRemainingStr.value :*/ "--:--:--"
    property var _activeVehicleCoordinate:   _activeVehicle ? _activeVehicle.coordinate : QtPositioning.coordinate()

    color: "transparent"


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

    MouseArea {
        anchors.fill: parent
        onPressed: {}
        onWheel: {}
    }

    Image {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        source: "qrc:/qmlimages/BeiLi/frame.png"
        width: 1921 * ScreenToolsController.ratio
        height: 145 * ScreenToolsController.ratio
    }

    Slider {
          id: zoomControl
          from: -1.0
          value: 0
          to: 1.0
          anchors.left: parent.left
          anchors.leftMargin: 10 * ScreenToolsController.ratio
          anchors.bottom: zoomValue.top
          anchors.bottomMargin: 6 * ScreenToolsController.ratio
          orientation: Qt.Vertical

          background: Rectangle {
              x: zoomControl.leftPadding + zoomControl.availableWidth / 2 - width / 2
              y: zoomControl.topPadding
              implicitWidth: 2 * ScreenToolsController.ratio
              implicitHeight: 100 * ScreenToolsController.ratio
              width: implicitWidth
              height: zoomControl.availableHeight
              //radius: 2
              color: "#39dcea"

              Rectangle {
                  width: parent.width
                  height: zoomControl.visualPosition * parent.height
                  color: "#39dcea"
                  //radius: 2
              }
          }

          handle: Rectangle {
              x: zoomControl.topPadding + zoomControl.availableWidth / 2 - width / 2
              y: zoomControl.leftPadding + zoomControl.visualPosition * (zoomControl.availableHeight - height)
              width: 48 * ScreenToolsController.ratio
              height: 24 * ScreenToolsController.ratio
              implicitWidth: 48 * ScreenToolsController.ratio
              implicitHeight: 24 * ScreenToolsController.ratio
              radius: 13 * ScreenToolsController.ratio
              Image {
                  source: "qrc:/qmlimages/BeiLi/slider_pitch.png"
                  width: parent.width;
                  height: parent.height
                  sourceSize.width: width
                  sourceSize.height: height
                  //border.left: 5 * ScreenToolsController.ratio; border.top: 5 * ScreenToolsController.ratio
                  //border.right: 5 * ScreenToolsController.ratio; border.bottom: 5 * ScreenToolsController.ratio
              }
          }

          onValueChanged: {
              //console.log(value)
              if (_activeVehicle) {
                  _activeVehicle.beiliGimbalMountControl(value)
              }
          }
      }

    Text {
        id: zoomValue
        text: qsTr("俯仰")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 20 * ScreenToolsController.ratio
        font.pixelSize: 16 * ScreenToolsController.ratio
        font.family: "Microsoft YaHei"
        font.weight: Font.Normal
        color: "#08D3E5"
    }

//    Timer {
//        interval: 40 // ms 25Hz
//        running:  true
//        repeat: true
//        onTriggered: {
//            console.log("debug:", gimbalStick.yAxis, gimbalStick.xAxis)
//        }
//    }

    // 云台控制  虚拟摇杆
    Joystick {
        id: gimbalStick
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 13 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 80 * ScreenToolsController.ratio
        width: 140 * ScreenToolsController.ratio
        height: 140 * ScreenToolsController.ratio
    }

    RoundButton {
        id: videoRecordBtn
        width: 32 * ScreenToolsController.ratio
        height: 32 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 239 * ScreenToolsController.ratio
        background: Rectangle {
            color: "transparent"
        }

        BorderImage {
            source: _videoStreamRecording ? "qrc:/qmlimages/BeiLi/icon_pause.png" : "qrc:/qmlimages/BeiLi/icon_record.png"
            width: videoRecordBtn.width; height: videoRecordBtn.height
        }

        onClicked: {
            if (_videoStreamAvailable && _videoStreamIsStreaming) {
                if (_videoStreamRecording) {
                    _videoStreamManager.stopRecording()
                } else {
                    _videoStreamManager.startRecording()
                }
            }
        }
    }

    Button {
        id: showVideoBtn
        width: 32 * ScreenToolsController.ratio
        height: 32 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 47 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 239 * ScreenToolsController.ratio
        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: "qrc:/qmlimages/BeiLi/icon_video.png"
            width: showVideoBtn.width; height: showVideoBtn.height
            border.left: 5 * ScreenToolsController.ratio; border.top: 5 * ScreenToolsController.ratio
            border.right: 5 * ScreenToolsController.ratio; border.bottom: 5 * ScreenToolsController.ratio
        }

        onClicked: {
            if (_videoSource === _videoSettings.disabledVideoSource) {
                _videoSettings.videoSource.value = _videoSettings.rtspVideoSource
            } else {
                _videoSettings.videoSource.value = _videoSettings.disabledVideoSource
            }
        }
    }


    Grid {
        id: smallLabelLeftInfo
        rows: 2
        columns: 3
        rowSpacing: 10 * ScreenToolsController.ratio
        columnSpacing: 30 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio

        anchors.left: parent.left
        anchors.leftMargin: 296 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 90 * ScreenToolsController.ratio

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_gps.png"
            title: qsTr("卫星")
            value: String("%1  %2").arg(_activeVehicle ? _activeVehicle.gps.count.value : 0).arg(_activeVehicle ? _activeVehicle.gps.hdop.value : 0)
            unit: ""
        }

        SmallLabel {
            width: 126 * ScreenToolsController.ratio
            icon: ""
            title: qsTr("Lon")
            value: _activeVehicleCoordinate.longitude
            unit: ""
        }

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_home.png"
            title: qsTr("家")
            value: _activeVehicle ? _activeVehicle.distanceToHome.floatStringValue : "0.0"
            unit: "m"
        }

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_gps.png"
            title: qsTr("卫星")
            value: String("%1  %2").arg(_activeVehicle ? _activeVehicle.gps2.count.value : 0).arg(_activeVehicle ? _activeVehicle.gps2.hdop.value : 0)
            unit: ""
        }

        SmallLabel {
            width: 126 * ScreenToolsController.ratio
            icon: ""
            title: qsTr("Lat")
            value: _activeVehicleCoordinate.latitude
            unit: ""
        }

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_loaction.png"
            title: qsTr("航点")
            value: _activeVehicle ? _activeVehicle.distanceToNextWP.floatStringValue : "0.0"
            unit: "m"
        }

    }

    Item {
        id: batteryInfo
        width: 56 * ScreenToolsController.ratio
        height: 98 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 720 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 46 * ScreenToolsController.ratio

        Image {
            id: batteryBg
            source: "qrc:/qmlimages/BeiLi/icon_battery_bg.png"
            width: 56 * ScreenToolsController.ratio
            height: 33 * ScreenToolsController.ratio
            sourceSize.width: width
            sourceSize.height: height
            anchors.top: parent.top
            anchors.left: parent.left
            //visible: _percentRemaining > 20

            Image {
                id: lowPowerWarning
                source: "qrc:/qmlimages/BeiLi/icon_battery_warning.png"
                width: 21 * ScreenToolsController.ratio
                height: 18 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.top: parent.top
                anchors.topMargin: parent.height / 2
                anchors.left: parent.left
                anchors.leftMargin: 7 * ScreenToolsController.ratio
                visible: _percentRemaining <= 20
            }

            Image {
                id: tick1
                source: "qrc:/qmlimages/BeiLi/icon_battery_tick.png"
                width: 6 * ScreenToolsController.ratio
                height: 17 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.left: parent.left
                anchors.leftMargin: 7 * ScreenToolsController.ratio
                anchors.verticalCenter: parent.verticalCenter
                visible: true
            }
            Image {
                id: tick2
                source: "qrc:/qmlimages/BeiLi/icon_battery_tick.png"
                width: 6 * ScreenToolsController.ratio
                height: 17 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.left: tick1.right
                anchors.leftMargin: 2 * ScreenToolsController.ratio
                anchors.verticalCenter: parent.verticalCenter
                visible: _percentRemaining >= 40
            }

            Image {
                id: tick3
                source: "qrc:/qmlimages/BeiLi/icon_battery_tick.png"
                width: 6 * ScreenToolsController.ratio
                height: 17 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.left: tick2.right
                anchors.leftMargin: 2 * ScreenToolsController.ratio
                anchors.verticalCenter: parent.verticalCenter
                visible: _percentRemaining >= 60
            }

            Image {
                id: tick4
                source: "qrc:/qmlimages/BeiLi/icon_battery_tick.png"
                width: 6 * ScreenToolsController.ratio
                height: 17 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.left: tick3.right
                anchors.leftMargin: 2 * ScreenToolsController.ratio
                anchors.verticalCenter: parent.verticalCenter
                visible: _percentRemaining >= 80
            }

            Image {
                id: tick5
                source: "qrc:/qmlimages/BeiLi/icon_battery_tick.png"
                width: 6 * ScreenToolsController.ratio
                height: 17 * ScreenToolsController.ratio
                sourceSize.width: width
                sourceSize.height: height
                anchors.left: tick4.right
                anchors.leftMargin: 2 * ScreenToolsController.ratio
                anchors.verticalCenter: parent.verticalCenter
                visible: _percentRemaining >= 100
            }
        }

        Text {
            id: percentRemainingValue
            text: String("%1%").arg(_percentRemaining)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: batteryBg.bottom
            anchors.topMargin: 10 * ScreenToolsController.ratio
            font.pixelSize: 24 * ScreenToolsController.ratio
            font.family: "Microsoft YaHei"
            font.weight: Font.Normal
            color: "#B2F9FF"
        }

        Text {
            id: percentRemainingTitle
            text: qsTr("电量")
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: percentRemainingValue.bottom
            //anchors.topMargin: 10
            font.pixelSize: 10 * ScreenToolsController.ratio
            font.family: "Microsoft YaHei"
            font.weight: Font.Normal
            color: "#08D3E5"
        }

    }

    Grid {
        id: largeLabelInfo
        rows: 2
        columns: 3
        rowSpacing: 10 * ScreenToolsController.ratio
        columnSpacing: 36 * ScreenToolsController.ratio
        anchors.left: batteryInfo.right
        anchors.leftMargin: 36 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 34 * ScreenToolsController.ratio
        height: 120 * ScreenToolsController.ratio


        LargeLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_current.png"
            title: qsTr("电流")
            value: _current
            unit: "A"
        }

        LargeLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_airspeed.png"
            title: qsTr("空速")
            value: _activeVehicle ? _activeVehicle.airSpeed.floatStringValue : "0.0"
            unit: "m/s"
            visible: false
        }

        LargeLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_heading.png"
            title: qsTr("航向")
            value: _activeVehicle ? _activeVehicle.heading.value : "0.0"
            unit: "°"
        }

        LargeLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_rh.png"
            title: qsTr("相对高度")
            value: _activeVehicle ? _activeVehicle.altitudeRelative.floatStringValue : "0.0"
            unit: "m"
        }

        LargeLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_voltage.png"
            title: qsTr("电压")
            value: _voltage
            unit: "V"
        }

        LargeLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_groundspeed.png"
            title: qsTr("地速")
            value: _activeVehicle ? _activeVehicle.groundSpeed.floatStringValue : "0.0"
            unit: "m/s"
        }

        LargeLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_ah.png"
            title: qsTr("绝对高度")
            value: _activeVehicle ? _activeVehicle.altitudeAMSL.floatStringValue : "0.0"
            unit: "m"
        }
    }

    Grid {
        id: smallLabelRightInfo
        rows: 2
        columns: 3
        rowSpacing: 10 * ScreenToolsController.ratio
        columnSpacing: 40 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio

        anchors.left: parent.left
        anchors.leftMargin: 1272 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 90 * ScreenToolsController.ratio

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_fall.png"
            title: qsTr("落差")
            value: "nan"
            unit: "m"
        }

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_4G.png"
            title: qsTr("4G")
            value: "nan"
            unit: "%"
        }

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_time02.png"
            title: qsTr("留空")
            value: _activeVehicle ? _activeVehicle.flightTimeFact.valueString : "00:00:00"
            unit: ""
        }

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_vertical_speed.png"
            title: qsTr("V速度")
            value: _activeVehicle ? _activeVehicle.climbRate.floatStringValue : "0.0"
            unit: "m/s"
        }

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_base.png"
            title: qsTr("电台")
            value: "nan"
            unit: "%"
        }

        SmallLabel {
            icon: "qrc:/qmlimages/BeiLi/icon_time01.png"
            title: qsTr("剩余")
            value: _timeRemaining
            unit: ""
        }
    }

    Button {
        id: setupBtn
        width: 32 * ScreenToolsController.ratio
        height: 32 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 145 * ScreenToolsController.ratio

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: "qrc:/qmlimages/BeiLi/icon_set.png"
            width: setupBtn.width; height: setupBtn.height
        }
        onClicked: {
            mainWindow.showToolSelectDialog()
        }
    }

    Button {
        id: linkBtn
        width: 32 * ScreenToolsController.ratio
        height: 32 * ScreenToolsController.ratio
        anchors.bottom: setupBtn.top
        anchors.bottomMargin: 13 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 145 * ScreenToolsController.ratio

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: "qrc:/qmlimages/BeiLi/icon_link.png"
            width: linkBtn.width; height: linkBtn.height
        }

        onClicked: {
            linkConfigView.visible = !linkConfigView.visible
        }
    }

    Button {
        id: loginBtn
        width: 80 * ScreenToolsController.ratio
        height: 80 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 20 * ScreenToolsController.ratio

        background: Rectangle {
            color: "transparent"
            anchors.fill: loginBtn

            Image {
                id: person
                source: QGroundControl.httpAPIManager.getUserManager().isLogin ? (QGroundControl.httpAPIManager.getUserManager().getAvatar() ? QGroundControl.httpAPIManager.getUserManager().getAvatar() : "qrc:/qmlimages/BeiLi/img_authorized_avatar.png") : "qrc:/qmlimages/BeiLi/img_unauthorized_avatar.png"
                anchors.centerIn: parent
                visible: false
                width: parent.width
                height: parent.height
            }
            Image {
                id: mask
                source: "qrc:/qmlimages/BeiLi/mask_avatar.png"
                anchors.fill: parent
                visible: false
            }
            OpacityMask {
                id:om
                anchors.fill: parent
                source: person
                maskSource: mask
            }

            Image {
                source: loginBtn.pressed ? "qrc:/qmlimages/BeiLi/img_authorized_outside.png" : "qrc:/qmlimages/BeiLi/img_unauthorized_outside.png"
                anchors.fill: parent
            }

        }

        onClicked: {
            loginView.visible = !loginView.visible
        }
    }

}
