//
//  IndexDetailViewController.swift
//  weather
//
//  Created by 韩冲 on 16/5/21.
//  Copyright © 2016年 tmachc. All rights reserved.
//

import UIKit

class IndexDetailViewController: UIViewController {

    @IBOutlet var labName: UILabel!
    @IBOutlet var labValue: UILabel!
    @IBOutlet var tvDetail: UITextView!
    
    var dicData = Dictionary<String, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labName.text = dicData["name"] as? String
        labValue.text = dicData["index"] as? String
        tvDetail.text = dicData["details"] as! String
        tvDetail.font = UIFont.systemFontOfSize(20)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}
