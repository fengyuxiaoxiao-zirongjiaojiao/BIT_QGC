import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QGroundControl   1.0
import QGroundControl.ScreenToolsController 1.0

RoundButton {
    id: btn
    property bool isLinked
    width: 40 * ScreenToolsController.ratio
    height: 40 * ScreenToolsController.ratio
    checkable: isLinked
    text: qsTr("01")
    background: Rectangle {
        color: "transparent"
    }

    BorderImage {
        source: btn.checked ? "qrc:/qmlimages/BeiLi/cluster_btn02_checked.png" : btn.hovered ? "qrc:/qmlimages/BeiLi/cluster_btn02_hovered.png" : btn.isLinked ? "qrc:/qmlimages/BeiLi/cluster_btn02_onLine.png" : "qrc:/qmlimages/BeiLi/cluster_btn02_normal.png"
        width: btn.width; height: btn.height
    }

    contentItem: Text {
        text: btn.text
        font.family: "MicrosoftYaHei"
        font.weight: Font.Bold
        font.pixelSize: 18 * ScreenToolsController.ratio
        color: "#B2F9FF"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
