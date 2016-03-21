//
//  ViewController.swift
//  weather
//
//  Created by tmachc on 16/3/14.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        HttpManager.defaultManager.getRequest(url: "http://apis.baidu.com/apistore/weatherservice/recentweathers?",
            params: ["cityname": "北京", "cityid": "101010100"],
            headers: ["apikey": "ab66b69af4de223187dcc22167846c2e"])
            { (result) -> Void in
                if result["errNum"]!.isEqual("0") {
                    let jsonData = try! NSJSONSerialization.dataWithJSONObject(result, options: NSJSONWritingOptions.PrettyPrinted) as NSData!
                    let str = NSString.init(data: jsonData, encoding: NSUTF8StringEncoding)!
                    self.textView.text = str as String
                }
                else {
                    
                }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

