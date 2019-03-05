//
//  TEEPicketView.swift
//  TEEFit
//
//  Created by 柯木超 on 2018/11/8.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit

class TEEPicketView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var picketView: UIPickerView!
    @IBOutlet weak var bgVIEW: UIView!
    
    var picketViewClick:((_ str:String) -> Void)?
    
    var str = ""
    var data:[String]!{
        didSet{
            picketView.reloadAllComponents()
            str = validString(data.validObjectAtIndex(0))
            picketView.selectedRow(inComponent: 0)
        }
    }
    
    override func awakeFromNib() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hiddlenView))
        bgVIEW.isUserInteractionEnabled = true
        bgVIEW.addGestureRecognizer(tap)
    }
    
    @objc func hiddlenView() {
        picketViewClick?(str)
        self.removeFromSuperview()
    }
}

extension TEEPicketView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return validString(data.validObjectAtIndex(row))
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        printX(validString(data.validObjectAtIndex(row)))
        str = validString(data.validObjectAtIndex(row))
    }
}
