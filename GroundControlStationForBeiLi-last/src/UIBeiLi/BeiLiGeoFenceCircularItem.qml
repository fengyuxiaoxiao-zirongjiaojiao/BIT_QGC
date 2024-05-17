import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Controls 2.14

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _root
    property bool checked
    property bool inclusion
    property Fact radius
    signal removeClicked()
    signal clicked();
    width: 238 * ScreenToolsController.ratio
    height: 26 * ScreenToolsController.ratio

    property ExclusiveGroup exclusiveGroup: null //对外开放一个ExclusiveGroup接口，用于绑定同个组

    function onClickedFunc() {
        _root.checked = !_root.checked
        _root.clicked();
    }

    onExclusiveGroupChanged: {
        if (exclusiveGroup) {
            exclusiveGroup.bindCheckable(_root)
        }
    }

    Rectangle {
        id: backGround
        width: parent.width
        height: 26 * ScreenToolsController.ratio
        color: _root.checked ? "#08D3E5" : "transparent"
        opacity: 0.2
    }
    MouseArea {
        anchors.fill: backGround
        onClicked: {
            _root.onClickedFunc()
        }
    }
    Row {
        Item {
            width: _root.width / 4
            height: _root.height
            Rectangle {
                id: actionRadioButton
                anchors.centerIn: parent
                property bool checked: _root.checked

                width: 12 * ScreenToolsController.ratio
                height: 12 * ScreenToolsController.ratio
                radius: width/2
                color: "transparent"
                border.color: actionRadioButton.checked ? Qt.rgba(37, 240, 133, 0.5)/*"#25f085"*/ : actionRadioButton.hovered ? Qt.rgba(178, 249, 255, 0.5)/*"#b2f9ff"*/ : Qt.rgba(8, 211, 229, 0.5)/*"#08d3e5"*/
                border.width: 1

                Rectangle {
                    width: actionRadioButton.width / 2
                    height: actionRadioButton.height / 2
                    radius: width/2
                    anchors.centerIn: parent
                    visible: actionRadioButton.checked
                    color: actionRadioButton.checked ? "#25f085" : actionRadioButton.hovered ? "#b2f9ff" : "#08d3e5"
                }

                MouseArea {
                    anchors.fill: actionRadioButton
                    onClicked: {
                        _root.onClickedFunc()
                    }
                }
            }
        }

        Item {
            width: _root.width / 4
            height: _root.height
            BeiLiCheckBox {
                text: qsTr("")
                checked:            _root.inclusion
                onCheckStateChanged: _root.inclusion = checked
                anchors.centerIn: parent
            }
        }

        Item {
            width: _root.width / 4
            height: _root.height
            BeiLiFactTextField {
                id: radiusFactTextField
                height: 26 * ScreenToolsController.ratio
                width: 54 * ScreenToolsController.ratio
                anchors.centerIn: parent
                fact: _root.radius
            }
        }

        Item {
            width: _root.width / 4
            height: _root.height
            Button {
                anchors.centerIn: parent
                width: 12 * ScreenToolsController.ratio
                height: 12 * ScreenToolsController.ratio

                background: Rectangle {
                    color: "transparent"
                }
                BorderImage {
                    source: "qrc:/qmlimages/BeiLi/camera_remove_btn.png"
                    width: 12 * ScreenToolsController.ratio; height: 12 * ScreenToolsController.ratio
                }

                onClicked: _root.removeClicked()
            }
        }
    }
}
