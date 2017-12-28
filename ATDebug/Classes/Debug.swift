//
//  Debug.swift
//  Pods
//
//  Created by 凯文马 on 2017/11/22.
//

import UIKit
import ATFoundation
import ATUIKit

/// 调试管理类
public final class DebugManager {
    
    /// 单例对象
    public static let shared = DebugManager()
    
    /// 开启调试选项，应该在window加载之后调用该方法
    public func enableDebug() {
        _enableDebug = true
    }
    
    /// 禁用调试选项
    public func disableDebug() {
        _enableDebug = false
    }
    
    /// 注册自定义功能到调试选项
    public func registerItemWithTitle(_ title:String,value:@escaping ValueAction = { return DebugValue.stringValue("") },desc:String?,action : @escaping DebugAction) {
        let debug = DebugModel.init(title: title, value: value, desc: desc ?? "", action: action)
        registerItems.append(debug)
    }
    
    
    // MARK: private
    var performanceShow = false

    var logWindow = LogWindow.window()
    
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


