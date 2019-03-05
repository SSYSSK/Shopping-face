
//
//  BizRequestCenter.swift
//  sst-ios
//
//  Created by Liang Zhang on 16/4/12.
//  Copyright © 2016年 lzhang. All rights reserved.
//

import UIKit

open class BizRequestCenter : NSObject {
    
    let ntwkAccess = NetworkAccess()
    var user : TEEUser?
    
    override init() {
        ntwkAccess.listen()
        let user = TEEUser().getUserData()
        self.user = user
    }
    
    class var sharedInstance : BizRequestCenter {
        return biz
    }
    

    func uploadImage(image: String, dataType: Int,  callback: @escaping RequestCallBack) {
        
        let timeStamp = Date().timeStamp
        let dict:[String:Any] = [
            "content":image,
            "db_id": "101",
            "code": "101",
            "randomValue": timeStamp,
            "classid": 0
        ]
    
        printX("url = \(kBaseUploadImageURLString) param===\(dict)")
        ntwkAccess.uploadFile(url: kBaseUploadImageURLString, parameters: dict) { (data, error) in
            callback(data, error)
        }
    }

    /**
     1.发送验证码
     */
    func setSendCode(phone:String, type:Int, time:String, sign: String, callback: @escaping RequestCallBack) {
        let urlstr = "/api/trackers/sms"
        let dict:[String:Any] = [
            "code":110104,
            "p":validString(phone),
            "t":time,
            "s":sign,
            "type":type
        ]
        ntwkAccess.request(.post, url: kBaseURLString + urlstr, parameters: dict) {(response, err) -> Void in
            callback(response, err)
        }
    }
    
    /**
     2、 注册
     */
    func register(phone:String, verify:String, pas:String, callback: @escaping RequestCallBack) {
        let urlstr = "/api/trackers/regist"
        let dict:[String:Any] = [
            "code":110101,
            "phone":phone,
            "verify":verify,
            "passwd":pas
        ]
        ntwkAccess.request(.post, url: kBaseURLString + urlstr, parameters: dict) {(response, err) -> Void in
            callback(response, err)
        }
    }
    
    /**
     提交反馈
     */
    func said(message:String, callback: @escaping RequestCallBack) {
        let urlstr = "/api/trackers/feedback"
        let dict:[String:Any] = [
            "code":110302,
            "token": validString(getUserDefautsData(kUserToken)),
            "content":message,
            "phone":validString(biz.user?.phone)
        ]
        ntwkAccess.request(.post, url: kBaseURLString + urlstr, parameters: dict) {(response, err) -> Void in
            callback(response, err)
        }
    }
    
    
    /**
     修改密码
     */
    func changePassword(phone:String, verify:String, pas:String, callback: @escaping RequestCallBack) {
        let urlstr = "/api/trackers/resetpw"
        let dict:[String:Any] = [
            "code":110105,
            "phone":phone,
            "verify":verify,
            "passwd":pas
        ]
        ntwkAccess.request(.post, url: kBaseURLString + urlstr, parameters: dict) {(response, err) -> Void in
            callback(response, err)
        }
    }
    
    
    
    /**
     3、 手机登陆
     */
    func loginByPhone(phone:String, pas:String, callback: @escaping RequestCallBack) {
        let urlstr = "/api/trackers/login"
        let dict:[String:Any] = [
            "code":110102,
            "phone":phone,
            "passwd":pas
        ]
        ntwkAccess.request(.post, url: kBaseURLString + urlstr, parameters: dict) {(response, err) -> Void in
            callback(response, err)
        }
    }
    
    /**
     4、 上传图片
     */
    func uploadFile(image: UIImage, callback: @escaping RequestCallBack) {
        let urlstr = "/api/trackers/uploadavator"
        let dict:[String:Any] = [
            "code":110107,
            "token": validString(getUserDefautsData(kUserToken)) //validString(biz.user?.token)
        ]
//        ntwkAccess.uploadFile(url: kBaseURLString + urlstr, image: image, parameters: dict) { (data, error) in
//            callback(data, error)
//        }
        
        
    }
    
    /**
     5、 修改用户信息
     */
    func updateUser(user: TEEUser, callback: @escaping RequestCallBack) {
        let urlstr = "/api/trackers/userinfo"
        let dict = NSMutableDictionary()
        dict.setValue(110103, forKey: "code")
        if validString(user.token) != "" {
            dict.setValue(validString(user.token), forKey: "token")
        }
        
        if validString(user.nickName) != "" {
            dict.setValue(validString(user.nickName), forKey: "nick_name")
        }
        if validString(user.sex) != "" {
            dict.setValue(validString(user.sex), forKey: "sex")
        }
        
        if validString(user.iconPath) != "" {
            dict.setValue(validString(user.iconPath), forKey: "headimgurl")
        }
        if validString(user.birth) != "" {
            dict.setValue(validString(user.birth), forKey: "cc")
        }
        if validString(user.height) != "" {
            dict.setValue(validString(user.height), forKey: "height")
        }
        
        if validString(user.weight) != "" {
            dict.setValue(validString(user.weight), forKey: "weight")
        }
        
        ntwkAccess.request(.put, url: kBaseURLString + urlstr, parameters: validDictionary(dict)) {(response, err) -> Void in
            callback(response, err)
        }
    }
    
    /**
     6. 获取用户信息
     */
    func getUserDetail(callback: @escaping RequestCallBack) {
        let urlstr = "/api/trackers/userinfo?code=110106&token=\(validString(biz.user?.token))"
        ntwkAccess.request(.get, url: kBaseURLString + urlstr) {(response, err) -> Void in
            callback(response, err)
        }
    }
    
    
    /**
     3、 修改用户昵称
     */
    func changeNickName(name:String, callback: @escaping RequestCallBack) {
        let urlstr = "/api/trackers/userinfo"
        let dict:[String:Any] = [
            "code":110103,
            "token": validString(getUserDefautsData(kUserToken)),
            "nick_name":name
        ]
        ntwkAccess.request(.put, url: kBaseURLString + urlstr, parameters: dict) {(response, err) -> Void in
            callback(response, err)
        }
    }
    
    func getProductList(products: String, callback: @escaping RequestCallBack) {
        let urlstr = "http://api4test.380star.com/friendshop/36/goods/recommendgoodslist.do?heleId=\(validString(products))"
        ntwkAccess.request(.get, url: urlstr) {(response, err) -> Void in
            callback(response, err)
        }
    }
  
}
