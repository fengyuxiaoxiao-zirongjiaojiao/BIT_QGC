/**************************************************
** Author      : 徐建文
** CreateTime  : 2019-06-27 09:02:00
** ModifyTime  : 2019-06-27 18:02:17
** Email       : Vincent_xjw@163.com
** Description : 车子与飞机切换
** cmd                      p1 	p2          p3 	p4 	p5 	p6 	p7
** MAV_CMD_DO_SET_SERVO 	1 	1300/1700
** 1300为车模式
** 1700为飞机模式
***************************************************/

#pragma once

#include "Section.h"
#include "FactSystem.h"
#include "QmlObjectListModel.h"

class PlanMasterController;

class CarSection : public Section
{
    Q_OBJECT

public:
    CarSection(PlanMasterController* masterController, QObject* parent = nullptr);

    Q_PROPERTY(bool     specifyCarAndPlane  READ specifyCarAndPlane WRITE setSpecifyCarAndPlane NOTIFY specifyCarAndPlaneChanged)
    Q_PROPERTY(Fact*    carAndPlane         READ carAndPlane                                    CONSTANT)

    bool    specifyCarAndPlane      (void) const { return _specifyCarAndPlane; }
    Fact*   carAndPlane             (void) { return &_carAndPlaneFact; }
    void    setSpecifyCarAndPlane   (bool specifyCarAndPlane);

    ///< Signals specifiedCarAndPlaneChanged
    ///< @return The car and plane specified by this item, NaN if not specified
    bool specifiedCarAndPlane(void) const;

    // Overrides from Section
    bool available          (void) const override { return _available; }
    bool dirty              (void) const override { return _dirty; }
    void setAvailable       (bool available) override;
    void setDirty           (bool dirty) override;
    bool scanForSection     (QmlObjectListModel* visualItems, int scanIndex) override;
    void appendSectionItems (QList<MissionItem*>& items, QObject* missionItemParent, int& seqNum) override;
    int  itemCount          (void) const override;
    bool settingsSpecified  (void) const override;

signals:
    void specifyCarAndPlaneChanged      (bool specifyCarAndPlane);
    void specifiedCarAndPlaneChanged    (bool carAndPlane);

private slots:
    void _updateSpecifiedCarAndPlane(void);
    void _carAndPlaneChanged        (void);

private:
    bool    _available;
    bool    _dirty;
    bool    _specifyCarAndPlane;
    Fact    _carAndPlaneFact;

    static QMap<QString, FactMetaData*> _metaDataMap;

    static const char* _carAndPlaneName;
};
