//
//  SSTInputAccessoryView.swift
//  sst-ios
//
//  Created by Zal Zhang on 7/7/17.
//  Copyright © 2017 ios. All rights reserved.
//

import UIKit

class ABCInputAccessoryView: UIView {

    var buttonClick: (() -> Void)?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 50))
        
        self.backgroundColor = UIColor.colorWithCustom(210, g: 211, b: 217)
        
        let doneButton = UIButton(frame: CGRect(x:kScreenWidth - 80, y:0, width:80, height: 50))
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(UIColor.darkText, for: .normal)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        doneButton.addTarget(self, action: #selector(clickedKeyboardDoneButton), for: .touchUpInside)
        
        self.addSubview(doneButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func clickedKeyboardDoneButton(sender: UIButton) {
        self.buttonClick?()
    }

}
