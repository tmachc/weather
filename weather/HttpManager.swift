//
//  HttpManager.swift
//  weather
//
//  Created by tmachc on 16/3/14.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit

class HttpManager: NSObject {
    static let defaultManager = HttpManager()
    private init() {} //This prevents others from using the default '()' initializer for this class.
}
