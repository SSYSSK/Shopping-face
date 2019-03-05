//
//  TEEDatePickerView.swift
//  TEEFit
//
//  Created by 柯木超 on 2018/11/8.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit

class TEEDatePickerView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dataPickerView: UIDatePicker!
    var picketViewClick:((_ str:String) -> Void)?
    var str = ""
    override func awakeFromNib() {
        dataPickerView.addTarget(self, action: #selector(datePickerChange), for: .valueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddlenView))
        bgView.isUserInteractionEnabled = true
        bgView.addGestureRecognizer(tap)
        str = Date().formatYYYYMMDD()
        dataPickerView.setDate(Date(), animated: true)
    }
    
    @objc func hiddlenView() {
        picketViewClick?(str)
        
        self.removeFromSuperview()
    }
    
    @objc func datePickerChange(paramDatePicker: UIDatePicker) {
        str = paramDatePicker.date.formatYYYYMMDD()
        printX(paramDatePicker.date.formatYYYYMMDD())
    }
}

