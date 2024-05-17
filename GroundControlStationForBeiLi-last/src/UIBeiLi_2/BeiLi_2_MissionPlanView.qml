import QtQuick              2.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.0
import QtQuick.Dialogs  1.3

import QGroundControl                       1.0
import QGroundControl.FactControls          1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.ScreenToolsController 1.0
import QGroundControl.SettingsManager       1.0
import QGroundControl.Vehicle               1.0
import QGroundControl.HttpAPIManager        1.0
import QGroundControl.UIBeiLi               1.0

Rectangle {
    id: _rootMissionPlan
    color: "#07424F"
    opacity: 0.9
    width: 510 * ScreenToolsController.ratio
    height: _layer === 2 ? 380 * ScreenToolsController.ratio : 350 * ScreenToolsController.ratio

    signal showFlyView()

    property var    _planMasterController:      globals.planMasterControllerPlanView
    property var    _missionController:         _planMasterController.missionController
    property bool   _controllerValid:           _planMasterController !== undefined && _planMasterController !== null
    property bool   _controllerOffline:         _controllerValid ? _planMasterController.offline : true
    property var    _controllerSyncInProgress:  _controllerValid ? _planMasterController.syncInProgress : false
    property var    _planView:                  globals.beiLiPlanView
    property var    _editorMap:                 _planView.editorMap
    property int    _layer: 1

    property int _curIndex: 0
    property int _itemsCount: _missionController.visualItems.count
    property var _survey: {
        if (_curIndex >= 1 && _curIndex < _itemsCount) {
            var visualItem = _missionController.visualItems.get(_curIndex)
            if (!visualItem.isSimpleItem && visualItem.patternName === "Survey") return visualItem
        }
        return null
    }
    property var _corridorScan: {
        if (_curIndex >= 1 && _curIndex < _itemsCount) {
            var visualItem = _missionController.visualItems.get(_curIndex)
            if (!visualItem.isSimpleItem && visualItem.patternName === "Corridor Scan") return visualItem
        }
        return null
    }

    property var _simpleImte: {
        if (_curIndex >= 1 && _curIndex < _itemsCount) {
            var visualItem = _missionController.visualItems.get(_curIndex)
            if (visualItem.isSimpleItem) {
                return visualItem
            }
        }
        return null
    }

    property var _missionSettingsItem: {
        if (_curIndex === 0) {
            var visualItem = _missionController.visualItems.get(0)
            return visualItem
        }
        return null
    }

    property var _fixedWingLandingComplexItem: {
        if (_curIndex >= 1 && _curIndex < _itemsCount) {
            var visualItem = _missionController.visualItems.get(_curIndex)
            if (!visualItem.isSimpleItem && visualItem.patternName === "Fixed Wing Landing") return visualItem
        }
        return null
    }

    property var _vtolLandingComplexItem: {
        if (_curIndex >= 1 && _curIndex < _itemsCount) {
            var visualItem = _missionController.visualItems.get(_curIndex)
            if (!visualItem.isSimpleItem && visualItem.patternName === "VTOL Landing") return visualItem
        }
        return null
    }


    function searchIndex(seq) {
        for(var i = 0; i < _missionController.visualItems.count; i++) {
            if (_missionController.visualItems.get(i).sequenceNumber === seq) return i
        }
        return -1
    }

    function coordinateIsValid(coordinate) {
        if (!coordinate.isValid || coordinate.longitude === 0 || coordinate.latitude === 0) return false
        return true
    }

    function hasSurveyItem() {
        for(var i = 0; i < _missionController.visualItems.count; i++) {
            var visualItem = _missionController.visualItems.get(i)
            if (!visualItem.isSimpleItem && visualItem.patternName === "Survey") return true
        }
        return false
    }

    function hasCorridorScanItem() {
        for(var i = 0; i < _missionController.visualItems.count; i++) {
            var visualItem = _missionController.visualItems.get(i)
            if (!visualItem.isSimpleItem && visualItem.patternName === "Corridor Scan") return true
        }
        return false
    }

    property var currentPlanViewSeqNum : _missionController.currentPlanViewSeqNum
    onCurrentPlanViewSeqNumChanged: {
        _curIndex = searchIndex(_missionController.currentPlanViewSeqNum)
    }

    function setEditingLayer(layer) {
        if (layer === 0) {
            importKmlbtn.checked = false
            polylineKmlBtn.checked = false
            polygonKmlBtn.checked = false
            rellyPointlbtn.checked = false
            circularFenceBtn.checked = false
            polygonFenceBtn.checked = false
            waypoingbtn.checked = false
            corridorScanBtn.checked = false
            surveyBtn.checked = false
        } else {
            _rootMissionPlan._layer = layer
            if (layer === 1) {
                importKmlbtn.checked = false
                polylineKmlBtn.checked = false
                polygonKmlBtn.checked = false
                rellyPointlbtn.checked = false
                circularFenceBtn.checked = false
                polygonFenceBtn.checked = false
            } else if (layer === 2) {
                importKmlbtn.checked = false
                polylineKmlBtn.checked = false
                polygonKmlBtn.checked = false
                rellyPointlbtn.checked = false
                waypoingbtn.checked = false
                corridorScanBtn.checked = false
                surveyBtn.checked = false
            } else if (layer === 3) {
                importKmlbtn.checked = false
                polylineKmlBtn.checked = false
                polygonKmlBtn.checked = false
                circularFenceBtn.checked = false
                polygonFenceBtn.checked = false
                waypoingbtn.checked = false
                corridorScanBtn.checked = false
                surveyBtn.checked = false
            } else if (layer === 4) {
                importKmlbtn.checked = false
                polylineKmlBtn.checked = false
                rellyPointlbtn.checked = false
                circularFenceBtn.checked = false
                polygonFenceBtn.checked = false
                waypoingbtn.checked = false
                corridorScanBtn.checked = false
                surveyBtn.checked = false
            } else if (layer === 5) {
                importKmlbtn.checked = false
                polygonKmlBtn.checked = false
                rellyPointlbtn.checked = false
                circularFenceBtn.checked = false
                polygonFenceBtn.checked = false
                waypoingbtn.checked = false
                corridorScanBtn.checked = false
                surveyBtn.checked = false
            }

            _planView.setEditingLayer(layer)
        }
        //QGroundControl.webMsgManager.planWaypoint(layer === 1);
    }

    Item {
        id: titleBarField
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 54 * ScreenToolsController.ratio

        Rectangle {
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            width: 150 * ScreenToolsController.ratio
            color: "transparent"

            property bool hovered: false
            Text {
                id: titleTextField
                text: qsTr("返回飞行界面")
                anchors.centerIn: parent

                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 20 * ScreenToolsController.ratioFont

                horizontalAlignment: Text.AlignLeft

                color: "#FFFFFF"
                opacity: parent.hovered ? 0.5 : 1
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: parent.hovered = true
                onExited: parent.hovered = false
                onClicked: {
                    showFlyView()
                }
            }
        }

        /*ActionButtonFive {
            text: "设置起飞点"
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10 * ScreenToolsController.ratio
        }*/
    }

    Rectangle {
        id: splitLine
        anchors.top: titleBarField.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 1
        color: "#118E9B"
    }

    Row {
        id: toolsRow
        spacing: (parent.width - (kmlAndFenceTool.width + waypointType.width)) / 3//40 * ScreenToolsController.ratio
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: splitLine.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio

        // KML工具 围栏工具
        Rectangle {
            id: kmlAndFenceTool
            color: "#084D5A"
            radius: 8 * ScreenToolsController.ratio
            width: 185 * ScreenToolsController.ratio
            height: 114 * ScreenToolsController.ratio
            //anchors.top: parent.top
            //anchors.topMargin: 10 * ScreenToolsController.ratio
            //anchors.left: uavTypeAndCameraType.right
            //anchors.leftMargin: 10 * ScreenToolsController.ratio
            property int currentView: 0

            Row {
                id: kmlToolView
                width: 144 * ScreenToolsController.ratio
                height: 66 * ScreenToolsController.ratio
                spacing: 6 * ScreenToolsController.ratio
                anchors.top: parent.top
                anchors.topMargin: 20 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: visible ? 10 * ScreenToolsController.ratio : 31 * ScreenToolsController.ratio
                visible: true
                ActionButtonWithText {
                    id: importKmlbtn
                    icon: (checked || hovered) ? "qrc:/qmlimages/BeiLi/route_icon_import_kml_checked.png" : "qrc:/qmlimages/BeiLi/route_icon_import_kml_normal.png"
                    text: qsTr("导入")
                    onClicked: {
                        setEditingLayer(0)
                        QGroundControl.kmlManager.loadKMLFile()
                        _editorMap.center = QGroundControl.kmlManager.mapToCenter()
                    }
                }

                ActionButtonWithText {
                    id: polylineKmlBtn
                    icon: (checked || hovered) ? "qrc:/qmlimages/BeiLi/route_icon_polyline_kml_checked.png" : "qrc:/qmlimages/BeiLi/route_icon_polyline_kml_normal.png"
                    text: qsTr("条带")
                    checkable: true
                    onClicked: setEditingLayer(5)
                    onCheckedChanged: {
                        QGroundControl.kmlManager.polylineTraceMode = checked
                    }
                }

                ActionButtonWithText {
                    id: polygonKmlBtn
                    icon: (checked || hovered) ? "qrc:/qmlimages/BeiLi/route_icon_polygon_kml_checked.png" : "qrc:/qmlimages/BeiLi/route_icon_polygon_kml_normal.png"
                    text: qsTr("多边形")
                    checkable: true
                    onClicked: setEditingLayer(4)
                    onCheckedChanged: {
                        QGroundControl.kmlManager.polygonTraceMode = checked
                    }
                }
            }

            Row {
                id: fenceToolView
                width: 144 * ScreenToolsController.ratio
                height: 66 * ScreenToolsController.ratio
                spacing: 6 * ScreenToolsController.ratio
                anchors.top: parent.top
                anchors.topMargin: 20 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: visible ? 31 * ScreenToolsController.ratio : 10 * ScreenToolsController.ratio
                visible: false
                ActionButtonWithText {
                    id: rellyPointlbtn
                    icon: (checked || hovered) ? "qrc:/qmlimages/BeiLi/route_icon_rellypoint_checked.png" : "qrc:/qmlimages/BeiLi/route_icon_rellypoint_normal.png"
                    text: qsTr("集结点")
                    checkable: true
                    enabled: _planMasterController.rallyPointController.supported
                    onCheckedChanged: {
                        setEditingLayer(3)
                        _planView.setAddWaypointRallyPointActionChecked(checked)
                    }
                    Rectangle {
                        visible: !rellyPointlbtn.enabled
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -2
                        color: "#084D5A"
                        opacity: 0.8
                        MouseArea {
                            anchors.fill: parent
                            onPressed: {}
                            onReleased: {}
                            onClicked: {}
                            onWheel: {}
                        }
                    }
                }

                ActionButtonWithText {
                    id: circularFenceBtn
                    icon: (checked || hovered) ? "qrc:/qmlimages/BeiLi/route_icon_circular_fence_checked.png" : "qrc:/qmlimages/BeiLi/route_icon_circular_fence_normal.png"
                    text: qsTr("圆形")
                    checkable: true
                    enabled: _planMasterController.geoFenceController.supported
                    onClicked: {
                        setEditingLayer(2)
                        if (checked) {
                            polygonFenceBtn.checked = false
                        }
                    }
                    Rectangle {
                        visible: !circularFenceBtn.enabled
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -2
                        color: "#084D5A"
                        opacity: 0.8
                        MouseArea {
                            anchors.fill: parent
                            onPressed: {}
                            onReleased: {}
                            onClicked: {}
                            onWheel: {}
                        }
                    }
                }

                ActionButtonWithText {
                    id: polygonFenceBtn
                    icon: (checked || hovered) ? "qrc:/qmlimages/BeiLi/route_icon_polygon_kml_checked.png" : "qrc:/qmlimages/BeiLi/route_icon_polygon_kml_normal.png"
                    text: qsTr("多边形")
                    checkable: true
                    enabled: _planMasterController.geoFenceController.supported
                    onClicked: {
                        setEditingLayer(2)
                        if (checked) {
                            circularFenceBtn.checked = false
                        }
                    }
                    Rectangle {
                        visible: !polygonFenceBtn.enabled
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: -2
                        color: "#084D5A"
                        opacity: 0.8
                        MouseArea {
                            anchors.fill: parent
                            onPressed: {}
                            onReleased: {}
                            onClicked: {}
                            onWheel: {}
                        }
                    }
                }
            }

            Button {
                width: 21 * ScreenToolsController.ratio
                height: 114 * ScreenToolsController.ratio
                anchors.right: parent.right
                anchors.top: parent.top
                visible: kmlAndFenceTool.currentView === 0
                background: Rectangle {
                    color: "transparent"
                }

                BorderImage {
                    source: "qrc:/qmlimages/BeiLi/route_btn_arrow_r.png"
                    width: 21 * ScreenToolsController.ratio; height: 114 * ScreenToolsController.ratio
                }

                onClicked: {
                    kmlAndFenceTool.currentView = 1
                }
            }

            Button {
                width: 21 * ScreenToolsController.ratio
                height: 114 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.top: parent.top
                visible: kmlAndFenceTool.currentView === 1
                background: Rectangle {
                    color: "transparent"
                }

                BorderImage {
                    source: "qrc:/qmlimages/BeiLi/route_btn_arrow_l.png"
                    width: 21 * ScreenToolsController.ratio; height: 114 * ScreenToolsController.ratio
                }

                onClicked: {
                    kmlAndFenceTool.currentView = 0
                }
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8 * ScreenToolsController.ratio
                anchors.horizontalCenter: kmlAndFenceTool.currentView === 0 ? kmlToolView.horizontalCenter : fenceToolView.horizontalCenter
                text: kmlAndFenceTool.currentView === 0 ? qsTr("KML工具") : qsTr("围栏工具")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }

            onCurrentViewChanged: {
                kmlToolView.visible = kmlAndFenceTool.currentView === 0
                fenceToolView.visible = kmlAndFenceTool.currentView === 1
                waypointTypeMask.visible = fenceToolView.visible

                if (fenceToolView.visible) {
                    waypoingbtn.checked = false
                    corridorScanBtn.checked = false
                    surveyBtn.checked = false
                } else {
                    rellyPointlbtn.checked = false
                    circularFenceBtn.checked = false
                    polygonFenceBtn.checked = false
                }

                setEditingLayer(fenceToolView.visible ? 3 : 1)
            }

        } // KML工具 围栏工具

         // 航线策略
        Rectangle {
            id: waypointType
            color: "#084D5A"
            radius: 8 * ScreenToolsController.ratio
            width: 166 * ScreenToolsController.ratio
            height: 114 * ScreenToolsController.ratio
            //anchors.top: parent.top
            //anchors.topMargin: 10
            //anchors.left: kmlAndFenceTool.right
            //anchors.leftMargin: 10

            Row {
                id: waypointTypeView
                width: 144 * ScreenToolsController.ratio
                height: 66 * ScreenToolsController.ratio
                spacing: 6 * ScreenToolsController.ratio
                anchors.top: parent.top
                anchors.topMargin: 20 * ScreenToolsController.ratio
                anchors.left: parent.left
                anchors.leftMargin: visible ? 10 * ScreenToolsController.ratio : 31 * ScreenToolsController.ratio
                visible: true

                function _mapCenter() {
                    var centerPoint = Qt.point(_editorMap.centerViewport.left + (_editorMap.centerViewport.width / 2), _editorMap.centerViewport.top + (_editorMap.centerViewport.height / 2))
                    return _editorMap.toCoordinate(centerPoint, false /* clipToViewPort */)
                }

                function _creator(complexItemName) {
                    if (_planMasterController.containsItems) {
                        console.log("是否清除旧的航线")
                    }

                    if (_missionController.flyThroughCommandsAllowed) {
                        _planView.insertComplexItemAfterCurrent(complexItemName)
                    } else {
                        var creators = _planMasterController.planCreators
                        for (var i = 0; i < creators.count; i++) {
                            var c = creators.get(i)
                            console.log(c.name)
                            if (c.name === complexItemName) {
                                c.createPlan(waypointTypeView._mapCenter())
                            }
                        }
                    }
                }

                ActionButtonWithText {
                    id: waypoingbtn
                    icon: (checked || hovered) ? "qrc:/qmlimages/BeiLi/route_icon_point_waypoint_checked.png" : "qrc:/qmlimages/BeiLi/route_icon_point_waypoint_normal.png"
                    text: qsTr("航点")
                    enabled: !waypointTypeMask.visible
                    checkable: true
                    onCheckedChanged: {
                        setEditingLayer(1)
                        _planView.setAddWaypointRallyPointActionChecked(checked)
                        QGroundControl.webMsgManager.setAddWaypointAction(checked)
                    }
                }

                ActionButtonWithText {
                    id: corridorScanBtn
                    icon: (checked || hovered) ? "qrc:/qmlimages/BeiLi/route_icon_polyline_waypoint_checked.png" : "qrc:/qmlimages/BeiLi/route_icon_polyline_waypoint_normal.png"
                    text: qsTr("通道")
                    enabled: !waypointTypeMask.visible
                    onClicked: {
                        setEditingLayer(1)

                        var x = _editorMap.centerViewport.x + (_editorMap.centerViewport.width / 2)
                        var yInset = _editorMap.centerViewport.height / 4
                        var topPointCoord =     _editorMap.toCoordinate(Qt.point(x, _editorMap.centerViewport.y + yInset),                                false /* clipToViewPort */)
                        var bottomPointCoord =  _editorMap.toCoordinate(Qt.point(x, _editorMap.centerViewport.y + _editorMap.centerViewport.height - yInset),    false /* clipToViewPort */)
                        var coordinateList = [ topPointCoord, bottomPointCoord ]
                        QGroundControl.kmlManager.defaultPolylineVertices = coordinateList;
                        if (hasCorridorScanItem()) {
                            var nextIndex = _missionController.currentPlanViewVIIndex + 1
                            _missionController.insertComplexMissionItem("Corridor Scan", _editorMap.center, nextIndex, true /* makeCurrentItem */)
                        } else {
                            waypointTypeView._creator("Corridor Scan")
                        }
                    }
                }

                ActionButtonWithText {
                    id: surveyBtn
                    icon: (checked || hovered) ? "qrc:/qmlimages/BeiLi/route_icon_polygon_waypoint_checked.png" : "qrc:/qmlimages/BeiLi/route_icon_polygon_waypoint_normal.png"
                    text: qsTr("面状")
                    enabled: !waypointTypeMask.visible
                    onClicked: {
                        setEditingLayer(1)

                        // Initial polygon is inset to take 2/3rds space
                        var rect = Qt.rect(_editorMap.centerViewport.x, _editorMap.centerViewport.y, _editorMap.centerViewport.width, _editorMap.centerViewport.height)
                        rect.x += (rect.width * 0.25) / 2
                        rect.y += (rect.height * 0.25) / 2
                        rect.width *= 0.75
                        rect.height *= 0.75

                        var centerCoord =       _editorMap.toCoordinate(Qt.point(rect.x + (rect.width / 2), rect.y + (rect.height / 2)),   false /* clipToViewPort */)
                        var topLeftCoord =      _editorMap.toCoordinate(Qt.point(rect.x, rect.y),                                          false /* clipToViewPort */)
                        var topRightCoord =     _editorMap.toCoordinate(Qt.point(rect.x + rect.width, rect.y),                             false /* clipToViewPort */)
                        var bottomLeftCoord =   _editorMap.toCoordinate(Qt.point(rect.x, rect.y + rect.height),                            false /* clipToViewPort */)
                        var bottomRightCoord =  _editorMap.toCoordinate(Qt.point(rect.x + rect.width, rect.y + rect.height),               false /* clipToViewPort */)

                        // Initial polygon has max width and height of 3000 meters
                        var halfWidthMeters =   Math.min(topLeftCoord.distanceTo(topRightCoord), 3000) / 2
                        var halfHeightMeters =  Math.min(topLeftCoord.distanceTo(bottomLeftCoord), 3000) / 2
                        topLeftCoord =      centerCoord.atDistanceAndAzimuth(halfWidthMeters, -90).atDistanceAndAzimuth(halfHeightMeters, 0)
                        topRightCoord =     centerCoord.atDistanceAndAzimuth(halfWidthMeters, 90).atDistanceAndAzimuth(halfHeightMeters, 0)
                        bottomLeftCoord =   centerCoord.atDistanceAndAzimuth(halfWidthMeters, -90).atDistanceAndAzimuth(halfHeightMeters, 180)
                        bottomRightCoord =  centerCoord.atDistanceAndAzimuth(halfWidthMeters, 90).atDistanceAndAzimuth(halfHeightMeters, 180)

                        var coordinateList = [ topLeftCoord, topRightCoord, bottomRightCoord, bottomLeftCoord  ]
                        QGroundControl.kmlManager.defaultPolygonVertices = coordinateList;
                        if (hasSurveyItem()) {
                            var nextIndex = _missionController.currentPlanViewVIIndex + 1
                            _missionController.insertComplexMissionItem("Survey", _editorMap.center, nextIndex, true /* makeCurrentItem */)
                        } else {
                            waypointTypeView._creator("Survey")
                        }
                    }
                }
            }

            Text {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 8 * ScreenToolsController.ratio
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("航线策略")
                font.family: "MicrosoftYaHei"
                font.weight: Font.Bold
                font.pixelSize: 12 * ScreenToolsController.ratio
                color: "#B2F9FF"
            }

            Rectangle {
                id: waypointTypeMask
                color: "#084D5A"
                opacity: 0.8
                radius: 8 * ScreenToolsController.ratio
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                visible: false
            }
        } // 航线策略
    } // Row 1


    Loader {
        id:           missionItemParame
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        anchors.top: toolsRow.bottom
        anchors.topMargin: 10 * ScreenToolsController.ratio
        source:             {
            anchors.topMargin = 10 * ScreenToolsController.ratio
            if (_rootMissionPlan._layer === 1 || _rootMissionPlan._layer === 4 || _rootMissionPlan._layer === 5) {
                if (_survey) {
                    missionItemParame.missionItem = _survey
                    return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiSurveyItemEditor.qml"
                } else if (_corridorScan) {
                    missionItemParame.missionItem = _corridorScan
                    return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiCorridorScanComplexItemEditor.qml";
                } else if (_simpleImte) {
                    missionItemParame.missionItem = _simpleImte
                    return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiSimpleItemEditor.qml"
                } else if (_missionSettingsItem) {
                    missionItemParame.missionItem = _missionSettingsItem
                    return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiMissionSettingsItem.qml"
                } /*else if (_vtolLandingComplexItem) {
                missionItemParame.missionItem = _vtolLandingComplexItem
                return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiVTOLLandingPatternEditor.qml"
            }*/ else {
                    missionItemParame.missionItem = null
                    return ""
                }
            } else if (_rootMissionPlan._layer === 3) {
                anchors.topMargin = 20 * ScreenToolsController.ratio
                return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiRallyPointItemEditor.qml"
            } else if (_rootMissionPlan._layer === 2) {
                return "qrc:/qml/QGroundControl/UIBeiLi/BeiLiGeoFenceItemEditor.qml"
            }
        }
        visible:            true

        property var missionItem

        property var missionController:         _missionController
        property var rallyPointController:      _planMasterController.rallyPointController
        property var geoFenceController:        _planMasterController.geoFenceController
        property var flightMap:                 _editorMap
        property var isGeoFencePolygon:         polygonFenceBtn.checked
        property var isGeoFenceCircular:        circularFenceBtn.checked
    }

    Button {
        id: deleteMissionItemBtn
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        visible: _rootMissionPlan._layer === 1 || _rootMissionPlan._layer === 4 || _rootMissionPlan._layer === 5
        width: 25 * ScreenToolsController.ratio
        height: 25 * ScreenToolsController.ratio
        background: Rectangle {
            color: "transparent"
        }
        BorderImage {
            source: deleteMissionItemBtn.checked || deleteMissionItemBtn.pressed ? "qrc:/qmlimages/BeiLi/link_icon_delete_hovered.png" : deleteMissionItemBtn.hovered ? "qrc:/qmlimages/BeiLi/link_icon_delete_hovered.png" : "qrc:/qmlimages/BeiLi/link_icon_delete_normal.png"
            width: deleteMissionItemBtn.width; height: deleteMissionItemBtn.height
        }

        onClicked: {
            for(var i = 1; i < _missionController.visualItems.count; i++) {
                if (_missionController.visualItems.get(i).sequenceNumber === _missionController.currentPlanViewSeqNum) {
                    _missionController.removeVisualItem(i)
                    break
                }
            }
        }
    }
}
