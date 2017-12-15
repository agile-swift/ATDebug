//
//  ViewController.swift
//  ATDebug
//
//  Created by devkevinma@gmail.com on 11/22/2017.
//  Copyright (c) 2017 devkevinma@gmail.com. All rights reserved.
//

import UIKit
import ATDebug

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view, typically from a nib.
        DebugManager.shared.registerItemWithTitle("自定义测试", desc: "你点一下试试") { (reload) -> (Void) in
            print("点就点了吧~")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

