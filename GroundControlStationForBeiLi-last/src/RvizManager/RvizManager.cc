#include "RvizManager.h"
#include <QQmlEngine>
#include <QQuickWindow>
#include <QWidget>
#include <QtConcurrent>
#include <QNetworkInterface>
#include "QGCApplication.h"

#include <windows.h>
#include <TlHelp32.h>
#pragma comment(lib,"user32.lib")

RvizManager::RvizManager(QGCApplication *app, QGCToolbox *toolbox)
    : QGCTool(app, toolbox)
    , _rosPath("c:\\opt\\ros\\melodic\\x64")
    , _rvizViewVisible(false)
    , _rvizViewEnable(false)
    , _rvizWidget(nullptr)
    , _processString("Rviz not load")
    , _process(nullptr)
    , _isOpen(false)
    , _masterURL("http://localhost:11311")
{

}

RvizManager::~RvizManager()
{

}

void RvizManager::shutdown()
{
    rviz(false);
    while (_rvizWidget) {
        QApplication::processEvents(QEventLoop::AllEvents);
    }
    setRvizViewVisible(false);
    _timer.stop();

    if (_process) {
        _process->close();// 避免这个报错QProcess: Destroyed while process ("c:\\opt\\ros\\melodic\\x64\\setup.bat") is still running.
        _process->deleteLater();
    }
    if (_rvizWidget) {
        _rvizWidget->deleteLater();
    }
    qDebug() << __FILE__ << __func__ << __LINE__;
}

void RvizManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<RvizManager>("QGroundControl.RvizManager", 1, 0, "RvizManager", "Reference only");

    QDir rosDir = QDir(_rosPath);
    setRvizViewEnable(rosDir.exists());

    _localIp = getIpByIpconfig();//getIp();

    connect(&_timer, &QTimer::timeout, this, &RvizManager::_onTimerout);
    connect(this, &RvizManager::findRviz, this, &RvizManager::_run);
}

QString RvizManager::getIp()
{
    //获取IPv4地址
    QList<QNetworkInterface> interfaceList = QNetworkInterface::allInterfaces();
    for(QNetworkInterface interface: interfaceList){
        QList<QNetworkAddressEntry> addList = interface.addressEntries();
        for (QNetworkAddressEntry add: addList) {
            if (add.ip().protocol() == QAbstractSocket::IPv4Protocol /*&& add.isTemporary()*/) {
                return add.ip().toString();
            }
        }
    }
    return "0.0.0.0";
}

QString RvizManager::getIpByIpconfig()
{
    QString ip = "";
    QProcess cmd_pro ;
    QString cmd_str = QString("ipconfig");
    cmd_pro.start("cmd.exe", QStringList() << "/c" << cmd_str);
    cmd_pro.waitForStarted();
    cmd_pro.waitForFinished();
    QString result = cmd_pro.readAll();
    QString pattern("[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}");
    QRegExp rx(pattern);

    int pos = 0;
    bool found = false;
    while((pos = rx.indexIn(result, pos)) != -1){
        QString tmp = rx.cap(0);
        //跳过子网掩码 eg:255.255.255.0
        if(-1 == tmp.indexOf("255")){
            if(ip != "" && -1 != tmp.indexOf(ip.mid(0,ip.lastIndexOf(".")))){
                found = true;
                break;
            }
            ip = tmp;
        }
        pos += rx.matchedLength();
    }

    return ip;
}

void RvizManager::setRvizViewVisible(bool visible)
{
    if (_rvizViewVisible != visible) {
        _rvizViewVisible = visible;
        if (_rvizWidget) _rvizWidget->setVisible(visible);
        //if (_rvizViewVisible) _timer.start(1000);
        //else _timer.stop();
        QtConcurrent::run([=](){
            while(_rvizViewVisible) {
                DWORD pid = 0;
                bool find = FindProcess("rviz.exe", pid);
                emit findRviz(find, pid);
                QThread::msleep(1000);
            }
        });
        emit rvizViewVisibleChanged();
    }
}

void RvizManager::rviz(bool open)
{
    if (open) {
        if (_pid > 0 && _rvizWidget) {
            qDebug() << "rviz process exitst";
            return;
        }
        _processString = tr("Rviz is opening, please wait...");
        emit processStringChanged();
        _pid = 0;
        _rvizWidget = nullptr;
        if (!_process) {
            _process = new QProcess(this);
        }
        _process->setWorkingDirectory(_rosPath);
        QStringList env;
        env << QString("ROS_MASTER_URI=%1").arg(_masterURL);
        env << QString("ROS_IP=%1").arg(_localIp);
        _process->setEnvironment(env);
        QString programer = QString("%1\\setup.bat && rviz").arg(_rosPath);
        _process->start(programer);
        if (_process->processId() > 0) {
            _processString = tr("Rviz is opening, please wait...");
        } else {
            _processString = tr("Rviz open failed, please try again... %1").arg(_process->errorString());
        }
        emit processStringChanged();
        qDebug() << "programer:" << programer << env << "pid:" << _process->pid() << "processId:" << _process->processId();
    } else {
        if (_pid > 0) KillProcess(_pid);
        if (_process) {
            _process->terminate();
        }
    }
}

void RvizManager::setWidgetSize(int width, int height)
{
    _widgetSize = QSize(width, height);
    if (_rvizWidget) {
        _rvizWidget->setFixedSize(width, height);
    }
}

void RvizManager::_onTimerout()
{
    DWORD pid = 0;
    bool find = FindProcess("rviz.exe", pid);
    _run(find, pid);
}

void RvizManager::_run(bool find, int pid)
{
    _pid = pid;
    if (find) {
        //qDebug() << "find process rviz.exe. pid:" << pid;
        if (!_rvizWidget) {
            qDebug() << "add widget to context pid:" << pid;
            HWND handle = GetWindowHwndByPID(pid);
            quint64 winId = (quint64)handle;
            if (winId > 0) {
                qDebug() << "winId:" << winId;
                QWindow *childWin = QWindow::fromWinId(winId);
                if (childWin) {
                    //qDebug() << "widget opacity:" << childWin->opacity() << childWin->isVisible() << childWin->size();
                    //childWin->show(); // 这句不能取消注释，会导致程序无法退出
                    //qDebug() << "widget opacity:" << childWin->opacity() << childWin->isVisible() << childWin->size();
                    if (childWin->width() < 500 && childWin->height() < 500) {
                        qDebug() << "widget to small return";
                        return;
                    }
                    if (childWin->isModal()) {
                        qDebug() << "widget isModal return";
                        return;
                    }
                    if (childWin->width() >= 1424) {
                        qDebug() << "widget to big return";
                        return;
                    }

                    _processString = tr("Rviz is opened,if rviz not in this window please reopen it.");
                    emit processStringChanged();
                    QWidget* widget = QWidget::createWindowContainer(childWin);
                    widget->winId();
                    qDebug() << "rviz widget:" << widget;
                    _rvizWidget = widget;
                    qDebug() << "rviz widget :" << widget;
                    QQuickWindow* rootWindow = (QQuickWindow*)qgcApp()->mainRootWindow();
                    if (rootWindow) {
                        QWindow *qmlWindow = qobject_cast<QWindow*>(rootWindow);
                        widget->setProperty("_q_embedded_native_parent_handle",QVariant(qmlWindow->winId()));
                        widget->windowHandle()->setParent(qmlWindow);
                        widget->move(4, 40);
                        widget->setFixedSize(_widgetSize);
                        widget->setVisible(true);
                    }
                    setIsOpen(true);
                    qDebug() << "rviz widget add to layout" << widget;
                }
            }
        }
    } else {
        if (_rvizWidget) {
            setIsOpen(false);
            _processString = tr("Rviz not load");
            emit processStringChanged();
            _rvizWidget->setVisible(false);
            _rvizWidget->windowHandle()->setParent(nullptr);
            delete _rvizWidget;
            _rvizWidget = nullptr;
            qDebug() << "rviz process not exist, clean layout";
        }
    }
}

QString RvizManager::masterURL() const
{
    return _masterURL;
}

void RvizManager::setMasterURL(const QString &masterURL)
{
    _masterURL = masterURL;
}

bool RvizManager::isOpen() const
{
    return _isOpen;
}

void RvizManager::setIsOpen(bool isOpen)
{
    if (_isOpen != isOpen) {
        _isOpen = isOpen;
        emit openChanged();
    }
}

///< 枚举窗口回调函数
BOOL CALLBACK EnumWindowsProc(HWND hwnd, LPARAM lParam)
{
    EnumWindowsArg *pArg = (EnumWindowsArg *)lParam;
    DWORD dwProcessID = 0;
    // 通过窗口句柄取得进程ID
    ::GetWindowThreadProcessId(hwnd, &dwProcessID);
    if (dwProcessID == pArg->dwProcessID)
    {
        pArg->hwndWindow = hwnd;
        // 找到了返回FALSE
        return FALSE;
    }
    // 没找到，继续找，返回TRUE
    return TRUE;
}

///< 通过进程ID获取窗口句柄
HWND RvizManager::GetWindowHwndByPID(DWORD dwProcessID)
{
    HWND hwndRet = NULL;
    EnumWindowsArg ewa;
    ewa.dwProcessID = dwProcessID;
    ewa.hwndWindow = NULL;
    EnumWindows(EnumWindowsProc, (LPARAM)&ewa);
    if (ewa.hwndWindow)
    {
        hwndRet = ewa.hwndWindow;
    }
    return hwndRet;
}

//查找进程
bool RvizManager::FindProcess(const char *name, DWORD &pid)
{
    int i = 0;
    PROCESSENTRY32 pe32;
    pe32.dwSize = sizeof(pe32);
    HANDLE hProcessSnap = ::CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    if (hProcessSnap == INVALID_HANDLE_VALUE)
    {
        i += 0;
    }
    bool bMore = ::Process32First(hProcessSnap, &pe32);
    while (bMore)
    {
        LPTSTR pf = (LPTSTR)(LPCTSTR)pe32.szExeFile;
        char *pFileName = (char *)malloc(2 * wcslen(pf) + 1);
        wcstombs(pFileName, pf, 2 * wcslen(pf) + 1);
        //printf (" 进程名称：%s \n", pe32.szExeFile);
        //qDebug() << QByteArray(pFileName);
        HWND handle = GetWindowHwndByPID(pe32.th32ProcessID);
        quint64 winId = (quint64)handle;
        if (stricmp(name, pFileName) == 0 && winId > 0)
        {
            //qDebug() << QByteArray(pFileName);
            i += 1;
            pid = pe32.th32ProcessID;
            return true;

        }
        bMore = ::Process32Next(hProcessSnap, &pe32);
    }
    if (i > 0){           //大于1，排除自身
        return true;
    }
    else{
        return false;
    }
}

//关闭进程
BOOL RvizManager::KillProcess(DWORD ProcessId)
{
    HANDLE hProcess = OpenProcess(PROCESS_TERMINATE, FALSE, ProcessId);
    if (hProcess == NULL)
        return FALSE;
    if (!TerminateProcess(hProcess, 0))
        return FALSE;
    return TRUE;
}
