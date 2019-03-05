//
//  TEEChangeMessageVC.swift
//  TEEAI
//
//  Created by TEE on 2018/12/21.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit

class TEEChangeMessageVC: ABCBaseVC {

    @IBOutlet weak var tableView: UITableView!
    
    var image = UIImage(named: "boy")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        choseImage()
    }

}

extension TEEChangeMessageVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 97
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topcell") as! MyTopChangeCell
            cell.iconImageView.setImageWithImage(fileUrl: validString(biz.user?.iconPath), placeImage: UIImage(named: "boy"))
            return cell
        }else {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "nicknameCell")
                let label = cell?.viewWithTag(100) as! UILabel
                if validString(biz.user?.nickName) == "" {
                    label.text = "昵称为空"
                }else {
                    label.text = biz.user?.nickName
                }
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell")
                let label = cell?.viewWithTag(101) as! UILabel
                if validString(biz.user?.phone) == "" {
                    label.text = "手机为空"
                }else {
                    label.text = biz.user?.phone
                }
                return cell!
            default:
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 15))
        view.backgroundColor = RGBA(237, g: 222, b: 200, a: 1)
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            choseIcon()
        }else {
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "toChangeNickNameVC", sender: self)
            }
        }
    }
    
}

// MARK:-- 相机操作
extension TEEChangeMessageVC {
    
    @objc func choseIcon(){
        self.choseCamera(1)
    }
    
    func choseImage(){
        // 图片设置
        KiClipperHelper.sharedInstance.clipperType = .Move
        KiClipperHelper.sharedInstance.systemEditing = false
        KiClipperHelper.sharedInstance.isSystemType = false
        KiClipperHelper.sharedInstance.nav = self.navigationController
        KiClipperHelper.sharedInstance.clippedImgSize = CGSize(width: 200, height: 200)
        
        KiClipperHelper.sharedInstance.clippedImageHandler = {img in
            ABCProgressHUD.show()
            biz.uploadFile(image: img, callback: {(data, error) in
                printX(data)
                printX(error)
                if error != nil {
                    self.image = UIImage(named: "user_icon_default")
                    ABCProgressHUD.showErrorWithStatus(string: "图片上传失败")
                }else {
                    ABCProgressHUD.showSuccessWithStatus(string: "图片上传成功")
                    self.image = img
                    let dict = validDictionary(data)
                    setUserDefautsData(kUserIcon, value: validString(dict["msg"]))
                    biz.user?.iconPath = validString(dict["msg"])
                }
                self.tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
            })
        }
    }
    
    
    func choseCamera(_ maxSelectedCount:Int){
        let iconActionSheet: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        iconActionSheet.addAction(UIAlertAction(title:NSLocalizedString("camera", comment: ""), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            openCamera()
        }))
        iconActionSheet.addAction(UIAlertAction(title:NSLocalizedString("album", comment: ""), style: UIAlertAction.Style.default, handler: { (UIAlertAction) in
            openPhotoLibrary(maxSelectedCount)
            
        }))
        iconActionSheet.addAction(UIAlertAction(title:NSLocalizedString("cancel", comment: ""), style: UIAlertAction.Style.cancel, handler:nil))
        self.present(iconActionSheet, animated: true, completion: nil)
    }
}
