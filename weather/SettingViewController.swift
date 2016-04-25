//
//  SettingViewController.swift
//  weather
//
//  Created by 韩冲 on 16/4/25.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit
import CoreLocation

class SettingViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var tv: UITextView!
    
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
    }
    
    //定位改变执行，可以得到新位置、旧位置
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //获取最新的坐标
        currLocation = locations.last!
        var str = ""
        str += "经度：\(currLocation.coordinate.longitude)\n"
        //获取纬度
        str += "纬度：\(currLocation.coordinate.latitude)\n"
        //获取海拔
        str += "海拔：\(currLocation.altitude)\n"
        //获取水平精度
        str += "水平精度：\(currLocation.horizontalAccuracy)\n"
        //获取垂直精度
        str += "垂直精度：\(currLocation.verticalAccuracy)\n"
        //获取方向
        str += "方向：\(currLocation.course)\n"
        //获取速度
        str += "速度：\(currLocation.speed)\n"
        //获取description
        str += "description：\(currLocation.description)\n"
        //获取distanceFromLocation
        let dis = currLocation.distanceFromLocation(currLocation)
        str += "distanceFromLocation：\(dis)\n"
        
        print(str)
        
        LonLatToCity()
    }
    
    ///将经纬度转换为城市名
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        
        
        geocoder.reverseGeocodeLocation(currLocation) { ( placemark: [CLPlacemark]?, error: NSError?) in
            if (error == nil) {//转换成功，解析获取到的各个信息
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                print(mark)
                
                let city: String = (mark.addressDictionary! as NSDictionary).valueForKey("City") as! String
                let country: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("Country") as! NSString
                let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("CountryCode") as! NSString
                let FormattedAddressLines: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("FormattedAddressLines")?.firstObject as! NSString
                let Name: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("Name") as! NSString
                let State: String = (mark.addressDictionary! as NSDictionary).valueForKey("State") as! String
                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("SubLocality") as! NSString
                
                //去掉“市”和“省”字眼
                //city = city.stringByReplacingOccurrencesOfString("市", withString: "")
                //State = State.stringByReplacingOccurrencesOfString("省", withString: "")
                
                
                
                print(city)
                print(country)
                print(CountryCode)
                print(FormattedAddressLines)
                print(Name)
                print(State)
                print(SubLocality)
                
                let str = (FormattedAddressLines as String) + "\n" + city + "\n" + (SubLocality as String)
                self.tv.text = str
            }else {
                //转换失败
            }
        }
    }
}
