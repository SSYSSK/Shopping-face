//
//  DataUtil.swift
//  sst-ios
//
//  Created by Zal Zhang on 12/29/17.
//  Copyright © 2017 ios. All rights reserved.
//

import UIKit

let kAttributeOptions: [NSAttributedString.DocumentReadingOptionKey : Any] = [
    NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
    NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
]

extension Data {
    func toAttributedString() -> NSAttributedString {
        do {
            return try NSAttributedString(data: self, options: kAttributeOptions, documentAttributes: nil)
        } catch {
            printX("Error: attributedString")
        }
        return NSAttributedString()
    }
}

