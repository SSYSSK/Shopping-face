//
//  TEEProductCell.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/11.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit

class TEEProductCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var product:TEEProduct! {
        didSet{
            nameLabel.text = validString(product.name)
            priceLabel.text = validString(product.price)
            fromLabel.text = validString(product.from)
            iconImageView.setImageWithImage(fileUrl: validString(product.icon), placeImage: UIImage(named: "1234"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
