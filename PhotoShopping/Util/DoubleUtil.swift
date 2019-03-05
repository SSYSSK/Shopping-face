//
//  DoubleUtil.swift
//  sst-ios-po
//
//  Created by Zal Zhang on 12/28/16.
//  Copyright © 2016 po. All rights reserved.
//

import UIKit

extension Double {
    
    func formatMoney(f: String = ".3") -> String {
        let moneyString = String(format: "%\(f)f", self + kOneInMillion)
        return moneyString.sub(start: 0, end: moneyString.count - 2)
    }
    
    func formatC(f: String = ".2") -> String {
        let precision = validInt(validDouble(f) * 10)
        return "¥ \(formatWithThousand(precision: precision))"
    }
    
    func formatCWithoutCurrency(f: String = ".2") -> String {
        let precision = validInt(validDouble(f) * 10)
        return formatWithThousand(precision: precision)
    }
    
    func equalZero() -> Bool {
        if self < 0.000001 {
            return true
        } else {
            return false
        }
    }
    
    func equal(_ b: Double) -> Bool {
        if fabs(self - b) < kOneInMillion {
            return true
        } else {
            return false
        }
    }
    
    func formatWithThousand(precision: Int) -> String {
        var dbValue = self
        if abs(self) < kOneInMillion {
            dbValue = 0
        }
        let formatter = NumberFormatter()
        if(precision == 0) {
            let format = NSMutableString(string: "###,##0")
            formatter.positiveFormat = format as String
            return validString(formatter.string(from: NSNumber(value: dbValue)))
        } else {
            let format = NSMutableString(string: "###,##0.")
            for _ in 1 ... precision {
                format.appendFormat("0")
            }
            formatter.positiveFormat = format as String
            return validString(formatter.string(from: NSNumber(value: dbValue)))
        }
    }
    
}
