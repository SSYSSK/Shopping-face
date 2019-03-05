//
//  Utils.swift
//  sst-ios-po
//
//  Created by Zal Zhang on 12/26/16.
//  Copyright © 2016 po. All rights reserved.
//

import UIKit
import AlamofireImage.Swift

import AVFoundation
import Photos

func loadNib(_ nibName: String) -> AnyObject? {
    return Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as AnyObject?
}

func initNib(_ nibName: String) -> UINib {
    return UINib(nibName: "\(nibName)", bundle: nil)
}

func loadVC(controllerName: String, storyboardName: String) -> AnyObject {
    let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
    return storyboard.instantiateViewController(withIdentifier: controllerName)
}

func validBool(_ data: Any?) -> Bool {
    if data == nil {
        return false
    } else {
        if data is NSNumber {
            if data as! NSNumber == 0 {
                return false
            } else {
                return true
            }
        }
        
        return data as! Bool
    }
}

func validString(_ data: Any?) -> String {
    if data == nil {
        return ""
    }
    let rString = "\(data!)"
    if rString == "<null>" {
        return ""
    }
    return rString
}

func validDouble(_ data: Any?) -> Double {
    if let rst = (data as AnyObject).doubleValue {
        return rst
    }
    return 0
}

func validCGFloat(_ data: Any?) -> CGFloat {
    return CGFloat(validDouble(data))
}

func validMoney(_ data: Any?) -> Double {   // to cover some currency which . is , like france currency
    if data == nil {
        return 0
    } else {
        return validDouble(validString(data).replacingOccurrences(of: ",", with: "."))
    }
}

func validInt(_ data: Any?) -> Int {
    return Int(validDouble(data))
}

func validInt64(_ data: Any?) -> Int64 {
    if data == nil {
        return 0
    } else {
        return (data as AnyObject).longLongValue
    }
}

func validInt32(_ data: Any?) -> Int32 {
    if data == nil {
        return 0
    } else {
        return Int32(validDouble(data))
    }
}

func validUInt32(_ data: Any?) -> UInt32 {
    if data == nil {
        return 0
    } else {
        return UInt32(validDouble(data))
    }
}


func validDate(_ data: Any?) -> Date {
    if let r = data as? Date {
        return r
    }
    return Date()
}

func validNSDictionary(_ data: Any?) -> NSDictionary {
    if let nsDict = data as? NSDictionary {
        return nsDict
    }
    return NSDictionary()
}

func validDictionary(_ data: Any?) -> Dictionary<String,AnyObject> {
    if let dict = data as? Dictionary<String, AnyObject> {
        return dict
    }
    return Dictionary()
}

func validNSArray(_ data: Any?) -> NSArray {
    if let nsArray = data as? NSArray {
        return nsArray
    }
    return NSArray()
}

func validArray(_ data: Any?) -> Array<AnyObject> {
    if let r = data as? Array<AnyObject> {
        return r
    }
    return Array()
}

func isError(_ data: Any?) -> Bool {
    if (data as AnyObject).isKind(of: NSError.classForCoder()) {
        return true
    } else if (data.unsafelyUnwrapped as? Error) != nil {
        return true
    }
    return false
}

extension NSArray {
    func validObjectAtIndex(_ index: Int) -> AnyObject? {
        if index < self.count {
            return object(at: index) as AnyObject?
        } else {
            return nil
        }
    }
}

extension Array {
    func validObjectAtIndex(_ index: Int) -> AnyObject? {
        if index >= 0 && index < self.count {
            return self[index] as AnyObject?
        } else {
            return nil
        }
    }
    func validObjectAtLoopIndex(_ index: Int) -> AnyObject? {
        if self.count == 0 || index >= self.count {
            return nil
        }
        let ind = (index + self.count) % self.count
        if ind >= 0 && ind < self.count {
            return self[ind] as AnyObject?
        } else {
            return nil
        }
    }
}

extension UIImageView {
    func setImage(fileUrl: String, placeholder: String? = nil, callback: RequestCallBack? = nil) {
        var image: UIImage? = nil
        if placeholder != nil {
            image = UIImage(named: placeholder!)
        }
        if fileUrl.isEmpty {
            self.image = image
        } else {
            if let mURL = URL(string: fileUrl) {
                
                self.af_setImage(withURL: mURL, placeholderImage: image, completion: { response in
                    switch response.result {
                    case .success:
                        callback?(response.data, nil)
                    case .failure(let error):
                        callback?(nil, error)
                    }
                })
            }
        }
    }
    func setImageWithImage(fileUrl: String, placeImage: UIImage? = nil) {
        
        if fileUrl.isEmpty {
            self.image = placeImage
        } else {
            if let mURL = URL(string: fileUrl) {
               
                self.af_setImage(withURL: mURL, placeholderImage: placeImage)
            }else {
                self.image = placeImage
            }
        }
    }
}

let kDateFormatFromString = "yyyy-MM-dd HH:mm:ss" // "EEE MMM dd HH:mm:ss zzz yyyy"
let kDateFormatToString = "MM/dd/yyyy HH:mm"
let kDateMmddyyFormatToString = "MM/dd/yyyy"
let kDateYYYYMMDDFormat = "yyyy-MM-dd"
let kDateFormatYYYYMM = "yyyy-MM"
let kDateFormatHHmmForCA = "HHmm"

extension Date {
    static func formatTime(_ dateString: String) -> String {
        dateFormatter.dateFormat = kDateFormatFromString
        dateFormatter.timeZone = NSTimeZone(abbreviation:"CST") as TimeZone?
        if let date = dateFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }
        return ""
    }
    static func fromString(_ dateString: String) -> Date? {
        dateFormatter.dateFormat = kDateFormatFromString
        return dateFormatter.date(from: dateString)
    }
    
    func format() -> String {
        dateFormatter.dateFormat = kDateFormatFromString
        return dateFormatter.string(from: self)
    }
    func formatYYYYMM() -> String {
        dateFormatter.dateFormat = kDateFormatYYYYMM
        return dateFormatter.string(from: self)
    }
    func formatHMmmddyyyy() -> String {
        dateFormatter.dateFormat = kDateFormatToString
        return dateFormatter.string(from: self)
        
    }
    func formatYYYYMMDD() -> String {
        dateFormatter.dateFormat = kDateYYYYMMDDFormat
        return dateFormatter.string(from: self)
    }
    func formatMMddyy() -> String {
        dateFormatter.dateFormat = kDateMmddyyFormatToString
        return dateFormatter.string(from: self)
    }
    func formatHHmmForCA() -> String {
        dateFormatter.dateFormat = kDateFormatHHmmForCA
        dateFormatter.timeZone = TimeZone(secondsFromGMT: -8 * 60 * 60)
        return dateFormatter.string(from: self)
    }
    func getJsonObject(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options:JSONSerialization.ReadingOptions.allowFragments) as AnyObject?
        } catch {
            return nil
        }
    }
    

    var timeStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
}

func getUserDefautsData(name: String) -> AnyObject? {
    return UserDefaults.standard.object(forKey: name) as AnyObject?
}

func printDebug(_ items: Any...) {
//    #if DEV || QA
        debugPrint(items)
//    #endif
}

func showToastOnlyForDEV(_ msg: String, duration: Double = 3.5) {
    #if DEV
        ToastUtil.showToast(msg)
    #endif
}

func presentLoginVC(_ callback: @escaping RequestCallBack) {
    ABCProgressHUD.dismiss()
    let loginBaseNC = UIStoryboard(name: kStoryBoard_Login, bundle: nil).instantiateViewController(withIdentifier: "Login") as! TEEBaseNC
    
//    let loginVC = loginBaseNC.viewControllers.first as! TEELoginVC
   
//    loginVC.relogBlock = { isLogined in
//        ABCProgressHUD.dismiss()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kBackHome), object: nil)
//        if isLogined {
//            callback("true", nil)
//        } else {
//            callback(nil, "false")
//        }
//    }

    let window = UIApplication.shared.delegate?.window
    window??.rootViewController?.present(loginBaseNC, animated: true, completion: nil)
}


var window: UIWindow {
    get {
        if let tmpW = UIApplication.shared.delegate?.window {
            return tmpW!
        }
        return UIWindow()
    }
}

//func getTopControllerView(view: UIView) -> UIView? {
//    if let VCWrapperClass = NSClassFromString("UINavigationTransitionView") {
//        if validBool(view.superview?.superview?.isKind(of: VCWrapperClass)) {
//            return view
//        }
//    }
//    for subV in view.subviews {
//        return getTopControllerView(view: subV)
//    }
//    return nil
//}

func getTopWindow() -> UIWindow? {
    let frontToBackWindows = UIApplication.shared.windows.reversed()
    for window in frontToBackWindows {
        if window.windowLevel == UIWindow.Level.normal && window.rootViewController != nil {
            return window
        }
    }
    return nil
}

//func getTopVC() -> UIViewController? {
//    if let win = getTopWindow() {
//        if let vc = getTopControllerView(view: win)?.inputViewController {
//            if vc.isKind(of: UINavigationController.classForCoder()) {
//                return vc.children.last
//            } else if vc.isKind(of: UIViewController.classForCoder()) {
//                return vc
//            }
//        }
//    }
//    return nil
//}


func getCurrentVCBS() -> UIViewController {
    let keywindow = (UIApplication.shared.delegate as! AppDelegate).window//UIApplication.shared.keyWindow使用此有时会崩溃
    let firstView: UIView = (keywindow?.subviews.first)!
    let secondView: UIView = firstView.subviews.first!
    var vc = viewForController(view: secondView)!
    vc = ((vc as! UITabBarController).selectedViewController! as! UINavigationController).visibleViewController!
    
    return vc
}

private func viewForController(view:UIView)->UIViewController?{
    var next:UIView? = view
    repeat{
        if let nextResponder = next?.next, nextResponder is UIViewController {
            return (nextResponder as! UIViewController)
        }
        next = next?.superview
    }while next != nil
    return nil
}

func getTopView() -> UIView? {
    var tView = getCurrentVCBS().view
    while tView?.superview != nil {
        tView = tView?.superview
    }
    return tView
}

func getAlertWindow() -> UIWindow? {
    let frontToBackWindows = UIApplication.shared.windows.reversed()
    for window in frontToBackWindows {
        if window.windowLevel == UIWindow.Level.alert {
            return window
        }
    }
    return nil
}

func RGBA(r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

func isCanUseCamera() -> Bool {

    let author = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    if (author == .restricted || author == .denied) {
//        let url = URL(string:UIApplicationOpenSettingsURLString)
//        if url != nil {
//            if UIApplication.shared.canOpenURL(url!) {
//                UIApplication.shared.openURL(url!)
//            }
//        }
        return false
    } else {
        return true
    }
}

func isCanUsePhoto() -> Bool {
   
    let author = PHPhotoLibrary.authorizationStatus()
    if author == .restricted || author == .denied {
//        let url = URL(string:UIApplicationOpenSettingsURLString)
//        if url != nil {
//            if UIApplication.shared.canOpenURL(url!) {
//                UIApplication.shared.openURL(url!)
//            }
//        }
        return false
    } else {
        return true
    }
}

// MARK: - 根据image计算放大之后的frame

func calculateFrameWithImage(image : UIImage) -> CGRect {
    let screenW = UIScreen.main.bounds.width
    let screenH = UIScreen.main.bounds.height
    
    let w = screenW
    let h = screenW / image.size.width * image.size.height
    let x : CGFloat = 0
    let y : CGFloat = (screenH - h) * 0.5
    
    return CGRect(x: x, y: y, width: w, height: h)
}

extension CALayer {
    var borderColorFromUIColor: UIColor {
        get {
            return UIColor(cgColor: self.borderColor!)
        } set {
            self.borderColor = newValue.cgColor
        }
    }
}

// MARK: -- json

func toJsonString(_ jsonObject: Any) -> String {
    if JSONSerialization.isValidJSONObject(jsonObject) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) {
            if let rString = String(data: jsonData, encoding: String.Encoding.utf8) {
                return rString
            }
        }
    }
    return ""
}

func getTimeString(cutOffTimeCountDown:Int64) -> String {
    let days = cutOffTimeCountDown / (1000 *  60 *  60 * 24);
    let hours =  (cutOffTimeCountDown % (1000 *  60 *  60 *  24)) / (1000 *  60 * 60);
    let minutes = (cutOffTimeCountDown % (1000 *  60 *  60)) / (1000 * 60);
    
    var str = "";
    if (days == 1) {
        str =  "\(days) Day ";
    } else if (days > 1) {
        str = "\(days) Days ";
    }
    return "\(str) \(hours)hrs \(minutes)mins"
}

enum Validate {
    case email(_: String)
    case phoneNum(_: String)
    case carNum(_: String)
    case username(_: String)
    case password(_: String)
    case nickname(_: String)
    
    case URL(_: String)
    case IP(_: String)
    
    
    var isRight: Bool {
        var predicateStr:String!
        var currObject:String!
        switch self {
        case let .email(str):
            predicateStr = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            currObject = str
        case let .phoneNum(str):
            predicateStr = "^1[3,8]\\d{9}|14[5,7,9]\\d{8}|15[^4]\\d{8}|17[^2,4,9]\\d{8}$"
            currObject = str
        case let .carNum(str):
            predicateStr = "^[A-Za-z]{1}[A-Za-z_0-9]{5}$"
            currObject = str
        case let .username(str):
            predicateStr = "^[A-Za-z0-9]{6,20}+$"
            currObject = str
        case let .password(str):
            predicateStr = "^[a-zA-Z0-9]{6,20}+$"
            currObject = str
        case let .nickname(str):
            predicateStr = "^[\\u4e00-\\u9fa5]{4,8}$"
            currObject = str
        case let .URL(str):
            predicateStr = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
            currObject = str
        case let .IP(str):
            predicateStr = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            currObject = str
        }
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,predicateStr)
        
        return predicate.evaluate(with: currObject)
        
    }
}

/**
 *  生成随机数
 */
func randomCustom(min: Int, max: Int) -> Int {
    let y = arc4random() % UInt32(max) + UInt32(min)
    return Int(y)
}


func resizeImage(originalImg:UIImage) -> UIImage{
    
    //prepare constants
    let width = originalImg.size.width
    let height = originalImg.size.height
    let scale = width/height
    
    var sizeChange = CGSize()
    
    if width <= 300 && height <= 300{ //a，图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
        return originalImg
    }else if width > 300 || height > 300 {//b,宽或者高大于1280，但是图片宽度高度比小于或等于2，则将图片宽或者高取大的等比压缩至1280
        
        if scale <= 2 && scale >= 1 {
            let changedWidth:CGFloat = 100
            let changedheight:CGFloat = changedWidth / scale
            sizeChange = CGSize(width: changedWidth, height: changedheight)
            
        }else if scale >= 0.5 && scale <= 1 {
            
            let changedheight:CGFloat = 300
            let changedWidth:CGFloat = changedheight * scale
            sizeChange = CGSize(width: changedWidth, height: changedheight)
            
        }else if width > 1280 && height > 300 {//宽以及高均大于1280，但是图片宽高比大于2时，则宽或者高取小的等比压缩至1280
            
            if scale > 2 {//高的值比较小
                
                let changedheight:CGFloat = 100
                let changedWidth:CGFloat = changedheight * scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }else if scale < 0.5{//宽的值比较小
                
                let changedWidth:CGFloat = 100
                let changedheight:CGFloat = changedWidth / scale
                sizeChange = CGSize(width: changedWidth, height: changedheight)
                
            }
        }else {//d, 宽或者高，只有一个大于1280，并且宽高比超过2，不改变图片大小
            return originalImg
        }
    }
    
    UIGraphicsBeginImageContext(sizeChange)
    originalImg.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))
    
    //create UIImage
    let resizedImg = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    if resizedImg != nil {
        return resizedImg!
    }else {
        return originalImg
    }
}




/**
 * 获取当前时间戳
 */
func getDatetimeIntervalSince1970() -> String{
    let now = Date().timeIntervalSinceNow
//    let dformatter = DateFormatter()
//    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    let timeInterval:TimeInterval = now.timeIntervalSince1970
    return validString(now)
}

func getDatetimeFormatIntervalSince1970() -> String{
    let now = Date()
    let dformatter = DateFormatter()
    dformatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let timeInterval:TimeInterval = now.timeIntervalSince1970
    return validString(timeInterval)
}

func getNowDateString() -> String {
    let date = Date()
    timeFormatter.dateFormat = "yyyy-MM-dd"
    let strNowTime = timeFormatter.string(from: date) as String
    return strNowTime
}

// 友盟事件记录函数
//func addEvent(name:String){
//    MobClick.event(name)
//}

// 友盟分享
//func uMSocialManagerShare(platformType:UMSocialPlatformType, vc: UIViewController) {
//    //创建分享消息对象
//    let messageObject = UMSocialMessageObject()
//    //创建网页内容对象
//    let shareObject = UMShareWebpageObject.shareObject(withTitle: "魔力英语", descr: "21天英语启蒙集训营", thumImage: UIImage(named: "loading"))
//    shareObject?.webpageUrl = "https://us.abctime-me.com/h5/weixin/appIndex.html"
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject
//    UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: vc) { (data, error) in
//        if (error != nil) {
//            ABCProgressHUD.showSuccessWithStatus(string: "分享失败")
//        }else{
//            ABCProgressHUD.showSuccessWithStatus(string: "分享成功")
//        }
//    }
//}


// 画虚线
func addDashdeBorderLayer(view:UIView){
    let imgV:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth/2, height: 1))
    view.addSubview(imgV)
    UIGraphicsBeginImageContext(imgV.frame.size)
    
    let context = UIGraphicsGetCurrentContext()
    context?.setLineCap(CGLineCap.square)
    
    let lengths:[CGFloat] = [5,15,]
    context?.setStrokeColor(RGBA(220, g: 224, b: 234, a: 1).cgColor)
    context?.setLineWidth(2)
    context?.setLineDash(phase: 0, lengths: lengths)
    context?.move(to: CGPoint(x: 0, y: 0))
    context?.addLine(to: CGPoint(x: kScreenWidth/2, y: 0))
    context?.strokePath()
    
    context?.setStrokeColor(RGBA(220, g: 224, b: 234, a: 1).cgColor)
    context?.setLineWidth(2)
    context?.setLineDash(phase: 0, lengths: lengths)
    context?.move(to: CGPoint(x: 10, y: 0))
    context?.addLine(to: CGPoint(x: kScreenWidth/2, y: 0))
    context?.strokePath()
    imgV.image = UIGraphicsGetImageFromCurrentImageContext()
    //结束
    UIGraphicsEndImageContext()
}

// 画虚线
func addDashdeBorderLayerWith(view:UIView){
    
    printX(view.frame)
//    let imgV:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.width, height: 1))
    let imgV:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.superview!.width, height: 1))

    view.addSubview(imgV)
    UIGraphicsBeginImageContext(imgV.frame.size)
    
    let context = UIGraphicsGetCurrentContext()
    context?.setLineCap(CGLineCap.square)
    
    let lengths:[CGFloat] = [5,15,]
    context?.setStrokeColor(RGBA(220, g: 224, b: 234, a: 1).cgColor)
    context?.setLineWidth(2)
    context?.setLineDash(phase: 0, lengths: lengths)
    context?.move(to: CGPoint(x: 0, y: 0))
    context?.addLine(to: CGPoint(x: view.superview!.width, y: 0))
//    context?.addLine(to: CGPoint(x: view.width, y: 0))

    context?.strokePath()
    
    context?.setStrokeColor(RGBA(220, g: 224, b: 234, a: 1).cgColor)
    context?.setLineWidth(2)
    context?.setLineDash(phase: 0, lengths: lengths)
    context?.move(to: CGPoint(x: 10, y: 0))
    context?.addLine(to: CGPoint(x: view.superview!.width, y: 0))
//    context?.addLine(to: CGPoint(x: view.width, y: 0))

    context?.strokePath()
    imgV.image = UIGraphicsGetImageFromCurrentImageContext()
    //结束
    UIGraphicsEndImageContext()
}



func abc_addBorderLayerWith(view: UIView){
    
    let imgView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.width, height: 1))
    view.addSubview(imgView)
    
    UIGraphicsBeginImageContext(imgView.frame.size) // 位图上下文绘制区域 FlyElephant
    imgView.image?.draw(in: imgView.bounds)
    
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.setLineCap(CGLineCap.square)
    
    let lengths:[CGFloat] = [10,20] // 绘制 跳过 无限循环
    
    context.setStrokeColor(UIColor.red.cgColor)
    context.setLineWidth(2)
    context.setLineDash(phase: 0, lengths: lengths)
    context.move(to: CGPoint(x: 0, y: 10))
    context.addLine(to: CGPoint(x: view.frame.width, y: 0))
    context.strokePath()
    
    context.setStrokeColor(UIColor.blue.cgColor)
    context.setLineWidth(2)
    context.setLineDash(phase: 0, lengths: lengths)
    context.move(to: CGPoint(x: 15, y: 0))
    context.addLine(to: CGPoint(x: view.frame.width, y: 0))
    context.strokePath()
    imgView.image = UIGraphicsGetImageFromCurrentImageContext()
}



func printX<T>(_ message: T,
               file: String = #file,
               method: String = #function,
               line: Int = #line) {
    #if DEBUGLOG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
    
    #if DEV
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #elseif QA
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #elseif SIM
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #else
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}


extension UIImage {
//    func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
//        
//        var maxSize = maxSizeKB
//        var maxImageSize = maxImageLenght
//        if (maxSize <= 0.0) {
//            maxSize = 1024.0;
//        }
//        if (maxImageSize <= 0.0)  {
//            maxImageSize = 1024.0;
//        }
//        //先调整分辨率
//        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
//        let tempHeight = newSize.height / maxImageSize;
//        let tempWidth = newSize.width / maxImageSize;
//        if (tempWidth > 1.0 && tempWidth > tempHeight) {
//            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
//        }
//            
//        else if (tempHeight > 1.0 && tempWidth < tempHeight){
//            
//            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
//            
//        }
//        
//        UIGraphicsBeginImageContext(newSize)
//        
//        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        
//        UIGraphicsEndImageContext()
//        
//        var imageData = UIImageJPEGRepresentation(newImage!, 1.0)
//        
//        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
//        
//        //调整大小
//        
//        var resizeRate = 0.9;
//        
//        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
//            
//            imageData = UIImageJPEGRepresentation(newImage!,CGFloat(resizeRate));
//            
//            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
//            
//            resizeRate -= 0.1;
//            
//        }
//        
//        return imageData!
//        
//    }
}


var animationData: Data = {
    var temphelloData = Data()
    let jsonPath = Bundle.main.path(forResource: "loding", ofType: "svga")
    
    do {
        temphelloData = try NSData.init(contentsOfFile: validString(jsonPath))as Data
    } catch {}
    return temphelloData
}()

//func showAnimation(view: UIView, bgImage: UIImage){
//    let viewb = UIView()
//
//    viewb.frame = CGRect(x: 0, y: 0, width: kScreenWidth*2, height: kScreenWidth*2)
//    viewb.center = view.center
//
//    let imageViewBg = UIImageView(frame: CGRect(x: 0, y: 0, width: viewb.width, height: viewb.height))
//    imageViewBg.image = bgImage
//    viewb.addSubview(imageViewBg)
//
//    let parser = SVGAParser()
//    let scanePlayer = SVGAPlayer(frame: CGRect(x: (viewb.width - 200)/2, y: (viewb.width - 100)/2, width: 200, height: 100))
//
//    viewb.addSubview(scanePlayer)
//
//    scanePlayer.loops = 1
//    parser.parse(with: animationData, cacheKey: "animationData", completionBlock: { (videoItem) in
//        scanePlayer.videoItem = videoItem;
//        scanePlayer.startAnimation()
//    }) { (error) in
//        printX(error)
//    }
//
//
//    viewb.backgroundColor = UIColor.clear
//    view.addSubview(viewb)
//
//    TaskUtil.delayExecuting(1) {
//        UIView.animate(withDuration: 1, animations: {
//
//            scanePlayer.alpha = 0
//            imageViewBg.frame = CGRect(x: viewb.width/2, y: viewb.height/2, width: 1, height: 1)
//
//        }, completion: { (data) in
//            viewb.removeFromSuperview()
//        })
//    }
//}


//打开相机
//func openCamera() {
//    if  isCanUseCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            KiClipperHelper.sharedInstance.photoWithSourceType(type: .camera)
//        } else {
//            ABCProgressHUD.showErrorWithStatus(string: "打开相机失败")
//        }
//    }else{
//        if let vc =  getTopVC() {
//            let alertView: UIAlertController = UIAlertController(title: nil, message: kOpenCameraMessage, preferredStyle: UIAlertControllerStyle.alert)
//            alertView.addAction(UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler:nil))
//            alertView.addAction(UIAlertAction(title:"去设置", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
//                if let tmpUrl = URL(string:UIApplicationOpenSettingsURLString) {
//                    if  UIApplication.shared.canOpenURL(tmpUrl) {
//                        UIApplication.shared.openURL(tmpUrl)
//                    }
//                }
//            }))
//            vc.present(alertView, animated: true, completion: nil)
//        }
//    }
//}

//打开相册
//func openPhotoLibrary(_ maxSelectedCount:Int) {
//
//    
//    if  isCanUsePhoto() {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary)
//        } else {
//            ABCProgressHUD.showErrorWithStatus(string: "打开相册失败")
//        }
//    }else{
//       
//        if let vc =  getTopVC() {
//            let alertView: UIAlertController = UIAlertController(title: nil, message: kOpenPhotoMessage, preferredStyle: UIAlertControllerStyle.alert)
//            alertView.addAction(UIAlertAction(title:"取消", style: UIAlertActionStyle.cancel, handler:nil))
//            alertView.addAction(UIAlertAction(title:"去设置", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
//                if let tmpUrl = URL(string:UIApplicationOpenSettingsURLString) {
//                    if  UIApplication.shared.canOpenURL(tmpUrl) {
//                        UIApplication.shared.openURL(tmpUrl)
//                    }
//                }
//            }))
//
//            vc.present(alertView, animated: true, completion: nil)
//        }
//    }
//}
/**
 字典转换为JSONString
 
 - parameter dictionary: 字典参数
 
 - returns: JSONString
 */
func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try! JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData?
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return validString(JSONString)
    
}

/// JSONString转换为字典
///
/// - Parameter jsonString: <#jsonString description#>
/// - Returns: <#return value description#>
func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
    
    let jsonData:Data = jsonString.data(using: .utf8)!
    
    let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
    if dict != nil {
        return dict as! NSDictionary
    }
    return NSDictionary()
}

// 时间转日期
func datefromString(_ dateString: String) -> Date? {
    dateFormatter.dateFormat = kDateYYYYMMDDFormat
    return dateFormatter.date(from: dateString)
}

//打开相机
func openCamera() {
    if  isCanUseCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            KiClipperHelper.sharedInstance.photoWithSourceType(type: .camera)
        } else {
            ABCProgressHUD.showErrorWithStatus(string: "打开相机失败")
        }
    }else{
        let alertView: UIAlertController = UIAlertController(title: nil, message: kOpenCameraMessage, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title:"取消", style: UIAlertAction.Style.cancel, handler:nil))
        alertView.addAction(UIAlertAction(title:"去设置", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            if let tmpUrl = URL(string:UIApplication.openSettingsURLString) {
                if  UIApplication.shared.canOpenURL(tmpUrl) {
                    UIApplication.shared.openURL(tmpUrl)
                    
                }
            }
        }))
        getCurrentVCBS().present(alertView, animated: true, completion: nil)
    }
}

//打开相册
func openPhotoLibrary(_ maxSelectedCount:Int) {
    
    
    if  isCanUsePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary)
        } else {
            ABCProgressHUD.showErrorWithStatus(string: "打开相册失败")
        }
    }else{
        
        let alertView: UIAlertController = UIAlertController(title: nil, message: kOpenPhotoMessage, preferredStyle: UIAlertController.Style.alert)
        alertView.addAction(UIAlertAction(title:"取消", style: UIAlertAction.Style.cancel, handler:nil))
        alertView.addAction(UIAlertAction(title:"去设置", style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            if let tmpUrl = URL(string:UIApplication.openSettingsURLString) {
                if  UIApplication.shared.canOpenURL(tmpUrl) {
                    //                        UIApplication.shared.openURL(tmpUrl)
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(tmpUrl, options:[:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(tmpUrl)
                    }
                }
            }
        }))
        
        getCurrentVCBS().present(alertView, animated: true, completion: nil)
    }
}

