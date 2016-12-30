//
//  PointMgr.swift
//  SpriteKitSimpleGame
//
//  Created by Steve on 28/12/16.
//  Copyright © 2016 Steve. All rights reserved.
//

import Foundation


class PointCounter {
    let pointInit = 10;
    let pointTank = 1;
    let pointChopper = 3;
    let pointLost = -10;
    var pointCurrent = 10;
    
    func reset() {
        pointCurrent = pointInit
    }
    
    func TankDestoried() -> Bool {
        pointCurrent += pointTank
        return true
    }
    
    func ChopperDestoried() -> Bool {
        pointCurrent += pointChopper
        return true
    }
    
    func AmbulanceDestoried() -> Bool {
        pointCurrent = -1
        return pointCurrent >= 0
    }
    
    func BottomTouched() -> Bool {
        pointCurrent += pointLost
        return pointCurrent >= 0
    }
}
