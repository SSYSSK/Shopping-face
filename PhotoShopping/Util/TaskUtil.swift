//
//  TaskUtil.swift
//  sst-ios-po
//
//  Created by Zal Zhang on 12/28/16.
//  Copyright © 2016 po. All rights reserved.
//

import UIKit

typealias AsynTask = (_ cancel: Bool) -> Void

class TaskUtil {
    
    @discardableResult
    static func delayExecuting(_ time: TimeInterval, block: @escaping () -> ()) -> AsynTask? {
        
        func dispatch_later(block: @escaping () -> ()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        
        var closure: (()->Void)? = block
        var result: AsynTask?
        
        let delayedClosure: AsynTask = { cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        
        result = delayedClosure
        
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        
        return result
    }
    
    static func cancel(_ asynTask: AsynTask?) {
        asynTask?(true)
    }
    
}
