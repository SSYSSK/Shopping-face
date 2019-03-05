//
//  TEEProductSessionHeadView.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/28.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit

class TEEProductSessionHeadView: UIView {

    @IBOutlet weak var lineView: UIView!
    
    @IBAction func btn1(_ sender: Any) {
        setLineViewFrame(btn: sender as! UIButton)
    }
    
    @IBAction func btn2(_ sender: Any) {
        setLineViewFrame(btn: sender as! UIButton)
    }
    
    @IBAction func btn3(_ sender: Any) {
        setLineViewFrame(btn: sender as! UIButton)
    }
    
    func setLineViewFrame(btn: UIButton) {
        UIView.animate(withDuration: 0.3) {
            self.lineView.frame = CGRect(x: btn.x, y: self.height - 0.5, width: btn.width, height: 0.5)
        }
    }
}
