//
//  LogWindow.swift
//  ATDebug
//
//  Created by 凯文马 on 2017/11/27.
//

import UIKit
import ATUIKit
import ATFoundation

 class LogWindow: UIWindow {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight * 0.5))
        let rootVc = UIViewController.init()
        rootVc.view.frame = self.bounds
        self.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.windowLevel = UIWindowLevelDebug
        self.rootViewController = rootVc
        self.textarea.font = FitFont(ofSize: 12)
        self.textarea.textColor = UIColor.white.withAlphaComponent(0.6)
        self.textarea.frame = rootVc.view.bounds
        self.textarea.backgroundColor = UIColor.clear
        rootVc.view.addSubview(self.textarea)
        self.isUserInteractionEnabled = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func window() -> LogWindow {
        let window = LogWindow.init(frame: CGRect.zero)
        return window
    }
    
    var showLog : Bool = false {
        didSet {
            if showLog {
                self.isHidden = false
                makeKeyAndVisible()
                resignKey()
                LogManager.shared.delegate = self
            } else {
                LogManager.shared.delegate = nil
                self.isHidden = true
            }
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return false
    }
    
    private func getCurrentTime() -> String {
        return dateFormatter.string(from: Date.init())
    }
    
    private let textarea = UITextView.init()
    
    private lazy var dateFormatter = { ()-> DateFormatter in
        let formatter = DateFormatter.init()
        formatter.dateFormat = "[HH:mm:ss]"
        return formatter
    }()
}

extension LogWindow : LogManagerDelegate {
    public func logManager(_ logManager: LogManager, didReceiveLog log: String) {
        var text = self.textarea.text ?? ""
        text += (getCurrentTime() + log + "\n")
        self.textarea.text = text
        let offsetY = self.textarea.contentSize.height - self.textarea.height
        if offsetY > 0 {
            self.textarea.setContentOffset( CGPoint.init(x: 0, y: offsetY), animated: true)
        }
    }
}
