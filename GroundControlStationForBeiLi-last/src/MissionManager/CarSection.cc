/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "CarSection.h"
#include "JsonHelper.h"
#include "FirmwarePlugin.h"
#include "SimpleMissionItem.h"
#include "PlanMasterController.h"

const char* CarSection::_carAndPlaneName = "CarAndPlane";

QMap<QString, FactMetaData*> CarSection::_metaDataMap;

CarSection::CarSection(PlanMasterController* masterController, QObject* parent)
    : Section               (masterController, parent)
    , _available            (false)
    , _dirty                (false)
    , _specifyCarAndPlane   (false)
    , _carAndPlaneFact      (0, _carAndPlaneName,   FactMetaData::valueTypeBool)
{
    if (_metaDataMap.isEmpty()) {
        _metaDataMap = FactMetaData::createMapFromJsonFile(QStringLiteral(":/json/CarSection.FactMetaData.json"), nullptr /* metaDataParent */);
    }

    double carAndPlane = 0;
    if (_masterController->controllerVehicle()->multiRotor()) {
        carAndPlane = _masterController->controllerVehicle()->defaultHoverSpeed();
    } else {
        carAndPlane = _masterController->controllerVehicle()->defaultCruiseSpeed();
    }

    _metaDataMap[_carAndPlaneName]->setRawDefaultValue(carAndPlane);
    _carAndPlaneFact.setMetaData(_metaDataMap[_carAndPlaneName]);
    _carAndPlaneFact.setRawValue(carAndPlane);

    connect(this,               &CarSection::specifyCarAndPlaneChanged,   this, &CarSection::settingsSpecifiedChanged);
    connect(&_carAndPlaneFact,  &Fact::valueChanged,                        this, &CarSection::_carAndPlaneChanged);

    connect(this,               &CarSection::specifyCarAndPlaneChanged,   this, &CarSection::_updateSpecifiedCarAndPlane);
    connect(&_carAndPlaneFact,  &Fact::valueChanged,                        this, &CarSection::_updateSpecifiedCarAndPlane);
}

bool CarSection::settingsSpecified(void) const
{
    return _specifyCarAndPlane;
}

void CarSection::setAvailable(bool available)
{
    if (available != _available) {
        if (available && (_masterController->controllerVehicle()->multiRotor() || _masterController->controllerVehicle()->fixedWing())) {
            _available = available;
            emit availableChanged(available);
        }
    }
}

void CarSection::setDirty(bool dirty)
{
    if (_dirty != dirty) {
        _dirty = dirty;
        emit dirtyChanged(_dirty);
    }
}

void CarSection::setSpecifyCarAndPlane(bool specifyCarAndPlane)
{
    if (specifyCarAndPlane != _specifyCarAndPlane) {
        _specifyCarAndPlane = specifyCarAndPlane;
        emit specifyCarAndPlaneChanged(specifyCarAndPlane);
        setDirty(true);
        emit itemCountChanged(itemCount());
    }
}

int CarSection::itemCount(void) const
{
    return _specifyCarAndPlane ? 1: 0;
}

void CarSection::appendSectionItems(QList<MissionItem*>& items, QObject* missionItemParent, int& seqNum)
{
    // IMPORTANT NOTE: If anything changes here you must also change CarSection::scanForSettings

    if (_specifyCarAndPlane) {
        MissionItem* item = new MissionItem(seqNum++,
                                            MAV_CMD_DO_SET_SERVO,
                                            MAV_FRAME_MISSION,
                                            1,
                                            _carAndPlaneFact.rawValue().toBool() ? 1300 : 1700,
                                            0,                                                                 // No throttle change
                                            0,                                                                  // Absolute speed change
                                            0, 0, 0,                                                            // param 5-7 not used
                                            true,                                                               // autoContinue
                                            false,                                                              // isCurrentItem
                                            missionItemParent);
        items.append(item);
    }
}

bool CarSection::scanForSection(QmlObjectListModel* visualItems, int scanIndex)
{
    if (!_available || scanIndex >= visualItems->count()) {
        return false;
    }

    SimpleMissionItem* item = visualItems->value<SimpleMissionItem*>(scanIndex);
    if (!item) {
        // We hit a complex item, there can't be a speed setting
        return false;
    }
    MissionItem& missionItem = item->missionItem();

    // See CarSection::appendMissionItems for specs on what consitutes a known speed setting

    if (missionItem.command() == MAV_CMD_DO_SET_SERVO && missionItem.param1() == 1 && (missionItem.param2() == 1300 || missionItem.param2() == 1700) && missionItem.param3() == 0 && missionItem.param4() == 0 && missionItem.param5() == 0 && missionItem.param6() == 0 && missionItem.param7() == 0) {
        visualItems->removeAt(scanIndex)->deleteLater();
        bool isCar = missionItem.param2() == 1300;
        _carAndPlaneFact.setRawValue(QVariant(isCar));
        setSpecifyCarAndPlane(true);
        return true;
    }

    return false;
}


bool CarSection::specifiedCarAndPlane(void) const
{
    return _specifyCarAndPlane ? _carAndPlaneFact.rawValue().toBool() : std::numeric_limits<bool>::quiet_NaN();
}

void CarSection::_updateSpecifiedCarAndPlane(void)
{
    if (_specifyCarAndPlane) {
        emit specifiedCarAndPlaneChanged(specifiedCarAndPlane());
    }
}

void CarSection::_carAndPlaneChanged(void)
{
    // We only set the dirty bit if specify flight speed it set. This allows us to change defaults for flight speed
    // without affecting dirty.
    if (_specifyCarAndPlane) {
        setDirty(true);
    }
}
