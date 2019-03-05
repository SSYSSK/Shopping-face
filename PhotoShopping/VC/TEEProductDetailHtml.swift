//
//  TEEProductDetailHtml.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/28.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit
import WebKit

class TEEProductDetailHtml: UIViewController {
    let webview = WKWebView()
    var path = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        //创建wkwebview
        webview.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        //创建网址
        let url = NSURL(string: path)
        //创建请求
        let request = NSURLRequest(url: url! as URL)
        //加载请求
        webview.load(request as URLRequest)
        //添加wkwebview
        self.view.addSubview(webview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
}
