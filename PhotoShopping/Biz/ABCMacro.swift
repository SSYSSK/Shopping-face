//
//  SSTAPPMacro.swift
//  sst-ios
//
//  Created by Amy on 16/4/20.
//  Copyright © 2016年 SST. All rights reserved.
//

import UIKit
//import AlamofireImage
import ObjectMapper
import AudioToolbox
import AssetsLibrary
import Photos

typealias Mapper = ObjectMapper.Mapper

#if QA
let kBaseURLString              = "https://clienttest.tee.com"
let kBaseUploadImageURLString   = "https://ai.tee.com:443/shopping_test"
#else
let kBaseURLString              = "https://clienttest.tee.com"
let kBaseUploadImageURLString   = "https://ai.tee.com:443/shopping"
#endif


//let defaultUserIcon = "https://courses.abctime.com/share/default_avatar.png"
let defaultBoyIcon  = "https://courses.abctime.com/share/default_avatar_boy.png"
let defaultGrilIcon = "https://courses.abctime.com/share/default_avatar_girl.png"
// MARK: - Cache Path
public let kCachePath: String = validString(NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last)

// 导航栏高度
let NavigationBarHeight = UIApplication.shared.statusBarFrame.height //获取statusBar的高度


let KSCREENWIDTH  =   UIScreen.main.bounds.width
let KSCREENHEIGHT =   UIScreen.main.bounds.height
let isIPhone      =   UIDevice.current.userInterfaceIdiom == .phone
let isPad        =   UI_USER_INTERFACE_IDIOM() == .pad

let kScreenSize = CGSize(width: kScreenWidth, height: kScreenHeight)

let isIpadAirOr9Pro = (KSCREENWIDTH == 1024 && KSCREENHEIGHT == 768) || (KSCREENWIDTH == 768 && KSCREENHEIGHT == 1024)
let isIpad10Pro = (KSCREENWIDTH == 1112 && KSCREENHEIGHT == 834) || (KSCREENHEIGHT == 1112 && KSCREENWIDTH == 834)
let isIpad12Pro = (KSCREENWIDTH == 1366 && KSCREENHEIGHT == 1024) || (KSCREENWIDTH == 1024 && KSCREENHEIGHT == 1366)


let iphonePlus = (((UIScreen.main.bounds.size.width == 414.0 || UIScreen.main.bounds.size.width == 736.0) && (UIScreen.main.bounds.size.height == 414.0 || UIScreen.main.bounds.size.height == 736.0)) ? true : false) as Bool
let isIPoneX = UIScreen.instancesRespond(to:#selector(getter: UIScreen.main.currentMode)) ? __CGSizeEqualToSize(CGSize(width:1125,height:2436), (UIScreen.main.currentMode?.size)!) || __CGSizeEqualToSize(CGSize(width:828,height:1792), (UIScreen.main.currentMode?.size)!) || __CGSizeEqualToSize(CGSize(width:1242,height:2688), (UIScreen.main.currentMode?.size)!): false
let isIPone5 = (KSCREENWIDTH == 320 && KSCREENHEIGHT == 568) || (KSCREENHEIGHT == 320 && KSCREENWIDTH == 568)

let isIPone4 = (KSCREENWIDTH == 320 && KSCREENHEIGHT == 480) || (KSCREENHEIGHT == 320 && KSCREENWIDTH == 480)
let kIsIphoneX = kScreenSize.equalTo(CGSize(width: 375, height: 812))   // 1125 x 2436


// MARK: -- Screen Size

let kScreenWidth                        = UIScreen.main.bounds.size.width
let kScreenHeight                       = UIScreen.main.bounds.size.height

let kProkScreenWidth                    = kScreenWidth / 667
let kProkScreenHeight                   = kScreenHeight / 375
let kIpadProWidth = kScreenWidth / 1024
let kIpadProHeight = kScreenHeight / 768


let kScreenNavigationHeight: CGFloat    = kIsIphoneX ? 88 : 64
let kScreenTabbarHeight: CGFloat        = kIsIphoneX ? 83 : 49

let kScreenViewHeight: CGFloat          = kScreenHeight - kScreenNavigationHeight - kScreenTabbarHeight

let kLabelSpaceWidth: CGFloat           = 5

// MARK: APP Constants
let kNameSpace = validString(Bundle.main.infoDictionary?["CFBundleExecutable"])
let kAppVersion = validString(Bundle.main.infoDictionary?["CFBundleShortVersionString"])
let kAppBuild = validString(Bundle.main.infoDictionary?["CFBundleVersion"])
let kAppBundleId = validString(Bundle.main.infoDictionary?["CFBundleIdentifier"])

let kOneInMillion: Double = 0.000001

//应用程序信息
let infoDictionary = Bundle.main.infoDictionary!
let appDisplayName = infoDictionary["CFBundleDisplayName"] //程序名称

let majorVersion = infoDictionary["CFBundleShortVersionString"]//主程序版本号
let minorVersion = infoDictionary["CFBundleVersion"]//版本号（内部标示）
let appVersion = majorVersion as! String

//设备信息
let iosVersion = UIDevice.current.systemVersion //iOS版本
let identifierNumber = UIDevice.current.identifierForVendor //设备udid
let systemName = UIDevice.current.systemName //设备名称
let model = UIDevice.current.modelName //设备具体详细的型号
let localizedModel = UIDevice.current.localizedModel //设备区域化型号如A1533


let ipsLoading = "ips_loading" // ipsLoading

let homeLessonLoading = "home_lesson_loading"
let homeWatchLoading = "home_watch_loading"
let loadingImage = "product_test"


//网络请求超时限制
let kTimeoutInterval: Double    = 30
let kTimeoutForTest: Double     = 20

//MARK:--
let kHomeFileName               = "home.data"
let kUserFileName               = "user.data"

//MAKR:--缓存图片名
let kIconBackImgName                = "icon_back_gray"

let kPlaceImage                = "staring"
//let kUserIconImage                = "userIcon"

let abcUIScale :CGFloat = isPad ? 1.6 : 1
let abcFontScale :CGFloat = isPad ? 1.5 : (isIPone5 ? 0.85 : (iphonePlus ? 1.10 : 1))
//#define SizeScale (isPad ? 1.5 : (isIphone5 ? 0.85 : (isIphone6p ? 1.10 : 1)))

//let systemFontSize :CGFloat  = isPad ? 24*1.6 : 24

let pathOfCaches = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first



let kexperienceClolor = UIColor(red: 143.0/255.0, green: 112.0/255.0, blue: 247.0/255.0, alpha: 1)
let kmainClolor = UIColor(red: 92.0/255.0, green: 200.0/255.0, blue: 141.0/255.0, alpha: 1)



let systemColor = UIColor(red: 131.0/255.0, green: 123.0/255.0, blue: 226.0/255.0, alpha: 1)


//系统时间
let kStoryBoard_Main     = "Main"
let kStoryBoard_Home     = "Home"
let kStoryBoard_Login    = "Login"
let kStoryBoard_SettingInfo    = "SettingInfo"


//device token
let kDeviceToken = "deviceToken"

let testLesson = false // ce shi shi yong

let kGuideDateLastViewed = "GuideDateLastViewed"    // for date last viewed guide to store
let kGuideAppPrevVersion = "GuideAppVersion"        // for app prev version to store to check app updated or not

let kOrderDetailInfoLeadingImageWidth:CGFloat = 110

enum ImageType {
    case localImageType,webImageType
}

enum SelectedTypeInCart:Int {
    case bestSellingType = 0, mostPopularType
}


func isIpad()->Bool{
    // 如果是iPhone或iPod则只显示列表页，如果是iPad则显示分割面板
    if (UIDevice.current.userInterfaceIdiom == .phone) {
        return false
    }
    else {
        return true
    }
}

//MARK: 快速生成颜色
func RGBA (_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat) -> UIColor {
    return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}

//MARK:--手机震动
func SHAKEPHONE () {
    let soundID = SystemSoundID(kSystemSoundID_Vibrate)
    //振动
    AudioServicesPlaySystemSound(soundID)
}

func GET_StoryBoard (_ sbName : String) -> UIStoryboard {
    return UIStoryboard(name: sbName, bundle: Bundle.main)
}

func getProductImagePath(_ imagePath: String?) -> String {
    if imagePath == nil {
        return ""
    }
    return  kBaseURLString + validString(imagePath)
}

//根据Key获取UserDefault的内容
func getUserDefautsData(_ name: String) -> AnyObject? {
    return UserDefaults.standard.object(forKey: name) as AnyObject?
}
func setUserDefautsData(_ name: String, value: Any) {
    return UserDefaults.standard.set(value, forKey: name)
}

//给view添加阴影
func shadowView(_ view: UIView, height: CGFloat, direction: CGFloat) {
    view.layer.shadowOffset = CGSize(width: direction, height: height)
    view.layer.shadowOpacity = 0.4
    view.layer.shadowColor = UIColor.gray.cgColor
}

func getColorInIPS(row:Int) -> UIColor{
    let i = row % 6
    switch i {
    case 0:
        return RGBA(255, g: 128, b: 234, a: 1)
    case 1:
        return RGBA(150, g: 107, b: 255, a: 1)
    case 2:
        return RGBA(255, g: 163, b: 0, a: 1)
    case 3:
        return RGBA(2, g: 191, b: 255, a: 1)
    case 4:
        return RGBA(0, g: 210, b: 180, a: 1)
    case 5:
        return RGBA(251, g: 210, b: 20, a: 1)
    default:
        return RGBA(150, g: 107, b: 255, a: 1)
    }
}


func Color966BFF() -> UIColor{
    return UIColor.hexStringToColor("#966BFF")
}

func ColorD5DBE6() -> UIColor{
    return UIColor.hexStringToColor("#D5DBE6")
}

func Color00CC88() -> UIColor{
    return UIColor.hexStringToColor("#00CC88")
}


//扩展UIDevice
extension UIDevice {
    //获取设备具体详细的型号
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1":                               return "iPhone 7 (CDMA)"
        case "iPhone9,3":                               return "iPhone 7 (GSM)"
        case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
        case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}


func homeBg()->UIImage{
    return UIImage(named: "")!
}

//func getNavigationBarBgImage() -> UIImage? {
//    #if DEV
//    if kIsIphoneX {
//        return UIImage(named: "icon_naviBg_Dev_X")
//    } else {
//        return UIImage(named: "icon_naviBg_Dev")
//    }
//    #elseif QA
//    if kIsIphoneX {
//        return UIImage(named: "icon_naviBg_QA_X")
//    } else {
//        return UIImage(named: "icon_nav_bg_QA")
//    }
//    #else
//    if kIsIphoneX {
//        return UIImage(named: "icon_navigationBarBg_X")
//    } else {
//        return UIImage(named: "icon_navigationBarBg")
//    }
//    #endif
//}
