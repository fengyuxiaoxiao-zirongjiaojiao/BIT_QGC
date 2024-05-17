import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Window           2.14
import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.ScreenToolsController   1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0

/// The SliderSwitch control implements a sliding switch control similar to the power off
/// control on an iPhone.
Rectangle {
    id:             _root
    width: 194 * ScreenToolsController.ratio
    height: 48 * ScreenToolsController.ratio
    implicitWidth:  194 * ScreenToolsController.ratio//label.contentWidth + (_diameter * 2.5) + (_border * 4)
    implicitHeight: 48 * ScreenToolsController.ratio//label.height * 2.5
    radius:         height /2
    color:          "#063844"

    signal accept   ///< Action confirmed

    property string confirmText                         ///< Text for slider
    property alias  fontPointSize: label.font.pointSize ///< Point size for text

    property real _border: 0
    property real _diameter: height - (_border * 2)

    QGCPalette { id: qgcPal; colorGroupEnabled: true }

    Image {
        source: "qrc:/qmlimages/BeiLi/frame_sure_sliders.png"
        anchors.centerIn: parent
        width: 81 * ScreenToolsController.ratio
        height: 18 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    QGCLabel {
        id:                         label
        anchors.horizontalCenter:   parent.horizontalCenter
        anchors.verticalCenter:     parent.verticalCenter
        text:                       confirmText
        color:                      qgcPal.buttonText
        visible:                    false
    }

    Rectangle {
        id:         slider
        x:          _border
        y:          _border
        height:     _diameter
        width:      _diameter
        radius:     _diameter / 2
        color:      "transparent"
        property bool checkable: false
        property bool checked: false
        property bool hovered: false
        property bool pressed: false

        Image {
            anchors.fill: parent

            source: (slider.checked || slider.pressed) ? "qrc:/qmlimages/BeiLi/frame_sure_clicked.png" : slider.hovered ? "qrc:/qmlimages/BeiLi/frame_sure_hovered.png" : "qrc:/qmlimages/BeiLi/frame_sure_normal.png"
            sourceSize.height: parent.height
            sourceSize.width: parent.width
        }

        Text {
            text: qsTr("确定")
            anchors.centerIn: parent
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
            color: (slider.hovered || slider.pressed) ? "#B2F9FF" : "#08D3E5"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

    }

    QGCMouseArea {
        id:                 sliderDragArea
        anchors.leftMargin: -ScreenTools.defaultFontPixelWidth * 15
        fillItem:           slider
        drag.target:        slider
        drag.axis:          Drag.XAxis
        drag.minimumX:      _border
        drag.maximumX:      _maxXDrag
        preventStealing:    true
        hoverEnabled:       true
        property real _maxXDrag:    _root.width - (_diameter + _border)
        property bool dragActive:   drag.active
        property real _dragOffset:  1
        onEntered: slider.hovered = true
        onExited: slider.hovered = false
        onPressed: {
            slider.pressed = true
            if (slider.checkable)
                slider.checked = !slider.checked
        }
        onReleased: slider.pressed = false
        onDragActiveChanged: {
            if (!sliderDragArea.drag.active) {
                if (slider.x >= _maxXDrag - _border) {
                    _root.accept()
                }
                slider.x = _border
            }
        }
    }
}
