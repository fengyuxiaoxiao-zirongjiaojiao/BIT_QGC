#ifndef PERMISSIONSMANAGER_H
#define PERMISSIONSMANAGER_H

#include <QObject>

class PermissionsManager : public QObject
{
    Q_OBJECT
public:
    explicit PermissionsManager(QObject *parent = nullptr);

signals:

public slots:
};

#endif // PERMISSIONSMANAGER_H