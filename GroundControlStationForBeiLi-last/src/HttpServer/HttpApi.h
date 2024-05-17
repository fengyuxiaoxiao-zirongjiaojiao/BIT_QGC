#ifndef HTTPAPI_H
#define HTTPAPI_H

#include <QObject>
#include <QString>
#include <QNetworkReply>
#include <QNetworkAccessManager>
#include <QNetworkProxy>
#include <QDebug>
#include <QApplication>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QString>
#include <QHttpPart>
#include <QFile>
#include <QMessageBox>
#include <QCryptographicHash>
#include <QSharedPointer>
#include "HttpApiDataDefine.h"
#include "UserManager.h"
#include "UAVInfoManager.h"
#include "AirspaceApplyManager.h"
#include "FlyTaskManager.h"
#include "PermissionsManager.h"
#include "DepartmentManager.h"

class HttpApi
{
public:
    HttpApi();
    ~HttpApi();
    static HttpApi *_httpApi;
    enum RequestMethod {
        REQ_GET,
        REQ_POST,
        REQ_PUT
    };
    static bool httpRequest(QString url, RequestMethod method, const QString& param_or_data, QByteArray& ret_data, const QString &authentication = QString(), bool showError=true);
    static bool httpRequest(QString url, QHttpMultiPart& multi_part, QByteArray& ret_data, bool showError=true);

    // user
    static bool userLogin(int type, const QString &userName, const QString &passwd, UserInfo &userInfo);
    static bool userLogout(const QString &authentication);
    //static bool userRegister(const QString &userName, const QString &passwd, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &imgFile);
    static bool userRegisterMultiPart(const QString &userName, const QString &passwd, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &imgFile);
    static bool sendValidCode(const QString &userName, const QString &toMail);
    static bool changePasswd(const QString &userName, const QString &passwd, const QString &validCode);
    static bool changePasswd(const QString &userName, const QString &passwd, const QString &oldPasswd, bool isKnowPwd);
    // MD5加密
    static QString encrypt(const QString &txt);

    // uavinfo
    /**
     * @brief addUAVInfo        添加设备信息
     * @param eNumber           设备编号
     * @param uavModel          无人机型号
     * @param uavNumber         产品序列号
     * @param uavIdent          实名登记号
     * @param uavFlightNum      飞控序列号
     * @param uavImei           通讯设备编号
     * @param maintenanceCycle  维护周期
     * @return
     */
    static bool addUAVInfo(const QString &eNumber, const QString &uavModel, const QString &uavNumber, const QString &uavIdent, const QString &uavFlightNum, const QString &uavImei, const QString &maintenanceCycle);
    /**
     * @brief updateUAVInfo     更新设备信息
     * @param maintenanceCycle  维护周期
     * @param audit             审批状态
     * @param uavImei           通讯设备编号
     * @param uavIdent          飞控序列号
     * @param uavModel          实名登记号
     * @param uavNumber         无人机型号
     * @param id                id
     * @return
     */
    static bool updateUAVInfo(const QString &id, const QString &maintenanceCycle = QString(), const QString &audit = QString(), const QString &uavImei = QString(), const QString &uavFlightNum = QString(), const QString &uavIdent = QString(), const QString &uavModel = QString(), const QString &uavNumber = QString());
    /**
     * @brief deleteUAVInfo 删除设备信息
     * @param id            需要删除的设备的id
     * @return
     */
    static bool deleteUAVInfo(const QString &id);

    /**
     * @brief queryUAVInfo  查询设备信息
     * @param pageSize      一页数据个数
     * @param pageNum       要查询第几页
     * @param sortOrder     升降序指示 descend：降序
     * @param sortField     排序字段
     * @param isDelete      是否已删除
     * @param audit         审批状态 disagree, agree, wait
     * @param eNumber       设备编号
     * @param registrantId  注册人id
     * @param uavModel      无人机型号
     * @param uavNumber     产品序列号
     * @param uavIdent      实名登记号
     * @param uavFlightNum  飞控序列号
     * @param uavImei       通讯设备编号
     * @return
     */
    static bool queryUAVInfo(UAVInfoList &infos, const QString &pageSize = QString(), const QString &pageNum = QString(), const QString &keyWord = QString(), const QString &deptId = QString(), const QString &uavGroup = QString(), const QString &registrantId = QString());
    /**
     * @brief registUAVUserInfoMultiPart  用户及设备注册信息
     * @param eNumber            设备编号
     * @param uavModel           无人机型号
     * @param uavNumber          产品序列号
     * @param uavIdent           实名登记号
     * @param uavFlightNum       飞控序列号
     * @param uavImei            通讯设备编号
     * @param username           自定义用户名
     * @param password           密码 （md5加密）
     * @param email              邮箱
     * @param idCard             个人身份证或企业信用代码等
     * @param type               注册类型 flier=飞手注册，co=企业注册，pu=个人注册
     * @param name               个人姓名或企业名称
     * @param idImgFile          注册时附带的照片
     * @param maintenanceCycle   维护周期
     * @return
     */
    //static bool registUAVUserInfo(const QString &eNumber, const QString &uavNumber, const QString &uavModel, const QString &uavIdent, const QString &uavFlightNum, const QString &uavImei, const QString &username, const QString &password, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &idImgFile, const QString &maintenanceCycle);
    static bool registUAVUserInfoMultiPart(const QString &eNumber, const QString &uavNumber, const QString &uavModel, const QString &uavIdent, const QString &uavFlightNum, const QString &uavImei, const QString &username, const QString &password, const QString &email, const QString &idCard, const QString &type, const QString &name, const QString &idImgFile, const QString &maintenanceCycle);
    /**
     * @brief queryUAVCount 查询设备数量
     * @return
     */
    static bool queryUAVCount(UAVOperationState &uavOperationState);
    /**
     * @brief queryUAVState 查询设备状态
     * @param id    无人机id
     * @param lng   中心位置经纬度
     * @param lat   中心位置纬度
     * @param radius 范围半径
     * @param uavId 无人机id
     * @param pageNum
     * @param pageSize
     * @return
     */
    static bool queryUAVState(UAVCurrentStateList &currentStates, const QString &id = QString(), const QString &lng = QString(), const QString &lat = QString(), const QString &radius = QString(), const QString &pageNum = QString(), const QString &pageSize = QString());

    // 飞行任务
    /**
     * @brief addFlightTask 添加飞行任务
     * @param uavId     无人机id
     * @param task      任务
     * @return
     */
    static bool addFlightTask(const QString &uavId, const QString &task);
    /**
     * @brief queryFlightTask   查询飞行任务
     * @param pageNum           一页数据的个数
     * @param pageSize          要查询第几页
     * @param sortField         排序字段
     * @param sortOrder         升降序指示
     * @param uavId             设备id
     * @return
     */
    static bool queryFlightTask(FlyTaskInfoList &taskInfos, const QString &pageNum = QString(), const QString &pageSize = QString(), const QString &sortField = QString(), const QString &sortOrder = QString(), const QString &uavId = QString());

    // 飞手权限以及与组织的关系
    /**
     * @brief queryDronePilotPermissions    查询飞手权限
     * @param pageNum           一页数据的个数
     * @param pageSize          要查询第几页
     * @param sortOrder         升降序指示
     * @param flierId           飞手id
     * @param uavId             设备id
     * @return
     */
    static bool queryDronePilotPermissions(DronePilotPermissionsInfoList &permissionsInfos, const QString &pageNum = QString(), const QString &pageSize = QString(), const QString &sortOrder = QString(), const QString &flierId = QString(), const QString &uavId = QString());
    /**
     * @brief deleteDronePilotPermissions   删除飞手的权限
     * @param flierId                       飞手id
     * @param uavId                         设备id
     * @return
     */
    static bool deleteDronePilotPermissions(const QString &flierId, const QString &uavId);
    /**
     * @brief updateDronePilotPermissions   更新飞手的权限
     * @param permissions                   飞手权限
     * @param flierId                       飞手id
     * @return
     */
    static bool updateDronePilotPermissions(const QString &permissions = QString(), const QString &flierId = QString());
    /**
     * @brief queryDronePilotWithOrg    查询飞手与组织的关系
     * @param companyId     组织（公司）的id
     * @param flierId       飞手id
     * @param pageSize      一页的数据条目
     * @param pageNum       要查询第几页
     * @param sortOrder     升序指示
     * @param sortField     排序字段
     * @param audit         审批状态 disagree || agree || wait
     * @return
     */
    static bool queryDronePilotWithOrg(DronePilotRelationshipWithOrgList &relationshipWithOrgs, const QString &audit, const QString &companyId = QString(), const QString &flierId = QString(), const QString &pageSize = QString(), const QString &pageNum = QString(), const QString &sortOrder = QString(), const QString &sortField = QString());
    /**
     * @brief deleteDronePilotWithOrg 删除飞手与组织（公司）的关系
     * @param flierId                   飞手id
     * @param companyId                 组织（公司）id
     * @return
     */
    static bool deleteDronePilotWithOrg(const QString &flierId, const QString &companyId);
    /**
     * @brief updateDronePilotWithOrg 更新飞手与组织（公司）的关系
     * @param isAgree 0：拒绝；1：确认
     * @param id
     * @return
     */
    static bool updateDronePilotWithOrg(const QString &isAgree, const QString &id);
    /**
     * @brief addDronePilotWithOrg 添加飞手与组织（公司）的关系
     * @param flierId              飞手id
     * @param companyId             公司id
     * @return
     */
    static bool addDronePilotWithOrg(const QString &flierId, const QString &companyId);

    // 空域申请与查询
    /**
     * @brief addAirspaceApplyInfo  添加空域申请信息
     * @param airspaceFile          空域文件
     * @param uavId                 设备id
     * @param instruction           空域申请说明
     * @param airspacePoints        空域范围（点集合）"[{lng:116.4127,lat:39.911707},{lng: 116.39455, lat: 39.910932},{lng: 116.403461, lat: 39.921336}...]"
     * @return
     */
    //static bool addAirspaceApplyInfo(const QString &airspaceFile, const QString &uavId, const QString &instruction, const QString &airspacePoints);
    static bool addAirspaceApplyInfoMultiPart(const QString &airspaceFile, const QString &uavId, const QString &instruction, const QList<QGeoCoordinate> &airspacePoints);

    /**
     * @brief queryAirspaceNoFlyZone    查询禁飞空域
     * @param position                  查询位置的中心坐标
     * @param radius                    查询半径
     * @param type                      查询类型 limitation_surface(障碍物限制面) || clearance(净空区) || 10km_buffer(10KM缓冲) || temp_no_fly_zone(临时禁飞区)
     * @return
     */
    static bool queryAirspaceNoFlyZone(QList<AirSpaceInfo> &airspaceInfos, const QGeoCoordinate &position, int radius, const QString &type = QString());
    /**
     * @brief auditAirspaceApply  审核空域申请
     * @param id
     * @param audit
     * @return
     */
    static bool auditAirspaceApply(const QString &id, const QString &audit);
    /**
     * @brief queryAirspaceApplyInfo    查询空域申请信息
     * @param pageNum
     * @param pageSize
     * @param sortField
     * @param sortOrder
     * @param audit     disagree || agree || wait 审批状态
     * @param applicantId   申请者的id
     * @param uavId         设备id
     * @return
     */
    static bool queryAirspaceApplyInfo(AirspaceApplyInfoList &airspaceApplyInfos, const QString &pageNum = QString(), const QString &pageSize = QString(), const QString &sortField = QString(), const QString &sortOrder = QString(), const QString &audit = QString(), const QString &applicantId = QString(), const QString &uavId = QString());
    /**
     * @brief deleteAirspaceApplyInfo 删除空域申请信息
     * @param id       对应的消息id
     * @return
     */
    static bool deleteAirspaceApplyInfo(const QString &id);

    static bool queryDepartmentInfo(QList<DeptInfo> &deptInfos);

    UserManager *userManager();

    UAVInfoManager *uavInfoManager();

    AirspaceApplyManager *airspaceApplyManager();

    FlyTaskManager *flyTaskManager();

    PermissionsManager *permissionsManager();

    DepartmentManager *departmentManager();

private:
    UserManager _userManager;
    UAVInfoManager _uavInfoManager;
    AirspaceApplyManager _airspaceApplyManager;
    FlyTaskManager _flyTaskManager;
    PermissionsManager _permissionsManager;
    DepartmentManager _departmentManager;
};
typedef QSharedPointer<HttpApi> HttpApiPtr;
//HttpApiPtr httpapi = HttpApiPtr(new HttpApi());
HttpApi *getHttpApiService(void);
#endif // HTTPAPI_H
