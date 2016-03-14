//
//  HttpManager.swift
//  weather
//
//  Created by tmachc on 16/3/14.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import Foundation
import Alamofire

class HttpManager {
    static let defaultManager = HttpManager()
    private init() {} //This prevents others from using the default '()' initializer for this class.
    
//    func networkStatus() -> NetworkReachabilityManager {
//        return NetworkReachabilityManager.NetworkReachabilityStatus
//    }
    
//    func getRequestToUrl(url: String, params: Dictionary, complete:(Void (^)Dictionary{})) {
//        
//    }
}
