//
//  GameViewController.swift
//  Reverse Tetris
//
//  Created by user on 15/7/19.
//  Copyright © 2019 Richard. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView?{
            
            let scene = MainMenuScene(size:CGSize(width:1080, height:1920))
            // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
            // including entities and graphs.
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .fill
            // Present the scene
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = false
            view.showsFPS = false
            view.showsNodeCount = false
            
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

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
