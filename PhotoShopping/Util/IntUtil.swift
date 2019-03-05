//
//  IntUtil.swift
//  sst-ios
//
//  Created by Zal Zhang on 1/13/18.
//  Copyright © 2018 ios. All rights reserved.
//

import UIKit

extension Int64 {
    
    func format(f: Int! = 2) -> String {
        var r = String(self)
        let cnt = f - r.count
        if cnt > 0 {
            var zeros = ""
            for _ in 0 ..< cnt {
                zeros = "0" + zeros
            }
            r = zeros + r
        }
        return r
    }
    
    func toCountdownText(timeUnit: Int64 = 1000) -> String {
        let totalSeconds = self / timeUnit
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60 % 60
        let hours = totalSeconds / 60 / 60 % 24
        let days = totalSeconds / 60 / 60 / 24
        if days <= 0 {
            return "\(hours.format()):\(minutes.format()):\(seconds.format())"
        } else {
            return "\(days) Day\(days > 1 ? "s": "") \(hours.format()):\(minutes.format()):\(seconds.format())"
        }
    }
    
}
