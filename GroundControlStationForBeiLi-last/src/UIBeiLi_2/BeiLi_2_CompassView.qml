import QtQuick              2.3
import QtGraphicalEffects   1.0
import QtQuick.Controls     2.14

import QGroundControl   1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: root
    property int size: 106 * ScreenToolsController.ratio
    property real yawAngle
    property real microphoneAngle
    width: size
    height: size

    property int _margin: 13 * ScreenToolsController.ratio

    // 背景
    Rectangle {
        id: bg
        color: "#2F6166"
        opacity: 0.8
        radius: size / 2
        anchors.fill: parent
    }

    // 表盘
    Image {
        source: "qrc:/qmlimages/BeiLi_2/img_compass.png"
        width: size - _margin
        height: size - _margin
        sourceSize.width: width
        sourceSize.height: height
        anchors.centerIn: parent
    }

    // 声音的方位
    Item {
        id: microphonePointer
        anchors.fill: parent
        Image {
            source: "qrc:/qmlimages/BeiLi_2/HUD_cursor.png"
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: _margin
            height: _margin
            sourceSize.width: width
            sourceSize.height: height
        }

        transform: [
            Rotation {
                origin.x: microphonePointer.width  / 2
                origin.y: microphonePointer.height / 2
                angle:    microphoneAngle
            }
        ]
    }


    // 飞机图标
    Image {
        id: yawPointer
        source: "qrc:/qmlimages/BeiLi_2/img_plane.png"
        anchors.centerIn: parent
        width: 24 * ScreenToolsController.ratio
        height: 24 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height

        transform: [
            Rotation { // 以图片的中心点旋转angle，顺时针
                origin.x: yawPointer.width  / 2
                origin.y: yawPointer.height / 2
                angle:    yawAngle
                }
        ]
    }

}
