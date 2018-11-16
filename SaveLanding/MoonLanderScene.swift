//  Created by Nikola Lajic on 11/23/17.
//  Copyright © 2017 ___ORGANIZATIONNAME___. All rights reserved.

import Foundation
import SpriteKit

private struct Categories {
    static let wall: UInt32 = 1
    static let platform: UInt32 = 1 << 1
}

class MoonLanderScene: SKScene {
    lazy var rocket: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "起飞火箭")
        node.zPosition = 30
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.angularDamping = 5
        node.physicsBody?.contactTestBitMask = Categories.wall
        return node
    }()
    lazy var land: SKSpriteNode = {
        let land = SKSpriteNode(imageNamed: "陆地1")
        land.zPosition = 30
        land.physicsBody = SKPhysicsBody(rectangleOf: land.frame.size)
        land.physicsBody?.isDynamic = false
        land.physicsBody?.contactTestBitMask = Categories.platform
        return land
    }()
    
    var gameSocre:Int = 0 {
        didSet {
            scoreLabel.text = "当前得分: \(gameSocre)"
        }
    }
    
    lazy var scoreLabel: SKLabelNode = {
        let scoreLabel = SKLabelNode(text: "当前得分: 0")
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 66
        scoreLabel.fontColor = UIColor(red: 70/255.0, green: 26/255.0, blue: 0, alpha: 1)
        scoreLabel.zPosition = 10
        scoreLabel.fontSize = 20
        return scoreLabel
    }()
    
    let padding: CGFloat = 40
    let rotation: CGFloat = 0.01//1
    let boost: CGFloat = 40
    var left: SKSpriteNode!
    var right: SKSpriteNode!
    var fire: SKSpriteNode!
    var win: SKLabelNode?
    
    var gameOverShow = false
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        physicsWorld.contactDelegate = self
        
        let level = GameConfig.shared.gameLevel
        if level == .Easy {
            physicsWorld.gravity = CGVector(dx: 0, dy: -1)
        }else if level == .Diff {
            physicsWorld.gravity = CGVector(dx: 0, dy: -1.5)
        }else  {
            physicsWorld.gravity = CGVector(dx: 0, dy: -2)
        }
        
        addRocket()
        addPlatform()
        setupGUI()
        setupWalls()
    }
    
    func setupWalls() {
        let leftWall = SKShapeNode()
        leftWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: 0, y: frame.maxY))
        leftWall.physicsBody?.contactTestBitMask = Categories.wall
        addChild(leftWall)
        
        let rightWall = SKShapeNode()
        rightWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: frame.maxX, y: 0), to: CGPoint(x: frame.maxX, y: frame.maxY))
        rightWall.physicsBody?.contactTestBitMask = Categories.wall
        addChild(rightWall)
        
        let topWall = SKShapeNode()
        topWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: frame.maxY), to: CGPoint(x: frame.maxX, y: frame.maxY))
        topWall.physicsBody?.contactTestBitMask = Categories.wall
        addChild(topWall)
        
        let bottomWall = SKShapeNode()
        bottomWall.physicsBody = SKPhysicsBody(edgeFrom: CGPoint(x: 0, y: 0), to: CGPoint(x: frame.maxX, y: 0))
        bottomWall.physicsBody?.contactTestBitMask = Categories.wall
        addChild(bottomWall)
    }
    
    func addPlatform() {
        if land.parent == nil {
            let x: CGFloat = land.size.width + CGFloat(arc4random_uniform(UInt32(frame.maxX - land.size.width * 2)))
            land.position = CGPoint(x: x, y: 120)
            addChild(land)
        }
    }
    
    func addRocket() {
        if rocket.parent == nil {
            let x: CGFloat = rocket.size.width + CGFloat(arc4random_uniform(UInt32(frame.maxX - rocket.size.width * 2)))
            rocket.texture = SKTexture(image: #imageLiteral(resourceName: "起飞火箭"))
            rocket.position = CGPoint(x: x, y: frame.maxY - rocket.size.height)
            rocket.zRotation = 0
            addChild(rocket)
        }
    }
    
    func setupGUI() {
        let background = SKShapeNode(rect: CGRect(x: 0, y: 0, width: frame.width, height: 100))
        background.fillColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        background.strokeColor = UIColor.clear
        addChild(background)
        
        let bgNode = SKSpriteNode(imageNamed: "游戏页面1")
        bgNode.size = CGSize(width: frame.width, height: frame.height)
        bgNode.position = CGPoint(x: frame.width/2, y: frame.height/2)
        bgNode.zPosition = 0
        addChild(bgNode)
        
        left = SKSpriteNode(imageNamed: "左移")
        left.zPosition = 1
        left.color = UIColor.white
        left.position = CGPoint(x: frame.minX + padding, y: padding)
        addChild(left)
        
        right = SKSpriteNode(imageNamed: "右移")
        right.zPosition = 1
        right.color = UIColor.white
        right.position = CGPoint(x: frame.maxX - padding, y: padding)
        addChild(right)
        
        fire = SKSpriteNode(imageNamed: "喷射")
        fire.zPosition = 1
        fire.position = CGPoint(x: frame.midX, y: padding)
        addChild(fire)
        
        scoreLabel.position = CGPoint(x: 350, y: 700)
        addChild(scoreLabel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            let spriteName = atPoint(location).name
            
            if spriteName == "again" || spriteName == "return" {
                
                guard let gameOverNode = childNode(withName: "gameOverTable") else {
                    return
                }
                
                if spriteName == "again" {
                    perform(#selector(restart), with: nil, afterDelay: 0.3)
                }
                if spriteName == "return" {
                    let scene = SKScene(fileNamed: "GameScene")!
                    scene.scaleMode = .aspectFill
                    
                    view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1.0))
                }
                
                let action = SKAction.scale(to: 0.1, duration: 0.3)
                let removeAction = SKAction.run {
                    gameOverNode.removeFromParent()
                    self.childNode(withName: "bg")?.removeFromParent()
                }
                gameOverNode.run(SKAction.sequence([action, removeAction]))
                
                return
            }
        }
        
        
        if win != nil {
            gameOver()
            restart()
            return
        }
        
        guard let touchLocation = touches.first?.location(in: self) else { return }
        
        if left.frame.insetBy(dx: -padding, dy: -padding).contains(touchLocation) {
            rocket.physicsBody?.applyAngularImpulse(rotation)
        }
        else if right.frame.insetBy(dx: -padding, dy: -padding).contains(touchLocation) {
            rocket.physicsBody?.applyAngularImpulse(-rotation)
        }
        else if fire.frame.insetBy(dx: -padding, dy: -padding).contains(touchLocation) {
            let rotation = rocket.zRotation + (CGFloat.pi / 2.0)
            let newVec = CGVector(dx: boost * cos(rotation), dy: boost * sin(rotation))
            rocket.physicsBody?.applyImpulse(newVec)
        }
    }
    
    func gameOver() {
        win?.removeFromParent()
        win = nil
        rocket.removeFromParent()
        land.removeFromParent()
    }
    
    func showGameOverView() {
        gameOverShow = true
        
        let backNode = SKSpriteNode(imageNamed: "背板")
        backNode.name = "gameOverTable"
        backNode.zPosition = 30
        backNode.position = CGPoint(x: frame.width / 2, y: 400)
        
        let bg = SKSpriteNode(color: UIColor.black, size: frame.size)
        bg.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        bg.alpha = 0.8
        bg.name = "bg"
        bg.zPosition = 29
        
        let scoreLabel = SKLabelNode(text: "\(gameSocre)")
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontColor = UIColor(red: 76/255.0, green: 26/255.0, blue: 0, alpha: 1)
        scoreLabel.zPosition = 31
        scoreLabel.position = CGPoint(x: 0, y: -30)
        
        let againNode = SKSpriteNode(imageNamed: "再来一局")
        againNode.name = "again"
        againNode.zPosition = 31
        againNode.position = CGPoint(x: -50, y: -100)
        
        let returnNode = SKSpriteNode(imageNamed: "返回首页")
        returnNode.name = "return"
        returnNode.zPosition = 31
        returnNode.position = CGPoint(x: 50, y: -100)
        
        backNode.addChild(scoreLabel)
        backNode.addChild(againNode)
        backNode.addChild(returnNode)
        
        addChild(backNode)
        addChild(bg)
        
        backNode.setScale(0.1)
        let scale = SKAction.scale(to: 1, duration: 0.3)
        backNode.run(scale)
        
    }
    
    @objc func restart() {
        addRocket()
        addPlatform()
    }
}

extension MoonLanderScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if win != nil {
            return
        }
        if contact.bodyB.contactTestBitMask & Categories.platform != 0 || contact.bodyA.contactTestBitMask & Categories.platform != 0 {
            if contact.collisionImpulse > 40 {
                gameOver()
                showGameOverView()
            }
            else {
                win = SKLabelNode(text: "YOU WON!")
                win?.position = CGPoint(x: frame.midX, y: frame.midY)
                addChild(win!)
                
                rocket.texture = SKTexture(image: #imageLiteral(resourceName: "落地火箭"))
                
                gameSocre += 10
            }
        }
        else {
            gameOver()
            showGameOverView()
        }
    }
    
}

