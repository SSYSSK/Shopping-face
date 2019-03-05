//
//  ToastUtil.swift
//  sst-ios-po
//
//  Created by Zal Zhang on 12/27/16.
//  Copyright © 2016 po. All rights reserved.
//

import UIKit

class ToastUtil: NSObject {
    
    static func showToast(_ msg: String, duration: Double = 3.5) {
        
        guard msg.trim().isNotEmpty else {
            return
        }
        
        let vcView: UIView! = getCurrentVCBS().view
        guard vcView != nil else {
            return
        }
        
        let msgLabel = UILabel()
        msgLabel.numberOfLines = 0
        msgLabel.font = UIFont.systemFont(ofSize: 13)
        msgLabel.lineBreakMode = .byWordWrapping
        msgLabel.textAlignment = .center
        msgLabel.textColor = UIColor.white
        msgLabel.alpha = 0.9
        msgLabel.text = msg
        
        let maxSize = CGSize(width: vcView.bounds.size.width * 0.8, height: vcView.bounds.size.height * 0.8)
        let expectedSize = msg.sizeByWidth(font: 13, width: maxSize.width)
        msgLabel.frame = CGRect(x: (kScreenWidth * 0.8 - expectedSize.width) / 2, y: 10, width: expectedSize.width, height: expectedSize.height)
        
        let containerV = UIView(frame: CGRect(x: vcView.bounds.size.width * 0.2 / 2, y: vcView.bounds.height - 130 - expectedSize.height, width: kScreenWidth * 0.8, height: expectedSize.height + 23))
        containerV.backgroundColor = UIColor.darkGray
        containerV.layer.cornerRadius = 5
        containerV.addSubview(msgLabel)
        
        vcView.addSubview(containerV)
        
        UIView.animate(withDuration: 0.3, delay: TimeInterval(expectedSize.height/10), options: UIView.AnimationOptions.allowAnimatedContent, animations: {
            containerV.alpha = 0.1
        }) { (Bool) in
            containerV.removeFromSuperview()
        }
    }
}
