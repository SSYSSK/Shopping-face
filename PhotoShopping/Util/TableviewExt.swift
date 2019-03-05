//
//  TableviewExt.swift
//  sst-ios
//
//  Created by Zal Zhang on 1/14/17.
//  Copyright © 2017 ios. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ cell: T.Type) -> T? {
        if let cell = dequeueReusableCell(withIdentifier: "\(T.classForCoder())") {
            return cell as? T
        }
        return nil
    }
    
    func creanLine(){
        //去掉没有数据显示部分多余的分隔线
        self.tableFooterView =  UIView.init(frame: CGRect.zero)
        //将分隔线offset设为零，即将分割线拉满屏幕
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //设置分隔线颜色
        self.separatorColor = RGBA(170, g: 170, b: 170, a: 1)
    }
}
