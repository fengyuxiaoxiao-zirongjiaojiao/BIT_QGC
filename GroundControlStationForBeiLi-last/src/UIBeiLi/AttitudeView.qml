/**************************************************
** Author      : 徐建文
** CreateTime  : 2021年7月20日 11点30分
** ModifyTime  : 2021年7月20日 11点30分
** Email       : Vincent_xjw@163.com
** Description : 消息打印窗口
***************************************************/

import QtQuick              2.3
import QtGraphicalEffects   1.0
import QGroundControl               1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: root

    property bool showPitch:    true
    property var  vehicle: null
    property real size
    property bool showHeading:  false

    property real _rollAngle:   vehicle ? vehicle.roll.rawValue  : 0
    property real _pitchAngle:  vehicle ? vehicle.pitch.rawValue : 0
    property bool _isCar: vehicle ? vehicle.isCar : false
    property int  _warningLevel: warningLevel() // 0:ok  1:warning  2:error
    property bool _active: vehicle ? (QGroundControl.multiVehicleManager.activeVehicle === vehicle) : false
    property var  _name: vehicle ? (vehicle.id < 10 ? String("0%1").arg(vehicle.id) : String("%1").arg(vehicle.id)) : "nan"
    property bool _armed: vehicle ? vehicle.armed : false
    property bool _communicationLost: vehicle ? vehicle.vehicleLinkManager.communicationLost : true
    property real _ratio: (size / 106)

    width:  size
    height: size
    signal clicked()

    property string _commLostText:      qsTr("Communication Lost")
    property string _readyToFlyText:    qsTr("Ready To Fly")
    property string _notReadyToFlyText: qsTr("Not Ready")
    property string _disconnectedText:  qsTr("Disconnected")
    property string _armedText:         qsTr("Armed")
    property string _flyingText:        qsTr("Flying")
    property string _landingText:       qsTr("Landing")
    property string _mainStatusBGColor: "red"

    function warningLevel() {
        var statusText = mainStatusText();
        //console.log(statusText)
        if (statusText === _commLostText) {
            return 2
        } else if (statusText === _notReadyToFlyText) {
            return 1
        }
        return 0
    }

    function mainStatusText() {
        var statusText
        if (vehicle) {
            if (_communicationLost) {
                _mainStatusBGColor = "red"
                return _commLostText
            }
            if (vehicle.armed) {
                _mainStatusBGColor =_mainStatusBGColor
                if (vehicle.flying) {
                    return _flyingText
                } else if (vehicle.landing) {
                    return _landingText
                } else {
                    return _armedText
                }
            } else {
                if (vehicle.readyToFlyAvailable) {
                    if (vehicle.readyToFly) {
                        _mainStatusBGColor = "green"
                        return _readyToFlyText
                    } else {
                        _mainStatusBGColor = "yellow"
                        return _notReadyToFlyText
                    }
                } else {
                    // Best we can do is determine readiness based on AutoPilot component setup and health indicators from SYS_STATUS
                    if (vehicle.allSensorsHealthy && vehicle.autopilot.setupComplete) {
                        _mainStatusBGColor = "green"
                        return _readyToFlyText
                    } else {
                        _mainStatusBGColor = "yellow"
                        return _notReadyToFlyText
                    }
                }
            }
        } else {
            _mainStatusBGColor = qgcPal.brandingPurple
            return _disconnectedText
        }
    }


    Item {
        id:             instrument
        anchors.centerIn:   parent
        visible:        false
        width: 92 * _ratio
        height: 92 * _ratio

        //----------------------------------------------------
        //-- Artificial Horizon
        ArtificialHorizon {
            rollAngle:          _rollAngle
            pitchAngle:         _pitchAngle
            anchors.fill:       parent
        }
        //----------------------------------------------------
        //-- Pointer
        Image {
            id:                 pointer
            source:             "qrc:/qmlimages/BeiLi/HUD_attitudePointer.png"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            width: 7 * _ratio
            height: 7 * _ratio
            sourceSize.height: width
            sourceSize.width: height
            anchors.top: parent.top
            anchors.topMargin: 10 * _ratio
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.fill:       parent
            //sourceSize.height:  parent.height

        }
        //----------------------------------------------------
        //-- Instrument Dial
        Image {
            id:                 instrumentDial
            source:             "qrc:/qmlimages/BeiLi/HUD_attitudeDial.png"
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            //anchors.top: parent.top
            //anchors.horizontalCenter: parent.horizontalCenter
            anchors.fill:       parent
            sourceSize.height:  parent.height
            transform: Rotation {
                origin.x:       instrumentDial.width  / 2
                origin.y:       instrumentDial.height / 2
                angle:          -_rollAngle
            }
        }
        //----------------------------------------------------
        //-- Pitch
        PitchIndicator {
            id:                 pitchWidget
            visible:            root.showPitch
            size:               parent.width * 0.6
            ratio:              _ratio
            anchors.verticalCenter: parent.verticalCenter
            pitchAngle:         _pitchAngle
            rollAngle:          _rollAngle
            color:              Qt.rgba(0,0,0,0)
        }
        //----------------------------------------------------
        //-- Cross Hair
        Image {
            id:                 crossHair
            anchors.centerIn:   parent
            source:             "qrc:/qmlimages/BeiLi/HUD_crossHair.png"
            mipmap:             true
            width:              92 * _ratio
            height:             6 * _ratio
            sourceSize.width:   width
            sourceSize.height:  height
            fillMode:           Image.PreserveAspectFit
        }
    }


    Rectangle {
        id:             mask
        anchors.fill:   instrument
        radius:         instrument.width / 2
        color:          "black"
        visible:        false
    }

    OpacityMask {
        anchors.fill: instrument
        source: instrument
        maskSource: mask
    }

    Rectangle {
        id:             borderRect
        anchors.fill:   instrument
        radius:         instrument.width / 2
        color:          Qt.rgba(0,0,0,0)
        border.color:   "white"
        border.width:   1
        visible: false  // 白色边框暂时不显示
    }

    Rectangle {
        id:             activeFlag
        width: 6 * _ratio
        height: 6 * _ratio
        anchors.horizontalCenter: instrument.horizontalCenter
        anchors.bottom: instrument.top
        anchors.bottomMargin: 4 * _ratio
        radius:         width / 2
        color:          _active ? "#00FF00" : "#D3D3D3"
        visible: true
    }

    // warning level
    Image {
        id: warningMask
        //anchors.horizontalCenter: instrument.horizontalCenter
        //anchors.verticalCenter: instrument.verticalCenter
        anchors.fill: instrument
        source: (_warningLevel === 1) ? "qrc:/qmlimages/BeiLi/HUD_yellow.png" : ((_warningLevel === 2) ? "qrc:/qmlimages/BeiLi/HUD_red.png" : "qrc:/qmlimages/BeiLi/HUD_green.png")
        visible: ((_warningLevel != 0) || _active)
    }

    BatteryView {
        visible: true
        width: parent.width + 6 * _ratio
        height: parent.height + 6 * _ratio
        lineWidth: 6 * _ratio
        anchors.centerIn: parent
        vehicle: root.vehicle
    }

    Text {
        id: vehicleName
        anchors.horizontalCenter: root.horizontalCenter
        anchors.top: root.bottom
        anchors.topMargin: -6 * _ratio
        text: _name
        font.family: "MicrosoftYaHei"
        font.weight: Font.Bold
        font.pixelSize: 12 * _ratio
        color: "#A8F1F5"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
        id: disarmedMask
        anchors.fill:   instrument
        radius:         instrument.width / 2
        color:          "#4D9096"
        visible: false//!_armed || _communicationLost
        opacity: 0.6
    }
    Rectangle {
        id: disarmedMaskSmall
        width: 28 * _ratio
        height: 28 * _ratio
        anchors.centerIn:   disarmedMask
        radius:         width / 2
        color:          "#000000"
        visible: !_armed || _communicationLost
        opacity: 0.3
    }
    Image {
        source: _communicationLost ? "qrc:/qmlimages/BeiLi/HUD_icon_communicationLost" : "qrc:/qmlimages/BeiLi/HUD_icon_ReadyToFly.png"
        width: _communicationLost ? (18 * _ratio) : (12 * _ratio)
        height: _communicationLost ? (13 * _ratio) : (12 * _ratio)
        sourceSize.width: width
        sourceSize.height: height
        anchors.centerIn: disarmedMaskSmall
        visible: !_armed || _communicationLost
    }

    // plane
    Image {
        id: isPlane
        anchors.centerIn: instrument
        //anchors.horizontalCenter: instrument.horizontalCenter
        //anchors.verticalCenter: instrument.verticalCenter
        anchors.verticalCenterOffset: -(parent.height / 5)
        source: "qrc:/qmlimages/BeiLi/HUD_img_plane.png"
        width: 30 * _ratio
        height: 10 * _ratio
        sourceSize.width: width
        sourceSize.height: height
        visible: !_isCar
    }

    Image {
        id: isCar
        anchors.centerIn: instrument
        //anchors.horizontalCenter: instrument.horizontalCenter
        //anchors.verticalCenter: instrument.verticalCenter
        anchors.verticalCenterOffset: (parent.height / 4)
        source: "qrc:/qmlimages/BeiLi/HUD_img_car.png"
        width: 18 * _ratio
        height: 18 * _ratio
        sourceSize.width: width
        sourceSize.height: height
        visible: _isCar
    }

    MouseArea {
        anchors.fill: instrument
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (mouse.button === Qt.LeftButton) {
                //root.clicked()
                QGroundControl.multiVehicleManager.activeVehicle = root.vehicle
            } else if (mouse.button === Qt.RightButton) {
                optionMenu.popup()
            }
        }

    }

    AttitudeViewMenu {
        id: optionMenu
        vehicle: root.vehicle
    }

}
