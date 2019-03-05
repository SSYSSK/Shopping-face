//
//  MyTopCell.swift
//  TEEAI
//
//  Created by TEE on 2018/12/20.
//  Copyright © 2018 柯木超. All rights reserved.
//

import UIKit

class MyTopCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLame: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImageView.setImageWithImage(fileUrl: validString(biz.user?.iconPath), placeImage: UIImage(named: "boy"))
        
        if validString(biz.user?.nickName) == "" {
            nameLame.text = "这个人很懒，啥都没写"
        }else{
            nameLame.text = biz.user?.nickName
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
