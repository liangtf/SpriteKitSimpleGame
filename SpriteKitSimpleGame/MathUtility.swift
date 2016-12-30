//
//  MathUtility.swift
//  SpriteKitSimpleGame
//
//  Created by Steve on 30/12/16.
//  Copyright © 2016 Steve. All rights reserved.
//

import SpriteKit

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

class MathUtility  {
    static func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let result = random() * (max - min) + min
//        print("min: " + min.description + " max:" + max.description + " result: " + result.description)
        return result
    }
    
    static func random_int(min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max))) + min
    }
    
    static func getAvailableLocation( Xes: [SKSpriteNode],screenSize: CGSize, monsterWidth: CGFloat) -> CGFloat {
        var Xes = Xes
        var actualX :CGFloat = 0.0
        var arrayActualX = [CGFloat]()
        if Xes.count > 0 {
            // find a place that has enough space for a monster.
            Xes.sort(by: { $0.position.x < $1.position.x })
            
            //            dump(arrayX)
            
//            print("The objects are on screen >>>")
//            for child in Xes {
//                print(child.position.x)
//            }
//            print("<<<<<<<")
            for i in 0...Xes.count - 1 {
                if i == 0 && Xes[i].position.x - Xes[i].size.width/2 - monsterWidth > 0 {
                    // first node on the left side
                    // there is a spot for a monster from left edge to first node?
                    arrayActualX.append(random(min: 0 + monsterWidth/2,
                                               max: Xes[i].position.x - Xes[i].size.width/2 - monsterWidth/2))
                }
                
                if i == Xes.count - 1 && screenSize.width - Xes[i].position.x - Xes[i].size.width/2 - monsterWidth > 0 {
                    // last node on the right side
                    // there is a spot for a monster from last node to right edge?
                    arrayActualX.append(random(min: Xes[i].position.x + Xes[i].size.width/2 + monsterWidth/2,
                                               max: screenSize.width - monsterWidth/2))
                    
                }
                
                if Xes.count > 1 && i != Xes.count - 1 && Xes[i+1].position.x - Xes[i].position.x - Xes[i+1].size.width/2 - Xes[i].size.width/2 - monsterWidth > 0 {
                    // the node between two nodes
                    // there is a spot for a monster from left node to right node
                    arrayActualX.append(random(min: Xes[i].position.x + Xes[i].size.width/2 + monsterWidth/2,
                                               max: Xes[i+1].position.x - Xes[i+1].size.width/2 - monsterWidth / 2))
                }
            }
            
            if arrayActualX.count > 0 {
//                print("The objects will be on screen =====")
//                dump(arrayActualX)
                // which node should we do?
                let rndidx = random_int(min: 1, max: arrayActualX.count )
//                print(rndidx)
                actualX = arrayActualX[rndidx-1]
//                print(actualX)
//                print("=====")
            } else {
//                print("WARNING==== WARNING=== WARNING... NO ENOUGH SPACE")
                actualX = 0.0
            }
            
        }
        else {
            actualX = random(min: monsterWidth/2, max: screenSize.width - monsterWidth/2)
        }
        return actualX;
    }
    
}
