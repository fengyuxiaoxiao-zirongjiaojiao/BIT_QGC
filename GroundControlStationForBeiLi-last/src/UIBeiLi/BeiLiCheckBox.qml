import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QGroundControl   1.0
import QGroundControl.ScreenToolsController    1.0

CheckBox {
    id: actionCheckBox
    text: qsTr("自动连接")

    indicator: Rectangle {
        id: indicatorRec
        anchors.left: actionCheckBox.left
        anchors.verticalCenter: actionCheckBox.verticalCenter
        width: 12 * ScreenToolsController.ratio
        height: 12 * ScreenToolsController.ratio
        color: "transparent"
        Image {
            source: actionCheckBox.checked ? "qrc:/qmlimages/BeiLi/login_icon_remembered_checked.png" : "qrc:/qmlimages/BeiLi/login_icon_remembered.png"
            width: 12 * ScreenToolsController.ratio
            height: 12 * ScreenToolsController.ratio
            sourceSize.width: width
            sourceSize.height: height
        }
    }

    contentItem: Text {
        anchors.verticalCenter: indicatorRec.verticalCenter
        anchors.left: indicatorRec.right
        anchors.leftMargin: 8 * ScreenToolsController.ratio
        font.family: "MicrosoftYaHei"
        font.weight: Font.Bold
        font.pixelSize: 14 * ScreenToolsController.ratio
        color: "#08D3E5"
        text: actionCheckBox.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
