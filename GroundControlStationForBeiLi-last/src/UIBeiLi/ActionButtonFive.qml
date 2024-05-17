import QtQuick 2.0
import QtQuick.Controls 2.14
import QGroundControl.ScreenToolsController 1.0

Button {
    id: actionBtn
    width: 110 * ScreenToolsController.ratio
    height: 25 * ScreenToolsController.ratio
    padding: 0
    background: Rectangle {
        color: "transparent"
    }
    BorderImage {
        source: actionBtn.checked || actionBtn.pressed ? "qrc:/qmlimages/BeiLi/viewpoint_btn_checked.png" : actionBtn.hovered ? "qrc:/qmlimages/BeiLi/viewpoint_btn_hovered.png" : "qrc:/qmlimages/BeiLi/viewpoint_btn_normal.png"
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
