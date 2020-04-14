//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Javed Siddique on 03/04/20.
//  Copyright © 2020 Javed. All rights reserved.
//

import SpriteKit
enum  PlayColors {
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState : Int{
    case red,yellow,green,blue
}

class GameScene: SKScene {
    
    var colorSwitch : SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex : Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score : Int = 0
    
    override func didMove(to view: SKView) {
        setUpPhysics()
        layoutScene()
    }
    func setUpPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -1.0)
        physicsWorld.contactDelegate = self
    }
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 88/255, alpha: 1.0)
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.width/3, height: frame.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY+colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCatgories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        scoreLabel.fontName = "Helvetica-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        spawnBall()
    }
    
    func updateScoreLabe(){
        scoreLabel.text = "\(score)"
    }
    func spawnBall(){
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30, height: 30))
        //ball.size = CGSize(width: 30, height: 30)
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY - 30)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCatgories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCatgories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCatgories.none
        addChild(ball)
    }
    
    func turnWheel(){
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = newState
        }else{
            switchState = .red
        }
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func gameOver(){
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "HighScore"){
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view?.presentScene(menuScene)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        turnWheel()
    }
}
extension GameScene : SKPhysicsContactDelegate{
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCatgories.ballCategory | PhysicsCatgories.switchCategory{
            if let ball = contact.bodyA.node?.name == "Ball" ?  contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue{
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    score += 1
                    updateScoreLabe()
                    ball.run(SKAction.fadeOut(withDuration: 0.25),completion: {
                        ball.removeFromParent()
                        self.spawnBall()
                    })
                }else{
                    run(SKAction.playSoundFileNamed("game_over", waitForCompletion: false))
                    gameOver()
                }
            }
        }
    }
}
