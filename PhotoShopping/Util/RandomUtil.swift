//
//  RandomUtil.swift
//  sst-ios
//
//  Created by Zal Zhang on 12/29/17.
//  Copyright © 2017 ios. All rights reserved.
//

import Foundation

class RandomUtil {
    
    static func randomUInt32(_ upperBound: UInt32) -> UInt32 {
        return arc4random_uniform(upperBound)
    }
    
    static func randomInt(_ upperBound: UInt32) -> Int {
        return validInt(randomUInt32(upperBound))
    }
}

