import QtQuick 2.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

Row {
    spacing: 5 * ScreenToolsController.ratio

	Rectangle {
        width: 100 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		TextField {
			id: loiterToAltLatitudeField
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
			font.family: "MicrosoftYaHei"
			font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
			color: "#293538"
			horizontalAlignment: Text.AlignLeft
			verticalAlignment: Text.AlignVCenter
			focus: true
			selectByMouse: true
            text: missionItem.coordinate.latitude.toFixed(8)
            padding: 0

			background: Rectangle {
                radius: 4 * ScreenToolsController.ratio
				border.color: "#0AC6D7"
				border.width: 1
			}

			Rectangle {
				anchors.fill: parent
				color: "#084D5A"
				opacity: 0.8
				visible: !parent.enabled
                radius: 4 * ScreenToolsController.ratio
				MouseArea {
					anchors.fill: parent
					onPressed: { }
					onReleased: { }
					onClicked: { }
					onWheel: { }
				}
			}
			onEditingFinished: {
				missionItem.coordinate.latitude = text
			}
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: loiterToAltLatitudeField.bottom
            anchors.topMargin: 9 * ScreenToolsController.ratio
			text: qsTr("纬度")
			font.family: "MicrosoftYaHei"
			font.weight: Font.Bold
            font.pixelSize: 12 * ScreenToolsController.ratio
			color: "#B2F9FF"
		}
	}

	Rectangle {
        width: 100 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		TextField {
			id: loiterToAltLongitudeField
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
			font.family: "MicrosoftYaHei"
			font.weight: Font.Bold
            font.pixelSize: 14 * ScreenToolsController.ratio
			color: "#293538"
			horizontalAlignment: Text.AlignLeft
			verticalAlignment: Text.AlignVCenter
			focus: true
			selectByMouse: true
            text: missionItem.coordinate.longitude.toFixed(8)
            padding: 0

			background: Rectangle {
                radius: 4 * ScreenToolsController.ratio
				border.color: "#0AC6D7"
				border.width: 1
			}

			Rectangle {
				anchors.fill: parent
				color: "#084D5A"
				opacity: 0.8
				visible: !parent.enabled
                radius: 4 * ScreenToolsController.ratio
				MouseArea {
					anchors.fill: parent
					onPressed: { }
					onReleased: { }
					onClicked: { }
					onWheel: { }
				}
			}
			onEditingFinished: {
				missionItem.coordinate.longitude = text
			}
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: loiterToAltLongitudeField.bottom
            anchors.topMargin: 9 * ScreenToolsController.ratio
			text: qsTr("经度")
			font.family: "MicrosoftYaHei"
			font.weight: Font.Bold
            font.pixelSize: 12 * ScreenToolsController.ratio
			color: "#B2F9FF"
		}
	}

	Rectangle {
        width: 60 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		BeiLiFactTextField {
			id: loiterToAltAltField
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
            fact: missionItem.altitude
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: loiterToAltAltField.bottom
            anchors.topMargin: 9 * ScreenToolsController.ratio
			text: qsTr("高度")
			font.family: "MicrosoftYaHei"
			font.weight: Font.Bold
            font.pixelSize: 12 * ScreenToolsController.ratio
			color: "#B2F9FF"
		}
	}

	Rectangle {
        width: 60 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		BeiLiFactTextField {
			id: loiterToAltRadiusField
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
            fact: missionItem ? missionItem.textFieldFacts.get(0) : null
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: loiterToAltRadiusField.bottom
            anchors.topMargin: 9 * ScreenToolsController.ratio
			text: qsTr("半径")
			font.family: "MicrosoftYaHei"
			font.weight: Font.Bold
            font.pixelSize: 12 * ScreenToolsController.ratio
			color: "#B2F9FF"
		}
		Rectangle {
			anchors.fill: parent
			color: "#084D5A"
			opacity: 0.8
			visible: false
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

	Rectangle {
        width: 60 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		BeiLiFactTextField {
			id: loiterToAltFieldNone2
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
			fact: null
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: loiterToAltFieldNone2.bottom
            anchors.topMargin: 9 * ScreenToolsController.ratio
			text: qsTr("--")
			font.family: "MicrosoftYaHei"
			font.weight: Font.Bold
            font.pixelSize: 12 * ScreenToolsController.ratio
			color: "#B2F9FF"
		}
		Rectangle {
			anchors.fill: parent
			color: "#084D5A"
			opacity: 0.8
			visible: true
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
