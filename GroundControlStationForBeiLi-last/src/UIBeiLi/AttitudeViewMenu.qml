import QtQuick 2.0
import QtQuick.Controls     2.14
import QGroundControl               1.0
import QGroundControl.Vehicle       1.0

Menu {
    id: menu
    property var  vehicle: null
    property bool armed: vehicle && vehicle.armed

    MenuItem {
        text: armed ? qsTr("上锁") : qsTr("解锁")
        onTriggered: {
            //if (vehicle) vehicle.armed = !vehicle.armed
            if (vehicle) {
                if (vehicle.armed) mainWindow.disarmVehicleRequest()
                else mainWindow.armVehicleRequest()
            }


        }
    }

    MenuItem {
        text: qsTr("强制解锁")
        visible: armed ? false : (vehicle && !(vehicle.readyToFlyAvailable && vehicle.readyToFly))
        onTriggered: {
            if (vehicle) vehicle.forceArm()
        }
    }

    MenuItem {
        text: qsTr("断开连接")
        onTriggered: {
            if (vehicle) vehicle.closeVehicle()
        }
    }
}
