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
    var arrToday = [Dictionary<String, String>]()
    let weatherLength = 100
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "天气预报"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        let itemRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = itemRight
//        let itemLeft = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(gotoSetting))
        let btnLeft = UIBarButtonItem.init(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(gotoSetting))
        self.navigationItem.leftBarButtonItem = btnLeft
        
        self.initView()
        self.getWeatherData()
    }
    
    func getWeatherData() -> Void {
        HttpManager.defaultManager.getRequest(url: "http://apis.baidu.com/apistore/weatherservice/recentweathers?",
                                              params: ["cityname": "北京", "cityid": "101010100"],
                                              headers: ["apikey": "ab66b69af4de223187dcc22167846c2e"])
        { (result) -> Void in
            if result["errNum"]!.isEqual(0) {
                for item in result["retData"]!["history"] as! [Dictionary<String, String>] {
                    self.arrWeather.append(item)
                }
                for item in result["retData"]!["forecast"] as! [Dictionary<String, String>] {
                    self.arrWeather.append(item)
                }
                for item in result["retData"]!["today"]!!["index"] as! [Dictionary<String, String>] {
                    self.arrToday.append(item)
                }
                userDefault.setObject(self.arrWeather, forKey: "arrWeather")
                userDefault.setObject(self.arrToday, forKey: "arrToday")
                userDefault.setObject(result["retData"]!["today"]!, forKey: "today")
                self.setData()
            }
            else {
                if (userDefault.objectForKey("arrWeather") != nil) {
                    self.arrWeather = userDefault.objectForKey("arrWeather") as! [Dictionary<String, AnyObject>]
                    self.arrToday = userDefault.objectForKey("arrToday") as! [Dictionary<String, String>]
                    self.setData()
                }
            }
        }
    }
    
    func initView() -> Void {
        for i in 0...10 {
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
                if i == 11 - 1 {
                    make.right.equalTo(-10)
                }
            })
            
            let labDate = UILabel.init()
            labDate.tag = 1000 + i;
            labDate.textColor = UIColor.blackColor()
            labDate.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labDate)
            labDate.snp_makeConstraints(closure: { (make) in
                make.left.top.right.equalTo(viewWeather)
                make.height.equalTo(20)
            })
            
            let labWeather = UILabel.init()
            labWeather.tag = 1100 + i;
            labWeather.textColor = UIColor.blackColor()
            labWeather.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labWeather)
            labWeather.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(viewWeather)
                make.top.equalTo(labDate.snp_bottom).offset(100)
                make.height.equalTo(20)
            })
            
            let labTemp = UILabel.init()
            labTemp.tag = 1200 + i;
            labTemp.textColor = UIColor.blackColor()
            labTemp.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labTemp)
            labTemp.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(viewWeather)
                make.top.equalTo(labWeather.snp_bottom).offset(10)
                make.height.equalTo(20)
            })
            
            let labWind = UILabel.init()
            labWind.tag = 1300 + i;
            labWind.textColor = UIColor.blackColor()
            labWind.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labWind)
            labWind.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(viewWeather)
                make.top.equalTo(labTemp.snp_bottom).offset(10)
                make.height.equalTo(20)
            })
            
            let labWindNum = UILabel.init()
            labWindNum.tag = 1400 + i;
            labWindNum.textColor = UIColor.blackColor()
            labWindNum.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labWindNum)
            labWindNum.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(viewWeather)
                make.top.equalTo(labWind.snp_bottom).offset(10)
                make.height.equalTo(20)
            })
        }
        
        let labChuanYi = UILabel.init()
        labChuanYi.tag = 2000;
        labChuanYi.textColor = UIColor.blackColor()
        labChuanYi.textAlignment = NSTextAlignment.Left
        self.scrView.addSubview(labChuanYi)
        labChuanYi.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(scrWeather.snp_bottom).offset(10)
            make.left.equalTo(scrView.snp_left).offset(10)
            make.right.equalTo(scrView.snp_centerX)
            make.height.equalTo(40)
        })
        let labXiChe = UILabel.init()
        labXiChe.tag = 2001;
        labXiChe.textColor = UIColor.blackColor()
        labXiChe.textAlignment = NSTextAlignment.Left
        self.scrView.addSubview(labXiChe)
        labXiChe.snp_makeConstraints(closure: { (make) in
            make.top.height.equalTo(labChuanYi)
            make.left.equalTo(labChuanYi.snp_right).offset(10)
            make.right.equalTo(scrView)
        })
        
        let labLvYou = UILabel.init()
        labLvYou.tag = 2002;
        labLvYou.textColor = UIColor.blackColor()
        labLvYou.textAlignment = NSTextAlignment.Left
        self.scrView.addSubview(labLvYou)
        labLvYou.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(labChuanYi.snp_bottom)
            make.left.right.height.equalTo(labChuanYi)
        })
        let labGanMao = UILabel.init()
        labGanMao.tag = 2003;
        labGanMao.textColor = UIColor.blackColor()
        labGanMao.textAlignment = NSTextAlignment.Left
        self.scrView.addSubview(labGanMao)
        labGanMao.snp_makeConstraints(closure: { (make) in
            make.left.height.width.equalTo(labXiChe)
            make.top.equalTo(labLvYou)
        })
        
        let labYunDong = UILabel.init()
        labYunDong.tag = 2004;
        labYunDong.textColor = UIColor.blackColor()
        labYunDong.textAlignment = NSTextAlignment.Left
        self.scrView.addSubview(labYunDong)
        labYunDong.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(labLvYou.snp_bottom)
            make.left.right.height.equalTo(labLvYou)
        })
        let labZiWaiXian = UILabel.init()
        labZiWaiXian.tag = 2005;
        labZiWaiXian.textColor = UIColor.blackColor()
        labZiWaiXian.textAlignment = NSTextAlignment.Left
        self.scrView.addSubview(labZiWaiXian)
        labZiWaiXian.snp_makeConstraints(closure: { (make) in
            make.left.height.width.equalTo(labGanMao)
            make.top.equalTo(labYunDong)
            
//            make.bottom.equalTo(scrView)
        })
        
        self.scrWeather.layoutSubviews()
        self.scrWeather.setContentOffset(CGPoint.init(x: 6 * (weatherLength + 10), y: 0), animated: false)
    }
    
    func setData() -> Void {
        for i in 0...10 {
            let dicWeather = self.arrWeather[i] as! Dictionary<String, String>
            let labDate = self.view.viewWithTag(1000 + i) as! UILabel
            labDate.text = dicWeather["date"]
            let labWeather = self.view.viewWithTag(1100 + i) as! UILabel
            labWeather.text = dicWeather["type"]
            let labTemp = self.view.viewWithTag(1200 + i) as! UILabel
            labTemp.text =  String(format:"%@/%@", dicWeather["hightemp"]!, dicWeather["lowtemp"]!)
            let labWind = self.view.viewWithTag(1300 + i) as! UILabel
            labWind.text = dicWeather["fengxiang"]
            let labWindNum = self.view.viewWithTag(1400 + i) as! UILabel
            labWindNum.text = dicWeather["fengli"]
        }
        for dic in self.arrToday {
            if dic["code"] == "gm" {
                let lab = self.view.viewWithTag(2003) as! UILabel
                lab.text = dic["name"]! + ":" + dic["index"]!
            }
            else if dic["code"] == "fs" {
                let lab = self.view.viewWithTag(2005) as! UILabel
                lab.text = dic["name"]! + ":" + dic["index"]!
            }
            else if dic["code"] == "ct" {
                let lab = self.view.viewWithTag(2000) as! UILabel
                lab.text = dic["name"]! + ":" + dic["index"]!
            }
            else if dic["code"] == "yd" {
                let lab = self.view.viewWithTag(2004) as! UILabel
                lab.text = dic["name"]! + ":" + dic["index"]!
            }
            else if dic["code"] == "xc" {
                let lab = self.view.viewWithTag(2001) as! UILabel
                lab.text = dic["name"]! + ":" + dic["index"]!
            }
            else if dic["code"] == "ls" {
                let lab = self.view.viewWithTag(2002) as! UILabel
                lab.text = dic["name"]! + ":" + dic["index"]!
            }
        }
    }
    
    func gotoSetting() -> Void {
        self.performSegueWithIdentifier("setting", sender: nil)
    }
    
    func share() -> Void {
        // 分享
        if (userDefault.objectForKey("today") != nil) {
            let dic = userDefault.objectForKey("today") as! Dictionary<String, AnyObject>
            let str = "今天的天气情况是：最高气温"
                + (dic["hightemp"]! as! String) + ",最低气温" + (dic["curTemp"]! as! String)
            print(str)
            self.sendText(str, inScene: WXSceneSession)
        }
    }
    
    func sendText(text:String, inScene: WXScene)->Bool{
        let req = SendMessageToWXReq()
        req.text = text
        req.bText = true
        req.scene = Int32(inScene.rawValue)
        return WXApi.sendReq(req)
    }
}

