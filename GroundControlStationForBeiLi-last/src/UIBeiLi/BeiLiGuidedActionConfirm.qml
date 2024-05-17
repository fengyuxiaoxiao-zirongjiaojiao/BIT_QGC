/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.ScreenToolsController   1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0

Rectangle {
    id:                     _root
    Layout.minimumWidth:    mainLayout.width + (_margins * 2)
    Layout.preferredHeight: mainLayout.height + (_margins * 2)
    //radius:                 ScreenTools.defaultFontPixelWidth / 2
    color:                  "#07424F"
    visible:                false
    width: Math.max(320 * ScreenToolsController.ratio, messageText.contentWidth + (_margins * 2))
    height: 162 * ScreenToolsController.ratio
    property var    guidedController
    property var    altitudeSlider
    property string title                                       // Currently unused
    property alias  message:            messageText.text
    property int    action
    property var    actionData
    property bool   hideTrigger:        false
    property var    mapIndicator
    property alias  optionText:         optionCheckBox.text
    property alias  optionChecked:      optionCheckBox.checked

    property real _margins:         20 * ScreenToolsController.ratio
    property bool _emergencyAction: action === guidedController.actionEmergencyStop

    Component.onCompleted: guidedController.confirmDialog = this

    onHideTriggerChanged: {
        if (hideTrigger) {
            confirmCancelled()
        }
    }

    function show(immediate) {
        if (immediate) {
            visible = true
        } else {
            // We delay showing the confirmation for a small amount in order for any other state
            // changes to propogate through the system. This way only the final state shows up.
            visibleTimer.restart()
        }
    }

    function confirmCancelled() {
        altitudeSlider.visible = false
        visible = false
        hideTrigger = false
        visibleTimer.stop()
        if (mapIndicator) {
            mapIndicator.actionCancelled()
            mapIndicator = undefined
        }
    }

    Timer {
        id:             visibleTimer
        interval:       1000
        repeat:         false
        onTriggered:    visible = true
    }

    Image {
        id: _upperLeft
        source: "qrc:/qmlimages/BeiLi/form_upper_left.png"
        anchors.top: parent.top
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_upper_right.png"
        anchors.top: parent.top
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_left.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_right.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    ColumnLayout {
        id:                         mainLayout
        anchors.horizontalCenter:   parent.horizontalCenter
        anchors.verticalCenter:     parent.verticalCenter
        spacing:                    25 * ScreenToolsController.ratio

        Text {
            id:                     messageText
            width: _root.width
            Layout.fillWidth:       true
            font.family:            "MicrosoftYaHei"
            font.weight:            Font.Bold
            font.pixelSize:         18 * ScreenToolsController.ratio
            color:                  "#B2F9FF"
            horizontalAlignment:    Text.AlignHCenter
            wrapMode:               Text.WordWrap
        }

        QGCCheckBox {
            id:                 optionCheckBox
            Layout.alignment:   Qt.AlignHCenter
            text:               ""
            visible:            text !== ""
        }

        RowLayout {
            Layout.alignment:       Qt.AlignHCenter
            spacing:                ScreenTools.defaultFontPixelWidth

            BeiLiSliderSwitch {
                id:                     slider
                confirmText:            qsTr("Slide to confirm")
                //Layout.minimumWidth:    Math.max(implicitWidth, ScreenTools.defaultFontPixelWidth * 30)

                onAccept: {
                    _root.visible = false
                    var altitudeChange = 0
                    if (altitudeSlider.visible) {
                        altitudeChange = altitudeSlider.getAltitudeChangeValue()
                        altitudeSlider.visible = false
                    }
                    hideTrigger = false
                    guidedController.executeAction(_root.action, _root.actionData, altitudeChange, _root.optionChecked)
                    if (mapIndicator) {
                        mapIndicator.actionConfirmed()
                        mapIndicator = undefined
                    }
                }
            }

        }
    }

    Button {
        id: closeBtn
        anchors.top: parent.top
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        width: 28 * ScreenToolsController.ratio
        height: 20 * ScreenToolsController.ratio

        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: closeBtn.checked || closeBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : closeBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : "qrc:/qmlimages/BeiLi/icon_close_normal.png"
            width: closeBtn.width; height: closeBtn.height
        }

        onClicked:  confirmCancelled()
    }
}

