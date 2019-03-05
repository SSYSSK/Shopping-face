//
//  TEEAddressVC.swift
//  TEEFit
//
//  Created by 柯木超 on 2018/11/8.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit

class TEEAddressVC: UIViewController {
    
    
    @IBOutlet weak var textField: UITextField!
    
    var saveClick:((_ str:String) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        saveClick?(validString(textField.text))
        self.navigationController?.popViewController(animated: true)
    }
    
}
