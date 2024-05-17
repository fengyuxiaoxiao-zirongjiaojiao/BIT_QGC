#ifndef USERMANAGER_H
#define USERMANAGER_H
#include <QSharedPointer>
#include "HttpApiDataDefine.h"

class AccountInfo : public QObject
{
    Q_OBJECT
public:
    // 初始化
    AccountInfo(){}
    AccountInfo(const QString &account,
                const QString &passwd) :
        _account(account),
        _passwd(passwd){}
    AccountInfo(const AccountInfo &other) :
        _account(other.account()),
        _passwd(other.passwd()){}
    Q_PROPERTY(QString  account    READ account  WRITE setAccount CONSTANT)
    Q_PROPERTY(QString  passwd     READ passwd   WRITE setPasswd CONSTANT)

    bool operator==(const AccountInfo &other) const
    {
        return _account == other.account() && _passwd == other.passwd();
    }

    QString account() const { return _account; }
    void setAccount(const QString& account) { _account = account; }

    QString passwd() const { return _passwd; }
    void setPasswd(const QString &passwd) { _passwd = passwd;}
private:
    // 数据
    QString _account;
    QString _passwd;
};

class UserManager : public QObject
{
    Q_OBJECT
public:
    explicit UserManager(QObject *parent = nullptr);
    ~UserManager();

    Q_PROPERTY(bool                isLogin                    READ isLogin                            NOTIFY isLoginChanged)
    Q_PROPERTY(QStringList         accountList                READ accountList                        NOTIFY accountListChanged)
    Q_PROPERTY(bool                rememberPassword           READ rememberPassword WRITE  setRememberPassword NOTIFY rememberPasswordChanged)
    Q_PROPERTY(QString             userName                   READ userName                           NOTIFY userNameChanged)
    Q_PROPERTY(QString             serialNumber               READ serialNumber                       NOTIFY serialNumberChanged)
    Q_PROPERTY(QString             description                READ description                        NOTIFY descriptionChanged)

    bool registUser(const QString &userName, const QString &passwd, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &imgFile);
    bool registUAVAndUser(const QString &eNumber, const QString &uavNumber, const QString &uavModel, const QString &uavIdent, const QString &uavFlightNum, const QString &uavImei, const QString &username, const QString &password, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &idImgFile, const QString &maintenanceCycle);
    Q_INVOKABLE bool login(const QString &userName, const QString &passwd);
    Q_INVOKABLE bool logout();
    bool sendValidCode(const QString &userName, const QString &toMail = QString());
    bool changePasswd(const QString &userName, const QString &passwd, const QString &validCode);
    bool changePasswd(const QString &userName, const QString &passwd, const QString &oldPasswd, bool isKnowPwd);
    UserInfo userInfo() const;
    void setUserInfo(const UserInfo &userInfo);
    bool isLogin();

    QStringList accountList();
    Q_INVOKABLE QString getPasswd(const QString &account);

    bool rememberPassword() const { return _rememberPassword; }
    void setRememberPassword(bool rememberPassword);

    QString userName() const { return _userInfo.username; }
    QString serialNumber() const { return _userInfo.serialNumber; }
    QString description() const { return _userInfo.description; }

    Q_INVOKABLE QString getAvatar();
    Q_INVOKABLE QString getToken();
signals:
    void isLoginChanged(bool isLogin);
    void accountListChanged();
    void rememberPasswordChanged();
    void userNameChanged();
    void serialNumberChanged();
    void descriptionChanged();
private:
    void _loadAccountInfo();
    void _saveAccountInfo();

    UserInfo _userInfo;
    bool _rememberPassword;
    bool _rememberPasswordChangeFlag;
    QString _accountInfoFileName;
    QList<AccountInfo> _accountInfos;

};
#endif // USERMANAGER_H
