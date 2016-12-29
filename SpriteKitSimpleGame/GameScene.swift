import SpriteKit

//struct PhysicsCategory {
//    static let None      : UInt32 = 0
//    static let All       : UInt32 = UInt32.max
//    static let Monster   : UInt32 = 0b1       // 1
//    static let Projectile: UInt32 = 0b10      // 2
//}

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

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

// images: house, tank, chopper, ambulance

// SKPhysicsContactDelegate
class GameScene: SKScene  {
    
    // create home on the bottom with a house image
    let house = SKSpriteNode(imageNamed: "house")
    
    override func didMove(to view: SKView) {
        
        house.name = "house"
        // set background color
        backgroundColor = SKColor.white
        // set position to the center of the bottom line
        house.position = CGPoint(x: size.width * 0.5, y: house.size.height * 0.5)
        // add it to scene
        addChild(house)
        

        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addTank),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addChopper),
                SKAction.wait(forDuration: 1.5)
                ])
        ))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addAmbulance),
                SKAction.wait(forDuration: 2.0)
                ])
        ))
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        let result = random() * (max - min) + min
        print("min: " + min.description + " max:" + max.description + " result: " + result.description)
        return result
    }
    
    func random_int(min: Int, max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max))) + min
    }
    
    func getAvailableLocation( Xes: [SKSpriteNode],width: CGFloat) -> CGFloat {
        var Xes = Xes
        var actualX :CGFloat = 0.0
        var arrayActualX = [CGFloat]()
        if Xes.count > 0 {
            // find a place that has enough space for a monster.
            Xes.sort(by: { $0.position.x < $1.position.x })

            //            dump(arrayX)
            
            print("The objects are on screen >>>")
            for child in Xes {
                print(child.position.x)
            }
            print("<<<<<<<")
            for i in 0...Xes.count - 1 {
                if i == 0 && Xes[i].position.x - Xes[i].size.width/2 - width > 0 {
                    arrayActualX.append(random(min: 0 + width/2,
                                               max: Xes[i].position.x - Xes[i].size.width/2 - width/2))
                }
                
                if i == Xes.count - 1 && size.width - Xes[i].position.x - Xes[i].size.width/2 - width > 0 {
                    arrayActualX.append(random(min: Xes[i].position.x + Xes[i].size.width/2 + width/2,
                                               max: size.width - width/2))
                    
                }
                
                if Xes.count > 1 && i != Xes.count - 1 && Xes[i+1].position.x - Xes[i].position.x - Xes[i+1].size.width/2 - Xes[i].size.width/2 - width > 0 {
                    arrayActualX.append(random(min: Xes[i].position.x + Xes[i].size.width/2 + width/2,
                                               max: Xes[i+1].position.x - Xes[i+1].size.width/2 - width / 2))
                }
            }
            
            if arrayActualX.count > 0 {
                print("The objects will be on screen =====")
                dump(arrayActualX)
                let rndidx = random_int(min: 1, max: arrayActualX.count )
                print(rndidx)
                actualX = arrayActualX[rndidx-1]
                print(actualX)
                print("=====")
            } else {
                print("WARNING==== WARNING=== WARNING... NO ENOUGH SPACE")
                actualX = 0.0
            }
            
        }
        else {
            actualX = random(min: width/2, max: size.width - width/2)
        }
        return actualX;
    }
    
    
    func addTank() {
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "tank")
        monster.name = "tank"
        // Determine where to spawn the monster along the Y axis
//        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        var arrayX = [SKSpriteNode]()
        for child in self.children {
            if child is SKSpriteNode && child.name != "house" {
                arrayX.append(child as! SKSpriteNode);
            }
        }
        
        let actualX = getAvailableLocation(Xes: arrayX, width: monster.size.width)
        if actualX == 0 {
            return
        }

        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: actualX, y: size.height + monster.size.height/2)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(5.0), max: CGFloat(6.0))
        
        // Create the actions
//        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -monster.size.height/2), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() {
            // points decrease
//            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
//            let gameOverScene = GameOverScene(size: self.size, won: false)
//            self.view?.presentScene(gameOverScene, transition: reveal)
            // check points
            
            //
        }
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
    }
    
    
    func addChopper() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "chopper")
        monster.name = "chopper"
        // Determine where to spawn the monster along the Y axis
        //        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)

        var arrayX = [SKSpriteNode]()
        for child in self.children {
            if child is SKSpriteNode && child.name != "house" {
                arrayX.append(child as! SKSpriteNode);
            }
        }
        
        let actualX = getAvailableLocation(Xes: arrayX, width: monster.size.width)
        if actualX == 0 {
            return
        }
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: actualX, y: size.height + monster.size.height/2)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(4.0))
        
        // Create the actions
        //        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -monster.size.height/2), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() {
            //            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            //            let gameOverScene = GameOverScene(size: self.size, won: false)
            //            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
    }
    
    func addAmbulance() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "ambulance")
        monster.name = "ambulance"
        // Determine where to spawn the monster along the Y axis
        //        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        var arrayX = [SKSpriteNode]()
        for child in self.children {
            if child is SKSpriteNode && child.name != "house" {
                arrayX.append(child as! SKSpriteNode);
            }
        }
        
        let actualX = getAvailableLocation(Xes: arrayX, width: monster.size.width)
        if actualX == 0 {
            return
        }
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: actualX, y: size.height + monster.size.height/2)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(7.0), max: CGFloat(8.0))
        
        // Create the actions
        //        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -monster.size.height/2), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() {
            //            let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
            //            let gameOverScene = GameOverScene(size: self.size, won: false)
            //            self.view?.presentScene(gameOverScene, transition: reveal)
        }
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            let touchedNodes = self.nodes (at: touchLocation)
            for touchedNode in touchedNodes {
                if touchedNode.name == "tank" {
                    touchedNode.removeFromParent()
                    print("hit! tank removed.")
                }
                
                if touchedNode.name == "chopper" {
                    touchedNode.removeFromParent()
                    print("hit! chopper removed.")
                }
                
                if touchedNode.name == "ambulance" {
                    touchedNode.removeFromParent()
                    print("hit! GameOver.")
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameOverScene = GameOverScene(size: self.size, won: false)
                    self.view?.presentScene(gameOverScene, transition: reveal)
                }
                
            }
        }
    }
    
}

