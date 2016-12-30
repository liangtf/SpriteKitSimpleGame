import SpriteKit

enum MonsterCategory : String {
    case Tank = "tank"
    case Chopper = "chopper"
    case Ambulance = "ambulance"
}

struct CrossingDuration {
    static let ChopperMinSpeed_Duration:Float = 6.0
    static let ChopperMaxSpeed_Duration:Float = 5.0
    static let TankMinSpeed_Duration:Float = 8.0
    static let TankMaxSpeed_Duration:Float = 7.0
    static let AmbulanceMinSpeed_Duration:Float = 10.0
    static let AmbulanceMaxSpeed_Duration:Float = 9.0
}

struct WaitingDuration {
    static let TankWaitingDuration:Double = 1.0
    static let ChopperWaitingDuration:Double = 1.5
    static let AmbulanceWaitingDuration:Double = 2.0
}

// images: house, tank, chopper, ambulance

class GameScene: SKScene  {
    
    // create home on the bottom with a house image
    let house = SKSpriteNode(imageNamed: "house")
    let points = SKLabelNode(text: "score: 10")
    let pointCounter = PointCounter()
    
    override func didMove(to view: SKView) {
        
        pointCounter.reset()
        house.name = "house"
        // set background color
        backgroundColor = SKColor.white
        // set position to the center of the bottom line
        house.position = CGPoint(x: size.width * 0.5, y: house.size.height * 0.5)
        // add it to scene
        addChild(house)
        
        // add point label
        points.fontSize = 12
        points.fontColor = SKColor.white
        points.position = CGPoint(x: 0, y: -points.frame.size.height/2 + 2);
        
        let background = SKSpriteNode (color: UIColor.darkGray, size:CGSize(width: points.frame.size.width + 5, height: points.frame.size.height + 2))
        background.position = CGPoint(x:size.width - background.size.width/2 - 10, y: background.size.height/2 + 5 )
        background.addChild( points )
        addChild(background)
        
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({self.addMonster(category: MonsterCategory.Tank)}),
                SKAction.wait(forDuration: WaitingDuration.TankWaitingDuration)
                ])
        ))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({self.addMonster(category: MonsterCategory.Chopper)}),
                SKAction.wait(forDuration: WaitingDuration.ChopperWaitingDuration)
                ])
        ))
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run({self.addMonster(category: MonsterCategory.Ambulance)}),
                SKAction.wait(forDuration: WaitingDuration.AmbulanceWaitingDuration)
                ])
        ))
        
        let backgroundMusic = SKAudioNode(fileNamed: "background-music-aac.caf")
        backgroundMusic.autoplayLooped = true
        addChild(backgroundMusic)
    }
    
    func addMonster(category: MonsterCategory) {
        
        let monsterName:String = category.rawValue
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: monsterName)
        monster.name = monsterName
        
        // Determine where to spawn the monster along the X axis
        var arrayX = [SKSpriteNode]()
        for child in self.children {
            // except house node
            if child is SKSpriteNode && child.name != "house" {
                arrayX.append(child as! SKSpriteNode);
            }
        }
        
        let actualX = MathUtility.getAvailableLocation(Xes: arrayX, screenSize: size, monsterWidth: monster.size.width)
        if actualX == 0 {
            return
        }

        // Position the monster slightly off-screen along the top edge,
        // and along a random position along the X axis as calculated above
        monster.position = CGPoint(x: actualX, y: size.height + monster.size.height/2)
        
        // Add the monster to the scene
        addChild(monster)
        
        var minSpeedDuration:Float = 0.0
        var maxSpeedDuration:Float = 0.0
        
        switch  category {
        case .Tank:
            minSpeedDuration = CrossingDuration.TankMinSpeed_Duration
            maxSpeedDuration = CrossingDuration.TankMaxSpeed_Duration
        case .Chopper:
            minSpeedDuration = CrossingDuration.ChopperMinSpeed_Duration
            maxSpeedDuration = CrossingDuration.ChopperMaxSpeed_Duration
        case .Ambulance:
            minSpeedDuration = CrossingDuration.AmbulanceMinSpeed_Duration
            maxSpeedDuration = CrossingDuration.AmbulanceMaxSpeed_Duration
        }
        
        
        // Determine speed of the monster
        let actualDuration = MathUtility.random(min: CGFloat(minSpeedDuration), max: CGFloat(maxSpeedDuration))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -monster.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.run() {
            if category != MonsterCategory.Ambulance {
                if self.pointCounter.BottomTouched() == false {
                    self.showGameOverScene();
                }
            } else {
                
            }

            self.points.text = "score: " + self.pointCounter.pointCurrent.description
        }
        monster.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let touchLocation = touch.location(in: self)
            let touchedNodes = self.nodes (at: touchLocation)
            for touchedNode in touchedNodes {
                var alive = true
                if touchedNode.name == "tank" {
                    touchedNode.removeFromParent()
//                    print("hit! tank removed.")
                    alive = pointCounter.TankDestoried()
                }else if touchedNode.name == "chopper" {
                    touchedNode.removeFromParent()
//                    print("hit! chopper removed.")
                    alive = pointCounter.ChopperDestoried()
                } else if touchedNode.name == "ambulance" {
                    touchedNode.removeFromParent()
//                    print("hit! GameOver.")
                    alive = pointCounter.AmbulanceDestoried()
                }
                self.points.text = "score: " + self.pointCounter.pointCurrent.description
                if alive == false {
                    showGameOverScene();
                    return;
                }
            }
        }
    }
    
    func showGameOverScene() {
        let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
        let gameOverScene = GameOverScene(size: self.size, won: false)
        self.view?.presentScene(gameOverScene, transition: reveal)
    }
    
}

