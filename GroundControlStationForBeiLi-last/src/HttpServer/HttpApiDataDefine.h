#ifndef HTTPAPIDATADEFINE_H
#define HTTPAPIDATADEFINE_H

#include <QString>
#include <QList>
#include <QGeoCoordinate>

#define MOJI_SERVER_URL         "http://apifreelat.market.alicloudapi.com"
#define BRIEFFORECAST_3DAYS     "/whapi/json/aliweather/briefforecast3days"
#define NO_ERROR                0
#define REQUEST_TIMEOUT_MS      5000
#define MOJI_TOKEN              "443847fa1ffd4e69d929807d42c2db1b"
#define APPCODE                 "0ac5e2c447c2430b8c5eded18aac3d4e"



// 飞图
//#define DATA_POST_URL           "39.100.128.156"
// 重庆
//#define DATA_POST_URL           "192.168.7.1"
// 北京
//#define DATA_POST_URL           "192.168.29.97"
// 本机
//#define DATA_POST_URL           "127.0.0.1"
// 台式电脑
//#define DATA_POST_URL           "192.168.0.105"
#define DATA_POST_URL           "192.168.1.216"

#define WEB_URL                 "http://"##DATA_POST_URL##":20601"
#define SERVER_URL              WEB_URL##"/svr"

#define GROUND_STATION_PORT "20800"
#define UAV_PORT "20900"
//指控中心端口发20700，监听20702; 转发到地面站的端口是20701
#define CONTROL_CENTER_PORT "20701"

// user
#define USER_REGIST_PATH         "/regist"
#define USER_LOGIN_PATH          "/authentication"
#define USER_VALIDCODE_PATH      "/mail/validcode/resetpassword"
#define USER_CHPASSWD_PATH       "/user/password"
#define USER_AVATAR              "/upload"
// uavinfo
#define UAV_ADD_PATH             "/uav/add"
#define UAV_UPDATE_PATH          "/uav/update"
#define UAV_DELETE_PATH          "/uav/delete"
#define UAV_QUERY_PATH           "/uavV2/query"
#define UAV_USER_PATH            "/regist/2"
#define UAV_COUNT_PATH           "/uav/queryCount"
#define UAV_STATE_PATH           "/uavV2/queryUavCurrentState"
// flight task add
#define TASK_ADD_PATH            "/flyTask/add"
#define TASK_QUERY_PATH          "/flyTask/query"
// 飞手权限
#define PERMISSION_QUERY_PATH     "/uavPermissions/query"
#define PERMISSION_DELETE_PATH    "/uavPermissions/delete"
#define PERMISSION_UPDATE_PATH    "/uavPermissions/update"
// 飞手与商家的关系
#define DRONE_PILOT_WITH_ORG_QUERY_PATH  "/flierAndCompany/query"
#define DRONE_PILOT_WITH_ORG_DELETE_PATH "/flierAndCompany/delete"
#define DRONE_PILOT_WITH_ORG_UPDATE_PATH "/flierAndCompany/update"
#define DRONE_PILOT_WITH_ORG_ADD_PATH    "/flierAndCompany/add"
// 空域申请
#define AIRSPACE_ADD_PATH           "/airspace/applyForAirspace/add"
#define AIRSPACE_QUERY_NOFLYZONE    "/airspace/queryNoFlyZone"
#define AIRSPACE_UPDATE_PATH        "/airspace/applyForAirspace/update"
#define AIRSPACE_QUERY_PATH         "/airspace/applyForAirspace/query"
#define AIRSPACE_DELETE_PATH        "/airspace/applyForAirspace/delete"
// 机构
#define DEPT_QUERY_PATH "/dept"
#define DEPT_ORDERED_QUERY_PATH "/dept/orderedList"

class UserInfo
{
public:
    int     userId = -1;
    QString username;
    QString password;
    QString email;
    int     status = -1;
    QString createTime;
    QString lastLoginTime;
    int     gender = -1;//性别
    QString type;// 注册类型
    QString idCard;
    QString name;
    QString idImgUrl;
    QString description;
    QString avatar;
    QString id;
    int     authCacheKey = -1;
    QString serialNumber;

    QString token;
};

class UAVInfo
{
public:
    QString createTime;//创建时间
    QString uavFlightNum;//飞控序列号
    int     registrantId = -1;//注册人id
    QString avatar;//头像
    QString uavNumber;//产品序列号
    QString isDelete;//是否已删除
    QString uavImei;//通讯设备编号
    QString uavIdent;//实名序列号
    QString maintenanceCycle;//维护周期
    QString audit;//审批状态 disagree, agree, wait
    int     id = -1;//自增id，uavId
    QString eNumber;//设备编号
    QString uavModel;//无人机型号
    QString username;//用户名称
    QString nickname;//用户昵称
    QString email;//邮箱
    QString idImgUrl;//身份证文件
    QString idCard;//身份证
    QString name;//公司名，个人姓名等
    QString flightTime; // 飞行时间
    QStringList permissionHolder; // 权限
    QStringList permissionFlight; // 飞行权限
    int ctrlId; // 控制id
    int systemId; // 飞控系统id
    QString userType; // 用户类型
    QString uavGroupName; // 所在组名
    QString videoStreamUrl; // 视频流地址
};

class UAVInfoList
{
public:
    void append(const UAVInfo &uavInfo) {
        _records.append(uavInfo);
    }

    UAVInfo at(int index) {
        if (index >= 0 && index < _records.count()) {
            return _records.at(index);
        }
        return UAVInfo();
    }

    void clear() {
        _records.clear();
        _total = 0;
        _size = 0;
        _current = 0;
        _pages = 0;
        _searchCount = false;
    }

    int count() {
        return _records.count();
    }

    int total() const
    {
        return _total;
    }

    void setTotal(int total)
    {
        _total = total;
    }

    int size() const
    {
        return _size;
    }

    void setSize(int size)
    {
        _size = size;
    }

    int current() const
    {
        return _current;
    }

    void setCurrent(int current)
    {
        _current = current;
    }

    int pages() const
    {
        return _pages;
    }

    void setPages(int pages)
    {
        _pages = pages;
    }

    bool searchCount() const
    {
        return _searchCount;
    }

    void setSearchCount(bool searchCount)
    {
        _searchCount = searchCount;
    }

private:
    QList<UAVInfo> _records;
    int _total;     // 当前请求了几条记录 _records的长度
    int _size;      // 最大可以请求多少条数据，既是服务器存储了多少条数据
    int _current;   // 当前第几页数据
    int _pages;     // 总页数
    bool _searchCount;
};
// 无人机类型以及数量
class UAVType
{
public:
    int count;          // 数量
    int type;           // 类型
    QString uavModel;   // 类型名称
};
// 无人机运营状态
class UAVOperationState
{
public:
    int total;              // 总的无人机数据数
    int approvedCount;      // 审核通过在运营无人机数量
    QList<UAVType> state;   // 机型分类以及数量
};

// 无人机当前的状态
class UAVCurrentState
{
public:
    double  speed;          //速度
    QString createdTime;   //创建时间
    QString updateTime;    // 更新时间
    double  height;         //海拔高度
    int     uavId;         //设备id（无人机）
    int     registrantId;  //申请人id
    double  alt;            //相对高度
    int     id;             //自增id
    QString eNumber;       //设备编号
    double  direction;      //航向
    double  latitude;       //纬度
    double  longitude;      //经度
};

class UAVCurrentStateList
{
public:
    void append(const UAVCurrentState &uavCurrentState) {
        _records.append(uavCurrentState);
    }

    UAVCurrentState at(int index) const {
        if (index >= 0 && index < _records.count()) {
            return _records.at(index);
        }
        return UAVCurrentState();
    }

    void clear() {
        _records.clear();
        _total = 0;
        _size = 0;
        _current = 0;
        _pages = 0;
        _searchCount = false;
    }

    int count() const {
        return _records.count();
    }

    int total() const
    {
        return _total;
    }

    void setTotal(int total)
    {
        _total = total;
    }

    int size() const
    {
        return _size;
    }

    void setSize(int size)
    {
        _size = size;
    }

    int current() const
    {
        return _current;
    }

    void setCurrent(int current)
    {
        _current = current;
    }

    bool searchCount() const
    {
        return _searchCount;
    }

    void setSearchCount(bool searchCount)
    {
        _searchCount = searchCount;
    }

    int pages() const
    {
        return _pages;
    }

    void setPages(int pages)
    {
        _pages = pages;
    }

private:
    QList<UAVCurrentState> _records;
    int _total;     // 当前请求了几条记录 _records的长度
    int _size;      // 最大可以请求多少条数据，既是服务器存储了多少条数据
    int _current;   // 当前第几页数据
    int _pages;     // 总页数
    bool _searchCount;
};

// 飞行任务信息
class FlyTaskInfo
{
public:
    int     flierId;
    QString createdTime;
    QString task;
    int     uavId;
    int     registrantId;
    QString name;
    int     id;
    QString eNumber;
    QString uavModel;
    QString username;
};

class FlyTaskInfoList
{
public:
    void append(const FlyTaskInfo &flyTaskInfo) {
        _records.append(flyTaskInfo);
    }

    void clear() {
        _records.clear();
        _total = 0;
        _size = 0;
        _current = 0;
        _pages = 0;
        _searchCount = false;
    }

    int total() const
    {
        return _total;
    }

    void setTotal(int total)
    {
        _total = total;
    }

    int size() const
    {
        return _size;
    }

    void setSize(int size)
    {
        _size = size;
    }

    int current() const
    {
        return _current;
    }

    void setCurrent(int current)
    {
        _current = current;
    }

    bool searchCount() const
    {
        return _searchCount;
    }

    void setSearchCount(bool searchCount)
    {
        _searchCount = searchCount;
    }

    int pages() const
    {
        return _pages;
    }

    void setPages(int pages)
    {
        _pages = pages;
    }
private:
    QList<FlyTaskInfo> _records;
    int _total;     // 当前请求了几条记录 _records的长度
    int _size;      // 最大可以请求多少条数据，既是服务器存储了多少条数据
    int _current;   // 当前第几页数据
    int _pages;     // 总页数
    bool _searchCount;
};

// 飞手权限
class DronePilotPermissionsInfo
{
public:
    int     flierId;        //飞手id
    QString createdTime;    //创建时间
    int     uavId;          //无人机id
    QString permissions;    // "[权限1,权限2]",//权限
    QString name;           //飞手名称
    int     id;             //自增id
    QString avatar;         //头像
    QString eNumber;        //设备编号
    QString uavModel;       //无人机型号
    QString username;       //账户名
};

class DronePilotPermissionsInfoList
{
public:
    void append(const DronePilotPermissionsInfo &permissionsInfo) {
        _records.append(permissionsInfo);
    }

    void clear() {
        _records.clear();
        _total = 0;
        _size = 0;
        _current = 0;
        _pages = 0;
        _searchCount = false;
    }

    int total() const
    {
        return _total;
    }

    void setTotal(int total)
    {
        _total = total;
    }

    int size() const
    {
        return _size;
    }

    void setSize(int size)
    {
        _size = size;
    }

    int current() const
    {
        return _current;
    }

    void setCurrent(int current)
    {
        _current = current;
    }

    bool searchCount() const
    {
        return _searchCount;
    }

    void setSearchCount(bool searchCount)
    {
        _searchCount = searchCount;
    }

    int pages() const
    {
        return _pages;
    }

    void setPages(int pages)
    {
        _pages = pages;
    }
private:
    QList<DronePilotPermissionsInfo> _records;
    int _total;     // 当前请求了几条记录 _records的长度
    int _size;      // 最大可以请求多少条数据，既是服务器存储了多少条数据
    int _current;   // 当前第几页数据
    int _pages;     // 总页数
    bool _searchCount;
};
// 飞手与组织（公司）的关系
class DronePilotRelationshipWithOrg
{
public:
    int     flierId;//飞手id
    QString createdTime;//创建时间
    int     companyId;//公司id
    QString audit;//审核状态
    QString name;//用户名
    int     id;//自增id
    QString username;//账号名
};
class DronePilotRelationshipWithOrgList
{
public:
    void append(const DronePilotRelationshipWithOrg &relationshipWithOrg) {
        _records.append(relationshipWithOrg);
    }

    void clear() {
        _records.clear();
        _total = 0;
        _size = 0;
        _current = 0;
        _pages = 0;
        _searchCount = false;
    }

    int total() const
    {
        return _total;
    }

    void setTotal(int total)
    {
        _total = total;
    }

    int size() const
    {
        return _size;
    }

    void setSize(int size)
    {
        _size = size;
    }

    int current() const
    {
        return _current;
    }

    void setCurrent(int current)
    {
        _current = current;
    }

    bool searchCount() const
    {
        return _searchCount;
    }

    void setSearchCount(bool searchCount)
    {
        _searchCount = searchCount;
    }

    int pages() const
    {
        return _pages;
    }

    void setPages(int pages)
    {
        _pages = pages;
    }
private:
    QList<DronePilotRelationshipWithOrg> _records;
    int _total;     // 当前请求了几条记录 _records的长度
    int _size;      // 最大可以请求多少条数据，既是服务器存储了多少条数据
    int _current;   // 当前第几页数据
    int _pages;     // 总页数
    bool _searchCount;
};

// 空域申请信息
class AirspaceApplyInfo
{
public:
    QString createdTime;       //创建时间
    int     uavId;             //无人机id
    QString airspaceFileUrl;    //空域申请文件url
    QString idCard;             //个人身份证或者企业信用代码等
    QList<QGeoCoordinate> airspacePoints;
    int     applicantId;        //申请人id
    QString audit;              //审核状态
    QString instruction;        //空域申请说明
    QString name;               //用户名
    int     id;                 //自增id
    QString uavModel;           //无人机型号
    QString eNumber;            //设备编号
    QString username;           //账户名
};
class AirspaceApplyInfoList
{
public:
    void append(const AirspaceApplyInfo &airspaceApplyInfo) {
        _records.append(airspaceApplyInfo);
    }

    void clear() {
        _records.clear();
        _total = 0;
        _size = 0;
        _current = 0;
        _pages = 0;
        _searchCount = false;
    }

    int total() const
    {
        return _total;
    }

    void setTotal(int total)
    {
        _total = total;
    }

    int size() const
    {
        return _size;
    }

    void setSize(int size)
    {
        _size = size;
    }

    int current() const
    {
        return _current;
    }

    void setCurrent(int current)
    {
        _current = current;
    }

    bool searchCount() const
    {
        return _searchCount;
    }

    void setSearchCount(bool searchCount)
    {
        _searchCount = searchCount;
    }

    int pages() const
    {
        return _pages;
    }

    void setPages(int pages)
    {
        _pages = pages;
    }
private:
    QList<AirspaceApplyInfo> _records;
    int _total;     // 当前请求了几条记录 _records的长度
    int _size;      // 最大可以请求多少条数据，既是服务器存储了多少条数据
    int _current;   // 当前第几页数据
    int _pages;     // 总页数
    bool _searchCount;
};

class AirSpaceInfo
{
public:
    QString                 createTime; // "2020-04-30 10:42:14"
    int                     typeId;
    QString                 name;
    QString                 typeName;
    QString                 drawType;
    int                     id;
    QString                 type;       // limitation_surface(障碍物限制面) || clearance(净空区) || 10km_buffer(10KM缓冲) || temp_no_fly_zone(临时禁飞区)
    QList<QGeoCoordinate>   points;
};

class UavGroupInfo
{
public:
    QString uavGroupName;
    int     uavGroupId;
};

class DeptInfo
{
public:
    QString deptName;
    int     deptId;
    QList<UavGroupInfo> uavGroupInfos;
};

#endif // HTTPAPIDATADEFINE_H


