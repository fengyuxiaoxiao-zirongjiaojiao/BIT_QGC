#ifndef RVIZMANAGER_H
#define RVIZMANAGER_H

#include <QObject>
#include <QWidget>
#include <QTimer>
#include "QGCToolbox.h"
#include <QThread>

///< 枚举窗口参数
typedef struct
{
    HWND hwndWindow; // 窗口句柄
    DWORD dwProcessID; // 进程ID
}EnumWindowsArg;

class RvizManager : public QGCTool
{
    Q_OBJECT
public:
    explicit RvizManager(QGCApplication* app, QGCToolbox* toolbox);
    ~RvizManager();

    void shutdown();

    // Override from QGCTool
    virtual void setToolbox(QGCToolbox *toolbox) override;

    Q_PROPERTY(bool rvizViewVisible        READ rvizViewVisible   WRITE setRvizViewVisible   NOTIFY rvizViewVisibleChanged)
    Q_PROPERTY(bool rvizViewEnable         READ rvizViewEnable    WRITE setRvizViewEnable    NOTIFY rvizViewEnableChanged)
    Q_PROPERTY(QString processString      READ processString  NOTIFY processStringChanged)
    Q_PROPERTY(bool isOpen                READ isOpen       NOTIFY openChanged)
    Q_PROPERTY(QString masterURL         READ masterURL    WRITE setMasterURL NOTIFY masterURLChanged)

    bool rvizViewVisible(void) { return _rvizViewVisible; }
    void setRvizViewVisible(bool visible);

    bool rvizViewEnable(void) { return _rvizViewEnable; }
    void setRvizViewEnable(bool enable) {
        if (_rvizViewEnable != enable) {
            _rvizViewEnable = enable;
            emit rvizViewEnableChanged();
        }
    }

    Q_INVOKABLE void rviz(bool open);
    Q_INVOKABLE void setWidgetSize(int width, int height);

    QString processString(void) { return _processString; }

    bool isOpen() const;
    void setIsOpen(bool isOpen);

    QString masterURL() const;
    void setMasterURL(const QString &masterURL);

signals:
    void rvizViewVisibleChanged();
    void rvizViewEnableChanged();
    void processStringChanged();
    void findRviz(bool find, int pid);
    void openChanged();
    void masterURLChanged();
private slots:
    void _onTimerout();
    void _run(bool find, int pid);
private:
    QString _rosPath;
    bool _rvizViewVisible = false;
    bool _rvizViewEnable = false;
    QWidget *_rvizWidget = nullptr;
    QString _processString;
    QSize _widgetSize;
    QProcess* _process;
    bool _isOpen;
    QString _masterURL;
    QTimer _timer;
    DWORD _pid = 0;
    HWND GetWindowHwndByPID(DWORD dwProcessID);
    bool FindProcess(const char *name, DWORD &pid);
    BOOL KillProcess(DWORD ProcessId);

    QString _localIp;
    QString getIp();
    QString getIpByIpconfig();
};

#endif // RVIZMANAGER_H
