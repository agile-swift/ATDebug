//
//  DebugViewController.swift
//  ATDebug
//
//  Created by 凯文马 on 2017/11/24.
//

import UIKit
import ATUIKit
import ATRequest
import ATFoundation
import GDPerformanceView_Swift

public enum DebugValue {
    case switchValue(Bool)
    case stringValue(String)
}

class DebugViewController: ViewController {

    func registerItemWithTitle(_ title:String,value:@escaping ValueAction = { return DebugValue.stringValue("") },desc:String?,action : @escaping DebugAction) {
        let debug = DebugModel.init(title: title, value: value, desc: desc ?? "", action: action)
        datas.append(debug)
    }
    
    private var datas : [DebugModel] = []
    
    private var customerDatas : [DebugModel] {
        get {
            return DebugManager.shared.registerItems
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "调试选项"
        addCell()
        self.view.addSubview(tableView)
    }
    
    private func addCell() {
        
        registerItemWithTitle("网络环境", value: { () -> (DebugValue) in
            return .stringValue(RequestConfig.environmentDesc)
        }, desc: "点击选择网络环境") { (reload) -> (Void) in
            let alert = UIAlertController.init(title: "切换网络环境", message: nil, preferredStyle: .actionSheet)
            var dict : [String : RequestEnvironment] = [:]
            for idx in 0..<4 {
                let env = RequestEnvironment.init(rawValue: idx)
                if env == nil{ continue }
                let desc = env!.desc
                dict[desc] = env!
                let act = UIAlertAction.init(title: desc, style: .default, handler: { (action) in
                    let en = dict[action.title!]
                    RequestConfig.environment = en ?? .release
                    reload()
                })
                if RequestConfig.environment.rawValue == env!.rawValue {
                    act.isEnabled = false
                }
                alert.addAction(act)
                
            }
            alert.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
            NavigationController.current?.present(alert, animated: true, completion: nil)
        }

        registerItemWithTitle("日志输出", value: { () -> (DebugValue) in
            return .switchValue(LogManager.shared.logEnable)
        }, desc: "ATFoundation中logger函数输出") { (reload) -> (Void) in
            LogManager.shared.logEnable ? LogManager.shared.disableLog() : LogManager.shared.enbaleLog()
            reload()
        }
        
        registerItemWithTitle("日志窗口", value: { () -> (DebugValue) in
            return .switchValue(DebugManager.shared.logWindow.showLog)
        }, desc: "是否在屏幕上显示日志") { (reload) -> (Void) in
            if DebugManager.shared.logWindow.showLog {
                DebugManager.shared.logWindow.showLog = false
            } else {
                DebugManager.shared.logWindow.showLog = true
            }
            reload()
        }
        
        registerItemWithTitle("性能测试", value: { () -> (DebugValue) in
            return .switchValue(DebugManager.shared.performanceShow)
        }, desc: "点击开启关闭性能测试") { (reload) -> (Void) in
            if DebugManager.shared.performanceShow {
                DebugManager.shared.performanceShow = false
                GDPerformanceMonitor.sharedInstance.stopMonitoring()
            } else {
                DebugManager.shared.performanceShow = true
                GDPerformanceMonitor.sharedInstance.startMonitoring()
                GDPerformanceMonitor.sharedInstance.appVersionHidden = true
                GDPerformanceMonitor.sharedInstance.deviceVersionHidden = true
            }
            reload()
        }
        
        registerItemWithTitle("应用信息", value: { () -> (DebugValue) in
            return .stringValue("\(App.deviceName) V\(App.systemVersion)")
        }, desc: "\(App.appName) version:\(App.appVersion) build:\(App.appDetailVersion)") { (_) -> (Void) in
            
        }
    }
    
    private lazy var tableView : UITableView = {
        let tv = UITableView.init(frame: ScreenBounds)
        let margin = NavigationBarHeight
        tv.top = margin
        tv.height -= margin
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
}

extension DebugViewController : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return customerDatas.count > 0 ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? datas.count : customerDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return DebugCell.cellWithTableView(tableView, bindData: datas[indexPath.row])
        } else {
            return DebugCell.cellWithTableView(tableView, bindData: customerDatas[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return DebugCell.height()
    }
}
