//
//  Common.swift
//  ClassSignInSwift
//
//  Created by tmachc on 16/3/15.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import Foundation

/* 接口地址 */
let HttpUrl_getWeather = "http://apis.baidu.com/apistore/weatherservice/recentweathers?"
let HttpUrl_getCityList = "http://apis.baidu.com/apistore/weatherservice/citylist?"

/* apiKey */
let HttpHeader = ["apikey": "ab66b69af4de223187dcc22167846c2e"]

/* 城市名 */
var CityName = "北京"
var DistrictName = "北京"

/* 城市id */
var CityId = "101010100"
let ChaoyangId = "101010300"

/* 用于储存信息 Dictionary */
let userDefault = NSUserDefaults.standardUserDefaults()

let WINDOW_WIDTH = UIScreen.mainScreen().bounds.size.width
let WINDOW_HIGHT = UIScreen.mainScreen().bounds.size.height

func RGBColor(r r:Int, g:Int, b:Int) -> UIColor {
    return UIColor.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1)
}
