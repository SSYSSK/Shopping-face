//
//  TEEUser.swift
//  TEEFit
//
//  Created by 柯木超 on 2018/11/2.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit
import ObjectMapper
import Foundation
import CommonCrypto

let kUserId          = "uid"
let kUserName        = "real_name"
let kUserNickName    = "nick_name"
let kUserToken       = "access_token"
let kUserType        = "token_type"
let kUserExpires     = "expires_in" // 有效时间(秒)

let kUserBirth       = "birth"
let kUserSex         = "sex"
let kUserHeight      = "height"
let kUserWeight      = "weight"
let kUserDynamic     = "dynamic" // 活力
let kUserIsSign      = "is_sign" //是否签订 0：未签到；1：签到
let kUserAccountAddr = "accountAddr" //钱包地址
let kUserAccountKey  = "accountKey" //钱包私钥
let kUserAmount      = "amount" //总资产
let kUserEarning     = "earning" // 收益（今天）
let kUserIsLogin     = "isLogin"
let kUserIcon        = "headimgurl"
let kUserPhone       = "phone"
class TEEUser: BaseModel{
    
    var userId: String!
    var realName: String?
    var nickName: String?
    var token: String?
    var sex: Int!       // 性别 0:未设置 1:男 2:女
    var expiresIn: Int! = 0
    var type: Int?      //1-游客, 2-注册用户， 3-付费用户
    var isLogin: Bool?
    var birth: String?
    var height: Int! = 0
    var weight: Int! = 0
    var dynamic: Int! = 0
    var isSign: Int! = 0
    var accountAddr:String?
    var amount:Int! = 0
    var accountKey:String?
    var earning:Int! = 0
    var phone:String?
    var address:String?
    var iconPath:String?
    override init() {
        super.init()
    }
    required init?(map: Map) {
        super.init(map: map)!
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        iconPath         <- map[kUserIcon]
        userId           <- (map[kUserId],transformIntToString)
        realName         <- map[kUserName]
        nickName         <- map[kUserNickName]
        token            <- map[kUserToken]
        sex              <- map[kUserSex]
        expiresIn        <- map[kUserExpires]
        type             <- map[kUserType]
        sex              <- map[kUserSex]
        birth            <- map[kUserBirth]
        height           <- map[kUserHeight]
        weight           <- map[kUserWeight]
        dynamic          <- map[kUserDynamic]
        isSign           <- map[kUserIsSign]
        accountAddr      <- map[kUserAccountAddr]
        amount           <- map[kUserAmount]
        accountKey       <- map[kUserAccountKey]
        earning          <- map[kUserEarning]
        phone            <- map[kUserPhone]
    }
    
    
    //发送验证码
    func sendCode(phone:String, type:Int, callback: @escaping RequestCallBack){
        
        // 生成时间戳+腌值
        let time = Date().timeStamp
        let sign = "\(time)7hRIElvt".md5()
        biz.setSendCode(phone: phone, type: type, time: validString(time), sign: sign) { (data, error) in
            callback(data,error)
        }
    }
    
    
    // 注册
    func register(phone:String, verify: String, password: String, callback: @escaping RequestCallBack){
        biz.register(phone: phone, verify: verify, pas: password) { (data, error) in
            if data == nil && error != nil {
                callback(data,error)
            }else {
                let user = TEEUser(JSON: validDictionary(validArray(validDictionary(data)["data"]).validObjectAtIndex(0)))
                user?.isLogin = true
                biz.user = user
                self.setUserData(user: user)
                callback(user,error)
            }
        }
    }
    
    // 登陆
    func login(phone:String, password: String, callback: @escaping RequestCallBack){
        biz.loginByPhone(phone: phone, pas: password) { (data, error) in
            let user = TEEUser(JSON: validDictionary(validArray(data).validObjectAtIndex(0)))
            user?.isLogin = true
            biz.user = user
            self.setUserData(user: user)
            callback(user,error)
        }
    }
    
    
    // 上传头像
    
    func uploadImage(image:UIImage, callback: @escaping RequestCallBack){
        biz.uploadFile(image: image) { (data, error) in
            callback(data,error)
        }
    }
    
    // 更新用户信息
    
    func updateUser(user:TEEUser, callback: @escaping RequestCallBack){
        biz.updateUser(user: user) { (data, error) in
            biz.user = user
            callback(user,error)
        }
    }
    
    // 获取用户信息
    func getUserDetail(){
        biz.getUserDetail() { (data, error) in
            let user = TEEUser(JSON: validDictionary(validArray(validDictionary(data)["data"]).validObjectAtIndex(0)))
            user?.token = validString(getUserDefautsData(kUserToken))
            self.setUserData(user: user)
            biz.user = user
            self.delegate?.refreshUI(user)
        }
    }
    
    // 修改密码/忘记密码
    func changePassword(phone:String, verify: String, password: String, callback: @escaping RequestCallBack){
        biz.changePassword(phone: phone, verify: verify, pas: password) { (data, error) in
            if data == nil && error != nil {
                callback(data,error)
            }else {
                let user = TEEUser(JSON: validDictionary(validArray(validDictionary(data)["data"]).validObjectAtIndex(0)))
                user?.isLogin = true
                biz.user = user
                self.setUserData(user: user)
                callback(user,error)
            }
        }
    }
    
    /**
     提交反馈
     */
    func said(message:String, callback: @escaping RequestCallBack){
        biz.said(message: message) { (data, error) in
            callback(data,error)
        }
    }
    
    /**
     修改昵称
     */
    func changeNickName(name:String, callback: @escaping RequestCallBack){
        biz.changeNickName(name: name) { (data, error) in
            callback(data,error)
            if data == nil && error != nil {
                callback(data,error)
            }else {
                biz.user?.nickName = name
                callback(biz.user!,error)
            }
        }
    }
    
    
    // 数据本地化
    func setUserData(user:TEEUser?) {
        setUserDefautsData(kUserId, value: validString(user?.userId))
        setUserDefautsData(kUserName, value: validString(user?.realName))
        setUserDefautsData(kUserNickName, value: validString(user?.nickName))
        setUserDefautsData(kUserToken, value: validString(user?.token))
        setUserDefautsData(kUserExpires, value: validString(user?.expiresIn))
        setUserDefautsData(kUserBirth, value: validString(user?.birth))
        setUserDefautsData(kUserIcon, value: validString(user?.iconPath))
        setUserDefautsData(kUserSex, value: validString(user?.sex))
        setUserDefautsData(kUserHeight, value: validString(user?.height))
        setUserDefautsData(kUserWeight, value: validString(user?.weight))
        setUserDefautsData(kUserIsLogin, value: true)
        setUserDefautsData(kUserDynamic, value: validString(user?.dynamic))
        setUserDefautsData(kUserIsSign, value: validString(user?.isSign))
        setUserDefautsData(kUserAccountAddr, value: validString(user?.accountAddr))
        setUserDefautsData(kUserAccountKey, value: validString(user?.accountKey))
        setUserDefautsData(kUserAmount, value: validString(user?.amount))
        setUserDefautsData(kUserEarning, value: validString(user?.earning))
    }
    
    func getUserData() -> TEEUser {
        let user = TEEUser()
        user.userId = validString(getUserDefautsData(kUserId))
        user.realName = validString(getUserDefautsData(kUserName))
        user.nickName = validString(getUserDefautsData(kUserNickName))
        user.token = validString(getUserDefautsData(kUserToken))
        user.expiresIn = validInt(getUserDefautsData(kUserExpires))
        user.birth = validString(getUserDefautsData(kUserBirth))
        user.iconPath = validString(getUserDefautsData(kUserIcon))
        user.sex = validInt(getUserDefautsData(kUserSex))
        user.height = validInt(getUserDefautsData(kUserHeight))
        user.weight = validInt(getUserDefautsData(kUserWeight))
        user.isLogin = true
        user.dynamic = validInt(getUserDefautsData(kUserDynamic))
        user.isSign = validInt(getUserDefautsData(kUserIsSign))
        user.accountAddr = validString(getUserDefautsData(kUserAccountAddr))
        user.accountKey = validString(getUserDefautsData(kUserAccountKey))
        user.amount = validInt(getUserDefautsData(kUserAmount))
        user.earning = validInt(getUserDefautsData(kUserEarning))
        return user
    }
}

