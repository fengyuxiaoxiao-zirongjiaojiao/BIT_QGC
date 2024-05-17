/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtLocation       5.3
import QtPositioning    5.3

import QGroundControl           1.0
import QGroundControl.Controls  1.0
import QGroundControl.FlightMap 1.0

// Adds visual items associated with the Flight Plan to the map.
// Currently only used by Fly View even though it's called PlanMapItems!
Item {
    id: _root

    property var    map                     ///< Map control to show items on
    property bool   largeMapView            ///< true: map takes up entire view, false: map is in small window
    property var    planMasterController    ///< Reference to PlanMasterController for vehicle
    property var    vehicle                 ///< Vehicle associated with these items

    property var    _map:                       map
    property var    _vehicle:                   vehicle
    property var    _activeVehicle:             QGroundControl.multiVehicleManager.activeVehicle
    property var    _missionController:         masterController.missionController
    property var    _geoFenceController:        masterController.geoFenceController
    property var    _rallyPointController:      masterController.rallyPointController
    property var    _guidedController:          globals.guidedControllerFlyView
    property var    _missionLineViewComponent

    property string fmode: vehicle.flightMode

    property var mapVisible: _map.visible
    property var zoomLevel: _map.zoomLevel

    onMapVisibleChanged: {
        if (mapVisible) {
            updateDottedSpace()
        }
    }

    onZoomLevelChanged: {
        if (mapVisible) updateDottedSpace()
    }
    function updateDottedSpace() {
        var centerPoint = _map.fromCoordinate(_map.center, false)
        var x1 = centerPoint.x
        var y1 = centerPoint.y
        var coord1 = _map.toCoordinate(Qt.point(x1, y1), false)
        var coord2 = _map.toCoordinate(Qt.point(x1 + 20, y1), false)
        _missionController.distanceMapPoint(coord1, coord2)
    }

    // Add the mission item visuals to the map
    Repeater {
        model: largeMapView ? _missionController.visualItems : 0

        delegate: MissionItemMapVisual {
            map:        _map
            vehicle:    _vehicle
            onClicked:  _guidedController.confirmAction(_guidedController.actionSetWaypoint, Math.max(object.sequenceNumber, 1))
        }
    }

    Component.onCompleted: {
        _missionLineViewComponent = missionLineViewComponent.createObject(map)
        if (_missionLineViewComponent.status === Component.Error)
            console.log(_missionLineViewComponent.errorString())
//        map.addMapItem(_missionLineViewComponent)
        map.addMapItemView(_missionLineViewComponent)
    }

    Component.onDestruction: {
        _missionLineViewComponent.destroy()
    }

    Component {
        id: missionLineViewComponent

//        MapPolyline {
//            line.width: 3
//            line.color: _vehicle.vehiclePathColor                           // Hack, can't get palette to work in here
//            opacity:    _vehicle === _activeVehicle ? 1.0 : 0.5
//            z:          QGroundControl.zOrderWaypointLines
//            path:       _missionController.waypointPath
//        }

        // 含虚线 vincent_xjw 2021年10月16日
        MapItemView {
            model: _missionController.dottedFlightPathSegments
            delegate: MapPolyline {
                line.width: 3
                // Note: Special visuals for ROI are hacked out for now since they are not working correctly
                line.color: _terrainCollision ? "red" : _vehicle.vehiclePathColor
                z:          QGroundControl.zOrderWaypointLines
                path:       {
                    return object && object.coordinate1.isValid && object.coordinate2.isValid ? [ object.coordinate1, object.coordinate2 ] : []
                }
                property bool _terrainCollision:    object && object.terrainCollision
            }
            opacity:    _vehicle === _activeVehicle ? 1.0 : 0.8
        }
    }
}
