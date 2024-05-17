import QtQuick 2.6
import QGroundControl               1.0
import QGroundControl.Vehicle       1.0



Item {
    visible: true
    id: root
    property var  vehicle:      null
    property int lineWidth: 6
    property var _battery_1: vehicle && vehicle.batteries.count ? vehicle.batteries.get(0) : undefined
    property var _current: _battery_1 ? _battery_1.current.floatStringValue : 0
    property var _voltage: _battery_1 ? _battery_1.voltage.floatStringValue : 0
    property int _percentReming: _battery_1 ? _battery_1.percentRemaining.value : 0


    Canvas
    {
        id : canvas
        anchors.fill: parent
        width: parent.width
        height: parent.height
        onPaint:
        {
            var ctx = getContext("2d");
            //drawBack(ctx); // 画线的方式
            drawArc(ctx);  // 画弧线
         }

    }

    function degTorad(deg) {
        var rad = deg * (Math.PI / 180);
        return rad
    }

    function drawArc(ctx)
    {
        var angle = 60;
        //var lineWidth = 6;
        var r = (height - lineWidth-2) / 2;
        var colorInvalid = "#C0C0C0"    // 白
        var colorGood = "#08ade5"       // 绿>35 #08ade5
        var colorWarning = "#ffb400"    // 橙>20 #ffb400
        var colorError = "#ff2b2b"      // 红>0 #ff2b2b
        ctx.save();
        ctx.translate(width/2,height/2);
        ctx.lineWidth = lineWidth;

        // back
        ctx.beginPath();
        ctx.strokeStyle = _percentReming > 35 ? colorGood : (_percentReming > 20 ? colorWarning : colorError);
        var startRadRight = degTorad(angle);
        var endRadRight = degTorad(-angle);
        ctx.arc(0, 0, r, startRadRight, endRadRight, true);
        ctx.stroke();

        ctx.beginPath();
        ctx.strokeStyle = colorInvalid;
        var startRadVlidRight = degTorad(-angle);
        var endDegRight = -angle + (120 * _percentReming) / 100.0;
        ctx.arc(0, 0, r, degTorad(360-endDegRight), degTorad(360-angle), true);
        ctx.stroke();



        // back
        ctx.beginPath();
        ctx.strokeStyle = _percentReming > 35 ? colorGood : (_percentReming > 20 ? colorWarning : colorError);
        var startRadLeft = degTorad(240);
        var endRadLeft = degTorad(120);
        ctx.arc(0, 0, r, startRadLeft, endRadLeft, true);
        ctx.stroke();

        ctx.beginPath();
        ctx.strokeStyle = colorInvalid;
        var startRadValidLeft = degTorad(240);
        var endRadValidLeft = degTorad(120 + (120 * _percentReming) / 100.0);
        ctx.arc(0, 0, r, startRadValidLeft, endRadValidLeft, true);
        ctx.stroke();

        ctx.restore();
    }

    function drawBack(ctx)
    {
        var r = height/2;
        //var lineLength = 6
        var margin = 0
        var lineWidth = 1
        var lineNumber = 124
        var validNumber = 100
        var halfValid = validNumber / 2
        var inValid = lineNumber - validNumber
        var halfInValid = inValid / 2
        var colorInvalid = "#ffffff"    // 白
        var colorGood = "#08ade5"       // 绿>35 #08ade5
        var colorWarning = "#ffb400"    // 橙>20 #ffb400
        var colorError = "#ff2b2b"      // 红>0 #ff2b2b

        ctx.save();
        ctx.translate(width/2,height/2);

        //画刻度
        ctx.lineWidth = lineWidth;

        for (var i = 0; i <lineNumber; ++i)
        {
            if ((i>=0 && i < halfInValid/2) ||
                    (i >= halfValid + halfInValid/2 && i< halfValid + halfInValid/2 + halfInValid) ||
                    (i > (lineNumber - 1 - halfInValid/2) && i < lineNumber)) {
                continue;
            }

            ctx.beginPath();
            var rad = 2*Math.PI/lineNumber*i;
            var deg = rad * (180/3.1415926);
            rad = (deg - 90.0) * (3.1415926 / 180);
            var x = Math.cos(rad)*(r-lineLength);
            var y = Math.sin(rad)*(r-lineLength);
            var x2 = Math.cos(rad)*(r-margin);
            var y2 = Math.sin(rad)*(r-margin);

            //通过画线也可以
            var n = i;
            if (i>=halfInValid/2 && i < halfValid + halfInValid/2) {
                // 将索引i映射到 [1,halfValid]
                n = (i- halfInValid / 2) - halfValid;
                n = n >= 0 ? n : (n * -1);
            } else {
                n = (i - (lineNumber - 1 - halfInValid/2)) + halfValid;
            }

            if (_percentReming >= n*2) {
                if (_percentReming > 35) ctx.strokeStyle = colorGood;
                else if (_percentReming > 20)ctx.strokeStyle = colorWarning;
                else ctx.strokeStyle = colorError;
            } else {
                ctx.strokeStyle = colorInvalid;
            }

            ctx.moveTo(x,y);
            ctx.lineTo(x2,y2);
            ctx.stroke();

        }
        ctx.restore();
    }

    //定时器
    Timer {
             interval: 1000; running: true; repeat: true
             onTriggered: canvas.requestPaint();
         }
}

