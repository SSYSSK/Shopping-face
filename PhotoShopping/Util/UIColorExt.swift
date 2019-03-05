//
//  UIColorExt.swift
//  sst-ios
//
//  Created by Zal Zhang on 1/13/17.
//  Copyright © 2017 ios. All rights reserved.
//

import UIKit

//let systemColor = UIColor(red: 142/255.0, green: 144/255.0, blue: 243/255.0, alpha: 1)

extension UIColor {
    
    class func setAppFontColor_Blue() -> UIColor {
        return UIColor(red: 69 / 255.0, green: 132 / 255.0, blue: 244 / 255.0, alpha: 1)
    }
    
    class func colorWithCustom(_ r: CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return UIColor.colorWithCustom(r, g: g, b: b)
    }
    
    class func hexStringToColor(_ hexString: String) -> UIColor {
        
        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("0X") {
            cString = cString.sub(start: 2, end: cString.count)
        }
        if cString.hasPrefix("#") {
            cString = cString.sub(start: 1, end: cString.count)
        }
        if cString.count != 6 {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
}
