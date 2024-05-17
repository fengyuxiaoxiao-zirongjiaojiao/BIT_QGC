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
        width: 60 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		BeiLiFactTextField {
            id: noneField
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
            fact: null
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: noneField.bottom
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
	// none
	Rectangle {
        width: 60 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		BeiLiFactTextField {
            id: noneField1
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
			fact: null
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: noneField1.bottom
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

	Rectangle {
        width: 60 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		BeiLiFactTextField {
            id: noneField2
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
			fact: null
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: noneField2.bottom
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
	Rectangle {
        width: 60 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		BeiLiFactTextField {
            id: noneField3
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
			fact: null
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: noneField3.bottom
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
	Rectangle {
        width: 60 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		BeiLiFactTextField {
            id: noneField4
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
			fact: null
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: noneField4.bottom
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
            opacity: 0.8 * ScreenToolsController.ratio
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
	Rectangle {
        width: 60 * ScreenToolsController.ratio
        height: 60 * ScreenToolsController.ratio
		color: "#084D5A"
        radius: 4 * ScreenToolsController.ratio
		BeiLiFactTextField {
            id: noneField5
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
            height: 30 * ScreenToolsController.ratio
			fact: null
		}

		Text {
			anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: noneField5.bottom
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
