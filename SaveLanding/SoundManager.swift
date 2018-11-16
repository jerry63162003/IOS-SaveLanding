//
//  SoundManager.swift
//  MathsMaster
//
//  Created by roy on 2018/7/26.
//  Copyright © 2018年 roy. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class SoundManager: NSObject {
    //申明一个播放器
    var bgMusicPlayer: AVAudioPlayer?
    var winMusic: AVAudioPlayer?
    //播放点击的动作音效
    lazy var gameOver: AVAudioPlayer = {
        do {
            if let fileURL = Bundle.main.path(forResource: "GameOver", ofType: "wav") {
                winMusic = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        
        return winMusic!
    }()
    
    //播放背景音乐的音效
    lazy var backGround: AVAudioPlayer = {
        do {
            if let fileURL = Bundle.main.path(forResource: "BackSound", ofType: "mp3") {
                bgMusicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
                bgMusicPlayer?.numberOfLoops = -1
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        return bgMusicPlayer!
    }()
    
    //播放点击音效动作的方法
    func playOverSound(){
        gameOver.play()
    }
    func playBackGroundSound(){
        backGround.play()
    }
    func stopBackGroundSound() {
        backGround.stop()
    }
}
