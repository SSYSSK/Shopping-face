//
//  UIViewExt.swift
//  sst-ios
//
//  Created by Amy on 2017/1/17.
//  Copyright © 2017年 ios. All rights reserved.
//
import UIKit

extension UIView {

    // 截图
    func screenShot() -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
            
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /// X值
    var x: CGFloat {
        return self.frame.origin.x
    }
    
    /// Y值
    var y: CGFloat {
        return self.frame.origin.y
    }
    
    /// 宽度
    var width: CGFloat {
        return self.frame.size.width
    }
    
    ///高度
    var height: CGFloat {
        return self.frame.size.height
    }
    
    var size: CGSize {
        return self.frame.size
    }
    
    var point: CGPoint {
        return self.frame.origin
    }
    
    var absoluteX: CGFloat {
        get {
            var rX: CGFloat = self.x
            var vw: UIView? = self
            while vw?.superview != nil {
                rX += validCGFloat(vw?.superview?.x)
                vw = vw?.superview
            }
            return rX
        }
    }
    
    var absoluteY: CGFloat {
        get {
            var rY: CGFloat = self.y
            var vw: UIView? = self
            while vw?.superview != nil {
                rY += validCGFloat(vw?.superview?.y)
                vw = vw?.superview
            }
            return rY
        }
    }
    
    func setLeft(_ x: CGFloat) {
        var frame = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    
    /*!
     设置圆角
     
     - parameter radius: 半径为空则圆形
     */
    func setRoundRadius(_ radius:CGFloat? = nil) {
        let r = radius ?? min(self.frame.size.width,self.frame.size.height) / 2
        self.layer.cornerRadius = r
        self.clipsToBounds = true
    }
    
    func setBorder(color:UIColor,width:CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
}
