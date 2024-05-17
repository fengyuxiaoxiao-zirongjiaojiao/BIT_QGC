import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2
import QtQuick.Dialogs  1.2

import QGroundControl                   1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Controls          1.0
import QGroundControl.FactControls      1.0
import QGroundControl.Palette           1.0
import QGroundControl.ScreenToolsController       1.0

Item {
    id: _root
    property var    _planMasterController:      globals.planMasterControllerPlanView
    property var    _currentMissionItem:        globals.currentPlanMissionItem          ///< Mission item to display status for

    property var    missionItems:               _controllerValid ? _planMasterController.missionController.visualItems : undefined
    property real   missionDistance:            _controllerValid ? _planMasterController.missionController.missionDistance : NaN
    property real   missionTime:                _controllerValid ? _planMasterController.missionController.missionTime : 0
    property real   missionMaxTelemetry:        _controllerValid ? _planMasterController.missionController.missionMaxTelemetry : NaN
    property bool   missionDirty:               _controllerValid ? _planMasterController.missionController.dirty : false

    property bool   _controllerValid:           _planMasterController !== undefined && _planMasterController !== null
    property bool   _currentMissionItemValid:   _currentMissionItem && _currentMissionItem !== undefined && _currentMissionItem !== null
    property bool   _missionValid:              missionItems !== undefined
    property bool   _currentItemIsVTOLTakeoff:  _currentMissionItemValid && _currentMissionItem.command === 84

    property real   _distance:                  _currentMissionItemValid ? _currentMissionItem.distance : NaN
    property real   _altDifference:             _currentMissionItemValid ? _currentMissionItem.altDifference : NaN
    property real   _azimuth:                   _currentMissionItemValid ? _currentMissionItem.azimuth : NaN
    property real   _heading:                   _currentMissionItemValid ? _currentMissionItem.missionVehicleYaw : NaN
    property real   _missionDistance:           _missionValid ? missionDistance : NaN
    property real   _missionMaxTelemetry:       _missionValid ? missionMaxTelemetry : NaN
    property real   _missionTime:               _missionValid ? missionTime : 0
    property real   _gradient:                  _currentMissionItemValid && _currentMissionItem.distance > 0 ?
                                                    (_currentItemIsVTOLTakeoff ?
                                                         0 :
                                                         (Math.atan(_currentMissionItem.altDifference / _currentMissionItem.distance) * (180.0/Math.PI)))
                                                  : NaN

    property string _distanceText:              isNaN(_distance) ?              "-.-" : QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_distance).toFixed(1) + "" + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString
    property string _altDifferenceText:         isNaN(_altDifference) ?         "-.-" : QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_altDifference).toFixed(1) + "" + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString
    property string _gradientText:              isNaN(_gradient) ?              "-.-" : _gradient.toFixed(0) + "deg"
    property string _azimuthText:               isNaN(_azimuth) ?               "-.-" : Math.round(_azimuth) % 360
    property string _headingText:               isNaN(_azimuth) ?               "-.-" : Math.round(_heading) % 360
    property string _missionDistanceText:       isNaN(_missionDistance) ?       "-.-" : QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_missionDistance).toFixed(0) + "" + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString
    property string _missionMaxTelemetryText:   isNaN(_missionMaxTelemetry) ?   "-.-" : QGroundControl.unitsConversion.metersToAppSettingsHorizontalDistanceUnits(_missionMaxTelemetry).toFixed(0) + "" + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString

    function getMissionTime() {
        if (_missionTime == 0) {
            return "00:00:00"
        }
        // On some versions of jscript, passing in year=0 returns bad time formatting, on some it doesnt. Setting year to a specific
        // year makes it always work correctly.
        var t = new Date(2021, 0, 0, 0, 0, Number(_missionTime))
        return Qt.formatTime(t, 'hh:mm:ss')
    }

    property int pixelSize: 12 * ScreenToolsController.ratio

    width: 490 * ScreenToolsController.ratio

    Flow {
        //anchors.top: _root.top
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: _root.left
        spacing: 6 * ScreenToolsController.ratio
        width: parent.width

        Row {
            spacing: 2 * ScreenToolsController.ratio
            Text {
                id: altDiffLabel
                text: qsTr("高差:")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: altDiffText
                text: _altDifferenceText
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }

        Row {
            spacing: 2 * ScreenToolsController.ratio
            Text {
                id: preDistanceLabel
                text: qsTr("距离:")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: preDistanceText
                text: _distanceText
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }

        Row {
            id: complexRow
            spacing: 2 * ScreenToolsController.ratio
            function getText() {
                if (_currentMissionItemValid && _currentMissionItem.isSimpleItem) {
                    return qsTr("方位:")
                } else if (_currentMissionItemValid && !_currentMissionItem.isSimpleItem && _currentMissionItem.patternName === "Survey") {
                    return qsTr("测区面积:")
                } else if (_currentMissionItemValid && !_currentMissionItem.isSimpleItem && _currentMissionItem.patternName === "Corridor Scan") {
                    return qsTr("通道长:")
                } else {
                    return qsTr("方位:")
                }
            }

            function getValue() {
                if (_currentMissionItemValid && _currentMissionItem.isSimpleItem) {
                    return _azimuthText
                } else if (_currentMissionItemValid && !_currentMissionItem.isSimpleItem && _currentMissionItem.patternName === "Survey") {
                    return (QGroundControl.unitsConversion.squareMetersToAppSettingsAreaUnits(_currentMissionItem.coveredArea).toFixed(2) + " " + QGroundControl.unitsConversion.appSettingsAreaUnitsString)
                } else if (_currentMissionItemValid && !_currentMissionItem.isSimpleItem && _currentMissionItem.patternName === "Corridor Scan") {
                    var km = _currentMissionItem.corridorPolyline.length * 0.001
                    if (parseInt(km) >= 1.0) return String("%1km").arg(km)
                    return String("%1m").arg(_currentMissionItem.corridorPolyline.length)
                } else {
                    return "0"
                }
            }

            Text {
                id: azimuthLabel
                text: complexRow.getText()
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: azimuthText
                text: complexRow.getValue()
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }

        Row {
            spacing: 2 * ScreenToolsController.ratio
            Text {
                id: headingLabel
                text: qsTr("航向:")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: headingText
                text: _headingText
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }

        Row {
            spacing: 2 * ScreenToolsController.ratio
            Text {
                id: gradientLabel
                text: qsTr("梯度:")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: gradientText
                text: _gradientText
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }

        Row {
            spacing: 2 * ScreenToolsController.ratio
            Text {
                id: totalDisTitle
                text: qsTr("航程:")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: totalDisValue
                text: _missionDistanceText
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }

        Row {
            spacing: 2 * ScreenToolsController.ratio
            Text {
                id: totalTimeTitle
                text: qsTr("航时:")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: totalTimeValue
                text: getMissionTime()
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }

        Row {
            spacing: 2 * ScreenToolsController.ratio
            Text {
                id: maxTelemDistTitle
                text: qsTr("电台距离(Max):")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: maxTelemDistValue
                text: _missionMaxTelemetryText
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }

        Row {
            spacing: 2 * ScreenToolsController.ratio
            Text {
                id: triggerInternalTitle
                text: qsTr("拍照间隔:")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: triggerInternalValue
                text: {
                    if (_currentMissionItemValid && !_currentMissionItem.isSimpleItem && _currentMissionItem.cameraCalc !== undefined) {
                        return String("%1%2-%3%4").arg(_currentMissionItem.cameraCalc.adjustedFootprintFrontal.valueString).arg(_currentMissionItem.cameraCalc.adjustedFootprintFrontal.units).arg(_currentMissionItem.timeBetweenShots.toFixed(1)) .arg(qsTr("secs"))
                    } else {
                        return String("00-00")
                    }
                }
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }

        Row {
            spacing: 2 * ScreenToolsController.ratio
            Text {
                id: triggerCountTitle
                text: qsTr("拍照总数:")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
            Text {
                id: triggerCountValue
                text: {
                    if (_currentMissionItemValid && !_currentMissionItem.isSimpleItem) {
                        return String("%1").arg(_currentMissionItem.cameraShots)
                    } else return String("0")
                }
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: _root.pixelSize
                color: "#B2F9FF"
            }
        }
    }
}
