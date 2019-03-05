//
//  ABCAlertContentView.swift
//  ABCTime
//
//  Created by 柯木超 on 2018/4/17.
//  Copyright © 2018年 Macoro. All rights reserved.
//

import UIKit

class ABCAlertContentView: UIView {
    var buttonClick: (() -> Void)?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func enterAction(_ sender: Any) {
        self.buttonClick?()
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.buttonClick?()
    }
}
