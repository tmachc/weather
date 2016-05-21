//
//  HomeTableViewCell.swift
//  weather
//
//  Created by 韩冲 on 16/5/19.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var dicData = Dictionary<String, AnyObject>()
    
    func setData() {
        textLabel!.text = (dicData["name"]! as! String) + ":"
        if dicData["index"]! as! String == "" {
            detailTextLabel!.text = "暂无"
        }
        else {
            detailTextLabel!.text = dicData["index"]! as? String
        }

    }
}
