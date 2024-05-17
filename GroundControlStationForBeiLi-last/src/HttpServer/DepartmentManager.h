#ifndef DEPARTMENTMANAGER_H
#define DEPARTMENTMANAGER_H

#include <QObject>
#include <QQmlEngine>
#include <QMetaType>
#include "QmlObjectListModel.h"
#include "HttpApiDataDefine.h"

class DepartmentManager : public QObject
{
    Q_OBJECT
public:
    explicit DepartmentManager(QObject *parent = nullptr);

signals:

public slots:

private:
    QList<DeptInfo> _deptInfos;
};

#endif // DEPARTMENTMANAGER_H
