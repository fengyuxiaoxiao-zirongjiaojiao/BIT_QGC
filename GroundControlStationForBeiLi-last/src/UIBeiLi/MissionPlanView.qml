import QtQuick 2.4
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 2.14
import QtQuick.Dialogs  1.3

import QGroundControl                   1.0
import QGroundControl.FactControls      1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootMissionPlan

    property var    _planMasterController:      globals.planMasterControllerPlanView
    property var    _missionController:         _planMasterController.missionController
    property bool   _controllerValid:           _planMasterController !== undefined && _planMasterController !== null
    property bool   _controllerOffline:         _controllerValid ? _planMasterController.offline : true
    property var    _controllerSyncInProgress:  _controllerValid ? _planMasterController.syncInProgress : false
    property var    _planView:  globals.beiLiPlanView
    property var    _editorMap: _planView.editorMap
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
        QGroundControl.webMsgManager.planWaypoint(layer === 1);
    }

    onVisibleChanged: {
        if (visible) {
            QGroundControl.webMsgManager.planWaypoint(_rootMissionPlan._layer === 1);
        } else {
            QGroundControl.webMsgManager.planWaypoint(false);
        }
    }

    Rectangle {
        id: _bg
        anchors.fill: parent
        color: "#07424F"
        opacity: 0.8
        MouseArea {
            anchors.fill: parent
            onPressed: { }
            onReleased: { }
            onClicked: { }
            onWheel: { }
        }
    }

    Image {
        id: _upperLeft
        source: "qrc:/qmlimages/BeiLi/form_upper_left.png"
        anchors.top: parent.top
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_upper_right.png"
        anchors.top: parent.top
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_left.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_right.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Column {
        id: btnColumn
        spacing: 16 * ScreenToolsController.ratio
        width: 36 * ScreenToolsController.ratio
        height: parent.height - 40 * ScreenToolsController.ratio
        anchors.left: parent.left
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 40 * ScreenToolsController.ratio
        RoundButton {
            id: importBtn
            width: 36 * ScreenToolsController.ratio
            height: 36 * ScreenToolsController.ratio
            enabled: !_controllerSyncInProgress
            background: Rectangle {
                color: "transparent"
            }
            BorderImage {
                source: (!importBtn.enabled) ? "qrc:/qmlimages/BeiLi/route_btn_import_disabled.png" : (importBtn.pressed ? "qrc:/qmlimages/BeiLi/route_btn_import_checked.png" : (importBtn.hovered ? "qrc:/qmlimages/BeiLi/route_btn_import_hovered.png" : "qrc:/qmlimages/BeiLi/route_btn_import_normal.png"))
                width: parent.width
                height: parent.height
            }
            onClicked: {
                if (_planMasterController.dirty) {
                    console.log("导入，是否覆盖？")
                    // 提示是否覆盖
                    //mainWindow.showComponentDialog(globals.beiLiPlanView.syncLoadFromFileOverwrite, columnHolder._overwriteText, mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                    _planMasterController.loadFromSelectedFile()
                } else {
                    _planMasterController.loadFromSelectedFile()
                }
            }
        }

        RoundButton {
            id: exportBtn
            width: 36 * ScreenToolsController.ratio
            height: 36 * ScreenToolsController.ratio
            enabled: !_controllerSyncInProgress && _planMasterController.containsItems
            background: Rectangle {
                color: "transparent"
            }
            BorderImage {
                source: (!exportBtn.enabled) ? "qrc:/qmlimages/BeiLi/route_btn_export_disabled.png" : (exportBtn.pressed ? "qrc:/qmlimages/BeiLi/route_btn_export_checked.png" : (exportBtn.hovered ? "qrc:/qmlimages/BeiLi/route_btn_export_hovered.png" : "qrc:/qmlimages/BeiLi/route_btn_export_normal.png"))
                width: parent.width
                height: parent.height
            }
            onClicked: {
                _planMasterController.saveToSelectedFile()
            }
        }

        RoundButton {
            id: uploadBtn
            width: 36 * ScreenToolsController.ratio
            height: 36 * ScreenToolsController.ratio
            enabled: !_controllerOffline && !_controllerSyncInProgress && _planMasterController.containsItems
            onClicked: _planMasterController.upload() // 上传当前航线到当前飞机
            //onClicked: missionUploadView.visible = true // 可以选择多台飞机同时上传航线
            background: Rectangle {
                color: "transparent"
            }
            BorderImage {
                source: (!uploadBtn.enabled) ? "qrc:/qmlimages/BeiLi/route_btn_upload_disabled.png" : (uploadBtn.pressed ? "qrc:/qmlimages/BeiLi/route_btn_upload_checked.png" : (uploadBtn.hovered ? "qrc:/qmlimages/BeiLi/route_btn_upload_hovered.png" : "qrc:/qmlimages/BeiLi/route_btn_upload_normal.png"))
                width: parent.width
                height: parent.height
            }
        }

        RoundButton {
            id: downloadBtn
            width: 36 * ScreenToolsController.ratio
            height: 36 * ScreenToolsController.ratio
            enabled: !_controllerOffline && !_controllerSyncInProgress
            onClicked:  {
                if (_planMasterController.dirty) {
                    console.log("下载，是否覆盖？")
                    // 提示是否覆盖
                    //mainWindow.showComponentDialog(globals.beiLiPlanView.syncLoadFromVehicleOverwrite, qsTr("Mission overwrite"), mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                    _planMasterController.loadFromVehicle()
                } else {
                    _planMasterController.loadFromVehicle()
                }
            }
            background: Rectangle {
                color: "transparent"
            }
            BorderImage {
                source: (!downloadBtn.enabled) ? "qrc:/qmlimages/BeiLi/route_btn_download_disabled.png" : (downloadBtn.pressed ? "qrc:/qmlimages/BeiLi/route_btn_download_checked.png" : (downloadBtn.hovered ? "qrc:/qmlimages/BeiLi/route_btn_download_hovered.png" : "qrc:/qmlimages/BeiLi/route_btn_download_normal.png"))
                width: parent.width
                height: parent.height
            }
        }

        RoundButton {
            id: clearBtn
            width: 36 * ScreenToolsController.ratio
            height: 36 * ScreenToolsController.ratio
            enabled: true//!_controllerOffline && !_controllerSyncInProgress
            background: Rectangle {
                color: "transparent"
            }
            BorderImage {
                source: (!clearBtn.enabled) ? "qrc:/qmlimages/BeiLi/route_btn_clear_disabled.png" : (clearBtn.pressed ? "qrc:/qmlimages/BeiLi/route_btn_clear_checked.png" : (clearBtn.hovered ? "qrc:/qmlimages/BeiLi/route_btn_clear_hovered.png" : "qrc:/qmlimages/BeiLi/route_btn_clear_normal.png"))
                width: parent.width
                height: parent.height
            }
            onClicked: {
                console.log("是否删除？")
                // 提示是否删除
                //mainWindow.showComponentDialog(globals.beiLiPlanView.clearVehicleMissionDialog, qsTr("Clear"), mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                //_planMasterController.removeAllFromVehicle()
                //_missionController.setCurrentPlanViewSeqNum(0, true)
                _planMasterController.removeAll()
                QGroundControl.kmlManager.polygon.clear()
                QGroundControl.kmlManager.polyline.clear()
                QGroundControl.webMsgManager.RemoveAll()
            }
        }
    }

    ToolSeparator {
        id: toolSeparator
        //anchors.verticalCenter: parent.verticalCenter
        anchors.top: parent.top
        anchors.topMargin: 20 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20 * ScreenToolsController.ratio
        anchors.left: btnColumn.right
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        contentItem: Rectangle {
            implicitWidth: 1
            //implicitHeight: 204
            color: "#118E9B"
        }
    }

    Rectangle {
        id: uavTypeAndCameraType
        color: "#084D5A"
        radius: 8 * ScreenToolsController.ratio
        width: 114 * ScreenToolsController.ratio
        height: 114 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: toolSeparator.right
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        function deleteItem(obj) {
            obj.destroy()
        }

        ActionButtonWithText {
            id: uavType
            anchors.top: parent.top
            anchors.topMargin: 20 * ScreenToolsController.ratio
            anchors.left: parent.left
            anchors.leftMargin: 10 * ScreenToolsController.ratio
            icon: "qrc:/qmlimages/BeiLi/route_icon_land_normal.png"
            text: qsTr("机型")

            onClicked: {
                var obj = vehicleInfoComponent.createObject(_rootMissionPlan);
                obj.anchors.fill = _rootMissionPlan
                obj.deleteThis.connect(uavTypeAndCameraType.deleteItem)
            }
        }

        ActionButtonWithText {
            id: cameraType
            anchors.top: parent.top
            anchors.topMargin: 20 * ScreenToolsController.ratio
            anchors.left: parent.left
            anchors.leftMargin: 60 * ScreenToolsController.ratio
            icon: "qrc:/qmlimages/BeiLi/route_icon_mount_normal.png"
            text: qsTr("挂载")

            onClicked: {
                if (QGroundControl.settingsManager.vehicleInfoSettings.curVehicleInfo) {
                    var obj = cameraInfoComponent.createObject(_rootMissionPlan);
                    obj.anchors.fill = _rootMissionPlan
                    obj.deleteThis.connect(uavTypeAndCameraType.deleteItem)
                }
            }
        }

        Text {
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 8 * ScreenToolsController.ratio
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("机型及挂载")
            font.family: "MicrosoftYaHei"
            font.weight: Font.Bold
            font.pixelSize: 12 * ScreenToolsController.ratio
            color: "#B2F9FF"
        }
    }

    Rectangle {
        id: kmlAndFenceTool
        color: "#084D5A"
        radius: 8 * ScreenToolsController.ratio
        width: 185 * ScreenToolsController.ratio
        height: 114 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: uavTypeAndCameraType.right
        anchors.leftMargin: 10 * ScreenToolsController.ratio
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

    }

    Rectangle {
        id: waypointType
        color: "#084D5A"
        radius: 8 * ScreenToolsController.ratio
        width: 166 * ScreenToolsController.ratio
        height: 114 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: kmlAndFenceTool.right
        anchors.leftMargin: 10 * ScreenToolsController.ratio

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
    }

    Rectangle {
        id: waypointTypeMask
        color: "#084D5A"
        opacity: 0.8
        radius: 8 * ScreenToolsController.ratio
        width: 166 * ScreenToolsController.ratio
        height: 114 * ScreenToolsController.ratio
        anchors.top: parent.top
        anchors.topMargin: 10 * ScreenToolsController.ratio
        anchors.left: kmlAndFenceTool.right
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        visible: false
    }

    Loader {
        id:           missionItemParame
        anchors.left: toolSeparator.right
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        anchors.top: uavTypeAndCameraType.bottom
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

    Loader {
        id: missionItemInfo
        anchors.top: uavTypeAndCameraType.bottom
        anchors.topMargin: 160 * ScreenToolsController.ratio
        anchors.left: toolSeparator.right
        anchors.leftMargin: 10 * ScreenToolsController.ratio
        source: "qrc:/qml/QGroundControl/UIBeiLi/BeiLiMissionInfo.qml"
        visible: _rootMissionPlan._layer === 1 || _rootMissionPlan._layer === 4 || _rootMissionPlan._layer === 5
    }


    Button {
        id: deleteMissionItemBtn
        anchors.right: parent.right
        anchors.rightMargin: 10 * ScreenToolsController.ratio
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10 * ScreenToolsController.ratio
        visible: _rootMissionPlan._layer === 1 || _rootMissionPlan._layer === 4 || _rootMissionPlan._layer === 5
        width: 24 * ScreenToolsController.ratio
        height: 24 * ScreenToolsController.ratio
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

    MissionUploadView {
        id: missionUploadView
        width: parent.width
        height: parent.height
        anchors.left: parent.left
        anchors.top: parent.top
        visible: false
    }

    Component {
        id: vehicleInfoComponent
        Item {
            id: vehicleInfoComponentObj
            signal deleteThis(var obj)

            Rectangle {
                id: mask
                color: "#000000"
                opacity: 0.6
                anchors.fill: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: false
                onPressed: {}
                onReleased: {}
                onWheel: {}
                onClicked: {}
            }

            Rectangle {
                id: vehicleInfoBackground
                width: 278 * ScreenToolsController.ratio
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                radius: 8 * ScreenToolsController.ratio
                color: "#084D5A"


                Rectangle {
                    id: currentInfo
                    width: parent.width
                    height: 89 * ScreenToolsController.ratio
                    anchors.top: parent.top
                    anchors.left: parent.left
                    radius: 8 * ScreenToolsController.ratio
                    color: "#0F6878"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 10 * ScreenToolsController.ratio
                        color: "#0F6878"
                    }

                    VehicleInfoItem {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10 * ScreenToolsController.ratio
                        isSelected: true
                        checkable: false
                        vehicleInfo: QGroundControl.settingsManager.vehicleInfoSettings.curVehicleInfo
                        removeable: false
                    }
                }

                Rectangle {
                    id: infoSelectArea
                    width: parent.width
                    height: 228 * ScreenToolsController.ratio
                    anchors.top: currentInfo.bottom
                    anchors.left: parent.left
                    color: "#084D5A"
                    border.color: "#084D5A"
                    Flickable {
                        id: flickableVehiceInfo
                        clip:               true
                        anchors.top:        parent.top
                        topMargin: 20 * ScreenToolsController.ratio
                        bottomMargin: 20 * ScreenToolsController.ratio
                        width:              parent.width
                        height:             parent.height
                        contentHeight:      settingsCloundColumn.height
                        contentWidth:       parent.width
                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        property color indicatorColor: Qt.rgba(0,0,0,0)
                        ScrollBar.vertical: ScrollBar {
                            id: flickableVehiceInfoScrillbar
                            parent: flickableVehiceInfo.parent
                            anchors.top: flickableVehiceInfo.top
                            anchors.right: flickableVehiceInfo.right
                            anchors.bottom: flickableVehiceInfo.bottom
                            width: 10 * ScreenToolsController.ratio
                            contentItem: Rectangle {
                                implicitWidth: flickableVehiceInfoScrillbar.width
                                radius: flickableVehiceInfoScrillbar.width / 2
                                color: "#08D3E5"
                                opacity: flickableVehiceInfoScrillbar.hovered ? 1 : 0.5
                            }
                        }

                        ExclusiveGroup { id: buttonGroup1 }
                        Column {
                            id:                 settingsCloundColumn
                            width:              parent.width
                            //height: parent.height
                            spacing:            20 * ScreenToolsController.ratio
                            Repeater {
                                model: QGroundControl.settingsManager.vehicleInfoSettings.vehicleInfoList
                                VehicleInfoItem {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10 * ScreenToolsController.ratio
                                    exclusiveGroup: buttonGroup1
                                    vehicleInfo: QGroundControl.settingsManager.vehicleInfoSettings.vehicleInfoList.get(index)
                                    removeable: {
                                        var curVehicleInfo = QGroundControl.settingsManager.vehicleInfoSettings.curVehicleInfo
                                        if (curVehicleInfo) {
                                            !(curVehicleInfo.canonicalName === vehicleInfo.canonicalName)
                                        } else {
                                            return true
                                        }
                                    }
                                    onCheckedChanged: {
                                        if (checked) {
                                            QGroundControl.settingsManager.vehicleInfoSettings.setCurVehicleInfoName(vehicleInfo.canonicalName)
                                        }
                                    }

                                    Rectangle {
                                        height: 1
                                        color: "#118E9B"
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.bottom
                                        anchors.topMargin: 10 * ScreenToolsController.ratio
                                    }
                                }

                            } // Repeater
                            VehicleInfoItemEditor {
                                anchors.left: parent.left
                                anchors.leftMargin: 10 * ScreenToolsController.ratio
                            }

                        } // Column
                    }

                }

                Button {
                    id: closeBtn
                    anchors.top: parent.top
                    anchors.topMargin: 6 * ScreenToolsController.ratio
                    anchors.right: parent.right
                    anchors.rightMargin: 6 * ScreenToolsController.ratio
                    width: 20 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio

                    background: Rectangle {
                        color: "transparent"
                    }
                    BorderImage {
                        source: closeBtn.checked || closeBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : closeBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : "qrc:/qmlimages/BeiLi/icon_close_normal.png"
                        width: closeBtn.width; height: closeBtn.height
                    }

                    onClicked: {
                        vehicleInfoComponentObj.deleteThis(vehicleInfoComponentObj)
                    }
                }
            }
        }
    }  // vehicle info component

    // camera info component
    Component {
        id: cameraInfoComponent
        Item {
            id: cameraInfoComponentObj
            signal deleteThis(var obj)

            Rectangle {
                id: mask
                color: "#000000"
                opacity: 0.6
                anchors.fill: parent
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: false
                onPressed: {}
                onReleased: {}
                onWheel: {}
                onClicked: {}
            }

            Rectangle {
                id: cameraInfoBackground
                width: 258 * ScreenToolsController.ratio
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                radius: 8 * ScreenToolsController.ratio
                color: "#084D5A"

                Rectangle {
                    id: currentInfo
                    width: 258 * ScreenToolsController.ratio
                    height: 89 * ScreenToolsController.ratio
                    anchors.top: parent.top
                    anchors.left: parent.left
                    radius: 8 * ScreenToolsController.ratio
                    color: "#0F6878"

                    Rectangle {
                        anchors.bottom: parent.bottom
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: 10 * ScreenToolsController.ratio
                        color: "#0F6878"
                    }

                    CameraInfoItem {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 10 * ScreenToolsController.ratio
                        checkable: false
                        isSelected: true
                        removeable: false
                        cameraInfo: QGroundControl.settingsManager.vehicleInfoSettings.curCameraInfo
                    }
                }

                Rectangle {
                    id: infoSelectArea
                    width: 258 * ScreenToolsController.ratio
                    height: 228 * ScreenToolsController.ratio
                    anchors.top: currentInfo.bottom
                    anchors.left: parent.left
                    color: "#084D5A"
                    border.color: "#084D5A"
                    Flickable {
                        id: flickableCameraInfo
                        clip:               true
                        anchors.top:        parent.top
                        topMargin: 20 * ScreenToolsController.ratio
                        bottomMargin: 20 * ScreenToolsController.ratio
                        width:              parent.width
                        height:             parent.height
                        contentHeight:      settingsCloundColumn.height
                        contentWidth:       parent.width
                        flickableDirection: Flickable.VerticalFlick
                        boundsBehavior: Flickable.StopAtBounds
                        property color indicatorColor: Qt.rgba(0,0,0,0)
                        ScrollBar.vertical: ScrollBar {
                            id: flickableCameraInfoScrillbar
                            parent: flickableCameraInfo.parent
                            anchors.top: flickableCameraInfo.top
                            anchors.right: flickableCameraInfo.right
                            anchors.bottom: flickableCameraInfo.bottom
                            width: 10 * ScreenToolsController.ratio
                            contentItem: Rectangle {
                                implicitWidth: flickableCameraInfoScrillbar.width
                                radius: flickableCameraInfoScrillbar.width / 2
                                color: "#08D3E5"
                                opacity: flickableCameraInfoScrillbar.hovered ? 1 : 0.5
                            }
                        }

                        ExclusiveGroup { id: buttonGroup1 }
                        Column {
                            id:                 settingsCloundColumn
                            width:              parent.width
                            //height: parent.height
                            spacing:            20 * ScreenToolsController.ratio
                            Repeater {
                                model: QGroundControl.settingsManager.cameraInfoSettings.cameraInfoList
                                CameraInfoItem {
                                    anchors.left: parent.left
                                    anchors.leftMargin: 10 * ScreenToolsController.ratio
                                    exclusiveGroup: buttonGroup1
                                    cameraInfo: QGroundControl.settingsManager.cameraInfoSettings.cameraInfoList.get(index)
                                    removeable: {
                                        var curCameraInfo = QGroundControl.settingsManager.vehicleInfoSettings.curCameraInfo
                                        if (curCameraInfo) {
                                            return !(curCameraInfo.canonicalName === cameraInfo.canonicalName)
                                        } else {
                                            return true
                                        }
                                    }
                                    onCheckedChanged: {
                                        if (checked) {
                                            QGroundControl.settingsManager.vehicleInfoSettings.setCurCameraInfoName(cameraInfo.canonicalName)
                                        }
                                    }
                                    Rectangle {
                                        height: 1
                                        color: "#118E9B"
                                        anchors.left: parent.left
                                        anchors.right: parent.right
                                        anchors.top: parent.bottom
                                        anchors.topMargin: 10 * ScreenToolsController.ratio
                                    }
                                }

                            } // Repeater
                            CameraInfoItemEditor {
                                anchors.left: parent.left
                                anchors.leftMargin: 10 * ScreenToolsController.ratio
                            }

                        } // Column
                    }

                }

                Button {
                    id: closeBtn
                    anchors.top: parent.top
                    anchors.topMargin: 6 * ScreenToolsController.ratio
                    anchors.right: parent.right
                    anchors.rightMargin: 6 * ScreenToolsController.ratio
                    width: 20 * ScreenToolsController.ratio
                    height: 16 * ScreenToolsController.ratio

                    background: Rectangle {
                        color: "transparent"
                    }
                    BorderImage {
                        source: closeBtn.checked || closeBtn.pressed ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : closeBtn.hovered ? "qrc:/qmlimages/BeiLi/icon_close_checked.png" : "qrc:/qmlimages/BeiLi/icon_close_normal.png"
                        width: closeBtn.width; height: closeBtn.height
                    }

                    onClicked: {
                        cameraInfoComponentObj.deleteThis(cameraInfoComponentObj)
                    }
                }
            }
        }
    }  // camera info component
}
