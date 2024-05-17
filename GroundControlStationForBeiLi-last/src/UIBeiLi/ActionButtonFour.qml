import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QGroundControl.ScreenToolsController 1.0

Button {
    id: actionBtn
    width: 110 * ScreenToolsController.ratio
    height: 36 * ScreenToolsController.ratio
    text: qsTr("xxxx")

    background: Rectangle {
        color: "transparent"
    }
    BorderImage {
        source: actionBtn.checked || actionBtn.pressed ? "qrc:/qmlimages/BeiLi/cluster_btn03_checked_four.png" : actionBtn.hovered ? "qrc:/qmlimages/BeiLi/cluster_btn03_hovered_four.png" : "qrc:/qmlimages/BeiLi/cluster_btn03_normal_four.png"
        width: actionBtn.width; height: actionBtn.height
    }

    contentItem: Text {
        text: actionBtn.text
        font.family: "MicrosoftYaHei"
        font.weight: Font.Bold
        font.pixelSize: 18 * ScreenToolsController.ratio
        color: "#08D3E5"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
