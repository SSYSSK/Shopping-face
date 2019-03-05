//
//  TEEProductVC.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/26.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit

class TEEProductVC: UIViewController {

    var productData = TEEProductData()
    var selectImage = UIImage()
    var clickProduct = TEEProduct()
    
    @IBOutlet weak var navView: UIView!
    @IBOutlet weak var tableView: UITableView!
    enum SegueIdentifier: String {
        case toTEEProductDetailHtml           = "toTEEProductDetailHtml"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let tableHeadView = loadNib("TEETableHeadView") as!  TEETableHeadView
        tableHeadView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 213)
        tableHeadView.iconImageView.image = selectImage
        tableView.tableHeaderView = tableHeadView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension TEEProductVC: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 51))
        let label = UILabel(frame: CGRect(x: 0, y: 10, width: kScreenWidth, height: 40))
        label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor.gray
        label.text = NSLocalizedString("findProduct", comment: "")
       
        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 14)
        view.addSubview(label)
        view.backgroundColor = RGBA(237, g: 222, b: 200, a: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productData.produdtcs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEEProductListCell") as! TEEProductListCell
        cell.product = productData.produdtcs[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        clickProduct = productData.produdtcs[indexPath.row]
        
        if clickProduct.from == "JD" {
            if UIApplication.shared.canOpenURL(URL(fileURLWithPath: "openApp.jdMobile://")) {
                let urlStr = "openApp.jdMobile://virtual?params={\"category\":\"jump\",\"des\":\"productDetail\",\"skuId\":\"\(validString(clickProduct.id))\",\"sourceType\":\"JSHOP_SOURCE_TYPE\",\"sourceValue\":\"JSHOP_SOURCE_VALUE\"}"
                let encodeWord = (urlStr as NSString).addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
                let url = URL(string: encodeWord!)
                UIApplication.shared.open(url!, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            }else {
                self.performSegue(withIdentifier: SegueIdentifier.toTEEProductDetailHtml.rawValue, sender: self)
            }
        }else {
            self.performSegue(withIdentifier: SegueIdentifier.toTEEProductDetailHtml.rawValue, sender: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 51
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
}

// MARK: - 跳转
extension TEEProductVC: SegueHandlerType {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch validString(segue.identifier) {
        case SegueIdentifier.toTEEProductDetailHtml.rawValue:
            let destVC = segue.destination as! TEEProductDetailHtml
            destVC.path = validString(self.clickProduct.url)
            break
        default:
            break
        }
    }
}

