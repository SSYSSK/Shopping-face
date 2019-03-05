 //
//  StringUtil.swift
//  sst-ios-po
//
//  Created by Zal Zhang on 12/28/16.
//  Copyright © 2016 po. All rights reserved.
//

import UIKit
import Foundation
import CommonCrypto
 
extension String {
    
    func matchRegex(pattern: String) -> Bool {
        if self.trim().count == 0 {
            return false
        }
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [pattern])
        return predicate.evaluate(with: self.trim())
    }
    
    var isValidEmail: Bool {
        return matchRegex(pattern:"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}")
    }
    
    var isValidPassword: Bool {
        return matchRegex(pattern:"[A-Z0-9a-z._%+-]{1,20}")
    }
    
    var isValidCharacter: Bool {
        return matchRegex(pattern:"[A-Za-z]")
    }
    
    var isValidMoney: Bool {
        return matchRegex(pattern: "^([1-9]\\d*|0)(\\.\\d{0,2})?$")
    }

    var isTwoDecimal: Bool {
        return matchRegex(pattern: "^[0-9]+(.[0-9]{2})?$")
    }
    
    var URL: NSURL? {
        return NSURL(string: self)
    }
    
    var Base64: String {
        if let utf8EncodeData = self.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            return utf8EncodeData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        }
        return ""
    }

    var URLEncoded: String {
        return validString(self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed))
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    var isValidInteger: Bool {
        return matchRegex(pattern: "^[0-9]\\d*$")
    }
    
    var isValidZipForUS: Bool {
        return matchRegex(pattern: "[0-9]{5}")
    }
    
    var isValidZipForCanada: Bool {
        return self.replacingOccurrences(of: " ", with: "").matchRegex(pattern: "[0-9a-zA-Z]{6}")
    }
    
    var isValidNaturalNumber: Bool {
        return matchRegex(pattern: "^[0-9]*$")
    }
    
    var isValidPositiveInteger: Bool {
        return matchRegex(pattern: "^[1-9]\\d*$")
    }
    
    var isValidZipCode:Bool {
        return matchRegex(pattern: "[1-9]\\d{4}")
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func strikeThrough() -> NSMutableAttributedString {
        let attributedStr = NSMutableAttributedString(string: self)
        attributedStr.addAttributes([NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue], range: NSMakeRange(0, validInt(self.count)))
        return attributedStr
    }
    
    func toAttributedString(font: UIFont = UIFont.systemFont(ofSize: 13)) -> NSAttributedString {
        var attributedString = NSMutableAttributedString()
        if let stringData = "<div>\(self)</div>".replaceInvisibleCharatersWithSapce().data(using: String.Encoding.utf8) {
            let tAttr = stringData.toAttributedString()
            attributedString = tAttr.mutableCopy() as! NSMutableAttributedString
            attributedString.addAttributes([NSAttributedString.Key.font: font], range: NSMakeRange(0 , attributedString.length))
        }
        return attributedString
    }
    
    func sub(start: Int, end: Int) -> String {
        guard start >= 0 && start < self.count && start <= end else { return "" }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(self.startIndex, offsetBy: (end < self.count) ? end : self.count - 1 )
        return String(self[startIndex...endIndex])
    }
    
    func heightByWidthAndNewLine(font: NSInteger, width: CGFloat) -> CGFloat {
        var rHeight: CGFloat = 0
        let stirngs = self.components(separatedBy: "\n")
        for str in stirngs {
            rHeight += str.sizeByWidth(font: font, width: width).height + CGFloat(font)
        }
        return rHeight
    }
    
    func heightByWidth(font: NSInteger, width: CGFloat) -> CGFloat {
        return sizeByWidth(font: font, width: width).height
    }
    
    func sizeByWidth(font: NSInteger, width: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        return sizeByFont(font: UIFont.systemFont(ofSize: CGFloat(font)), maxWidth: width)
    }
    
    func getWidth(withHeight height:CGFloat,font:UIFont) -> CGSize {
        let attributionDic=[NSAttributedString.Key.font:font]
        let rect=self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributionDic, context: nil)
        return rect.size;
    }
    
    func getHeight(withWidth width:CGFloat,font:UIFont) -> CGSize {
        let attributionDic=[NSAttributedString.Key.font:font]
        let rect=self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributionDic, context: nil)
        return rect.size;
    }
    
    func sizeByFont(font: UIFont, maxWidth: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        let size = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attributes = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle.copy()]
        let rect = self.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: attributes, context:nil)
        return rect.size
    }
    
    func toUrl() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func toDictionary() -> Dictionary<String,AnyObject>? {
        if let tData = self.data(using: String.Encoding.unicode, allowLossyConversion: true) {
            let dict = try? JSONSerialization.jsonObject(with: tData, options:JSONSerialization.ReadingOptions.allowFragments)
            return dict as? Dictionary<String, AnyObject>
        }
        return nil
    }
    
    func replaceInvisibleCharatersWithSapce() -> String {
        let rString: NSMutableString = NSMutableString(string: self)
        let regex = try! NSRegularExpression(pattern: "(\\s){1,}", options: [])
        regex.replaceMatches(in: rString, options: [], range: NSMakeRange(0, rString.length), withTemplate: " ")
        return rString as String
    }
    
    // 直接给String扩展方法
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
        
    }
 
}

extension String {
    public var URLString: String {
        return self
    }
    
    func stringToStringDate()->String {
        let splitedArray = self.components(separatedBy: " ")
        
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let strNowTime = timeFormatter.string(from: date) as String
        if strNowTime == validString(splitedArray.first) {
            let splitedArray = validString(splitedArray.validObjectAtIndex(1)).components(separatedBy: ":")
            let str = "\(validString(splitedArray.validObjectAtIndex(0))):\(validString(splitedArray.validObjectAtIndex(1)))"
            return str
        }else {
            return validString(splitedArray.first)
        }
    }
    
    func sysstringToStringDate()->String {
        let splitedArray = self.components(separatedBy: " ")
        
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let strNowTime = timeFormatter.string(from: date) as String
        
        // 明天
        let yesterday = Date(timeInterval: 24*60*60, since: date)
        let yesterdayString = timeFormatter.string(from: yesterday) as String
        
        if strNowTime == validString(splitedArray.first) {
            let splitedArray = validString(splitedArray.validObjectAtIndex(1)).components(separatedBy: ":")
            let str = "今天 \(validString(splitedArray.validObjectAtIndex(0))):\(validString(splitedArray.validObjectAtIndex(1)))"
            return str
        }else if yesterdayString == validString(splitedArray.first) {
            let splitedArray = validString(splitedArray.validObjectAtIndex(1)).components(separatedBy: ":")
            let str = "明天 \(validString(splitedArray.validObjectAtIndex(0))):\(validString(splitedArray.validObjectAtIndex(1)))"
            return str
            
        }else if yesterdayString > validString(splitedArray.first) {  // 以前的时间
            return validString(splitedArray.validObjectAtIndex(0))
        }else {
            if let date = datefromString(validString(splitedArray.validObjectAtIndex(0))) {
                let string = getweekDayWithDate(date)
                return string
            }else {
                return validString(splitedArray.validObjectAtIndex(0))
            }
        }
    }
    
    func homesysstringToStringDate()->String {
        let splitedArray = self.components(separatedBy: " ")
        
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd"
        let strNowTime = timeFormatter.string(from: date) as String
        
        // 明天
        let yesterday = Date(timeInterval: 24*60*60, since: date)
        let yesterdayString = timeFormatter.string(from: yesterday) as String
        
        if strNowTime == validString(splitedArray.first) {
            let splitedArray = validString(splitedArray.validObjectAtIndex(1)).components(separatedBy: ":")
            let str = "今天 \(validString(splitedArray.validObjectAtIndex(0))):\(validString(splitedArray.validObjectAtIndex(1)))"
            return str
        }else if yesterdayString == validString(splitedArray.first) {
            let splitedArray = validString(splitedArray.validObjectAtIndex(1)).components(separatedBy: ":")
            let str = "明天 \(validString(splitedArray.validObjectAtIndex(0))):\(validString(splitedArray.validObjectAtIndex(1)))"
            return str
            
        }

        else {
            if let date = datefromString(validString(splitedArray.validObjectAtIndex(0))) {
                let string = weekDay(date)
                let splitedArray = validString(splitedArray.validObjectAtIndex(1)).components(separatedBy: ":")
                let str = "\(string) \(validString(splitedArray.validObjectAtIndex(0))):\(validString(splitedArray.validObjectAtIndex(1)))"
                return str
            }else {
                return validString(splitedArray.validObjectAtIndex(0))
            }
        }
    }

    
    func getweekDayWithDate(_ date : Date) ->String{
        let calensar : Calendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let comps = (calensar as NSCalendar).component(NSCalendar.Unit.weekday, from: date)
        let nowwWekDay = weekDayNum(date) // 当前星期几
        
        // 下周，返回日期
        if validInt(nowwWekDay) + validInt(comps) >= 7 {
            return dateTimeToStringDate(date: date)
        }
        else {
            print("comps :\(comps)")
            var str : String = String()
            if comps == 1 {
                str = "周日"
            }else if comps == 2 {
                str = "周二"
            }else if comps == 3 {
                str =  "周三"
            }else if comps == 4 {
                str =  "周四"
            }else if comps == 5 {
                str =  "周五"
            }else if comps == 6 {
                str =  "周六"
            }else if comps == 7 {
                str =  "周日"
            }
            return str
        }
    }
    
    func stringToStringFormatDate()->String {
        let splitedArray = self.components(separatedBy: " ")
        let timeFormatter1 = DateFormatter()
        timeFormatter1.dateFormat = "yyyy-MM-dd"
        
        let timeFormatter2 = DateFormatter()
        timeFormatter2.dateFormat = "yyyy年MM月dd日"
        
        let time = timeFormatter1.date(from: validString(splitedArray.first))//
        if time != nil {
            let strNowTime = timeFormatter2.string(from: time!) as String
            if strNowTime != "" {
                return strNowTime
            }else {
                return validString(splitedArray.first)
            }
        }else {
            return validString(splitedArray.first)
        }
    }
    
//    func stringToStringFormatDateTime(date:String)->String {
//
//        let timeFormatter1 = DateFormatter()
//        timeFormatter1.dateFormat = "HH:mm"
//
//        let timeFormatter2 = DateFormatter()
//        timeFormatter2.dateFormat = "HH:mm"
//
//        let time = timeFormatter1.date(from: validString(date))//
//        if time != nil {
//            let strNowTime = timeFormatter2.string(from: time!) as String
//            if strNowTime != "" {
//                return strNowTime
//            }else {
//                return validString(date)
//            }
//        }else {
//            return validString(date)
//        }
//    }
}

extension NSString {
    public var URLString: String {
        get {
            return self as String
        }
    }
    

}
 
 func weekDay(_ date : Date) -> String {
    
    let weekDays = [NSNull.init(),"周日","周一","周二","周三","周四","周五","周六"] as [Any]
    
    let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
    
    let timeZone = NSTimeZone.init(name: "Asia/Shanghai")
    
    calendar?.timeZone = timeZone! as TimeZone
    
    let calendarUnit = NSCalendar.Unit.weekday
    
    let theComponents = calendar?.components(calendarUnit, from: date)
    
    return validString(weekDays[validInt(theComponents?.weekday)])
 }
 
 func weekDayNum(_ date : Date) -> String {
    
    let weekDays = [NSNull.init(),"7","1","2","3","4","5","6"] as [Any]
    
    let calendar = NSCalendar.init(calendarIdentifier: .gregorian)
    
    let timeZone = NSTimeZone.init(name: "Asia/Shanghai")
    
    calendar?.timeZone = timeZone! as TimeZone
    
    let calendarUnit = NSCalendar.Unit.weekday
    
    let theComponents = calendar?.components(calendarUnit, from: date)
    
    return validString(weekDays[validInt(theComponents?.weekday)])
 }
 

 // 日期转字符串
 func dateTimeToStringDate(date:Date)->String {
    
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "MM月dd日"
    let strNowTime = timeFormatter.string(from: date) as String
    return strNowTime
 }

 
 // 获取今天的日期字符串
func toDayTimeToStringDate()->String {
    
    let date = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "yyyy年MM月dd日"
    let strNowTime = timeFormatter.string(from: date) as String
    return strNowTime
}

 
 func tomorrowTimeToStringDate()->String {
    
    let date = Date()
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "yyyy年MM月dd日"
    let strNowTime = timeFormatter.string(from: date) as String
    return strNowTime
 }
 
func stringToTimeStamp(stringTime:String)->Int {
    let dfmatter = DateFormatter()
    dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
    let date = dfmatter.date(from: stringTime)
    if date != nil {
        let dateStamp:TimeInterval = date!.timeIntervalSince1970
        let dateSt:Int = Int(dateStamp)
        return dateSt
    }
    return 0
 }


extension NSAttributedString {
    func addLineSpaceTextAligment(space: CGFloat, textAlignment: NSTextAlignment) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        paragraphStyle.alignment = textAlignment
        
        let rAttributedString = self.mutableCopy() as! NSMutableAttributedString
        rAttributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, self.length))
        return rAttributedString
    }
    
    func addColor(color: UIColor) -> NSAttributedString {
        let rAttributedString = self.mutableCopy() as! NSMutableAttributedString
        rAttributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, self.length))
        return rAttributedString
    }
    
    func addFontSize(size: CGFloat) -> NSAttributedString {
        let rAttributedString = self.mutableCopy() as! NSMutableAttributedString
        rAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: size), range: NSMakeRange(0, self.length))
        return rAttributedString
    }
    
    func addBoldFontSize(size: CGFloat) -> NSAttributedString {
        let rAttributedString = self.mutableCopy() as! NSMutableAttributedString
        rAttributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.boldSystemFont(ofSize: size), range: NSMakeRange(0, self.length))
        return rAttributedString
    }
    
    func strikeThrough(_ start: Int = 0, _ end: Int? = nil) -> NSAttributedString {
        let rAttributedString = self.mutableCopy() as! NSMutableAttributedString
        var tEnd = self.length
        if end != nil {
            tEnd = validInt(end)
        }
        rAttributedString.addAttributes([NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue], range: NSMakeRange(start, tEnd))
        return rAttributedString
    }
    
    func sizeByFont(font: UIFont, maxWidth: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
        let size = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        return rect.size
    }
}
