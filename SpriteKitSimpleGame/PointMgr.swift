//
//  PointMgr.swift
//  SpriteKitSimpleGame
//
//  Created by Steve on 28/12/16.
//  Copyright © 2016 Steve. All rights reserved.
//

import Foundation


class PointMgr {
    let pointInit = 10;
    let pointTank = 1;
    let pointChopper = 3;
    let pointLost = -10;
    var pointCurrent = 10;
    
    func reset() -> Bool {
        pointCurrent = pointInit
        return true
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
        pointCurrent = 0
        return pointCurrent > 0
    }
    
    func BottomTouched() -> Bool {
        pointCurrent += pointLost
        return pointCurrent > 0
    }
}
