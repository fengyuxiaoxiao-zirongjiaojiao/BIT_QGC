import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _root

    property var _commandStringList: [qsTr("Home"), qsTr("起飞"), /*qsTr("爬高"),*/ qsTr("导航点"), qsTr("返航"), qsTr("降落")]
    property var _missionItem: missionItem
    property var _command: _missionItem ? _missionItem.command : null

    function searchIndex(seq) {
        for(var i = 0; i < missionController.visualItems.count; i++) {
            if (missionController.visualItems.get(i).sequenceNumber === seq) return i
        }
        return -1
    }

    function command(index) {
        if (index === 1) return missionController.takeoffCommand()
        //else if (index === 2) return 31/*MAV_CMD_NAV_LOITER_TO_ALT*/
        else if (index === 2) return 16 /*MAV_CMD_NAV_WAYPOINT*/
        else if (index === 3) return 20 /*MAV_CMD_NAV_RETURN_TO_LAUNCH*/
        else if (index === 4) return missionController.landCommand()
        else return 16
    }

    function commandIndex(missionItem) {
        var index = 0
        if(missionItem !== null) {
            if(missionItem.command === 22/*MAV_CMD_NAV_TAKEOFF*/ || missionItem.command === 24/*MAV_CMD_NAV_TAKEOFF_LOCAL*/ || missionItem.command === 84/*MAV_CMD_NAV_VTOL_TAKEOFF*/) {
                index = 1
            }
            //else if (missionItem.command === 31/*MAV_CMD_NAV_LOITER_TO_ALT*/) {
            //    return 2
            //}
            else if (missionItem.command === 16/*MAV_CMD_NAV_WAYPOINT*/) {
                index = 2
            } else if (missionItem.command === 20/*MAV_CMD_NAV_RETURN_TO_LAUNCH*/) {
                index = 3
            } else if (missionItem.command === 21/*MAV_CMD_NAV_LAND*/ || missionItem.command === 85/*MAV_CMD_NAV_VTOL_LAND*/) {
                index = 4
            }
        }
        return index
    }

    function commandComponent(command) {
            if (command === 22 || command === 24 || command === 84 ) return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiTakeoffItem.qml"
            else if (command === 31) return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiLoiterToAltItem.qml"
            else if (command === 16) return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiWaypointItem.qml"
            else if (command === 20) return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiItemNoneParame.qml"
            else if (command === 21 || command === 85) return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiLandItem.qml"
            else return ""
    }

    on_CommandChanged: {
        commandComboBox.currentIndex = commandIndex(_missionItem)
        //console.log("command", _missionItem.command)
        simpleMissionItemParame.source = commandComponent(_missionItem.command)
    }

    Connections {
        target: missionController
        onCurrentPlanViewSeqNumChanged: {
            var curIndex = searchIndex(missionController.currentPlanViewSeqNum)
            if (curIndex >= 0 && curIndex < missionController.visualItems.count) {
                var visualItem = missionController.visualItems.get(curIndex)
                if (visualItem.isSimpleItem) {
                    simpleMissionItemParame.source = commandComponent(visualItem.command)
                    //_missionItem = visualItem
                }
                commandComboBox.currentIndex = commandIndex(visualItem)
            } else {
                simpleMissionItemParame.source = commandComponent(visualItem.command)
                //_missionItem = null
            }

            simpleMissionItemSection.source = ""
            simpleMissionItemSection.source = "qrc:/qml/QGroundControl/UIBeiLi/BeiLiSimpleItemSectionEditor.qml"
        }
    }

    Column {
        id: parameGrid
        spacing: 10 * ScreenToolsController.ratio

        Row {
            spacing: 10 * ScreenToolsController.ratio
            Rectangle {
                width: 60 * ScreenToolsController.ratio
                height: 60 * ScreenToolsController.ratio
                color: "#084D5A"
                radius: 4 * ScreenToolsController.ratio
                BeiLiComboBox {
                    id:             commandComboBox
                    width:          60 * ScreenToolsController.ratio
                    height:         30 * ScreenToolsController.ratio
                    font.pixelSize: 14 * ScreenToolsController.ratio
                    model:          _commandStringList
                    function updateComboBox() {
                        commandComboBox.currentIndex = commandIndex(missionItem)
                    }

                    onActivated: {
                        if (index != -1 && missionItem) {
                            var com = command(index)
                            if (com === 22) {
                                var curVIIndex = missionController.currentPlanViewVIIndex
                                missionController.removeVisualItem(curVIIndex)
                                missionController.insertTakeoffItem(missionItem.coordinate, curVIIndex, true /* makeCurrentItem */)
                            } else {
                                missionItem.command = com
                            }
                            _command = com
                            console.log("isTakeoffItem", _command === 22)
                        }
                    }
                    Component.onCompleted: {
                        updateComboBox()
                    }
                }

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: commandComboBox.bottom
                    anchors.topMargin: 9 * ScreenToolsController.ratio
                    text: qsTr("命令")
                    font.family: "MicrosoftYaHei"
                    font.weight: Font.Bold
                    font.pixelSize: 12 * ScreenToolsController.ratio
                    color: "#B2F9FF"
                }
            }

            Loader {
                id: simpleMissionItemParame
            }
        }

        Loader {
            id: simpleMissionItemSection
            source: "qrc:/qml/QGroundControl/UIBeiLi/BeiLiSimpleItemSectionEditor.qml"
        }
    }

}
