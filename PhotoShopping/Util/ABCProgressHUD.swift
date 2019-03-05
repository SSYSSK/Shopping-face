//
//  SSTProgressHUD.swift
//  sst-ios
//
//  Created by MuChao Ke on 16/10/19.
//  Copyright © 2016年 SST. All rights reserved.
//

import UIKit
import SVProgressHUD

class ABCProgressHUD {
    
    static func show() {
//        SVProgressHUD.show()
    }
    
    static func dismiss() {
//        SVProgressHUD.dismiss(withDelay: 1)
    }
    
    static func showInfoWithStatus(string:String) {
        SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
        SVProgressHUD.showInfo(withStatus: string)
    }
    static func showSuccessWithStatus(string:String) {
        SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
        SVProgressHUD.showSuccess(withStatus: string)
    }
    static func showErrorWithStatus(string:String) {
        SVProgressHUD.setImageViewSize(CGSize(width: 28, height: 28))
        SVProgressHUD.showError(withStatus: string)
    }
    static func showImage(image:UIImage, status:String) {
        SVProgressHUD.setImageViewSize(CGSize(width: 70, height: 70))
        SVProgressHUD.show(animatedImageWithImages(), status: status)
    }
    
    private static func animatedImageWithImages()-> UIImage {
        var images = [UIImage]()
        for i in 1 ... 4 {
            let imageName = "loading000\(i)"
            images.append(UIImage(named: imageName)!)
        }
        let animatedImage = UIImage.animatedImage(with: images, duration: 0.7)
        return animatedImage!
    }
   
}
