//
//  ViewController.swift
//  weather
//
//  Created by tmachc on 16/3/14.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrView: UIScrollView!
    @IBOutlet var scrWeather: UIScrollView!
    var arrWeather = [Dictionary<String, AnyObject>]()
    let weatherLength = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "天气预报"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        let itemRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = itemRight
        
        self.getWeatherData()
    }
    
    func getWeatherData() -> Void {
        HttpManager.defaultManager.getRequest(url: "http://apis.baidu.com/apistore/weatherservice/recentweathers?",
                                              params: ["cityname": "北京", "cityid": "101010100"],
                                              headers: ["apikey": "ab66b69af4de223187dcc22167846c2e"])
        { (result) -> Void in
            if result["errNum"]!.isEqual(0) {
                userDefault.setObject(result["retData"]!["forecast"], forKey: "forecast")
                userDefault.setObject(result["retData"]!["history"], forKey: "history")
                userDefault.setObject(result["retData"]!["today"], forKey: "today")
                for item in result["retData"]!["history"] as! [Dictionary<String, String>] {
                    self.arrWeather.append(item)
                }
                for item in result["retData"]!["forecast"] as! [Dictionary<String, String>] {
                    self.arrWeather.append(item)
                }
                self.initView()
            }
            else {
                
            }
        }
    }
    
    func initView() -> Void {
        print(self.arrWeather)
        for i in 0...self.arrWeather.count - 1 {
            print(i, self.arrWeather[i])
            let dicWeather = self.arrWeather[i] as! Dictionary<String, String>
            let viewWeather = UIView.init()
            if i < 7 {
                viewWeather.backgroundColor = UIColor.orangeColor()
            }
            else if i == 7 {
                viewWeather.backgroundColor = UIColor.redColor()
            }
            else if i > 7 {
                viewWeather.backgroundColor = UIColor.greenColor()
            }
            self.scrWeather.addSubview(viewWeather)
            viewWeather.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(10 + i * (weatherLength + 10))
                make.width.equalTo(weatherLength)
                make.top.height.bottom.equalTo(self.scrWeather)
                if i == self.arrWeather.count - 1 {
                    make.right.equalTo(-10)
                }
            })
            
            let labDate = UILabel.init()
            labDate.text = dicWeather["date"]
            labDate.textColor = UIColor.blackColor()
            labDate.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labDate)
            labDate.snp_makeConstraints(closure: { (make) in
                make.left.top.right.equalTo(viewWeather)
                make.height.equalTo(20)
            })
            
            let labWeather = UILabel.init()
            labWeather.text = dicWeather["type"]
            labWeather.textColor = UIColor.blackColor()
            labWeather.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labWeather)
            labWeather.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(viewWeather)
                make.top.equalTo(labDate.snp_bottom).offset(100)
                make.height.equalTo(20)
            })
            
            let labTemp = UILabel.init()
            labTemp.text =  String(format:"%@/%@", dicWeather["hightemp"]!, dicWeather["lowtemp"]!)
            labTemp.textColor = UIColor.blackColor()
            labTemp.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labTemp)
            labTemp.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(viewWeather)
                make.top.equalTo(labWeather.snp_bottom).offset(10)
                make.height.equalTo(20)
            })
            
            let labWind = UILabel.init()
            labWind.text = dicWeather["fengxiang"]
            labWind.textColor = UIColor.blackColor()
            labWind.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labWind)
            labWind.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(viewWeather)
                make.top.equalTo(labTemp.snp_bottom).offset(10)
                make.height.equalTo(20)
            })
            
            let labWindNum = UILabel.init()
            labWindNum.text = dicWeather["fengli"]
            labWindNum.textColor = UIColor.blackColor()
            labWindNum.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labWindNum)
            labWindNum.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(viewWeather)
                make.top.equalTo(labWind.snp_bottom).offset(10)
                make.height.equalTo(20)
            })
        }
        
        self.scrWeather.setContentOffset(CGPoint.init(x: 6 * (weatherLength + 10), y: 0), animated: false)
    }
    
    func share() -> Void {
        // 分享
    }
}

