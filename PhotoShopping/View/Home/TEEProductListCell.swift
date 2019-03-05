//
//  TEEProductListCell.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/28.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit

class TEEProductListCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var productIconImageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var fromIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    var product: TEEProduct!{
        didSet{
            nameLabel.text = product.name
            productIconImageView.setImageWithImage(fileUrl: validString(product.icon), placeImage: UIImage(named: loadingImage))
            priceLabel.text = "\(NSLocalizedString("price", comment: ""))\(validString(product.price))"
            switch validString(product.from) {
            case "JD":
                fromIconImageView.image = UIImage(named: "jingdong")
            default:
                fromIconImageView.image = UIImage(named: "taobao")
            }
        }
    }
    
}
