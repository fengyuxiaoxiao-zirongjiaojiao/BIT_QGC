import QtQuick 2.4

import QGroundControl                       1.0
import QGroundControl.Vehicle               1.0

Item {
    id:             _joyRoot

    //property alias  lightColors:    false  ///< true: use light colors from QGCMapPalette for drawing
    property real   xAxis:          0                   ///< Value range [-1,1], negative values left stick, positive values right stick
    property real   yAxis:          0                   ///< Value range [-1,1], negative values up stick, positive values down stick
    property bool   yAxisThrottle:  false               ///< true: yAxis used for throttle, range [1,0], positive value are stick up
    property real   xPositionDelta: 0                   ///< Amount to move the control on x axis
    property real   yPositionDelta: 0                   ///< Amount to move the control on y axis
    property bool   throttle:       false

    property real   _centerXY:              width / 2
    property bool   _processTouchPoints:    false
    property bool   _stickCenteredOnce:     false
    property bool   xReverse:               false
    property bool   yReverse:               true
    property real   stickPositionX:         _centerXY
    property real   stickPositionY:         yAxisThrottle ? height : _centerXY

    property var  _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle

    Timer {
        id: timer
        interval: 40 // ms 25Hz
        running:  false
        repeat: true
        property var timerCount: 0
        onTriggered: {
            timerCount++;
            if (_activeVehicle) {
                _activeVehicle.gimbalControlValue(0, 0)
            }

            if (timerCount > 5) {
                timerCount = 0
                timer.stop()
            }
        }
    }

    onStickPositionXChanged: {
        var xAxisTemp = stickPositionX / width
        xAxisTemp *= 2.0
        xAxisTemp -= 1.0
        xAxis = xReverse ? xAxisTemp * -1 : xAxisTemp

        gimbalControlValue()
    }

    onStickPositionYChanged: {
        var yAxisTemp = stickPositionY / height
        yAxisTemp *= 2.0
        yAxisTemp -= 1.0
        yAxis = yReverse ? yAxisTemp * -1 : yAxisTemp

        gimbalControlValue()
    }

    function reCenter()
    {
        _processTouchPoints = false
        xPositionDelta = 0
        yPositionDelta = 0
        stickPositionX = _centerXY
        if (!yAxisThrottle) {
            stickPositionY = _centerXY
        }
    }

    function thumbDown(touchPoints)
    {
        xPositionDelta = touchPoints[0].x - _centerXY
        if (yAxisThrottle) {
            yPositionDelta = touchPoints[0].y - stickPositionY
        } else {
            yPositionDelta = touchPoints[0].y - _centerXY
        }

        _processTouchPoints = true
    }

    function gimbalControlValue()
    {
        if (_activeVehicle) {
            var range_min = -1;
            var range_max = 1;
            var deg_min = -45;
            var deg_max = 45;

            var deg_dif = deg_max - deg_min;
            var m = (range_max - range_min) / deg_dif;

            var pitch_deg = yAxis;
            if (yAxis === 0 || Math.abs(m) < 0.000001) pitch_deg = 0;
            else {
                pitch_deg = deg_min + (yAxis - range_min) / m;
            }

            var yaw_deg = xAxis;
            if (xAxis === 0 || Math.abs(m) < 0.000001) yaw_deg = 0;
            else {
                yaw_deg = deg_min + (xAxis - range_min) / m;
            }
            // console.log(pitch_deg, yaw_deg)
            _activeVehicle.gimbalControlValue(pitch_deg*100, yaw_deg*100)

            if (pitch_deg === yaw_deg && pitch_deg === 0) {
                timer.start()
            }
        }
    }

    Image {
        id: _bg
        anchors.fill: parent
        source: "qrc:/qmlimages/BeiLi/btn_control_outside.png"
        mipmap: true
        smooth: true
    }

    Rectangle {
        id: _handle
        //anchors.centerIn: parent
        width: (_joyRoot.width / 2) - 12
        height: (_joyRoot.height / 2) - 12
        x: stickPositionX - width/2
        y: stickPositionY - height/2
        color:              "transparent"
        Image {
            anchors.fill: parent
            source: "qrc:/qmlimages/BeiLi/btn_control_inside.png"
        }
    }

    Connections {
        target: touchPoint

        onXChanged: {
            if (_processTouchPoints) {
                _joyRoot.stickPositionX = Math.max(Math.min(touchPoint.x, _joyRoot.width), 0)
            }
            //console.log("onXChanged", xAxis)
            //gimbalControlValue()
        }

        onYChanged: {
            if (_processTouchPoints) {
                _joyRoot.stickPositionY = Math.max(Math.min(touchPoint.y, _joyRoot.height), 0)
            }
            //console.log("onYChanged", yAxis)
            //gimbalControlValue()
        }
    }

    MultiPointTouchArea {
        anchors.fill: parent
        minimumTouchPoints: 1
        maximumTouchPoints: 1
        touchPoints: [ TouchPoint { id: touchPoint } ]

        onPressed: _joyRoot.thumbDown(touchPoints)
        onReleased: _joyRoot.reCenter()
    }


    Component.onCompleted: {
        console.log(_joyRoot.width, _joyRoot.height)
        console.log(_handle.width, _handle.height)
    }
}
