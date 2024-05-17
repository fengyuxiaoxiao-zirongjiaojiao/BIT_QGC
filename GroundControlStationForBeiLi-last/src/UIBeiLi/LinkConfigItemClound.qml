import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14
import QGroundControl                       1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: root

    property var customWidth: 428
    property var customHeight: 64
    property real _widthRatio: (customWidth * ScreenToolsController.ratio) / 428
    property real _heightRatio: (customHeight * ScreenToolsController.ratio) / 64

    width: customWidth * _widthRatio
    height: customHeight * _heightRatio
    property var uavInfo: null
    property var linkConfig: uavInfo ? uavInfo.linkConfig : null
    property bool onLine: uavInfo ? uavInfo.onLine : false
    property bool isLinked: uavInfo ? linkConfig.isLinked : false
    property var text: uavInfo ? String("%1%2%3").arg(uavInfo.nickName).arg(qsTr("的飞机")).arg(uavInfo.systemId) : ""

    property int connectCount: QGroundControl.multiVehicleManager.vehicles.count
    property bool enableLink: (QGroundControl.settingsManager.appSettings.bootAppMode === 1) ? (linkConfig && (connectCount === 0 || isLinked)) : linkConfig

    Image {
        id: bg
        property bool hovered: false
        anchors.fill: parent
        source: bg.hovered ? "qrc:/qmlimages/BeiLi/link_btn_hovered.png" : "qrc:/qmlimages/BeiLi/link_btn_normal.png"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: bg.hovered = true
        onExited: bg.hovered = false
        onClicked: {
        }
    }

    Rectangle {
        id: flagRec
        anchors.left: parent.left
        anchors.leftMargin: 20 * _widthRatio
        anchors.verticalCenter: parent.verticalCenter
        width: 10 * ScreenToolsController.ratio
        height: 10 * ScreenToolsController.ratio
        radius: width / 2
        color: onLine ? "#54D060" : "#146574"
    }

    Text {
        text: root.text
        anchors.left: flagRec.right
        anchors.leftMargin: 10 * _widthRatio
        anchors.verticalCenter: parent.verticalCenter
        font.family: "MicrosoftYaHei"
        font.weight: Font.Bold
        font.pixelSize: 16 * ScreenToolsController.ratio
        color: "#B2F9FF"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    Button {
        id: linkBtn
        width: 25 * ScreenToolsController.ratio
        height: 25 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 20 * _widthRatio
        anchors.verticalCenter: parent.verticalCenter
        enabled: (onLine || isLinked) && enableLink
        background: Rectangle {
            color: "transparent"
        }

        BorderImage {
            id: name
            source: {
                if (isLinked) {
                    return !linkBtn.enabled ? "qrc:/qmlimages/BeiLi/link_icon_link_disabled.png" : linkBtn.hovered ? "qrc:/qmlimages/BeiLi/link_icon_link_hovered.png" : "qrc:/qmlimages/BeiLi/link_icon_link_normal.png"
                } else {
                    return !linkBtn.enabled ? "qrc:/qmlimages/BeiLi/link_icon_unlink_disabled.png" : linkBtn.hovered ? "qrc:/qmlimages/BeiLi/link_icon_unlink_hovered.png" : "qrc:/qmlimages/BeiLi/link_icon_unlink_normal.png"
                }
            }
            width: linkBtn.width; height: linkBtn.height
        }

        onClicked: {
            if (linkConfig) {
                if (isLinked) {
                    linkConfig.link.disconnect()
                } else{
                    QGroundControl.linkManager.createConnectedLink(linkConfig)
                }
            }
        }
    }
}
