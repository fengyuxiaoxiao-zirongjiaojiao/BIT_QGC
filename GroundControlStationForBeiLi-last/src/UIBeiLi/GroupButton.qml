import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl   1.0
import QGroundControl.ScreenToolsController 1.0

Button {
    id: groupBtn
    checkable: true
    width: 72 * ScreenToolsController.ratio
    height: 32 * ScreenToolsController.ratio
    text: qsTr("第一组")

    background: Rectangle {
        color: "transparent"
    }
    BorderImage {
        source: !groupBtn.enabled ? "qrc:/qmlimages/BeiLi/cluster_btn01_normal.png" : groupBtn.checked ? "qrc:/qmlimages/BeiLi/cluster_btn01_checked.png" : groupBtn.hovered ? "qrc:/qmlimages/BeiLi/cluster_btn01_hovered.png" : "qrc:/qmlimages/BeiLi/cluster_btn01_normal.png"
        width: groupBtn.width; height: groupBtn.height
    }

    contentItem: Text {
        text: groupBtn.text
        font.family: "MicrosoftYaHei"
        font.weight: Font.Bold
        font.pixelSize: 18 * ScreenToolsController.ratio
        color: "#B2F9FF"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
