import QtQuick 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QtWebEngine 1.8
import QGroundControl               1.0
import QGroundControl.HttpAPIManager 1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootCesiumWebView
    property bool _reload: false

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
        radius: 8
        anchors.centerIn: parent
        width: parent.width
        height: parent.height


        WebEngineView {
            id: webview
            anchors.fill: parent
            url: QGroundControl.httpAPIManager.getMapCesiumUrl()
            settings.pluginsEnabled: true
            settings.webGLEnabled: true
            onNewViewRequested: request.openIn(webview)
        }
    }

    Rectangle {
        id: refreshBtn
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 10
        width: 64 * ScreenToolsController.ratio
        height: width
        radius: width / 2
        color: "#07424F"
        visible: true

        Image {
            anchors.centerIn: parent
            source: "qrc:/qmlimages/BeiLi/icon_refresh.png"
            width: 36 * ScreenToolsController.ratio
            height: 36 * ScreenToolsController.ratio
            sourceSize.width: width
            sourceSize.height: height
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                webview.reload()
                _reload = true
            }
        }
    }


    Rectangle {
        id:             progressBar
        anchors.left:   parent.left
        anchors.top:    parent.top
        height:         4 * ScreenToolsController.ratio
        width:          _progressPct * parent.width
        color:          "#00ff00"
        visible:        false

        property bool loading: webview.loading
        property real   _progressPct:     webview.loading ? webview.loadProgress * 0.01 : 0
        on_ProgressPctChanged: {
            if (_progressPct != 0) progressBar.visible = true
            if (_progressPct === 1) {
                resentToCesiumTimer.start()
            }
        }

        onLoadingChanged: {
            if (!loading) {
                _progressPct = 1
            }
        }
    }

    Timer {
        id: resentToCesiumTimer
        running: false
        repeat: false
        interval: 2000
        onTriggered: {
            progressBar._progressPct = 0
            progressBar.visible = false
            if (_reload) {
                QGroundControl.webMsgManager.webRefresh()
                _reload = false
            }
        }
    }

}

