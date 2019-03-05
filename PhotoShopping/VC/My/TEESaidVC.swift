//
//  TEESaidVC.swift
//  TEEAI
//
//  Created by TEE on 2018/12/20.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit

class TEESaidVC: ABCBaseVC {

    @IBOutlet weak var textVIEW: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func commitAction(_ sender: Any) {
        if self.textVIEW.text != "" {
            ABCProgressHUD.show()
            biz.user?.said(message: self.textVIEW.text, callback: { (data, error) in
                if error != nil {
                    ABCProgressHUD.showErrorWithStatus(string: "提交失败")
                }else {
                    ABCProgressHUD.showSuccessWithStatus(string: "感谢您的宝贵建议")
                    TaskUtil.delayExecuting(1, block: {
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            })
        }else {
            ABCProgressHUD.showInfoWithStatus(string: "内容不能为空")
        }
    }
}
