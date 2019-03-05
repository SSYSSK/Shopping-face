//
//  BaseModel.swift
//  sst-ios
//
//  Created by Zal Zhang on 12/26/16.
//  Copyright © 2016 po. All rights reserved.
//

import UIKit
import ObjectMapper

typealias Map = ObjectMapper.Map

// MARK: - URLStringConvertible

/**
 Types adopting the `URLStringConvertible` protocol can be used to construct URL strings, which are then used to
 construct URL requests.
 */
public protocol URLStringConvertible {
    /**
     A URL that conforms to RFC 2396.
     
     Methods accepting a `URLStringConvertible` type parameter parse it according to RFCs 1738 and 1808.
     
     See https://tools.ietf.org/html/rfc2396
     See https://tools.ietf.org/html/rfc1738
     See https://tools.ietf.org/html/rfc1808
     */
    var URLString: String { get }
}

protocol SSTUIRefreshDelegate: class {
    func refreshUI(_ data: Any?)
}

class BaseModel: Mappable {
    
    weak var delegate: SSTUIRefreshDelegate?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {}
    
    let transformIntToString = TransformOf<String, Int> (
        fromJSON: { (value: Int?) -> String? in
            return validString(value)
    },
        toJSON: { (value: String?) -> Int? in
            if let value = value {
                return Int(value)
            }
            return nil
    })
    
    let transformStringToInt = TransformOf<Int, String> (
        fromJSON: { (value: String?) -> Int? in
            return validInt(value)
    },
        toJSON: { (value: Int?) -> String? in
            if let value = value {
                return String(value)
            }
            return nil
    })
    
    
    let transformNSNumberToInt64 = TransformOf<Int64, NSNumber> (
        fromJSON: { (value: NSNumber?) -> Int64? in
            return validInt64(value)
    },
        toJSON: { (value: Int64?) -> NSNumber? in
            if let value = value {
                return NSNumber(value: value as Int64)
            }
            return nil
    })
    
    let transformStringToDate = TransformOf<Date,String> (
        fromJSON: { value in
            if value == nil {
                return nil
            } else {
                return Date.fromString(value!)
            }
    },
        toJSON: { value in
            if value == nil {
                return nil
            }
            return value!.format()
    })
}
