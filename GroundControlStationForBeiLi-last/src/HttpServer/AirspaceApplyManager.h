#ifndef AIRSPACEAPPLYMANAGER_H
#define AIRSPACEAPPLYMANAGER_H

#include <QObject>
#include "HttpApiDataDefine.h"

class AirspaceApplyManager : public QObject
{
    Q_OBJECT
public:
    explicit AirspaceApplyManager(QObject *parent = nullptr);
    ~AirspaceApplyManager();

signals:

public slots:
};

#endif // AIRSPACEAPPLYMANAGER_H
