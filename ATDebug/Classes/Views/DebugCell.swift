//
//  DebugCell.swift
//  ATDebug
//
//  Created by 凯文马 on 2017/11/27.
//

import UIKit
import ATUIKit

final class DebugCell: TableViewCell {

    private let titleLabel = UILabel.init()
    
    private let descLabel = UILabel.init()
    
    private let valueLabel = UILabel.init()
    
    private let valueSwitch = UISwitch.init()
    
    private var action : DebugAction?
    
    private var value : DebugValue? {
        didSet {
            switch value! {
            case .stringValue(let value):
                valueSwitch.isHidden = true
                valueLabel.text = value
                valueLabel.isHidden = false
                break
            case .switchValue(let isOn):
                valueSwitch.isHidden = false
                valueSwitch.setOn(isOn, animated: true)
                valueLabel.isHidden = true
                break
            }
        }
    }

    override func bindData(_ data: Any?) {
        guard let debug = data as? DebugModel else { return }
        titleLabel.text = debug.title
        descLabel.text = debug.desc
        value = debug.value()
        action = debug.action
    }
    
    override func setupView() {
        selectionStyle = .none
        
        titleLabel.font = FitFont(ofSize: 14, bold: true)
        titleLabel.textColor = UIColor.init(hex: 0xFF8C00)
        contentView.addSubview(titleLabel)
        
        descLabel.font = FitFont(ofSize: 12, bold: false)
        descLabel.textColor = UIColor.gray
        contentView.addSubview(descLabel)
        
        valueLabel.font = FitFont(ofSize: 12, bold: false)
        valueLabel.textColor = UIColor.darkGray
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
        
        contentView.addSubview(valueSwitch)
        valueSwitch.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        valueSwitch.isUserInteractionEnabled = false

        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tap)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
        titleLabel.left = 15.fit6
        titleLabel.top = 5.fit6
        
        descLabel.sizeToFit()
        descLabel.frame = CGRect.init(x: 15.fit6, y: 0, width: 200.fit6, height: descLabel.height)
        descLabel.bottom = height - 5.fit6
        
        valueLabel.frame = CGRect.init(x: 0, y: 0, width: width - 15.fit6, height: height)
        valueSwitch.sizeToFit()
        valueSwitch.centerY = height * 0.5
        valueSwitch.right = width - 15.fit6 + valueSwitch.width * 0.5
    }
    
    open override class func height(_ data:Any? = nil) -> CGFloat {
        return 54.fit6
    }

    @objc private func tapAction() {
        action?({
            self.tableView?.reloadData()
        })
    }
}
