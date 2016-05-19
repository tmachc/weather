//
//  HomeTableViewCell.swift
//  weather
//
//  Created by 韩冲 on 16/5/19.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    var dicData = Dictionary<String, String>()
    
    @IBOutlet var labName: UILabel!
    @IBOutlet var labValue: UILabel!
    
    func setData() {
        labName.text = dicData["name"]! + ":"
        if dicData["index"]! == "" {
            labValue.text = "暂无"
        }
        else {
            labValue.text = dicData["index"]!
        }
    }
}
