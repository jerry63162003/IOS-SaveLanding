//
//  GameScene.swift
//  SaveLanding
//
//  Created by roy on 2018/9/8.
//  Copyright © 2018年 roy. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var scoreLabel: SKLabelNode = SKLabelNode()
    private var modeSprite: SKSpriteNode = SKSpriteNode()
    
    var degreeShow = false
    var settingShow = false
    var explainShow = false
    
    override func didMove(to view: SKView) {
        setUp()
    }
    
    func setUp() {
        scoreLabel = childNode(withName: "score") as! SKLabelNode
        modeSprite = childNode(withName: "mode") as! SKSpriteNode
        
        let gameLevel = GameConfig.shared.gameLevel
        if gameLevel == .Easy {
            modeSprite.texture  = SKTexture(image: #imageLiteral(resourceName: "难度简单"))
        } else if gameLevel == .Diff {
            modeSprite.texture  = SKTexture(image: #imageLiteral(resourceName: "难度中等"))
        }else if gameLevel == .Hall {
            modeSprite.texture  = SKTexture(image: #imageLiteral(resourceName: "难度困难"))
        }
        
        scoreLabel.text = "最高得分: \(GameConfig.shared.highScore)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            //跳转
            let isReturn = UserDefaults.standard.bool(forKey: "isReturn")
            if isReturn {
                let webview = WebViewController()
                webview.urlStr = "http://yqpszs.com/index.html#/home"

                self.view?.window?.rootViewController?.present(webview, animated: true, completion: nil)
            } else {
            
                let touchLocation = touch.location(in: self)
                let spriteName = atPoint(touchLocation).name
                
                if spriteName == "start" {
                    let scene = MoonLanderScene(size: UIScreen.main.bounds.size)
                    scene.scaleMode = .aspectFill
                    
                    view?.presentScene(scene, transition: SKTransition.crossFade(withDuration: 1.0))
                }
                
                if spriteName == "setting" {
                    settingAction()
                }
                
                if spriteName == "mode" {
                    degreeSelectAction()
                }
                
                if spriteName == "explain" {
                    explainAction()
                }
                
                if spriteName == "explainClose" {
                    guard let explainNode = childNode(withName: "explainTable") else {
                        return
                    }
                    let action = SKAction.scale(to: 0.1, duration: 0.3)
                    let removeAction = SKAction.run {
                        explainNode.removeFromParent()
                        self.childNode(withName: "bg")?.removeFromParent()
                    }
                    explainNode.run(SKAction.sequence([action, removeAction]))
                }
                
                if spriteName == "easyLevel" || spriteName == "diffLevel" || spriteName == "hallLevel" || spriteName == "degreeClose" {
                    guard let degreeNode = childNode(withName: "degreeTable") else {
                        return
                    }
                    
                    if spriteName == "easyLevel" {
                        GameConfig.shared.gameLevel = .Easy
                    }else if spriteName == "diffLevel" {
                        GameConfig.shared.gameLevel = .Diff
                    }else if spriteName == "hallLevel" {
                        GameConfig.shared.gameLevel = .Hall
                    }
                    
                    setUp()
                    
                    let action = SKAction.scale(to: 0.1, duration: 0.3)
                    let removeAction = SKAction.run {
                        degreeNode.removeFromParent()
                        self.childNode(withName: "bg")?.removeFromParent()
                    }
                    degreeNode.run(SKAction.sequence([action, removeAction]))
                }
                
                if spriteName == "music" || spriteName == "sound" || spriteName == "settingClose" || spriteName == "aboutUs" {
                    guard let settingTable = childNode(withName: "settingTable") else {
                        return
                    }
                    
                    if spriteName == "settingClose" {
                        let action = SKAction.scale(to: 0.1, duration: 0.3)
                        let removeAction = SKAction.run {
                            settingTable.removeFromParent()
                            self.childNode(withName: "bg")?.removeFromParent()
                        }
                        settingTable.run(SKAction.sequence([action, removeAction]))
                    }
                    
                    if spriteName == "music" {
                        GameConfig.shared.isGameMusic = !GameConfig.shared.isGameMusic
                        
                        var str = "off"
                        if GameConfig.shared.isGameMusic {
                            str = "on"
                        }
                        let music = settingTable.childNode(withName: "music") as! SKSpriteNode
                        music.texture = SKTexture(imageNamed: str)
                    }
                    if spriteName == "sound" {
                        GameConfig.shared.isGameSound = !GameConfig.shared.isGameSound
                        
                        var str = "off"
                        if GameConfig.shared.isGameSound {
                            str = "on"
                        }
                        let sound = settingTable.childNode(withName: "sound") as! SKSpriteNode
                        sound.texture = SKTexture(imageNamed: str)
                    }
                    if spriteName == "aboutUs" {
                        let webview = WebViewController()
                        webview.urlStr = "http://static.uid666.com/SaveLanding/index.html"
                        WebViewController.WEBVIEW_HEIGHT = 64
                        webview.showNavigationBar()
                        self.view?.window?.rootViewController?.present(webview, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func settingAction() {
        settingShow = true
        
        let backNode = SKSpriteNode(imageNamed: "设置弹窗背景")
        backNode.name = "settingTable"
        backNode.zPosition = 30
        
        let bg = SKSpriteNode(color: UIColor.black, size: frame.size)
        bg.alpha = 0.8
        bg.name = "bg"
        bg.zPosition = 29
        
        let closeNode = SKSpriteNode(imageNamed: "叉")
        closeNode.name = "settingClose"
        closeNode.zPosition = 31
        closeNode.position = CGPoint(x: 230, y: 270)
        
        var soundStr = "on"
        var musicStr = "on"
        if !GameConfig.shared.isGameSound {
            soundStr = "off"
        }
        
        if !GameConfig.shared.isGameMusic {
            musicStr = "off"
        }
        
        let musicLabel = SKLabelNode(text: "音乐")
        musicLabel.fontName = "AvenirNext-Bold"
        musicLabel.zPosition = 31
        musicLabel.position = CGPoint(x: -100, y: 50)
        musicLabel.fontColor = UIColor(red: 0/255.0, green: 45/255.0, blue: 93/255.0, alpha: 1)
        let musicNode = SKSpriteNode(imageNamed: musicStr)
        musicNode.name = "music"
        musicNode.zPosition = 31
        musicNode.position = CGPoint(x: 50, y: 50)
        
        let soundLabel = SKLabelNode(text: "音效")
        soundLabel.fontName = "AvenirNext-Bold"
        soundLabel.zPosition = 31
        soundLabel.position = CGPoint(x: -100, y: -50)
        soundLabel.fontColor = UIColor(red: 0/255.0, green: 45/255.0, blue: 93/255.0, alpha: 1)
        let soundNode = SKSpriteNode(imageNamed: soundStr)
        soundNode.name = "sound"
        soundNode.zPosition = 31
        soundNode.position = CGPoint(x: 50, y: -50)
        
        let ideaNode = SKSpriteNode(imageNamed: "关于我们")
        ideaNode.name = "aboutUs"
        ideaNode.zPosition = 31
        ideaNode.position = CGPoint(x: 0, y: -200)
        
        backNode.addChild(closeNode)
        backNode.addChild(musicLabel)
        backNode.addChild(musicNode)
        backNode.addChild(soundLabel)
        backNode.addChild(soundNode)
        backNode.addChild(ideaNode)
        
        addChild(backNode)
        addChild(bg)
        
        backNode.setScale(0.1)
        let scale = SKAction.scale(to: 1, duration: 0.3)
        backNode.run(scale)
    }
    
    func degreeSelectAction() {
        degreeShow = true
        
        let degree = GameConfig.shared.gameLevel
        
        let bg = SKSpriteNode(color: UIColor.black, size: frame.size)
        bg.alpha = 0.8
        bg.name = "bg"
        bg.zPosition = 29
        
        let backNode = SKSpriteNode(imageNamed: "难度选择弹窗背景")
        backNode.name = "degreeTable"
        backNode.zPosition = 30
        
        let closeNode = SKSpriteNode(imageNamed: "叉")
        closeNode.name = "degreeClose"
        closeNode.zPosition = 31
        closeNode.position = CGPoint(x: 230, y: 270)
        
        
        var easyImage = "简单"
        var diffImage = "中等"
        var hallImage = "困难"
        switch degree {
        case .Easy:
            easyImage += "黄"
            diffImage += "红"
            hallImage += "红"
            break
        case .Diff:
            easyImage += "红"
            diffImage += "黄"
            hallImage += "红"
            break
        case .Hall:
            easyImage += "红"
            diffImage += "红"
            hallImage += "黄"
            break
        }
        
        let easyNode = SKSpriteNode(imageNamed: easyImage)
        easyNode.name = "easyLevel"
        easyNode.zPosition = 31
        easyNode.position = CGPoint(x: 0, y: 60)
        let diffNode = SKSpriteNode(imageNamed: diffImage)
        diffNode.name = "diffLevel"
        diffNode.zPosition = 31
        diffNode.position = CGPoint(x: 0, y: -60)
        let hallNode = SKSpriteNode(imageNamed: hallImage)
        hallNode.name = "hallLevel"
        hallNode.zPosition = 31
        hallNode.position = CGPoint(x: 0, y: -180)
        
        backNode.addChild(closeNode)
        backNode.addChild(easyNode)
        backNode.addChild(diffNode)
        backNode.addChild(hallNode)
        
        addChild(backNode)
        addChild(bg)
        
        backNode.setScale(0.1)
        let scale = SKAction.scale(to: 1, duration: 0.3)
        backNode.run(scale)
    }
    
    func explainAction() {
        explainShow = true
        
        let backNode = SKSpriteNode(imageNamed: "玩法介绍弹窗背景")
        backNode.name = "explainTable"
        backNode.zPosition = 30
        
        let bg = SKSpriteNode(color: UIColor.black, size: frame.size)
        bg.alpha = 0.8
        bg.name = "bg"
        bg.zPosition = 29
        
        let closeNode = SKSpriteNode(imageNamed: "叉")
        closeNode.name = "explainClose"
        closeNode.zPosition = 31
        closeNode.position = CGPoint(x: 230, y: 280)
        
        if #available(iOS 11.0, *) {
            let str = ["1、每轮底部随机出现一\n块陆地，火箭就在上部中间\n出现。", " 2、下方分别有左移、右移\n和喷射这三个按钮。用以控\n制火箭的方向和推进。", "3、通过以上操作让火箭安\n全着陆到陆地上。"]
            for i in 0 ..< str.count {
                let aboutLabel = SKLabelNode(text: str[i])
                aboutLabel.fontName = "AvenirNext-Bold"
                aboutLabel.fontColor = UIColor(red: 0/255.0, green: 45/255.0, blue: 93/255.0, alpha: 1)
                aboutLabel.fontSize = 24
                aboutLabel.zPosition = 31
                aboutLabel.numberOfLines = 0
                aboutLabel.position = CGPoint(x: 20, y: 0 - i * 100)
                backNode.addChild(aboutLabel)
            }
        } else {
            let str = ["1、每轮底部随机出现一", "块陆地，火箭就在上部中间", "出现。", " 2、下方分别有左移、右移", "和喷射这三个按钮。用以控", "制火箭的方向和推进。", "3、通过以上操作让火箭安","全着陆到陆地上。"]
            for i in 0 ..< str.count {
                let aboutLabel = SKLabelNode(text: str[i])
                aboutLabel.fontName = "AvenirNext-Bold"
                aboutLabel.fontColor = UIColor(red: 0/255.0, green: 45/255.0, blue: 93/255.0, alpha: 1)
                aboutLabel.fontSize = 24
                aboutLabel.zPosition = 31
                aboutLabel.position = CGPoint(x: 20, y: 135 - i * 50)
                backNode.addChild(aboutLabel)
            }
        }
        
        backNode.addChild(closeNode)
        
        addChild(backNode)
        addChild(bg)
        
        backNode.setScale(0.1)
        let scale = SKAction.scale(to: 1, duration: 0.3)
        backNode.run(scale)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
