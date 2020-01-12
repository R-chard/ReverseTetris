//
//  EndScene.swift
//  Reverse Tetris
//
//  Created by user on 11/1/20.
//  Copyright © 2020 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class EndScene:SKScene{
    
    var hasTouchedHome = false
    
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
        for touch:AnyObject in touches{
            let pointOfTouch = touch.location(in:self)
            let nodeAtPoint = atPoint(pointOfTouch)
            
            if nodeAtPoint.name == "Home"{
                hasTouchedHome = true
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hasTouchedHome{
            hasTouchedHome = false
            goToMain()
            
        }
    }
    
    func drawLabels(){
        let endSceneLine1 = Labels()
        endSceneLine1.build(xPos: self.size.width*0.5, yPos: self.size.height*0.8, fontSize: 170, text: "Congrats!")
        self.addChild(endSceneLine1)
        
        let endSceneLine2 = Labels()
        endSceneLine2.build(xPos: self.size.width*0.5, yPos: self.size.height*0.65, fontSize: 70, text: "You have completed")
        self.addChild(endSceneLine2)
        
        let endSceneLine3 = Labels()
        endSceneLine3.build(xPos: self.size.width*0.5, yPos: self.size.height*0.59, fontSize: 70, text: "the game")
        self.addChild(endSceneLine3)
        
        let endSceneLine4 = Labels()
        endSceneLine4.build(xPos: self.size.width*0.5, yPos: self.size.height*0.48, fontSize: 70, text: "If you enjoyed it,please")
        self.addChild(endSceneLine4)
        
        let endSceneLine5 = Labels()
        endSceneLine5.build(xPos: self.size.width*0.5, yPos: self.size.height*0.42, fontSize: 70, text: "give us a positive review")
        self.addChild(endSceneLine5)
        
        let homeButton = Labels()
        homeButton.build(xPos: self.size.width*0.5, yPos: self.size.height*0.125, fontSize: 70, text: "Home")
        self.addChild(homeButton)
    }
    
    func goToMain(){
        self.removeAllChildren()
        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
}
