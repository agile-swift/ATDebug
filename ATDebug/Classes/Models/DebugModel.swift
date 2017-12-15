//
//  DebugModel.swift
//  ATDebug
//
//  Created by 凯文马 on 2017/11/27.
//

import UIKit

public typealias DebugAction = (@escaping ()->())->(Void)
public typealias ValueAction = ()->(DebugValue)

class DebugModel: NSObject {
    var title : String
    var desc : String
    var value : ValueAction
    var action : DebugAction?
    
    init(title:String,value:@escaping ValueAction,desc:String,action:DebugAction?) {
        self.title = title
        self.desc = desc
        self.value = value
        self.action = action
    }
    
}
