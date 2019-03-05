//
//  TEEForgetPasword.swift
//  TEEAI
//
//  Created by TEE on 2018/12/20.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit

class TEEForgetPasword: ABCBaseVC {

    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var enterPassword: UITextField!
    
    @IBOutlet weak var codeButton: UIButton!
    
    private var countdownTimer: Timer?
    var phone = ""
    var user = TEEUser()
    enum SegueIdentifier: String {
        case toCommitMessage           = "toCommitMessageVC"
    }
    var remainingSeconds: Int = 0 {
        willSet {
            codeButton.setTitle("\(remainingSeconds) S", for: .disabled)
            if newValue <= 0 {
                codeButton.isEnabled = true
                codeButton.setTitle("获取验证码", for: UIControl.State.normal)
                isCounting = false
            }
        }
    }
    
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TEERegistionVC.updateTime(timer:)), userInfo: nil, repeats: true)
                remainingSeconds = 120
                countdownTimer?.fire()
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
            }
            codeButton.isEnabled = !newValue
        }
    }
    
    @objc func updateTime(timer: Timer) {
        printX("remainingSeconds===\(remainingSeconds)")
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        countdownTimer?.invalidate()
        countdownTimer = nil
    }
    
    @IBAction func getCode(_ sender: Any) {
        guard validString(phoneTextField.text) != "" else {
            ABCProgressHUD.showErrorWithStatus(string: "请输入手机号码")
            return
        }
        phone = validString(phoneTextField.text)
        ABCProgressHUD.show()
        // 发送验证码
        user.sendCode(phone: validString(phoneTextField.text), type: 3) { (data, error) in
            ABCProgressHUD.dismiss()
            if error == nil {
                ABCProgressHUD.showSuccessWithStatus(string: "验证码发送成功")
                self.isCounting = true
            }else {
                
                let dict = validDictionary(error)
                if validInt(dict["code"]) == APICodeType.CodeRepeat.rawValue {
                    ABCProgressHUD.showErrorWithStatus(string: "请勿重复发送验证码")
                }else {
                    ABCProgressHUD.showErrorWithStatus(string: "发送验证码失败")
                }
            }
        }
    }
    
    @IBAction func changeAction(_ sender: Any) {
        
        //        self.performSegue(withIdentifier: SegueIdentifier.toCommitMessage.rawValue, sender: self)
        
        guard validString(phoneTextField.text) != "" else {
            ABCProgressHUD.showErrorWithStatus(string: "请输入手机号码")
            return
        }
        guard validString(codeTextField.text) != "" else {
            ABCProgressHUD.showErrorWithStatus(string: "请输入验证码")
            return
        }
        guard validString(newPassword.text) != "" else {
            ABCProgressHUD.showErrorWithStatus(string: "请输入密码")
            return
        }
        guard validString(enterPassword.text) != "" else {
            ABCProgressHUD.showErrorWithStatus(string: "请输入确认密码")
            return
        }
        guard validString(newPassword.text) == validString(enterPassword.text) else {
            ABCProgressHUD.showErrorWithStatus(string: "两次密码输入不一样")
            return
        }
        phone = validString(phoneTextField.text)
        ABCProgressHUD.show()
        user.changePassword(phone: phone, verify: validString(codeTextField.text), password: validString(enterPassword.text)) { (data, error) in
            ABCProgressHUD.dismiss()
            if error == nil {
                ABCProgressHUD.showSuccessWithStatus(string: "修改成功")
                self.navigationController?.popViewController(animated: true)
            }else {
                ABCProgressHUD.showErrorWithStatus(string: "修改失败")
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

// MARK: - 跳转
extension TEEForgetPasword: SegueHandlerType {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch validString(segue.identifier) {
        case SegueIdentifier.toCommitMessage.rawValue:
            let destVC = segue.destination as! TEECommitMessageVC
            destVC.user.phone = validString(phoneTextField.text)
            break
        default:
            
            break
        }
    }
}
