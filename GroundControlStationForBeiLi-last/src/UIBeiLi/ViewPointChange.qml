import QtQuick 2.0
import QtPositioning    5.3
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

import QGroundControl                       1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Vehicle               1.0
import QGroundControl.QGCPositionManager    1.0
import QGroundControl.ScreenToolsController 1.0

Item {
    id: _rootQuickSetup
    property var customWdith: 170
    property var customHeight: 400

    property real _widthRatio: (customWdith * ScreenToolsController.ratio) / 170
    property real _heightRatio: (customHeight * ScreenToolsController.ratio) / 400

    property int version: 1

    property var planViewMap: globals.beiLiPlanView.editorMap
    property var flyViewMap: globals.beiLiFlightView.mapControl
    property var map: globals.beiLiFlightView.mapControl
    property var _planMasterController:      globals.planMasterControllerPlanView
    property var _missionController:         _planMasterController.missionController
    property bool   usePlannedHomePosition: true

    width: customWdith * _widthRatio
    height: customHeight * _heightRatio

    property real spacingHeight: (height - (36 * ScreenToolsController.ratio * 5 + latEdit.height + lngEdit.height + viewCoordinateBtn.height)) / 7

    function fitActiveVehicleCoordinate() {
        var activeVehicle = QGroundControl.multiVehicleManager.activeVehicle
        var coordinate = activeVehicle.coordinate
        if (coordinate.isValid) {
            map.center = coordinate
            QGroundControl.settingsManager.flightMapSettings.setViewPoint(map.center)
        }
    }

    function fitHomePosition() {
        var homePosition = QtPositioning.coordinate()
        var activeVehicle = QGroundControl.multiVehicleManager.activeVehicle
        if (usePlannedHomePosition) {
            homePosition = _missionController.visualItems.get(0).coordinate
        } else if (activeVehicle) {
            homePosition = activeVehicle.homePosition
        }
        return homePosition
    }

    /// Normalize latitude to range: 0 to 180, S to N
    function normalizeLat(lat) {
        return lat + 90.0
    }

    /// Normalize longitude to range: 0 to 360, W to E
    function normalizeLon(lon) {
        return lon + 180.0
    }

    /// Fits the visible region of the map to inclues all of the specified coordinates. If no coordinates
    /// are specified the map will center to fitHomePosition()
    function fitMapViewportToAllCoordinates(coordList) {
        var mapFitViewport = Qt.rect(0, 0, map.width, map.height)
        if (coordList.length === 0) {
            var homeCoord = fitHomePosition()
            if (homeCoord.isValid) {
                map.center = homeCoord
                QGroundControl.settingsManager.flightMapSettings.setViewPoint(map.center)
            }
            return
        }

        // Create the normalized lat/lon corners for the coordinate bounding rect from the list of coordinates
        var north = normalizeLat(coordList[0].latitude)
        var south = north
        var east = normalizeLon(coordList[0].longitude)
        var west = east
        for (var i = 1; i < coordList.length; i++) {
            var lat = coordList[i].latitude
            var lon = coordList[i].longitude
            if (isNaN(lat) || lat === 0 || isNaN(lon) || lon === 0) {
                // Be careful of invalid coords which can happen when items are not yet complete
                continue
            }
            lat = normalizeLat(lat)
            lon = normalizeLon(lon)
            north = Math.max(north, lat)
            south = Math.min(south, lat)
            east  = Math.max(east,  lon)
            west  = Math.min(west,  lon)
        }

        // Expand the coordinate bounding rect to make room for the tools around the edge of the map
        var latDegreesPerPixel = (north - south) / mapFitViewport.height
        var lonDegreesPerPixel = (east  - west)  / mapFitViewport.width
        north = Math.min(north + (mapFitViewport.y * latDegreesPerPixel), 180)
        south = Math.max(south - ((map.height - mapFitViewport.bottom) * latDegreesPerPixel), 0)
        west  = Math.max(west  - (mapFitViewport.x * lonDegreesPerPixel), 0)
        east  = Math.min(east  + ((map.width - mapFitViewport.right) * lonDegreesPerPixel), 360)

        // Back off on zoom level
        east  = Math.min(east  * 1.0000075, 360)
        north = Math.min(north * 1.0000075, 180)
        west  = west  * 0.9999925
        south = south * 0.9999925

        // Fit the map region to the new bounding rect
        var topLeftCoord      = QtPositioning.coordinate(north - 90.0, west - 180.0)
        var bottomRightCoord  = QtPositioning.coordinate(south - 90.0, east - 180.0)
        map.setVisibleRegion(QtPositioning.rectangle(topLeftCoord, bottomRightCoord))
        QGroundControl.settingsManager.flightMapSettings.setViewPoint(QtPositioning.rectangle(topLeftCoord, bottomRightCoord).center)
    }

    function addMissionItemCoordsForFit(coordList) {
        for (var i = 1; i < _missionController.visualItems.count; i++) {
            var missionItem = _missionController.visualItems.get(i)
            if (missionItem.specifiesCoordinate && !missionItem.isStandaloneCoordinate) {
                if(missionItem.boundingCube.isValid()) {
                    coordList.push(missionItem.boundingCube.pointNW)
                    coordList.push(missionItem.boundingCube.pointSE)
                } else {
                    coordList.push(missionItem.coordinate)
                }
            }
        }
    }

    function fitMapViewportToMissionItems() {
        if (!_missionController.visualItems) {
            // Being called prior to controller.start
            return
        }
        var coordList = [ ]
        addMissionItemCoordsForFit(coordList)
        fitMapViewportToAllCoordinates(coordList)
    }

    function fitMapViewportToAllMissionItems() {
        var coordList = []
        var vehicles = QGroundControl.multiVehicleManager.vehicles
        for (var i = 0; i < vehicles.count; i++) {
            var vehicle = vehicles.get(i)
            for (var j in vehicle.missionCoordinate) {
                coordList.push(vehicle.missionCoordinate[j])
            }
        }
        fitMapViewportToAllCoordinates(coordList)
    }


    Rectangle {
        id: _bg
        anchors.fill: parent
        color: "#07424F"
        opacity: 0.8
    }

    Image {
        id: _upperLeft
        source: "qrc:/qmlimages/BeiLi/form_upper_left.png"
        anchors.top: parent.top
        anchors.left: parent.left
        visible: parent.version === 1
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_upper_right.png"
        anchors.top: parent.top
        anchors.right: parent.right
        visible: parent.version === 1
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_left.png"
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        visible: parent.version === 1
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Image {
        source: "qrc:/qmlimages/BeiLi/form_lower_right.png"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        visible: parent.version === 1
        width: 16 * ScreenToolsController.ratio
        height: 16 * ScreenToolsController.ratio
        sourceSize.width: width
        sourceSize.height: height
    }

    Column {
        id: column
        anchors.top: parent.top
        anchors.topMargin: spacingHeight//20 * _heightRatio
        anchors.left: parent.left
        anchors.leftMargin: 30 * _widthRatio
        spacing: spacingHeight//20 * _heightRatio

        ActionButtonFour {
            text: qsTr("家")
            onClicked: {
                map.center = fitHomePosition()
                QGroundControl.settingsManager.flightMapSettings.setViewPoint(map.center)
            }
        }

        ActionButtonFour {
            text: qsTr("基站")
            onClicked: {
                var gcsPosition = QGroundControl.qgcPositionManger.gcsPosition
                if (gcsPosition.isValid) {
                    map.center = gcsPosition
                    QGroundControl.settingsManager.flightMapSettings.setViewPoint(map.center)
                }
            }
        }

        ActionButtonFour {
            text: qsTr("当前航线")
            onClicked: {
                fitMapViewportToMissionItems()
            }
        }

        ActionButtonFour {
            text: qsTr("当前飞机")
            onClicked: {
                fitActiveVehicleCoordinate()
            }
        }

        ActionButtonFour {
            text: qsTr("全部")
            onClicked: {
                fitMapViewportToAllMissionItems()
            }
        }

    }

    TextField {
        id: latEdit
        anchors.top: column.bottom
        anchors.topMargin: spacingHeight//20 * _heightRatio
        anchors.horizontalCenter: parent.horizontalCenter
        width: 110 * _widthRatio
        height: 26 * _heightRatio
        text: qsTr("")
        font.family: "MicrosoftYaHei"
        font.weight: Font.Normal
        font.pixelSize: 18 * ScreenToolsController.ratio
        textColor: "#293538"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        focus: true
        selectByMouse: true
        placeholderText: qsTr("纬度")

        style: TextFieldStyle {
            background: Rectangle {
                radius: 4 * ScreenToolsController.ratio
                color: "#E4FDFF"
                border.color: "#0AC6D7"
                border.width: 1
            }
        }
    }

    TextField {
        id: lngEdit
        anchors.top: latEdit.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        width: 110 * _widthRatio
        height: 26 * _heightRatio
        text: qsTr("")
        font.family: "MicrosoftYaHei"
        font.weight: Font.Normal
        font.pixelSize: 18 * ScreenToolsController.ratio
        textColor: "#293538"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        focus: true
        selectByMouse: true
        placeholderText: qsTr("经度")

        style: TextFieldStyle {
            background: Rectangle {
                radius: 4 * ScreenToolsController.ratio
                color: "#E4FDFF"
                border.color: "#0AC6D7"
                border.width: 1
            }
        }
    }

    ActionButtonFive {
        id: viewCoordinateBtn
        anchors.top: lngEdit.bottom
        anchors.topMargin: 0
        height: 26 * ScreenToolsController.ratio
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("坐标")
        onClicked: {
            var coordinate = QtPositioning.coordinate(latEdit.text, lngEdit.text, 1)
            console.log(coordinate)
            if (coordinate.isValid) {
                map.center = coordinate
                QGroundControl.settingsManager.flightMapSettings.setViewPoint(map.center)
            }
        }
    }
}
