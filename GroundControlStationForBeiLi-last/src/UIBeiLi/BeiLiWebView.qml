import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QtWebEngine 1.8
import QGroundControl               1.0
import QGroundControl.HttpAPIManager 1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootWebView
    Rectangle {
        id: mask
        color: "#000000"
        opacity: 0.6
        anchors.fill: parent
    }

    MouseArea{
        anchors.fill: parent;
        onClicked: {}

        onPressed: {}

        onReleased: {}
    }

    Rectangle {
        id: bg
        color: "#07424F"
        radius: 8 * ScreenToolsController.ratio
        anchors.centerIn: parent
        width: parent.width
        height: parent.height


        WebEngineView {
            anchors.fill: parent
            url: QGroundControl.httpAPIManager.getWebViewURL()//"http://192.168.0.105:20601/"
            onCertificateError: {
                console.log(qsTr("证书错误"), error.description)
                error.ignoreCertificateError()
            }
        }
    }

    Button {
        id: closeWebViewBtn
        anchors.top: parent.top
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 20 * ScreenToolsController.ratio
        width: 38 * ScreenToolsController.ratio
        height: 30 * ScreenToolsController.ratio

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: closeWebViewBtn.checked || closeWebViewBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : closeWebViewBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : "qrc:/qmlimages/BeiLi/icon_close_normal.png"
            width: closeWebViewBtn.width; height: closeWebViewBtn.height
        }

        onClicked: {
            _rootWebView.visible = false
        }
    }

}

