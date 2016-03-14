//
//  ViewController.swift
//  weather
//
//  Created by tmachc on 16/3/14.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit
import Alamofire
import HttpManager

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        var url = "http://apis.baidu.com/apistore/weatherservice/recentweathers"
//        var httpArg = "cityname=%E5%8C%97%E4%BA%AC&cityid=101010100"
//        request(url, httpArg: httpArg)
//        func  request(httpUrl: String, httpArg: String) {
//            var req = NSMutableURLRequest(URL: NSURL(string: httpUrl + "?" + httpArg)!)
//            req.timeoutInterval = 6
//            req.HTTPMethod = "GET"
//            req.addValue("ab66b69af4de223187dcc22167846c2e", forHTTPHeaderField: "apikey")
//            NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) {
//                (response, data, error) -> Void in
//                let res = response as! NSHTTPURLResponse
//                println(res.statusCode)
//                if let e = error{
//                    println("请求失败")
//                }
//                if let d = data {
//                    var content = NSString(data: d, encoding: NSUTF8StringEncoding)
//                    println(content)
//                }
//            }
//        }
        
//        Alamofire.request(.GET, "https://httpbin.org/get", parameters: ["foo": "bar"])
//            .responseJSON { response in
//                print(response.request)  // original URL request
//                print(response.response) // URL response
//                print(response.data)     // server data
//                print(response.result)   // result of response serialization
//                
//                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
//                }
//        }
        
//        let parameters = [
//            "cityname": "北京",
//            "cityid": "101010100"
//        ]
        Alamofire.request(
            .GET,
            "http://apis.baidu.com/apistore/weatherservice/recentweathers?cityname=%E5%8C%97%E4%BA%AC&cityid=101010100",
            parameters: nil,
            encoding: .JSON,
            headers: ["apikey": "ab66b69af4de223187dcc22167846c2e"]).responseJSON { response in
                print("1 --->>> ",response.request)  // original URL request
                print("2 --->>> ",response.response) // URL response
                print("3 --->>> ",response.data)     // server data
                print("4 --->>> ",response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                    let jsonData = try! NSJSONSerialization.dataWithJSONObject(JSON, options: NSJSONWritingOptions.PrettyPrinted) as NSData!
                    let str = NSString.init(data: jsonData, encoding: NSUTF8StringEncoding)!
                    self.textView.text = str as String
                }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

