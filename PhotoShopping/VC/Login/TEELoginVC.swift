//
//  TEELoginVC.swift
//  TEEFit
//
//  Created by 柯木超 on 2018/11/2.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit

class TEELoginVC: ABCBaseVC {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var phoneLoginbutton: UIButton!
    
    enum SegueIdentifier: String {
        case toPhoneLogin           = "toPhoneLoginVC"
        case toTEERegistion     = "toRegistionVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        registerButton.layer.borderWidth = 1;
//        registerButton.layer.borderColor = RGBA(211, g: 172, b: 1, a: 1).cgColor
        
//        phoneLoginbutton.layer.borderWidth = 1;
//        phoneLoginbutton.layer.borderColor = RGBA(211, g: 172, b: 1, a: 1).cgColor
        
    }
    
    @IBAction func phoneLoginAction(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifier.toPhoneLogin.rawValue, sender: self)
    }
    
    @IBAction func registionAction(_ sender: Any) {
        self.performSegue(withIdentifier: SegueIdentifier.toTEERegistion.rawValue, sender: self)
    }
    
    @IBAction func gotoHome(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
