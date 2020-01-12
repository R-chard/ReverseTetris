//
//  HelpScene.swift
//  Reverse Tetris
//
//  Created by user on 9/1/20.
//  Copyright © 2020 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class HelpScene:SKScene{
    
    var pageNumber:Int = 1
    var hasTappedOK:Bool = false
    
   override init(size:CGSize){
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        switchPage()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let nodeAtPoint = atPoint(touch.location(in:self))
        if nodeAtPoint.name == "forwardArrow"{
            self.pageNumber += 1
            switchPage()
        }
        else if nodeAtPoint.name == "backArrow"{
            self.pageNumber -= 1
            switchPage()
        }
        else if nodeAtPoint.name == "OK"{
            hasTappedOK = true
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    if hasTappedOK{
        hasTappedOK = false
        if (UserData.getLevelUnlocked() == 0){
            startGame()
        }
        else {goToMain()}
        }
    }
    
    func drawPage1(){
        
        drawArrows()
        
        let line1Label = Labels()
        line1Label.build(xPos: self.size.width*0.29, yPos: self.size.height*0.8, fontSize: 70, text: "Drag the")
        self.addChild(line1Label)
        
        let line2Label = Labels()
        line2Label.build(xPos: self.size.width*0.65, yPos: self.size.height*0.8, fontSize: 70, text: "blue pieces")
        line2Label.fontColor = SKColor.blue
        self.addChild(line2Label)
        
        let line3Label = Labels()
        line3Label.build(xPos: self.size.width*0.28, yPos: self.size.height*0.74, fontSize: 70, text: "onto the")
        self.addChild(line3Label)
        
        let line4Label = Labels()
        line4Label.build(xPos: self.size.width*0.66, yPos: self.size.height*0.74, fontSize: 70, text: "green blocks")
        line4Label.fontColor = SKColor.green
        self.addChild(line4Label)
        
        let line5Label = Labels()
        line5Label.build(xPos: self.size.width*0.5, yPos: self.size.height*0.63, fontSize: 70, text: "You can also rotate the")
        self.addChild(line5Label)
        
        let line6Label = Labels()
        line6Label.build(xPos: self.size.width*0.31, yPos: self.size.height*0.57, fontSize: 70, text: "blue pieces")
        line6Label.fontColor = SKColor.blue
        self.addChild(line6Label)
        
        let line7Label = Labels()
        line7Label.build(xPos: self.size.width*0.7, yPos: self.size.height*0.57, fontSize: 70, text: "by tapping")
        self.addChild(line7Label)
        
        let line8Label = Labels()
        line8Label.build(xPos: self.size.width*0.5, yPos: self.size.height*0.46, fontSize: 70, text: "You win when all the")
        self.addChild(line8Label)
        
        let line9Label = Labels()
        line9Label.build(xPos: self.size.width*0.3, yPos: self.size.height*0.4, fontSize: 70, text: "green blocks")
        line9Label.fontColor = SKColor.green
        self.addChild(line9Label)
        
        let line10Label = Labels()
        line10Label.build(xPos: self.size.width*0.73, yPos: self.size.height*0.4, fontSize: 70, text: "are cleared")
        self.addChild(line10Label)
        
    }
    
    func drawPage2(){
        
        drawArrows()
        
        let line1Label = Labels()
        line1Label.build(xPos: self.size.width*0.5, yPos: self.size.height*0.8, fontSize: 70, text: "Hint: You do not have to")
        self.addChild(line1Label)
        
        let line2Label = Labels()
        line2Label.build(xPos: self.size.width*0.3, yPos: self.size.height*0.74, fontSize: 70, text: "use all your")
        self.addChild(line2Label)
        
        let line3Label = Labels()
        line3Label.build(xPos: self.size.width*0.71, yPos: self.size.height*0.74, fontSize: 70, text: "blue pieces")
        line3Label.fontColor = SKColor.blue
        self.addChild(line3Label)
        
        let line4Label = Labels()
        line4Label.build(xPos: self.size.width*0.16, yPos: self.size.height*0.63, fontSize: 70, text: "Also,")
        self.addChild(line4Label)
        
        let line5Label = Labels()
        line5Label.build(xPos: self.size.width*0.47, yPos: self.size.height*0.63, fontSize: 70, text: "green blocks")
        line5Label.fontColor = SKColor.green
        self.addChild(line5Label)
        
        let line6Label = Labels()
        line6Label.build(xPos: self.size.width*0.79, yPos: self.size.height*0.63, fontSize: 70, text: "fall if")
        self.addChild(line6Label)
        
        let line7Label = Labels()
        line7Label.build(xPos: self.size.width*0.5, yPos: self.size.height*0.57, fontSize: 70, text: "you remove those beneath")
        self.addChild(line7Label)
        
        let okLabel = Labels()
        okLabel.build(xPos:self.size.width*0.76,yPos:self.size.height*0.125, fontSize: 70, text: "OK")
        self.addChild(okLabel)
    }
    
    func switchPage(){
        reset()
        if self.pageNumber == 1{
            drawPage1()
        }
        
        else if self.pageNumber == 2{
            drawPage2()
        }
    }
    
    func drawArrows(){
        if self.pageNumber == 1{
            let forwardArrow = SKSpriteNode(imageNamed:"arrow")
            forwardArrow.zRotation = CGFloat.pi
            forwardArrow.setScale(0.35)
            forwardArrow.position = CGPoint(x:self.size.width*0.76,y:self.size.height*0.14)
            forwardArrow.zPosition = 5
            forwardArrow.name = "forwardArrow"
            self.addChild(forwardArrow)
        }
        
        if self.pageNumber == 2{
            let backArrow = SKSpriteNode(imageNamed:"arrow")
            backArrow.setScale(0.35)
            backArrow.position = CGPoint(x:self.size.width*0.17,y:self.size.height*0.14)
            backArrow.zPosition = 5
            backArrow.name = "backArrow"
            self.addChild(backArrow)
        }
    }
    
    func reset(){
        for child in self.children{
            if child.name != "Home"{
                child.removeFromParent()
            }
        }
    }
    
    func goToMain(){
        self.removeAllChildren()
        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func startGame(){
        self.removeAllChildren()
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
}
