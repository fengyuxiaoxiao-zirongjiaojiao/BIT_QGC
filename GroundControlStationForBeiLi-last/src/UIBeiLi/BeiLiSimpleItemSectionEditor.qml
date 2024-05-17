import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

// section
Row {
    spacing: 5 * ScreenToolsController.ratio
    property var    _planMasterController:      globals.planMasterControllerPlanView
    property var    _missionController:         _planMasterController.missionController
    property var    _currentMissionItem:        globals.currentPlanMissionItem          ///< Mission item to display status for

    // 速度
    Rectangle {
        width: 114 * ScreenToolsController.ratio
        height: 64 * ScreenToolsController.ratio
        color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10 * ScreenToolsController.ratio
            spacing: 10 * ScreenToolsController.ratio
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10 * ScreenToolsController.ratio
                Button {
                    id: flightSpeedBtn
                    width: 20 * ScreenToolsController.ratio
                    height: 20 * ScreenToolsController.ratio
                    checkable: true
                    checked: _currentMissionItem ? _currentMissionItem.speedSection.specifyFlightSpeed : false
                    background: Rectangle {
                        color: "transparent"
                    }
                    BorderImage {
                        source: flightSpeedBtn.checked || flightSpeedBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_speed_checked.png" : flightSpeedBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_speed_hovered.png" : "qrc:/qmlimages/BeiLi/icon_speed_normal.png"
                        width: flightSpeedBtn.width; height: flightSpeedBtn.height
                    }
                    onCheckedChanged: {
                        if (_currentMissionItem) _currentMissionItem.speedSection.specifyFlightSpeed = checked
                    }
                }

                Text {
                    text: qsTr("速度")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

            Column {
                spacing: 5 * ScreenToolsController.ratio
                BeiLiFactTextField {
                    id: flightSpeed
                    fact: _currentMissionItem ? _currentMissionItem.speedSection.flightSpeed : null
                    width: 60 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    enabled: _currentMissionItem ? _currentMissionItem.speedSection.specifyFlightSpeed : false
                }

                BeiLiFactTextField {
                    id: flightSpeedNone
                    text: "N/A"
                    width: 60 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    enabled: false
                }


            }
        }

    }

    // 拍照
    Rectangle {
        width: 130 * ScreenToolsController.ratio
        height: 64 * ScreenToolsController.ratio
        color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10 * ScreenToolsController.ratio
            spacing: 10 * ScreenToolsController.ratio
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10 * ScreenToolsController.ratio
                Button {
                    id: takePhotoBtn
                    width: 20 * ScreenToolsController.ratio
                    height: 20 * ScreenToolsController.ratio
                    checkable: true
                    background: Rectangle {
                        color: "transparent"
                    }
                    BorderImage {
                        source: takePhotoBtn.checked || takePhotoBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_photo_checked.png" : takePhotoBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_photo_hovered.png" : "qrc:/qmlimages/BeiLi/icon_photo_normal.png"
                        width: takePhotoBtn.width; height: takePhotoBtn.height
                    }
                }

                Text {
                    text: qsTr("拍照")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

            Column {
                spacing: 5 * ScreenToolsController.ratio
                BeiLiComboBox {
                    id:             cameraSectionComboBox
                    width:          76 * ScreenToolsController.ratio
                    height:         26 * ScreenToolsController.ratio
                    enabled:        takePhotoBtn.checked
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    model:          _currentMissionItem ? _currentMissionItem.cameraSection.cameraAction.enumStrings : null
                    function updateComboBox() {
                        var index = 0
                        if(_currentMissionItem !== null) {
                            index = _currentMissionItem.cameraSection.cameraAction.enumIndex
                        }
                        cameraSectionComboBox.currentIndex = index


                    }

                    onActivated: {
                        if (index != -1 && _currentMissionItem) {
                            _currentMissionItem.cameraSection.cameraAction.value = missionItem.cameraSection.cameraAction.enumValues[index]
                        }
                    }
                    Component.onCompleted: {
                        updateComboBox()
                    }
                }

                BeiLiFactTextField {
                    id: cameraSectionParamTime
                    fact: _currentMissionItem ? _currentMissionItem.cameraSection.cameraPhotoIntervalTime : null
                    width: 76 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    visible: _currentMissionItem ? _currentMissionItem.cameraSection.cameraAction.rawValue === 1 : false
                }

                BeiLiFactTextField {
                    id: cameraSectionParamDistance
                    fact: _currentMissionItem ? _currentMissionItem.cameraSection.cameraPhotoIntervalDistance : null
                    width: 76 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    visible: _currentMissionItem ? _currentMissionItem.cameraSection.cameraAction.rawValue === 2 : false
                }

                BeiLiFactTextField {
                    id: cameraSectionParamNone
                    fact: null
                    width: 76 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    enabled: false
                    visible: _currentMissionItem ? (_currentMissionItem.cameraSection.cameraAction.rawValue !== 1 && _currentMissionItem.cameraSection.cameraAction.rawValue !== 2) : true
                }

            }
        }

    }

    // 云台
    Rectangle {
        width: 171 * ScreenToolsController.ratio
        height: 64 * ScreenToolsController.ratio
        color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 10 * ScreenToolsController.ratio
            spacing: 10 * ScreenToolsController.ratio
            Column {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 10 * ScreenToolsController.ratio
                Button {
                    id: gimbalBtn
                    width: 20 * ScreenToolsController.ratio
                    height: 20 * ScreenToolsController.ratio
                    checkable: true
                    checked: _currentMissionItem ? _currentMissionItem.cameraSection.specifyGimbal : false
                    background: Rectangle {
                        color: "transparent"
                    }
                    BorderImage {
                        source: gimbalBtn.checked || gimbalBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_gimbal_checked.png" : gimbalBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_gimbal_hovered.png" : "qrc:/qmlimages/BeiLi/icon_gimbal_normal.png"
                        width: gimbalBtn.width; height: gimbalBtn.height
                    }
                    onCheckedChanged: {
                        if (_currentMissionItem) _currentMissionItem.cameraSection.specifyGimbal = checked
                    }
                }

                Text {
                    text: qsTr("云台")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

            Grid {
                rows: 2
                columns: 2
                rowSpacing: 5 * ScreenToolsController.ratio
                columnSpacing: 0
                flow: Grid.TopToBottom
                layoutDirection: Qt.LeftToRight
                BeiLiComboBox {
                    id:             gimbalModeComboBox
                    enabled:        gimbalBtn.checked && (_currentMissionItem ? _currentMissionItem.cameraSection.cameraModeSupported : false)
                    width:          60 * ScreenToolsController.ratio
                    height:         26 * ScreenToolsController.ratio
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    model:          _currentMissionItem ? _currentMissionItem.cameraSection.cameraMode.enumStrings : null
                    function updateComboBox() {
                        var index = 0
                        if(_currentMissionItem !== null) {
                            index = _currentMissionItem.cameraSection.cameraMode.enumIndex
                        }
                        gimbalModeComboBox.currentIndex = index

                    }

                    onActivated: {
                        if (index != -1 && _currentMissionItem) {
                            _currentMissionItem.cameraSection.cameraMode.value = _currentMissionItem.cameraSection.cameraMode.enumValues[index]
                        }
                    }
                    Component.onCompleted: {
                        updateComboBox()
                    }
                }

                BeiLiFactTextField {
                    id: gimbalPitch
                    fact: _currentMissionItem ? _currentMissionItem.cameraSection.gimbalPitch : null
                    width: 60 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    enabled:        gimbalBtn.checked
                }

                BeiLiFactTextField {
                    id: gimbalYaw
                    fact: _currentMissionItem ? _currentMissionItem.cameraSection.gimbalYaw : null
                    width: 60 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    enabled:        gimbalBtn.checked
                }

                BeiLiFactTextField {
                    id: gimbalRoll
                    fact: null//missionItem.cameraSection.gimbalRoll
                    width: 60 * ScreenToolsController.ratio
                    height: 26 * ScreenToolsController.ratio
                    enabled:        gimbalBtn.checked
                }
            }
        }

    } // 云台

    // 按钮 删除和飞机/小车
    Item {
        height: 60 * ScreenToolsController.ratio
        width: 60 * ScreenToolsController.ratio
        Row {
            spacing: 5 * ScreenToolsController.ratio
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left

            Rectangle {
                id: carOrPlaneCheckBtn
                property bool checked: _currentMissionItem ? _currentMissionItem.carSection.specifyCarAndPlane : false
                property bool hovered
                onCheckedChanged: {
                    if (_currentMissionItem) {
                        _currentMissionItem.carSection.specifyCarAndPlane = carOrPlaneCheckBtn.checked
                    }
                }

                anchors.verticalCenter: parent.verticalCenter
                width: 12 * ScreenToolsController.ratio
                height: 12 * ScreenToolsController.ratio
                radius: width/2
                color: "transparent"
                border.color: carOrPlaneCheckBtn.checked ? Qt.rgba(37, 240, 133, 0.5)/*"#25f085"*/ : carOrPlaneCheckBtn.hovered ? Qt.rgba(178, 249, 255, 0.5)/*"#b2f9ff"*/ : Qt.rgba(8, 211, 229, 0.5)/*"#08d3e5"*/
                border.width: 1

                Rectangle {
                    width: 6 * ScreenToolsController.ratio
                    height: 6 * ScreenToolsController.ratio
                    radius: width/2
                    anchors.centerIn: parent
                    color: carOrPlaneCheckBtn.checked ? "#25f085" : carOrPlaneCheckBtn.hovered ? "#b2f9ff" : "#08d3e5"
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: carOrPlaneCheckBtn.checked = !carOrPlaneCheckBtn.checked
                    onEntered: carOrPlaneCheckBtn.hovered = true
                    onExited: carOrPlaneCheckBtn.hovered = false
                }
            }

            Rectangle {
                id: carOrPlanaBack
                color: "#189764"
                width: 40 * ScreenToolsController.ratio
                height: 24 * ScreenToolsController.ratio
                radius: 12 * ScreenToolsController.ratio
                property bool isCar: _currentMissionItem ? _currentMissionItem.carSection.carAndPlane.value : false
                property bool enabled: carOrPlaneCheckBtn.checked

                Image {
                    id: carIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    source: "qrc:/qmlimages/BeiLi/mode_icon_car.png"
                    visible: carOrPlanaBack.isCar
                    width: 24 * ScreenToolsController.ratio
                    height: 24 * ScreenToolsController.ratio
                    sourceSize.width: 24 * ScreenToolsController.ratio
                    sourceSize.height: 24 * ScreenToolsController.ratio
                }

                Image {
                    id: planIcon
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    source: "qrc:/qmlimages/BeiLi/mode_icon_plan.png"
                    visible: !carOrPlanaBack.isCar
                    width: 24 * ScreenToolsController.ratio
                    height: 24 * ScreenToolsController.ratio
                    sourceSize.width: 24 * ScreenToolsController.ratio
                    sourceSize.height: 24 * ScreenToolsController.ratio
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        carOrPlanaBack.isCar = !carOrPlanaBack.isCar
                        if (_currentMissionItem) {
                            _currentMissionItem.carSection.carAndPlane.value = carOrPlanaBack.isCar
                        }
                    }
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#084D5A"
                    opacity: 0.8
                    visible: !carOrPlanaBack.enabled
                    radius: 4 * ScreenToolsController.ratio
                    MouseArea {
                        anchors.fill: parent
                        onPressed: { }
                        onReleased: { }
                        onClicked: { }
                        onWheel: { }
                    }
                }

            }
        }
    }

}
