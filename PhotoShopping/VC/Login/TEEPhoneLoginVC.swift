//
//  TEEPhoneLoginVC.swift
//  TEEFit
//
//  Created by 柯木超 on 2018/11/6.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit
let NotifyReloadData = "NotifyReloadData"
class TEEPhoneLoginVC: ABCBaseVC {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var pasTextField: UITextField!
    let user = TEEUser()
    var relogBlock:(() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func forgetPasAction(_ sender: Any) {
        self.performSegue(withIdentifier: "toTEEForgetPasword", sender: self)
        
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        loginButton.setTitle("登陆中...", for: UIControl.State.normal)
        loginButton.isUserInteractionEnabled = false
        user.login(phone: validString(phoneTextField.text), password: validString(pasTextField.text)) {[weak self](data, error) in
            if error == nil {
                 self?.loginButton.isUserInteractionEnabled = true
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotifyReloadData), object: nil, userInfo: nil)
                self?.navigationController?.dismiss(animated: true, completion: {
                    self?.relogBlock?()
                    })
            }else {
                 self?.loginButton.isUserInteractionEnabled = true
                 self?.loginButton.setTitle("登陆", for: UIControl.State.normal)
                 ABCProgressHUD.showErrorWithStatus(string: "用户名或密码错误")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}
