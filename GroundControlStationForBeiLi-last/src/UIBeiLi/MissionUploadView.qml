import QtQuick 2.4
//import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl               1.0
import QGroundControl.Vehicle       1.0
import QGroundControl.HttpAPIManager 1.0

Item {
    id: _root
    property var vehicleIds: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]
    property var checkedIds: []
    property var    _planMasterController:      globals.planMasterControllerPlanView
    function upload() {
        checkedIds = []
        for (var i = 0; i < vehicleIdsRepeater.count; i++) {
            var btn = vehicleIdsRepeater.itemAt(i)
            if (btn && btn.checked) {
                var id = btn.text
                checkedIds.push(id);
            }
        }
        if (checkedIds.length > 0) {
            _planMasterController.setSelectedVehicleIds(checkedIds)
            _planMasterController.uploadToVehicles()
            _root.visible = false
        }
    }

    Rectangle {
        id: mask
        color: "#000000"
        opacity: 0.6
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {}
        onReleased: {}
        onWheel: {}
    }

    Rectangle {
        id: background
        anchors.centerIn: parent
        color: "#07424F"
        width: 519
        height: 265

        Text {
            id: title
            text: qsTr("请选择设备")
            anchors.top: parent.top
            anchors.topMargin: 14
            anchors.left: parent.left
            anchors.leftMargin: 48
            color: "#B2F9FF"
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 16
        }

        Text {
            id: infoMsg
            text: qsTr("注意：“当前上传”为上传到当前激活的飞机。")
            anchors.top: parent.top
            anchors.topMargin: 14
            anchors.left: title.right
            anchors.leftMargin: 48
            color: "#B2F9FF"
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 14
        }

        Grid {
            id: vehicleIdGrid
            anchors.top: parent.top
            anchors.topMargin: 46
            anchors.left: parent.left
            anchors.leftMargin: 48
            rows: 4
            rowSpacing: 20
            columnSpacing: 28
            flow: Grid.LeftToRight
            layoutDirection: Qt.LeftToRight

            Repeater {
                id: vehicleIdsRepeater
                model: vehicleIds
                FlyRoundButton {
                    id: btn1
                    text: modelData
                    enabled: true
                    isLinked: true
                    onCheckedChanged: {
                        if (!checked) {
                            selectAllCheckBox.checked = false
                        }
                    }
                }
            }

        }

        ToolSeparator {
            id: toolSeparator
            anchors.verticalCenter: vehicleIdGrid.verticalCenter
            anchors.left: vehicleIdGrid.right
            anchors.leftMargin: 50
            contentItem: Rectangle {
                implicitWidth: 1
                implicitHeight: 204
                color: "#118E9B"
            }
        }

        CheckBox {
            id: selectAllCheckBox
            anchors.left: toolSeparator.right
            anchors.leftMargin: 35
            anchors.top: parent.top
            anchors.topMargin: 46
            text: qsTr("全选")
            height: 20
            checkable: true
            onClicked: {
                for (var i = 0; i < vehicleIdsRepeater.count; i++) {
                    var btn = vehicleIdsRepeater.itemAt(i)
                    btn.checked = checked
                }
            }
            indicator: Rectangle {
                id: indicatorRec
                anchors.left: selectAllCheckBox.left
                anchors.verticalCenter: selectAllCheckBox.verticalCenter
                width: 12
                height: 12
                color: "transparent"
                Image {
                    source: selectAllCheckBox.checked ? "qrc:/qmlimages/BeiLi/login_icon_remembered_checked.png" : "qrc:/qmlimages/BeiLi/login_icon_remembered.png"
                }
            }


            contentItem: Text {
                anchors.verticalCenter: indicatorRec.verticalCenter
                anchors.left: indicatorRec.right
                anchors.leftMargin: 8
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 14
                color: "#B2F9FF"
                text: selectAllCheckBox.text
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }

        ActionButtonFour {
            id: confirmUploadBtn
            text: qsTr("确定上传")
            enabled: true
            anchors.left: toolSeparator.right
            anchors.leftMargin: 35
            anchors.top: selectAllCheckBox.bottom
            anchors.topMargin: 30
            onClicked: {
                _root.upload()
            }
        }

        ActionButtonFour {
            id: uploadToActiveVehicleBtn
            text: qsTr("当前上传")
            enabled: true
            anchors.left: toolSeparator.right
            anchors.leftMargin: 35
            anchors.top: confirmUploadBtn.bottom
            anchors.topMargin: 20
            onClicked: {
                _planMasterController.upload()
                _root.visible = false
            }
        }

        ActionButtonFour {
            text: qsTr("取消上传")
            enabled: true
            anchors.left: toolSeparator.right
            anchors.leftMargin: 35
            anchors.top: uploadToActiveVehicleBtn.bottom
            anchors.topMargin: 20
            onClicked: {
                _root.visible = false
            }
        }

    }

}
