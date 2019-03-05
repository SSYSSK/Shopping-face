//
//  SSTBaseViewController.swift
//  sst-mobile
//
//  Created by Amy on 16/4/12.
//  Copyright © 2016年 lzhang. All rights reserved.
//

import UIKit

let kBackButtonRect = CGRect(x: 0, y: 0, width: 25, height: 28)

// MARK: - SegueHandlerType

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegueWithIdentifier(_ identifier:SegueIdentifier, sender:AnyObject?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(_ segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            printDebug("Error: Invalid Segue Identifier: \(validString(segue.identifier))")
            return SegueIdentifier(rawValue: "")!
        }
        return segueIdentifier
    }
}

// MARK: - SSTBaseVC

class ABCBaseVC: UIViewController {

    // 收起键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    deinit {
        printX("=====================释放类=================\(self.classForCoder)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        ABCProgressHUD.dismiss()
    }

}
