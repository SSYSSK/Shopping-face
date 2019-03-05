//
//  UIFont.swift
//  sst-ios
//
//  Created by Amy on 2017/1/17.
//  Copyright © 2017年 ios. All rights reserved.
//

import UIKit

//MARK:UIFont
enum ABCtimeFontName: String{
//    case FZLanTingYuanRegular  = "FZLANTY_JW--GB1-0" // 方正兰亭圆 FZLanTingYuanS-R-GB/FZLANTY_JW--GB1-0
//    case FZLanTingYuanZhun     = "FZLANTY_ZHUNJW--GB1-0" // 方正兰亭圆 FZLanTingYuanS-M-GB/FZLANTY_JW--GB1-0
    case FZLanTingYuanZhun        =  "FZLANTY_ZHUNJW--GB1-0" //方正兰亭圆 准
    //case FZLanTingYuanRegular     =  "FZLANTY_JW--GB1-0" // 方正兰亭圆-Regular
    case PingFangTC               = "PingFang TC"
    case PingFangSC               = "PingFang SC"
    case PingFangHK               = "PingFang HK"

}

extension UIFont {
    func sizeOfString (string: String, constrainedToWidth width: Double) -> CGSize {
        return (string as NSString).boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                                         options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                         attributes: [NSAttributedString.Key.font: self],
                                                         context: nil).size
    }
    
    class func customFontWithName(name:ABCtimeFontName,size:CGFloat) -> UIFont{
        return UIFont(name: name.rawValue, size:size) ?? UIFont.systemFont(ofSize: size)
    }
    
    class func customFontWithName(name:ABCtimeFontName,size:Double) -> UIFont{
        return UIFont(name: name.rawValue, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size))
    }
    
    class func customFontWithName(name:ABCtimeFontName,size:Int) -> UIFont{
        return UIFont(name: name.rawValue, size: CGFloat(size)) ?? UIFont.systemFont(ofSize: CGFloat(size))
    }
    
//    // 根据手机型号 适配字体大小
//    class func customFitFontWithName(name:ABCtimeFontName,size:CGFloat) -> UIFont{
//        let abcSize = size * abcFontScale
//        return UIFont(name: name.rawValue, size:abcSize) ?? UIFont.systemFont(ofSize: abcSize)
//    }
}
