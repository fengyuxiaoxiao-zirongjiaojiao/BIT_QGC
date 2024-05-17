import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0

Item {
    id: _root
    property var _currentMissionItem: globals.currentPlanMissionItem          ///< Mission item to display status for

//    Flow {
//        anchors.top: _root.top
//        anchors.left: _root.left
//        spacing: 10
//        width: 490

//        Column {
//            ActionButtonFour {
//                checkable: true
//                text: qsTr("盘旋降高")
//                onCheckedChanged: {

//                }
//            }
//        }

//        Rectangle {
//            width: 60
//            height: 60
//            color: "#084D5A"
//            radius: 4
//            BeiLiFactTextField {
//                id: descentAltField
//                anchors.top: parent.top
//                anchors.left: parent.left
//                anchors.right: parent.right
//                height: 30
//                fact: _currentMissionItem.finalApproachAltitude
//            }

//            Text {
//                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.top: descentAltField.bottom
//                anchors.topMargin: 9
//                text: qsTr("降高")
//                font.family: "MicrosoftYaHei"
//                font.weight: Font.Bold
//                font.pixelSize: 12
//                color: "#B2F9FF"
//            }
//        }

//        Rectangle {
//            width: 60
//            height: 60
//            color: "#084D5A"
//            radius: 4
//            visible: _currentMissionItem.useLoiterToAlt.rawValue
//            BeiLiFactTextField {
//                id: loiterRadiusField
//                anchors.top: parent.top
//                anchors.left: parent.left
//                anchors.right: parent.right
//                height: 30
//                fact: _currentMissionItem.loiterRadius
//            }

//            Text {
//                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.top: loiterRadiusField.bottom
//                anchors.topMargin: 9
//                text: qsTr("半径")
//                font.family: "MicrosoftYaHei"
//                font.weight: Font.Bold
//                font.pixelSize: 12
//                color: "#B2F9FF"
//            }
//        }

//        Rectangle {
//            width: 60
//            height: 60
//            color: "#084D5A"
//            radius: 4
//            BeiLiFactTextField {
//                id: waypointAltField
//                anchors.top: parent.top
//                anchors.left: parent.left
//                anchors.right: parent.right
//                height: 30
//                fact: missionItem.altitude
//            }

//            Text {
//                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.top: waypointAltField.bottom
//                anchors.topMargin: 9
//                text: qsTr("高度")
//                font.family: "MicrosoftYaHei"
//                font.weight: Font.Bold
//                font.pixelSize: 12
//                color: "#B2F9FF"
//            }
//        }

//        Rectangle {
//            width: 60
//            height: 60
//            color: "#084D5A"
//            radius: 4
//            BeiLiFactTextField {
//                id: waypointFieldNone1
//                anchors.top: parent.top
//                anchors.left: parent.left
//                anchors.right: parent.right
//                height: 30
//                fact: null
//            }

//            Text {
//                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.top: waypointFieldNone1.bottom
//                anchors.topMargin: 9
//                text: qsTr("--")
//                font.family: "MicrosoftYaHei"
//                font.weight: Font.Bold
//                font.pixelSize: 12
//                color: "#B2F9FF"
//            }
//            Rectangle {
//                anchors.fill: parent
//                color: "#084D5A"
//                opacity: 0.8
//                visible: true
//                radius: 4
//                MouseArea {
//                    anchors.fill: parent
//                    onPressed: { }
//                    onReleased: { }
//                    onClicked: { }
//                    onWheel: { }
//                }
//            }
//        }

//        Rectangle {
//            width: 60
//            height: 60
//            color: "#084D5A"
//            radius: 4
//            BeiLiFactTextField {
//                id: waypointFieldNone2
//                anchors.top: parent.top
//                anchors.left: parent.left
//                anchors.right: parent.right
//                height: 30
//                fact: null
//            }

//            Text {
//                anchors.horizontalCenter: parent.horizontalCenter
//                anchors.top: waypointFieldNone2.bottom
//                anchors.topMargin: 9
//                text: qsTr("--")
//                font.family: "MicrosoftYaHei"
//                font.weight: Font.Bold
//                font.pixelSize: 12
//                color: "#B2F9FF"
//            }
//            Rectangle {
//                anchors.fill: parent
//                color: "#084D5A"
//                opacity: 0.8
//                visible: true
//                radius: 4
//                MouseArea {
//                    anchors.fill: parent
//                    onPressed: { }
//                    onReleased: { }
//                    onClicked: { }
//                    onWheel: { }
//                }
//            }
//        }

//    }

}
