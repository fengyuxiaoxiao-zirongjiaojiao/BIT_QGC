
#pragma once

#include "QGCToolbox.h"
#include "QmlObjectListModel.h"

#include <QThread>
#include <QTcpSocket>
#include <QTimer>
#include <QGeoCoordinate>
#include "RosTopic.h"

class RosTopicManager : public QGCTool {
    Q_OBJECT
    
public:
    RosTopicManager(QGCApplication* app, QGCToolbox* toolbox);
    ~RosTopicManager();

    // QGCTool overrides
    void setToolbox(QGCToolbox* toolbox) final;

private slots:
    void _onAutoConnect();

private:

    void _create();

    QList<RosTopic*> _rosTopicList;
    QTimer  _autoConnectTimer;
};
