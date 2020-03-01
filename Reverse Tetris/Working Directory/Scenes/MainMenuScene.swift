//
//  MainMenuScene.swift
//  Reverse Tetris
//
//  Created by user on 7/1/20.
//  Copyright © 2020 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenuScene: SKScene{
    
    var hasTappedPlay:Bool = false
    var hasTappedHelp:Bool = false
    var popUpMode:Bool = false
    
    override init(size:CGSize){
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        drawBackground()
        drawLabels()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
                let pointOfTouch = touch.location(in:self)
                let nodeAtPoint = atPoint(pointOfTouch)
                // checks the node at the location the user touched
                switch nodeAtPoint.name{
                    case "Play":
                        hasTappedPlay = true
                        (nodeAtPoint as! Labels).darkenWhenTouched()
                    case "Help":
                        hasTappedHelp = true
                        (nodeAtPoint as! Labels).darkenWhenTouched()
                    default:break
                }
            }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if hasTappedPlay{
            checkIfFirstTime()
            hasTappedPlay = false
            if let playButton = self.childNode(withName:"Play"){
                (playButton as! SKLabelNode).fontColor = SKColor.white
                goToMenu()
            }
        }
        else if hasTappedHelp{
            hasTappedHelp = false
            if let helpButton = self.childNode(withName:"Help"){
                (helpButton as! SKLabelNode).fontColor = SKColor.white
                goToHelp()
            }
        }
        
    }
    
    func drawLabels(){
         
         let playButton = Labels()
         playButton.build(xPos: self.size.width*0.3, yPos: self.size.height*0.13, fontSize: 100, text: "Play")
         self.addChild(playButton)
        
        let helpButton = Labels()
        helpButton.build(xPos: self.size.width*0.7, yPos: self.size.height*0.13, fontSize: 100, text: "Help")
        self.addChild(helpButton)
         
    }
    
    func goToMenu(){
        self.removeAllChildren()
        let sceneToMoveTo = MenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func goToHelp(){
        self.removeAllChildren()
        let sceneToMoveTo = HelpScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func checkIfFirstTime(){
        if (UserData.getLevelUnlocked() == 0){
            goToHelp()
        }
    }
    
    func drawBackground(){
        let background = SKSpriteNode(imageNamed:"Background2")
        background.size = CGSize(width:self.frame.width*1.1, height:self.frame.height)
        background.zPosition = 0
        background.position = CGPoint(x:self.size.width*0.5,y:self.size.height*0.5)
        self.addChild(background)
    }
    
    
}
