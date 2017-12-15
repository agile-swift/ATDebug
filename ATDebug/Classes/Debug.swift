//
//  Debug.swift
//  Pods
//
//  Created by 凯文马 on 2017/11/22.
//

import UIKit
import ATFoundation
import ATUIKit

public final class DebugManager {
    
    public static let shared = DebugManager()
    
    public var performanceShow = false
    
    public func enableDebug() {
        _enableDebug = true
    }
    
    public func disableDebug() {
        _enableDebug = false
    }
    
    public func registerItemWithTitle(_ title:String,value:@escaping ValueAction = { return DebugValue.stringValue("") },desc:String?,action : @escaping DebugAction) {
        let debug = DebugModel.init(title: title, value: value, desc: desc ?? "", action: action)
        registerItems.append(debug)
    }
    
    var logWindow = LogWindow.window()
    
    // MARK: private
    private let window = DebugWindow.window()
    
    private var _enableDebug : Bool = false {
        didSet {
            let appWindow = UIApplication.shared.delegate?.window
            if appWindow == nil || !(appWindow!!.isKeyWindow) { return }
            window.enableDebug = _enableDebug
        }
    }
    
    var registerItems : [DebugModel] = []
    
    private init() {
        window.delegate = self
    }
}

extension DebugManager : DebugWindowDelegate {
    func debugWindow(_ window: DebugWindow, didFinishClickWithTimes times: Int) {
        guard let nav = NavigationController.current,
            let current = nav.topViewController,
            !(current is DebugViewController) else {
                return
        }
        NavigationController.current?.pushViewController(DebugViewController(), animated: true)
    }
}


