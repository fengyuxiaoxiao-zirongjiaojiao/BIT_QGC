import QtQuick 2.3

Rectangle {
    property real pitchAngle:       0
    property real rollAngle:        0
    property real size:             100
    property real ratio: 1
    property real _reticleHeight:   1
    property real _reticleSpacing:  size * 0.1
    property real _reticleSlot:     _reticleSpacing + _reticleHeight
    property real _longDash:        size * 0.35
    property real _shortDash:       size * 0.25

    property real _dashOffset: size * 0.2
    property real _dash: size * 0.1

    height: size
    width:  size
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter:   parent.verticalCenter
    clip: true
    Item {
        height: parent.height
        width:  parent.width
        Column{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter:   parent.verticalCenter
            spacing: _reticleSpacing
            Repeater {
                model: 36
                Rectangle {
                    property int _pitch: -(modelData * 5 - 90)
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: _dash * 2 +  _dashOffset * 2 + 20
                    height: _reticleHeight
                    color: "transparent"
                    // 左横线
                    Rectangle {
                        anchors.left: parent.left
                        anchors.leftMargin: 6 * ratio
                        anchors.verticalCenter: parent.verticalCenter
                        width: _dash
                        height: _reticleHeight
                        color: "white"
                        antialiasing: true
                        smooth: true
                        visible: (_pitch === 0) || ((_pitch != 0) && ((_pitch % 10) === 0))
                    }
                    // 左数字
                    Text {
                        anchors.left: parent.left
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -6 * ratio
                        smooth: true
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Normal
                        font.pixelSize: 8 * ratio
                        text: _pitch
                        color: "white"
                        visible: (_pitch === 0) || ((_pitch != 0) && ((_pitch % 10) === 0))
                        antialiasing:   true
                    }


                    // 右横线
                    Rectangle {
                        anchors.right: parent.right
                        anchors.rightMargin: 6 * ratio
                        anchors.verticalCenter: parent.verticalCenter
                        width: _dash
                        height: _reticleHeight
                        color: "white"
                        antialiasing: true
                        smooth: true
                        visible: (_pitch === 0) || ((_pitch != 0) && ((_pitch % 10) === 0))
                    }
                    // 右数字
                    Text {
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: -6 * ratio
                        smooth: true
                        font.family: "MicrosoftYaHei"
                        font.weight: Font.Normal
                        font.pixelSize: 8 * ratio
                        text: _pitch
                        color: "white"
                        visible: (_pitch === 0) || ((_pitch != 0) && ((_pitch % 10) === 0))
                        antialiasing:   true
                    }
                }// Rectangle
            }// Repeater
        }
        transform: [ Translate {
                y: (pitchAngle * _reticleSlot / 5) - (_reticleSlot / 2)
                }]
    }
    transform: [
        Rotation {
            origin.x: width  / 2
            origin.y: height / 2
            angle:    -rollAngle
            }
    ]
}
