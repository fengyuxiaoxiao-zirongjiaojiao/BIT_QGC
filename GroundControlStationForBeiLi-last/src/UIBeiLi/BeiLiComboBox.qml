import QtQuick                  2.11
import QtQuick.Window           2.3
import QtQuick.Controls         2.4
import QtQuick.Controls.impl    2.4
import QtQuick.Templates        2.4 as T

import QGroundControl.ScreenTools   1.0
import QGroundControl.Palette       1.0
import QGroundControl.Controls      1.0
import QGroundControl.ScreenToolsController 1.0

T.ComboBox {
    id:             control
    editable:       false
    padding:        ScreenTools.comboBoxPadding
    spacing:        ScreenTools.defaultFontPixelWidth
    font.family: "MicrosoftYaHei"
    font.weight: Font.Bold
    font.pixelSize: 14 * ScreenToolsController.ratio
    implicitWidth:  Math.max(background ? background.implicitWidth : 0,
                             contentItem.implicitWidth + leftPadding + rightPadding + padding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(contentItem.implicitHeight, indicator ? indicator.implicitHeight : 0) + topPadding + bottomPadding)
    leftPadding:    padding + (!control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width + spacing)
    rightPadding:   padding + (control.mirrored || !indicator || !indicator.visible ? 0 : indicator.width)
    bottomPadding: 0
    topPadding: 0

    property bool   centeredLabel:  false
    property bool   sizeToContents: false
    property string alternateText:  ""
    property var    fieldText:      control.currentText

    property var    _qgcPal:            QGCPalette { colorGroupEnabled: enabled }
    property real   _largestTextWidth:  0
    property real   _popupWidth:        sizeToContents ? _largestTextWidth + itemDelegateMetrics.leftPadding + itemDelegateMetrics.rightPadding : control.width
    property bool   _onCompleted:       false

    onActivated: {
        text.text = control.currentText
        fieldText = control.currentText
    }

    TextMetrics {
        id:                 textMetrics
        font.family:        control.font.family
        font.pixelSize:     control.font.pixelSize
    }

    ItemDelegate {
        id:             itemDelegateMetrics
        visible:        false
        font.family:    control.font.family
        font.pixelSize: control.font.pixelSize
    }

    function _adjustSizeToContents() {
        if (_onCompleted && sizeToContents) {
            _largestTextWidth = 0
            for (var i = 0; i < model.length; i++){
                textMetrics.text = model[i]
                _largestTextWidth = Math.max(textMetrics.width, _largestTextWidth)
            }
        }
    }

    onModelChanged: _adjustSizeToContents()

    Component.onCompleted: {
        _onCompleted = true
        _adjustSizeToContents()
    }

    // The items in the popup
    delegate: ItemDelegate {
        width:  _popupWidth
        height: Math.round(popupItemMetrics.height * 1.75)

        property string _text: control.textRole ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole]) : modelData

        TextMetrics {
            id:             popupItemMetrics
            font:           control.font
            text:           _text
        }

        contentItem: Text {
            text:                   _text
            font:                   control.font
            color:                  control.currentIndex === index ? "#B2F9FF" : "#08D3E5"
            verticalAlignment:      Text.AlignVCenter
            padding: 0
        }

        background: Rectangle {
            color:                  control.currentIndex === index ? "#1C996A" : "#07424F"
        }

        highlighted:                control.highlightedIndex === index
    }

    indicator: QGCColoredImage {
        anchors.rightMargin:    control.padding
        anchors.right:          parent.right
        anchors.verticalCenter: parent.verticalCenter
        height:                 ScreenTools.defaultFontPixelWidth
        width:                  height
        source:                 "/qmlimages/arrow-down.png"
        color:                  _qgcPal.text
    }

    // The label of the button
    contentItem: Item {
        implicitWidth:                  text.implicitWidth
        implicitHeight:                 text.implicitHeight

        QGCLabel {
            id:                         textLabel
            anchors.verticalCenter:     parent.verticalCenter
            anchors.horizontalCenter:   centeredLabel ? parent.horizontalCenter : undefined
            text:                       control.alternateText === "" ? control.currentText : control.alternateText
            font:                       control.font
            color:                      "#293538"
            visible: !editable
        }
        TextField {
            id:         text
            text:       control.currentText
            anchors.verticalCenter:     parent.verticalCenter
            anchors.horizontalCenter:   centeredLabel ? parent.horizontalCenter : undefined
            font: control.font
            color: text.readOnly ? "#08D3E5" : "#293538"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            focus: true
            selectByMouse: true
            readOnly: !control.editable
            visible:  editable
            placeholderText: control.alternateText
            leftPadding: 4 * ScreenToolsController.ratio
            topPadding: 0
            bottomPadding: 0

            background: Rectangle {
                color: "transparent"//text.readOnly ? "transparent" : "white"
                //radius: text.readOnly ? 0 : 4
//                border.color: text.readOnly ? "transparent" : "#80BFE8"
//                border.width: text.readOnly ? 0 : 1
            }
            onEditingFinished: fieldText = text.text
        }
    }

    background: Rectangle {
        implicitWidth:  ScreenTools.implicitComboBoxWidth
        implicitHeight: ScreenTools.implicitComboBoxHeight
        color:          "white"
        border.color:   "#80BFE8"
        radius: 4
    }

    popup: T.Popup {
        y:              control.height
        width:          _popupWidth
        height:         Math.min(contentItem.implicitHeight, control.Window.height - topMargin - bottomMargin)
        topMargin:      6
        bottomMargin:   6

        contentItem: ListView {
            clip:                   true
            implicitHeight:         contentHeight
            model:                  control.delegateModel
            currentIndex:           control.highlightedIndex
            highlightMoveDuration:  0

            Rectangle {
                z:              10
                width:          parent.width
                height:         parent.height
                color:          "transparent"
                border.color:   _qgcPal.text
                radius: 4
            }

            T.ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            color: control.palette.window

        }
    }

    Rectangle {
        anchors.fill: parent
        color: "#084D5A"
        opacity: 0.8
        visible: !control.enabled
        radius: 4
        MouseArea {
            anchors.fill: parent
            onPressed: { }
            onReleased: { }
            onClicked: { }
            onWheel: { }
        }
    }
}
