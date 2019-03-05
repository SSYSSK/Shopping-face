//
//  SSTTimerUtil.swift
//  sst-ios
//
//  Created by 天星 on 17/3/10.
//  Copyright © 2017年 ios. All rights reserved.
//

import UIKit

let kEveryOneInTwentySecondNotification = NSNotification.Name(rawValue: "EveryOneInTwentySecond")
let kEveryOneSecondNotification = NSNotification.Name(rawValue: "EveryOneSecond")

class ABCTimer {
    
    var alarmCnt = 0
    
    init() {
        let timer = Timer(timeInterval: 0.05, target: self, selector: #selector(didTimerAlarm), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func didTimerAlarm() {
        NotificationCenter.default.post(name: kEveryOneInTwentySecondNotification, object: nil, userInfo:nil)
        alarmCnt = alarmCnt + 1
        if alarmCnt % 20 == 0 { // one second past
            NotificationCenter.default.post(name: kEveryOneSecondNotification, object: nil, userInfo:nil)
        }
        alarmCnt = alarmCnt % 20000
    }
}


