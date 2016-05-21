//
//  SettingViewController.swift
//  weather
//
//  Created by 刘宏宇 on 16/4/25.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit
import CoreLocation

class SettingViewController: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    var arrCity = [Dictionary<String, AnyObject>]()
    var position = ""
    
    //定位管理器
    let locationManager:CLLocationManager = CLLocationManager()
    
    var currLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置定位服务管理器代理
        locationManager.delegate = self
        //设置定位进度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //更新距离
        locationManager.distanceFilter = 100
        ////发送授权申请
        locationManager.requestAlwaysAuthorization()
        if (CLLocationManager.locationServicesEnabled()) {
            //允许使用定位服务的话，开启定位服务更新
            locationManager.startUpdatingLocation()
            print("定位开始")
        }
        
        self.getCityList()
    }
    
    func getCityList() {
        HttpManager.defaultManager.getRequest(url: HttpUrl_getCityList,
                                              params: ["cityname": "北京"],
                                              headers: HttpHeader)
        { (result) -> Void in
            if result["errNum"]!.isEqual(0) {
                self.arrCity = result["retData"] as! [Dictionary<String, AnyObject>]
                self.table.reloadData()
            }
            else {
                let alert = UIAlertController.init(title: "提示", message: result["errMsg"] as? String, preferredStyle: UIAlertControllerStyle.Alert)
                let cancel = UIAlertAction.init(title: "确定", style: .Cancel, handler: nil)
                alert.addAction(cancel)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        currLocation = locations.last!
        
//        var str = ""
//        str += "经度：\(currLocation.coordinate.longitude)\n"
//        //获取纬度
//        str += "纬度：\(currLocation.coordinate.latitude)\n"
//        //获取海拔
//        str += "海拔：\(currLocation.altitude)\n"
//        //获取水平精度
//        str += "水平精度：\(currLocation.horizontalAccuracy)\n"
//        //获取垂直精度
//        str += "垂直精度：\(currLocation.verticalAccuracy)\n"
//        //获取方向
//        str += "方向：\(currLocation.course)\n"
//        //获取速度
//        str += "速度：\(currLocation.speed)\n"
//        //获取description
//        str += "description：\(currLocation.description)\n"
//        //获取distanceFromLocation
//        let dis = currLocation.distanceFromLocation(currLocation)
//        str += "distanceFromLocation：\(dis)\n"
//        
//        print(str)
        
        LonLatToCity()
    }
    
    ///将经纬度转换为城市名
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currLocation) { ( placemark: [CLPlacemark]?, error: NSError?) in
            if (error == nil) {//转换成功，解析获取到的各个信息
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                
                var city: String = (mark.addressDictionary! as NSDictionary).valueForKey("City") as! String
                //去掉“市”字眼
                city = city.stringByReplacingOccurrencesOfString("市", withString: "")
                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("SubLocality") as! NSString
                CityName = city
                self.position = SubLocality as String
                self.table.reloadData()
            }else {
                //转换失败
            }
        }
    }
    
    // MARK: - table
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return arrCity.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cityCell")!
        if indexPath.section == 0 {
            if DistrictName == "北京" {
                cell.textLabel?.text = "定位城市：" + self.position
            }
            else {
                cell.textLabel?.text = "定位城市：" + self.position
            }
            if ChaoyangId.isEqual(CityId) {
                cell.accessoryType = .Checkmark
            }
        }
        else {
            let str = arrCity[indexPath.row]["name_cn"] as! String
            if str == "北京" {
                cell.textLabel?.text = str + "市"
            }
            else {
                cell.textLabel?.text = str + "区"
            }
            if (arrCity[indexPath.row]["area_id"] as! String).isEqual(CityId) {
                cell.accessoryType = .Checkmark
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false) //取消选中效果
        if indexPath.section == 0 {
            DistrictName = "朝阳"
            CityId = ChaoyangId
        }
        else {
            DistrictName = arrCity[indexPath.row]["name_cn"] as! String
            CityId = arrCity[indexPath.row]["area_id"] as! String
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
