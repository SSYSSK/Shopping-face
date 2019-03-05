//
//  TEEChangeNickNameVC.swift
//  TEEAI
//
//  Created by TEE on 2018/12/21.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit

class TEEChangeNickNameVC: ABCBaseVC {

    @IBOutlet weak var nickNameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        nickNameTextField.text = biz.user?.nickName
    }
    
    @IBAction func saveAction(_ sender: Any) {
        biz.user?.changeNickName(name: validString(self.nickNameTextField.text), callback: { (data, error) in
            if error != nil {
                ABCProgressHUD.showErrorWithStatus(string: "修改失败")
            }else {
                biz.user?.nickName = validString(self.nickNameTextField.text)
                ABCProgressHUD.showSuccessWithStatus(string: "修改成功")
                TaskUtil.delayExecuting(1, block: {
                    let vcCnt = validInt(self.navigationController?.viewControllers.count)
                    for ind in 0 ..< vcCnt {
                        if let changeMessageVC = self.navigationController?.viewControllers.validObjectAtIndex(ind) as? TEEChangeMessageVC {
                            changeMessageVC.tableView.reloadData()
                            self.navigationController?.popToViewController(changeMessageVC, animated: true)
                            return
                        }
                    }
                })
            }
        })
    }
}
