#ifndef FLYTASKMANAGER_H
#define FLYTASKMANAGER_H

#include <QObject>

class FlyTaskManager : public QObject
{
    Q_OBJECT
public:
    explicit FlyTaskManager(QObject *parent = nullptr);

signals:

public slots:
};

#endif // FLYTASKMANAGER_H