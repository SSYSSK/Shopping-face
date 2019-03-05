//
//  TEECenterVC.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/26.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit

class TEECenterVC: UIViewController {

    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    enum SegueIdentifier: String {
        case toTEEMyCenter           = "toTEEMyCenterVC"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImageView.setImageWithImage(fileUrl: validString(biz.user?.iconPath), placeImage: UIImage(named: "boy"))
        
        if biz.user?.nickName != nil {
            nameLabel.text = biz.user?.nickName
        }else {
            nameLabel.text = "昵称为空"
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(iconAction))
        
        iconImageView.isUserInteractionEnabled = true
        iconImageView.addGestureRecognizer(tap)
    }
    
    @objc func iconAction() {
        self.performSegue(withIdentifier: SegueIdentifier.toTEEMyCenter.rawValue, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        btn1.layer.masksToBounds = true
        btn1.layer.cornerRadius=btn1.width / 2  //变圆形
        btn2.layer.masksToBounds = true
        btn2.layer.cornerRadius=btn1.width / 2  //变圆形
        btn3.layer.masksToBounds = true
        btn3.layer.cornerRadius=btn1.width / 2  //变圆形
        btn4.layer.masksToBounds = true
        btn4.layer.cornerRadius=btn1.width / 2  //变圆形
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
