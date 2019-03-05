//
//  TEETableHeadView.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/28.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit

class TEETableHeadView: UIView {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        
        bgView.layer.cornerRadius = 12
        bgView.layer.shadowColor = UIColor.gray.cgColor
        bgView.layer.shadowOpacity = 1.0
        bgView.layer.shadowOffset = CGSize(width: 4, height: 4)
        bgView.layer.shadowRadius = 4
        bgView.layer.masksToBounds = false
       
    }
}

