//
//  GameConfig.swift
//  SaveLanding
//
//  Created by roy on 2018/9/8.
//  Copyright © 2018年 roy. All rights reserved.
//

import UIKit

enum GameLevel: String {
    case Easy = "Easy"
    case Diff = "Diff"
    case Hall = "Hall"
}

let screenWidth = UIApplication.shared.keyWindow?.frame.width ?? 0

let screenHeigh = UIApplication.shared.keyWindow?.frame.height ?? 0

class GameConfig: NSObject {
    static let shared = GameConfig()
    
    var gameLevel: GameLevel = (UserDefaults.standard.string(forKey: "gameLevel") != nil) ? GameLevel(rawValue: UserDefaults.standard.string(forKey: "gameLevel")!)! : GameLevel.Easy {
        didSet {
            UserDefaults.standard.set(gameLevel.rawValue, forKey: "gameLevel")
            UserDefaults.standard.synchronize()
        }
    }
    
    var isGameMusic = UserDefaults.standard.object(forKey: "isGameMusic") as? Bool ?? true {
        didSet {
            UserDefaults.standard.set(isGameMusic, forKey: "isGameMusic")
            UserDefaults.standard.synchronize()
        }
    }
    var isGameSound = UserDefaults.standard.object(forKey: "isGameSound") as? Bool ?? true {
        didSet {
            UserDefaults.standard.set(isGameSound, forKey: "isGameSound")
            UserDefaults.standard.synchronize()
        }
    }
    
    private var _highScore: Int = 0
    var highScore: Int {
        get {
            let level = GameConfig.shared.gameLevel
            var gameLevelStr = "Sorce"
            gameLevelStr += "_\(level.rawValue)"
            
            return UserDefaults.standard.integer(forKey: gameLevelStr)
        }
        
        set {
            _highScore = newValue
            let level = GameConfig.shared.gameLevel
            var gameLevelStr = "Sorce"
            gameLevelStr += "_\(level.rawValue)"
            
            UserDefaults.standard.set(newValue, forKey: gameLevelStr)
            UserDefaults.standard.synchronize()
        }
    }
}
