//
//  TEEProduct.swift
//  PhotoShopping
//
//  Created by TEE on 2019/1/11.
//  Copyright © 2019 TEE. All rights reserved.
//

import UIKit
import ObjectMapper

let kGoodsFrom      = "from"
let kGoodsId        = "gid"
let kGoodsIcon      = "image"
let kCommList       = "item"
let kGoodsName      = "name"
let kGoodsPrice     = "price"
let kGoodsUrl       = "url"
class TEEProduct: BaseModel {
    
    var id: String?
    var icon: String?
    var from: String?
    var name: String?
    var price: Double! = 0
    var url: String?
    var commList = [TEEProduct]()
    
    override init() {
        super.init()
    }
    required init?(map: Map) {
        super.init(map: map)!
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id        <- map[kGoodsId]
        from      <- map[kGoodsFrom]
        icon      <- map[kGoodsIcon]
        name      <- map[kGoodsName]
        price     <- map[kGoodsPrice]
        url       <- map[kGoodsUrl]
        self.setCommList(validNSArray(map.JSON[kCommList]))
    }
    
    func setCommList(_ arr: NSArray) {
        for commDict in arr {
            if let product = TEEProduct(JSON: validDictionary(commDict)) {
                commList.append(product)
            }
        }
    }
}
