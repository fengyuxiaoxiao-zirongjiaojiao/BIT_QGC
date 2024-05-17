#ifndef JSCONTEXT_H
#define JSCONTEXT_H

#include <QObject>
#include <ShapeFileHelper.h>

class JsContext : public QObject
{
    Q_OBJECT
public:
    explicit JsContext(QObject *parent = nullptr);

signals:
    /*
        This signal is emitted from the C++ side and the text displayed on the HTML client side.
    */
    void sendText(const QString &text);
    /**
     * @brief vehicleAdded
     * @param id
     */
    void vehicleAdded(int id);
    /**
     * @brief vehicleRemoved
     * @param id
     */
    void vehicleRemoved(int id);
    /**
     * @brief sendVehicleStatus
     * @param status
        {
            "activeVehicle": 1,
            "vehicles": [
                {
                "altitude": 0.27399998903274536,
                "altitudeAMSL": 13.369999885559082,
                "camera": {
                    "HFOV": 90,						// 可视域水平夹角（单位`度`，默认值90）
                    "VFOV": 100,					// 可视域垂直夹角（单位`度`，默认值60）
                    "pitch": 0.01767219603061676,	// 俯仰角（单位`度`，默认值0）
                    "roll": 0.027614036574959755,	// 横滚角（单位`度`，默认值0）
                    "yaw": 2						// 航向角（单位`度`，默认值0）
                },
                "id": 1,
                "isArmed": false,
                "isCar": false,
                "latitude": 23.17300033569336,
                "longitude": 113.40799713134766,
                "pitch": 0.01767219603061676,
                "roll": 0.027614036574959755,
                "yaw": 2
                }
            ]
        }
     */
    void sendVehicleStatus(QString status);
    /**
     * @brief activeVehicleChanged 通知cesium活动的飞机变化了
     * @param value    jsonvalue
     * {
     *  id: 1-255
     *  color: 未激活时候的颜色
     *  activeColor: 激活时候的颜色
     * }
     */
    void activeVehicleChanged(QString value);
    /**
     * @brief cmdKml 发送绘制kml的指令;// onReceiveKml
     * @param type 0:Polygon, 1:Polyline
     * @trace trace true: 绘制，false：停止绘制
     */
    void cmdKml(int type, bool trace);
    /**
     * @brief cmdWayPoint   发送绘制航点的命令
     * @param defaultHeight 默认航高
     * @param start         true为开始绘制，false为结束绘制
     */
    void cmdWayPoint(double defaultHeight, bool start = true);
    /**
     * @brief cmdTrackVehicle   跟踪某台飞机
     * @param vehicleId         跟踪的飞机id
     */
    void cmdTrackVehicle(int vehicleId);
    /**
     * @brief drawWayPoint  发送绘制航点
     * @param waypoint      需要绘制的航点
     */
    void drawWayPoint(QString waypoint);
    /**
     * @brief drawKml   发送绘制kml
     * @param kml
     */
    void drawKml(int type, QString kml);
    /**
     * @brief removeKml 删除所有绘制的kml
     */
    void removeKml();
    /**
     * @brief removeWaypoint 删除所有绘制的航点
     */
    void removeWaypoint();
    /**
     * @brief removeFlightPath 删除飞机路径，航迹
     */
    void removeFlightPath();
    /**
     * @brief gotoViewPoint 视角切换
     * @param viewPoint 视角坐标
     */
    void gotoViewPoint(QString viewPoint);
    /**
     * @brief planView 视图是否为航线规划视图
     * @param isPlanView 为true是当前为规划视图，否则为飞行视图
     */
    void planView(bool isPlanView);
    /**
     * @brief planWaypoint 在规划视图中，航线变化时调用推送航线
     * @param plan 任务航线
     */
    void planWaypoint(QString plan);
    /**
     * @brief videoPath rtsp视频流的地址
     * @param path
     */
    void videoPath(QString path);
public slots:

    /*
        This slot is invoked from the HTML client side and the text displayed on the server side.
    */
    void onReceiveText(const QString &text);
    /**
     * @brief onReceiveKml  接收绘制好的kml，每绘制一个点就返回一个点
     * @param type
     * @param kml
     */
    void onReceiveKml(int type, QString kml); // cmdKml
    /**
     * @brief onReceiveWayPoint 接收绘制好的航点，每绘制一个点就返回一个点
     * @param point
     */
    void onReceiveWayPoint(QString point);// cmdWayPoint
    /**
     * @brief onActiveVehicleChanged    3D地图界面双击飞行器激活飞机，将飞机id回传给地面站
     * @param id                        飞机id
     */
    void onActiveVehicleChanged(int id);
    /**
     * @brief onPlanWaypointEdited
     * @param index 航点序号
     * @param json 航点信息
     */
    void onPlanWaypointEdited(int index, QString json);

    /**
     * @brief onPlanWaypointSelected 点选航点模块
     * @param index         航点序号 vindex
     */
    void onPlanWaypointSelected(int index);

    /**
     * @brief onCenterChanged 地图中心改变的时候调用，即拖动地图后调用
     * @param point
     */
    void onMapCenterChanged(QString point);
signals:
    void activeVehicleFromWebChanged(int id);
    void kmlPointFromWebChanged(int type, QGeoCoordinate coor);
    void addWayPointFromWebChanged(QGeoCoordinate coor);
    void planWaypointFromWebEdited(int index, QString json);
    void planWaypointFromWebSelected(int index);
    void mapCenterChanged(QGeoCoordinate coor);
};

#endif // JSCONTEXT_H
