//
//  LevelCompletedScene.swift
//  Reverse Tetris
//
//  Created by user on 31/7/19.
//  Copyright © 2019 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class LevelCompletedScene:SKScene{
    
    var hasTappedNextLevel:Bool = false
    
    override init(size:CGSize){
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        drawLabels()
    }
    
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           let touch = touches.first!
           let nodeAtPoint = atPoint(touch.location(in:self))
           if nodeAtPoint.name == "Next Level"{
               (nodeAtPoint as! Labels).darkenWhenTouched()
               hasTappedNextLevel = true
           }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hasTappedNextLevel{
            hasTappedNextLevel = false
            if let nextLevelButton = self.childNode(withName:"Next Level"){
                (nextLevelButton as! SKLabelNode).fontColor = SKColor.white
                nextLevel()
            }
        }
    }
    
    func nextLevel(){
        
        self.removeAllChildren()
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func drawLabels(){
        
        let wellDoneLabel = Labels()
        wellDoneLabel.build(xPos: self.size.width*0.5, yPos: self.size.height*0.7, fontSize: 170, text: "Well Done")
        self.addChild(wellDoneLabel)
        
        let nextLevelButton = Labels()
        nextLevelButton.build(xPos: self.size.width*0.5, yPos: self.size.height*0.3, fontSize: 120, text: "Next Level")
        self.addChild(nextLevelButton)
    }
    
}
