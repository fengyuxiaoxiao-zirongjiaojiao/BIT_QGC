import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _buttonBar

    property var firstText: "first"
    property var secondText: "second"
    property var thirdText: "third"
    property var fourthText: "fourth"
    property var fifthText: "fifth"
    property int current: 1

    signal firstClicked()
    signal secondClicked()
    signal thirdClicked()
    signal fourthClicked()
    signal fifthClicked()
    signal checkChanged(int v)

    onCurrentChanged: {
        calcCheckState()
    }

    function calcCheckState()
    {
        if (current === 0) {
            _firstBtnBg.source = "qrc:/qmlimages/BeiLi/cluster_btn_checked.png"
            _firstText.color = "#B2F9FF"

            _secondBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _secondText.color = "#08D3E5"
            _thirdBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _thirdText.color = "#08D3E5"
            _fourthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fourthText.color = "#08D3E5"
            _fifthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fifthText.color = "#08D3E5"

        } else if (current === 1) {
            _secondBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_checked.png"
            _secondText.color = "#B2F9FF"

            _firstBtnBg.source = "qrc:/qmlimages/BeiLi/cluster_btn_normal.png"
            _firstText.color = "#08D3E5"
            _thirdBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _thirdText.color = "#08D3E5"
            _fourthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fourthText.color = "#08D3E5"
            _fifthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fifthText.color = "#08D3E5"
        } else if (current === 2) {
            _thirdBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_checked.png"
            _thirdText.color = "#B2F9FF"

            _firstBtnBg.source = "qrc:/qmlimages/BeiLi/cluster_btn_normal.png"
            _firstText.color = "#08D3E5"
            _secondBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _secondText.color = "#08D3E5"
            _fourthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fourthText.color = "#08D3E5"
            _fifthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fifthText.color = "#08D3E5"
        } else if (current ===3 ) {
            _fourthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_checked.png"
            _fourthText.color = "#B2F9FF"

            _firstBtnBg.source = "qrc:/qmlimages/BeiLi/cluster_btn_normal.png"
            _firstText.color = "#08D3E5"
            _secondBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _secondText.color = "#08D3E5"
            _thirdBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _thirdText.color = "#08D3E5"
            _fifthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fifthText.color = "#08D3E5"
        } else if (current == 4) {
            _fifthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_checked.png"
            _fifthText.color = "#B2F9FF"

            _firstBtnBg.source = "qrc:/qmlimages/BeiLi/cluster_btn_normal.png"
            _firstText.color = "#08D3E5"
            _secondBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _secondText.color = "#08D3E5"
            _thirdBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _thirdText.color = "#08D3E5"
            _fourthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fourthText.color = "#08D3E5"
        } else {
            _firstBtnBg.source = "qrc:/qmlimages/BeiLi/cluster_btn_normal.png"
            _firstText.color = "#08D3E5"
            _secondBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _secondText.color = "#08D3E5"
            _thirdBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _thirdText.color = "#08D3E5"
            _fourthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fourthText.color = "#08D3E5"
            _fifthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_normal.png"
            _fifthText.color = "#08D3E5"
        }

        checkChanged(current)
    }

    // first
    Image {
        id: _firstBtnBg
        anchors.top: parent.top
        anchors.left: parent.left
        width: 118 * ScreenToolsController.ratio
        height: 38 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
        Button {
            id: _firstBtn
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100 * ScreenToolsController.ratio
                    implicitHeight: 38 * ScreenToolsController.ratio
                    color: "transparent"
                }
            }

            onClicked: {
                _buttonBar.firstClicked()
            }

            onHoveredChanged: {
                if (current != 0) {
                    _firstBtnBg.source = _firstBtn.hovered ? "qrc:/qmlimages/BeiLi/cluster_btn_hovered.png" : "qrc:/qmlimages/BeiLi/cluster_btn_normal.png"
                    _firstText.color = _firstBtn.hovered ? "#B2F9FF" : "#08D3E5"
                }
            }

            onPressedChanged: {
                if (_firstBtn.pressed) {
                    if (current === 0) current = -1
                    else {
                        current = 0
                        _firstBtnBg.source = "qrc:/qmlimages/BeiLi/cluster_btn_checked.png"
                        _firstText.color = "#B2F9FF"
                    }
                }
            }
        }

        Text {
            id: _firstText
            anchors.centerIn: parent
            text: _buttonBar.firstText
            color: "#08D3E5"
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 20 * ScreenToolsController.ratio
        }

    }

    // second
    Image {
        id: _secondBtnBg
        anchors.top: parent.top
        anchors.left: _firstBtnBg.right
        anchors.leftMargin: -19 * ScreenToolsController.ratio
        width: 118 * ScreenToolsController.ratio
        height: 38 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height

        Button {
            id: _secondBtn
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100 * ScreenToolsController.ratio
                    implicitHeight: 38 * ScreenToolsController.ratio
                    color: "transparent"
                }
            }

            onClicked: {
                _buttonBar.secondClicked()
            }

            onHoveredChanged: {
                if (current != 1) {
                    _secondBtnBg.source = _secondBtn.hovered ? "qrc:/qmlimages/BeiLi/features_btn_hovered.png" : "qrc:/qmlimages/BeiLi/features_btn_normal.png"
                    _secondText.color = _secondBtn.hovered ? "#B2F9FF" : "#08D3E5"
                }
            }

            onPressedChanged: {
                if (_secondBtn.pressed) {
                    if (current === 1) current = -1
                    else {
                        current = 1
                        _secondBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_checked.png"
                        _secondText.color = "#B2F9FF"
                    }
                }
            }
        }

        Text {
            id: _secondText
            anchors.centerIn: parent
            text: _buttonBar.secondText
            color: "#08D3E5"
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 20 * ScreenToolsController.ratio
        }

    }

    // third
    Image {
        id: _thirdBtnBg
        anchors.top: parent.top
        anchors.left: _secondBtnBg.right
        anchors.leftMargin: -19 * ScreenToolsController.ratio
        width: 118 * ScreenToolsController.ratio
        height: 38 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height

        Button {
            id: _thirdBtn
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100 * ScreenToolsController.ratio
                    implicitHeight: 38 * ScreenToolsController.ratio
                    color: "transparent"
                }
            }

            onClicked: {
                _buttonBar.thirdClicked()
            }

            onHoveredChanged: {
                if (current != 2) {
                    _thirdBtnBg.source = _thirdBtn.hovered ? "qrc:/qmlimages/BeiLi/features_btn_hovered.png" : "qrc:/qmlimages/BeiLi/features_btn_normal.png"
                    _thirdText.color = _thirdBtn.hovered ? "#B2F9FF" : "#08D3E5"
                }
            }

            onPressedChanged: {
                if (_thirdBtn.pressed) {
                    if (current === 2) current = -1
                    else {
                        current = 2
                        _thirdBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_checked.png"
                        _thirdText.color = "#B2F9FF"
                    }
                }
            }
        }

        Text {
            id: _thirdText
            anchors.centerIn: parent
            text: _buttonBar.thirdText
            color: "#08D3E5"
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 20 * ScreenToolsController.ratio
        }

    }

    // fourth
    Image {
        id: _fourthBtnBg
        anchors.top: parent.top
        anchors.left: _thirdBtnBg.right
        anchors.leftMargin: -19 * ScreenToolsController.ratio
        width: 118 * ScreenToolsController.ratio
        height: 38 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height

        Button {
            id: _fourthBtn
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100 * ScreenToolsController.ratio
                    implicitHeight: 38 * ScreenToolsController.ratio
                    color: "transparent"
                }
            }

            onClicked: {
                _buttonBar.fourthClicked()
            }

            onHoveredChanged: {
                if (current != 3) {
                    _fourthBtnBg.source = _fourthBtn.hovered ? "qrc:/qmlimages/BeiLi/features_btn_hovered.png" : "qrc:/qmlimages/BeiLi/features_btn_normal.png"
                    _fourthText.color = _fourthBtn.hovered ? "#B2F9FF" : "#08D3E5"
                }
            }

            onPressedChanged: {
                if (_fourthBtn.pressed) {
                    if (current === 3) current = -1
                    else {
                        current = 3
                        _fourthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_checked.png"
                        _fourthText.color = "#B2F9FF"
                    }
                }
            }
        }

        Text {
            id: _fourthText
            anchors.centerIn: parent
            text: _buttonBar.fourthText
            color: "#08D3E5"
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 20 * ScreenToolsController.ratio
        }

    }

    // fifth
    Image {
        id: _fifthBtnBg
        anchors.top: parent.top
        anchors.left: _fourthBtnBg.right
        anchors.leftMargin: -19 * ScreenToolsController.ratio
        width: 118 * ScreenToolsController.ratio
        height: 38 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height

        Button {
            id: _fifthBtn
            style: ButtonStyle {
                background: Rectangle {
                    implicitWidth: 100 * ScreenToolsController.ratio
                    implicitHeight: 38 * ScreenToolsController.ratio
                    color: "transparent"
                }
            }

            onClicked: {
                _buttonBar.fifthClicked()
            }

            onHoveredChanged: {
                if (current != 4) {
                    _fifthBtnBg.source = _fifthBtn.hovered ? "qrc:/qmlimages/BeiLi/features_btn_hovered.png" : "qrc:/qmlimages/BeiLi/features_btn_normal.png"
                    _fifthText.color = _fifthBtn.hovered ? "#B2F9FF" : "#08D3E5"
                }
            }

            onPressedChanged: {
                if (_fifthBtn.pressed) {
                    if (current === 4) current = -1
                    else {
                        current = 4
                        _fifthBtnBg.source = "qrc:/qmlimages/BeiLi/features_btn_checked.png"
                        _fifthText.color = "#B2F9FF"
                    }
                }
            }
        }

        Text {
            id: _fifthText
            anchors.centerIn: parent
            text: _buttonBar.fifthText
            color: "#08D3E5"
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 20 * ScreenToolsController.ratio
        }

    }

    Image {
        id: _emptyBtnBg
        anchors.top: parent.top
        anchors.left: _fifthBtnBg.right
        anchors.leftMargin: -19 * ScreenToolsController.ratio
        source: "qrc:/qmlimages/BeiLi/empty_btn.png"
        width: 85 * ScreenToolsController.ratio
        height: 38 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Component.onCompleted: {

    }

}
