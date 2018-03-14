//
//  DebugWindow.swift
//  ATDebug
//
//  Created by 凯文马 on 2017/11/24.
//

import UIKit
import ATUIKit

let UIWindowLevelDebug : UIWindowLevel = UIWindowLevelStatusBar + 500

protocol DebugWindowDelegate : class {
    func debugWindow(_ window:DebugWindow,didFinishClickWithTimes times:Int)
}

class DebugWindow: UIWindow {

    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: StatusBarHeight))
        let rootVc = UIViewController.init()
        rootVc.view.frame = self.bounds
        self.windowLevel = UIWindowLevelDebug
        self.rootViewController = rootVc
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func window() -> DebugWindow {
        let window = DebugWindow.init(frame: CGRect.zero)
        return window
    }
    
    var needTimes : Int = 4
    
    weak var delegate : DebugWindowDelegate?
    
    var enableDebug : Bool = false {
        didSet {
            if enableDebug {
                self.isHidden = false
            } else {
                self.isHidden = true
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return false
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if super.hitTest(point, with: event) == self.rootViewController?.view {
            clickAction()
        }
        let keyWindow = UIApplication.shared.delegate?.window
        return keyWindow??.hitTest(point, with: event)
    }
    
    private func clickAction() {
        let time = getCurrentInterval()
        if time - _lastTimeInterval < 300 {
            _clickTimes = 1 + _clickTimes
        } else {
            _clickTimes = 1
        }
        _lastTimeInterval = time
        if (needTimes * 2 == _clickTimes) {
            _clickTimes = 1
            self.delegate?.debugWindow(self, didFinishClickWithTimes: needTimes)
        }
    }
    
    private func getCurrentInterval() -> TimeInterval {
        return Date.init().timeIntervalSinceReferenceDate * 1000
    }
    
    private var _lastTimeInterval : TimeInterval = 0
    private var _clickTimes : Int = 0
    
    
}
