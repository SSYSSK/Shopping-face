//
//  TEEProductView.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/15.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit

class TEEProductView: UIView {
    var productViewClick:((_ product:TEEProduct) -> Void)?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var product: TEEProduct!{
        didSet{
            nameLabel.text = validString(product.name)
            priceLabel.text = "\(NSLocalizedString("price", comment: ""))  \(validString(product.price.formatC()))"
            fromLabel.text = validString(product.from)
            iconImageView.setImageWithImage(fileUrl: validString(product.icon), placeImage: UIImage(named: "tee_loading"))
        }
    }
    
    @IBAction func click(_ sender: Any) {
        productViewClick?(product)
    }
}
