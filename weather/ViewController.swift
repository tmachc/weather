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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    var refreshControl: UIRefreshControl!
    @IBOutlet var scrWeather: UIScrollView!
    
    var arrWeather = [Dictionary<String, AnyObject>]()
    var arrToday = [Dictionary<String, AnyObject>]()
    let weatherLength = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
        
        let itemRight = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = itemRight
        
        let btnLeft = UIBarButtonItem.init(title: "设置", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(gotoSetting))
        self.navigationItem.leftBarButtonItem = btnLeft
        
        table.tableFooterView = UIView()
        
        self.refreshControl = UIRefreshControl.init()
        self.refreshControl.addTarget(self, action: #selector(getWeatherData), forControlEvents: UIControlEvents.ValueChanged)
        self.table.addSubview(self.refreshControl)
        
        self.initView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "天气" + "(" + DistrictName + ")"
        self.refreshControl.beginRefreshing()
        self.getWeatherData()
    }
    
    func getWeatherData() -> Void {
        // http
        HttpManager.defaultManager.getRequest(url: HttpUrl_getWeather,
                                              params: ["cityname": DistrictName, "cityid": CityId],
                                              headers: HttpHeader)
        { (result) -> Void in
            // 处理结果
            if result["errNum"]!.isEqual(0) {
                // 请求正确
                self.arrWeather.removeAll()
                self.arrToday.removeAll()
                
                // 天气列表数据
                for item in result["retData"]!["history"] as! [Dictionary<String, AnyObject>] {
                    self.arrWeather.append(self.dicRemoveNull(item))
                }
                
                let todayData = self.dicRemoveNull(result["retData"]!["today"] as! Dictionary<String, AnyObject>)
                self.arrWeather.append(todayData)
                
                for item in result["retData"]!["forecast"] as! [Dictionary<String, AnyObject>] {
                    self.arrWeather.append(self.dicRemoveNull(item))
                }
                
                // 天气指数 数据
                for item in result["retData"]!["today"]!!["index"] as! [Dictionary<String, String>] {
                    self.arrToday.append(self.dicRemoveNull(item))
                }
                
                // 存储数据到本机
                userDefault.setObject(self.arrWeather, forKey: "arrWeather")
                userDefault.setObject(self.arrToday, forKey: "arrToday")
                userDefault.setObject(todayData, forKey: "today")
                
                self.setData()
                self.refreshControl.endRefreshing()
            }
            else {
                // 没拿到数据 用之前存的数据 setData
                if (userDefault.objectForKey("arrWeather") != nil) {
                    self.arrWeather = userDefault.objectForKey("arrWeather") as! [Dictionary<String, AnyObject>]
                    self.arrToday = userDefault.objectForKey("arrToday") as! [Dictionary<String, AnyObject>]
                    self.setData()
                }
            }
        }
    }
    
    // 去掉 null
    func dicRemoveNull(item: Dictionary<String, AnyObject>) -> Dictionary<String, AnyObject> {
        var newItem = item
        if ((newItem["aqi"]?.isKindOfClass(NSNull)) != nil) {
            newItem["aqi"] = ""
        }
        return newItem
    }
    
    func initView() -> Void {
        for i in 0...11 {
            let viewWeather = UIView.init()
            if i < 7 {
                viewWeather.backgroundColor = RGBColor(r: 255, g: 222, b: 175)
            }
            else if i == 7 {
                viewWeather.backgroundColor = RGBColor(r: 148, g: 229, b: 255)
            }
            else if i > 7 {
                viewWeather.backgroundColor = RGBColor(r: 189, g: 213, b: 255)
            }
            self.scrWeather.addSubview(viewWeather) // 加到滚动里面
            viewWeather.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(10 + i * (weatherLength + 10))
                make.width.equalTo(weatherLength)
                make.top.equalTo(self.scrWeather).offset(3)
                make.height.equalTo(self.scrWeather)
                make.bottom.equalTo(self.scrWeather).offset(3)
                if i == 11 {
                    make.right.equalTo(-10)
                }
            })
            
            let labDate = UILabel.init()
            labDate.tag = 1000 + i;
            labDate.textColor = UIColor.blackColor()
            labDate.textAlignment = NSTextAlignment.Center // 居中
            viewWeather.addSubview(labDate)
            labDate.snp_makeConstraints(closure: { (make) in
                make.left.top.right.equalTo(viewWeather)
                make.height.equalTo(20)
            })
            
            let imgWeather = UIImageView.init()
            imgWeather.tag = 1500 + i;
            viewWeather.addSubview(imgWeather)
            imgWeather.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(labDate.snp_bottom).offset(10)
                make.width.height.equalTo(weatherLength - 20)
                make.centerX.equalTo(labDate)
            })
            
            let labWeather = UILabel.init()
            labWeather.tag = 1100 + i;
            labWeather.textColor = UIColor.blackColor()
            labWeather.textAlignment = NSTextAlignment.Center
            viewWeather.addSubview(labWeather)
            labWeather.snp_makeConstraints(closure: { (make) in
                make.left.right.equalTo(viewWeather)
                make.top.equalTo(labDate.snp_bottom).offset(weatherLength)
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
        self.scrWeather.layoutSubviews()
        self.scrWeather.setContentOffset(CGPoint.init(x: 6 * (weatherLength + 10), y: 0), animated: false) // 初始位置
    }
    
    func setData() -> Void {
        for i in 0...11 {
            let dicWeather = self.arrWeather[i]
            
            let labDate = self.view.viewWithTag(1000 + i) as! UILabel
            labDate.text = dicWeather["date"] as? String
            
            let labWeather = self.view.viewWithTag(1100 + i) as! UILabel
            labWeather.text = dicWeather["type"] as? String
            
            let labTemp = self.view.viewWithTag(1200 + i) as! UILabel
            labTemp.text = String(format:"%@/%@", dicWeather["hightemp"] as! String, dicWeather["lowtemp"] as! String)
            
            let labWind = self.view.viewWithTag(1300 + i) as! UILabel
            labWind.text = dicWeather["fengxiang"] as? String
            
            let labWindNum = self.view.viewWithTag(1400 + i) as! UILabel
            labWindNum.text = dicWeather["fengli"] as? String
            
            let imgWeather = self.view.viewWithTag(1500 + i) as! UIImageView
            switch dicWeather["type"] as! String {
            case "晴":
                imgWeather.image = UIImage.init(named: "sun")
            case "多云":
                imgWeather.image = UIImage.init(named: "cloudy_sunny")
            case "阴":
                imgWeather.image = UIImage.init(named: "cloud")
            case "小雨":
                imgWeather.image = UIImage.init(named: "rain")
            case "中雨":
                imgWeather.image = UIImage.init(named: "rain")
            case "大雨":
                imgWeather.image = UIImage.init(named: "rain")
            case "雪":
                imgWeather.image = UIImage.init(named: "snow")
            case "霾":
                imgWeather.image = UIImage.init(named: "fog")
            case "雾":
                imgWeather.image = UIImage.init(named: "fog")
            default:
                imgWeather.image = UIImage.init(named: "sun")
            }
        }
        table.reloadData()
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
            
            let alert = UIAlertController.init(title: "选择分享方式", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let friend = UIAlertAction.init(title: "发送给朋友", style: .Default) { aaa in
                self.sendText(str, inScene: WXSceneSession)
            }
            let timeline = UIAlertAction.init(title: "分享到朋友圈", style: .Default) { aaa in
                self.sendText(str, inScene: WXSceneTimeline)
            }
            let cancel = UIAlertAction.init(title: "取消", style: .Cancel, handler: nil)
            alert.addAction(friend)
            alert.addAction(timeline)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    // 分享到微信
    func sendText(text:String, inScene: WXScene)->Bool{
        let req = SendMessageToWXReq()
        req.bText = true
        
        req.text = text // 分享的文本
        req.scene = Int32(inScene.rawValue) // 分享的场景 好友\朋友圈
        
        return WXApi.sendReq(req)
    }
    
    // MARK: - table
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrToday.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! HomeTableViewCell
        cell.dicData = arrToday[indexPath.row]
        cell.setData()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        self.performSegueWithIdentifier("indexDetail", sender: indexPath)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "indexDetail" {
            let destinationController = segue.destinationViewController as! IndexDetailViewController
            destinationController.dicData = arrToday[sender!.row]
        }
    }
    
}

