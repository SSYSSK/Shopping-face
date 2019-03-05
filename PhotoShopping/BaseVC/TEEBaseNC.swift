//
//  LHBaseNC.swift
//  LANHU
//
//  Created by 柯木超 on 2018/11/2.
//  Copyright © 2018年 柯木超. All rights reserved.
//

import UIKit

let kNavigationBarForegroundColor = RGBA(193, g: 149, b: 88, a: 1)
let kNavigationBarFont = UIFont.boldSystemFont(ofSize: 16)

class TEEBaseNC: UINavigationController {
    var backButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.isHidden = true
        //在override func viewDidLoad()中调用
        self.setStatusBarBackgroundColor(color: kNavigationBarForegroundColor)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: kNavigationBarFont]
        
        self.navigationBar.tintColor = UIColor.white
        
        //设置导航栏背景颜色
        self.navigationBar.barTintColor = kNavigationBarForegroundColor
        
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        
        self.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
       
//        self.navigationBar.isHidden = true
        
    }
    
    //定义以下方法：
    func setStatusBarBackgroundColor(color : UIColor) {
//        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
//        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = color
//        }
    }
     override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if self.children.count > 0{
            viewController.tabBarController?.tabBar.isHidden=true
            
            //导航栏返回按钮自定义
//            backButton = UIButton(frame:CGRect.init(x:10, y: self.navigationBar.frame.minY, width: self.navigationBar.frame.height/38*24, height: self.navigationBar.frame.height))
//            backButton.imageEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 10)
//            backButton.setImage(UIImage.init(named:"parent_back"), for: UIControl.State.normal)
//            backButton.addTarget(self, action:#selector(self.didBackButton(sender:)), for: UIControl.Event.touchUpInside)
////            backButton.sizeToFit()
//            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView:backButton)
        }
        super.pushViewController(viewController, animated: true)
    }
    
    
    @objc func didBackButton(sender:UIButton){
        self.popViewController(animated:true)
    }

}
