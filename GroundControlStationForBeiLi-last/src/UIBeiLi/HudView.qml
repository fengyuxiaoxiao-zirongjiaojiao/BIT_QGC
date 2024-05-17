import QtQuick 2.0
import QGroundControl               1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootHudView
    property int group: {
        var firstRowCount = QGroundControl.multiVehicleManager.firstVehicles.count > 0 ? 1 : 0
        var secondRowCount = QGroundControl.multiVehicleManager.secondVehicles.count > 0 ? 1 : 0
        var thirdRowCount = QGroundControl.multiVehicleManager.thirdVehicles.count > 0 ? 1 : 0
        var fourthRowCount = QGroundControl.multiVehicleManager.fourthVehicles.count > 0 ? 1 : 0
        return (firstRowCount + secondRowCount + thirdRowCount + fourthRowCount)
    }
    property int sideline: 6 * ScreenToolsController.ratio
    property int centerline: 0
    width: 580 * ScreenToolsController.ratio
    height: 140 * ScreenToolsController.ratio
    function _calc() {
        if (group === 1) {
            height = 140 * ScreenToolsController.ratio
            sideline = 6 * ScreenToolsController.ratio
            centerline = 0
        } else if (group === 2) {
            height = 256 * ScreenToolsController.ratio
            sideline = 20 * ScreenToolsController.ratio
            centerline = 64 * ScreenToolsController.ratio
        } else if (group === 3) {
            height = 372 * ScreenToolsController.ratio
            sideline = 60 * ScreenToolsController.ratio
            centerline = 108 * ScreenToolsController.ratio
        } else if (group === 4) {
            height = 486 * ScreenToolsController.ratio
            sideline = 117 * ScreenToolsController.ratio
            centerline = 108 * ScreenToolsController.ratio
        } else {
            height = 140 * ScreenToolsController.ratio
            sideline = 6 * ScreenToolsController.ratio
            centerline = 0
        }
    }

    onGroupChanged: _calc()

    MouseArea {
        anchors.fill: parent
        onPressed: {}
        onWheel: {}
    }

    Rectangle {
        id: hudBg
        anchors.fill: parent
        color: "#07424F"
        opacity: 0.8
        border.color: "#08d3e5"
        radius: 40 * ScreenToolsController.ratio
    }

    Image {
        id: bg_01
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_01.png"
        anchors.top: parent.top
        anchors.left: parent.left
        width: 48  * ScreenToolsController.ratio
        height: 48 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_02_left
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_02.png"
        anchors.top: parent.top
        anchors.left: bg_01.right
        anchors.right: bg_03.left
        width: 36  * ScreenToolsController.ratio
        height: 7 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_03
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_03.png"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: 55  * ScreenToolsController.ratio
        height: 13 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_02_right
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_02.png"
        anchors.top: parent.top
        anchors.left: bg_03.right
        anchors.right: bg_04.left
        width: 36  * ScreenToolsController.ratio
        height: 7 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_04
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_04.png"
        anchors.top: parent.top
        anchors.right: parent.right
        width: 48  * ScreenToolsController.ratio
        height: 48 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        id: bg_05_top_right
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_05.png"
        anchors.right: parent.right
        anchors.top: bg_04.bottom
        anchors.bottom: bg_06.visible ? bg_06.top : bg_14.top
        width: 6  * ScreenToolsController.ratio
        height: 36 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_06
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_06.png"
        anchors.right: parent.right
        anchors.top: bg_04.bottom
        anchors.topMargin: sideline
        visible: centerline != 0
        width: 11  * ScreenToolsController.ratio
        height: 34 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_14
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_14.png"
        anchors.right: parent.right
        anchors.top: bg_04.bottom
        anchors.topMargin: sideline
        visible: centerline === 0
        width: 11  * ScreenToolsController.ratio
        height: 34 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_07
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_07.png"
        anchors.right: parent.right
        anchors.bottom: bg_08.top
        anchors.bottomMargin: sideline
        visible: centerline != 0
        width: 11  * ScreenToolsController.ratio
        height: 34 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_05_bottom_right
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_05.png"
        anchors.right: parent.right
        anchors.top: bg_07.visible ? bg_07.bottom : bg_14.bottom
        anchors.bottom: bg_08.top
        width: 6  * ScreenToolsController.ratio
        height: 36 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        id: bg_08
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_08.png"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width: 48  * ScreenToolsController.ratio
        height: 48 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_02_bottom_right
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_02.png"
        anchors.bottom: parent.bottom
        anchors.left: bg_09.right
        anchors.right: bg_08.left
        width: 36  * ScreenToolsController.ratio
        height: 7 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_09
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_09.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        width: 55  * ScreenToolsController.ratio
        height: 13 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_02_bottom_left
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_02.png"
        anchors.bottom: parent.bottom
        anchors.left: bg_10.right
        anchors.right: bg_09.left
        width: 36  * ScreenToolsController.ratio
        height: 7 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_10
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_10.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 48  * ScreenToolsController.ratio
        height: 48 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }



    Image {
        id: bg_05_top_left
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_05.png"
        anchors.left: parent.left
        anchors.top: bg_01.bottom
        anchors.bottom: bg_12.visible ? bg_12.top : bg_13.top
        width: 6  * ScreenToolsController.ratio
        height: 36 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height

    }
    Image {
        id: bg_12
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_12.png"
        anchors.left: parent.left
        anchors.top: bg_01.bottom
        anchors.topMargin: sideline
        visible: centerline != 0
        width: 11  * ScreenToolsController.ratio
        height: 34 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_13
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_13.png"
        anchors.left: parent.left
        anchors.top: bg_01.bottom
        anchors.topMargin: sideline
        visible: centerline === 0
        width: 11  * ScreenToolsController.ratio
        height: 34 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        id: bg_11
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_11.png"
        anchors.left: parent.left
        anchors.bottom: bg_10.top
        anchors.bottomMargin: sideline
        visible: centerline != 0
        width: 11  * ScreenToolsController.ratio
        height: 34 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }
    Image {
        id: bg_05_bottom_left
        source: "qrc:/qmlimages/BeiLi/HUD_background_many_05.png"
        anchors.left: parent.left
        anchors.bottom: bg_10.top
        anchors.top: bg_11.visible ? bg_11.bottom : bg_13.bottom
        width: 6  * ScreenToolsController.ratio
        height: 36 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Column {
        anchors.centerIn: parent
        spacing: 6 * ScreenToolsController.ratio
        Row {

            spacing: 29 * ScreenToolsController.ratio
            visible: true
            Repeater {
                model: QGroundControl.multiVehicleManager.firstVehicles
                AttitudeView {
                    size: 106 * ScreenToolsController.ratio
                    vehicle: QGroundControl.multiVehicleManager.firstVehicles.get(index)
                }
            }

        }
        Row {

            spacing: 29 * ScreenToolsController.ratio
            visible: true
            Repeater {
                model: QGroundControl.multiVehicleManager.secondVehicles
                AttitudeView {
                    size: 106 * ScreenToolsController.ratio
                    vehicle: QGroundControl.multiVehicleManager.secondVehicles.get(index)
                }
            }
        }
        Row {

            spacing: 29 * ScreenToolsController.ratio
            visible: true
            Repeater {
                model: QGroundControl.multiVehicleManager.thirdVehicles
                AttitudeView {
                    size: 106 * ScreenToolsController.ratio
                    vehicle: QGroundControl.multiVehicleManager.thirdVehicles.get(index)
                }
            }
        }
        Row {

            spacing: 29 * ScreenToolsController.ratio
            visible: true
            Repeater {
                model: QGroundControl.multiVehicleManager.fourthVehicles
                AttitudeView {
                    size: 106 * ScreenToolsController.ratio
                    vehicle: QGroundControl.multiVehicleManager.fourthVehicles.get(index)
                }
            }
        }
    }

}
