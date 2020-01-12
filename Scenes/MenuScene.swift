//
//  MenuScene.swift
//  Reverse Tetris
//
//  Created by user on 8/1/20.
//  Copyright © 2020 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene:SKScene{
    
    var pageNumber:Int = 1
    var hasTappedLevel:Bool = false
    var hasTappedBack:Bool = false
    var levelCount: Int = 0
    // indicates how many levels there are
    var numberPosition:[CGPoint] = [CGPoint(x:0,y:0)]
    var levelTapped:Int = 0
    var popUpMode:Bool = false
    
    override init(size:CGSize){
        super.init(size:size)
        levelCount = checkLevelCount()
        numberPosition = findNumberPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        drawLabels()
        drawGrayShape()
        loadIcons()
        addArrows()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        
        if !popUpMode{
            let nodeAtPoint = atPoint(touch.location(in:self))
            
            if let levelNumber = Int(nodeAtPoint.name ?? ""){
                self.levelTapped = levelNumber
                (nodeAtPoint as! SKLabelNode).fontColor = SKColor.black
                // because nodeAtPoint is a button
                hasTappedLevel = true
            }
            
            else if nodeAtPoint.name == "Home"{
                hasTappedBack = true
                (nodeAtPoint as! SKLabelNode).fontColor = SKColor.black
            }
            
            else if nodeAtPoint.name == "forwardArrow"{
                // next page
                pageNumber += 1
                reset()
                loadIcons()
                // Numbers and locks and ticks
                addArrows()
            }
            
            else if nodeAtPoint.name == "backArrow"{
                pageNumber -= 1
                reset()
                loadIcons()
                addArrows()
            }
            
            
        }
        else { closePopUp() }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if hasTappedLevel{
            hasTappedLevel = false
            checkLevelCompletion(levelNumber:self.levelTapped)
        }
        if hasTappedBack{
            hasTappedBack = false
            goToMain()
        }
    }
    
    func drawGrayShape(){
        
        let leftCornerOfShape = CGPoint(x:self.size.width*0.1,y:self.size.height*0.1)
        let sizeOfRect = CGSize(width:self.size.width*0.8,height:self.size.height*0.64)
        let rect = CGRect(origin:leftCornerOfShape,size:sizeOfRect)
        // "origin" here refers to left cornerpoint of shape
        let greyShape = SKShapeNode(rect:rect,cornerRadius:100)
        greyShape.fillColor = SKColor.gray
        greyShape.zPosition = 4
        greyShape.name = "greyShape"
        self.addChild(greyShape)
    }
    
    func drawLabels(){
        let selectLabel = Labels()
        selectLabel.build(xPos: self.size.width*0.5, yPos: self.size.height*0.88, fontSize: 160, text: "Select")
        self.addChild(selectLabel)
        
        let levelLabel = Labels()
        levelLabel.build(xPos: self.size.width*0.5, yPos: self.size.height*0.79, fontSize: 160, text: "Level")
        self.addChild(levelLabel)
        
        let backButton = Labels()
        backButton.build(xPos: self.size.width*0.5, yPos: self.size.height*0.125, fontSize: 80, text: "Home")
        self.addChild(backButton)
    }
    
    func findNumberPosition() -> ([CGPoint]){
        var numberPosition:[CGPoint] = []
        for y in 1...3{
            let yPos = self.size.height*(0.77-0.16*CGFloat(y))
            // written based on assumption bottom leftcorner of gray shape is 0.1 and height of gray shape is 0.16
            for x in 1...3{
                // written based on the assumption bottom leftcorner of the gray shape is self.size.height*0.1 and width of gray shape is 0.8
                let xPos = self.size.width*(0.08+0.2*CGFloat(x))
                numberPosition.append(CGPoint(x:xPos,y:yPos))
            }
            
        }
        return numberPosition
    }
    
    func startGame(){
        self.removeAllChildren()
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func goToMain(){
        self.removeAllChildren()
        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func loadIcons(){
        let firstNumber:Int = 9*(self.pageNumber-1)+1
        // find the firstNumber of that page
        var difference = self.levelCount - firstNumber + 1
        if difference > 9{
            difference = 9
        }
        var counter = 0
        while (counter+1 <= difference){
            let numberLabel = Labels()
            numberLabel.build(centre:self.numberPosition[counter], fontSize: 150, text:"\(firstNumber+counter)")
            self.addChild(numberLabel)
            drawLocks(position:self.numberPosition[counter], levelNumber:firstNumber+counter)
            counter += 1
            }
    }
    
    func drawLocks(position:CGPoint,levelNumber:Int){
        //adding locks to indicate whether the user has unlocked the level
        let lastLevelUnlocked = UserData.getLevelUnlocked()
        if levelNumber > lastLevelUnlocked{
            let lock = SKSpriteNode(imageNamed:"Lock")
            lock.setScale(0.15)
            lock.position = CGPoint(x:position.x+self.size.width*0.045, y:position.y+self.size.height*0.01)
            lock.zPosition = 11
            lock.name = "Lock"
            self.addChild(lock)
        }
    }
    
    func addArrows(){
        // adding forward and back arrows
        var totalPages:Int = 1
        var levelCounter = self.levelCount
        while (levelCounter>9){
            totalPages += 1
            levelCounter -= 9
        }
        
        if (self.pageNumber < totalPages){
            let forwardArrow = SKSpriteNode(imageNamed:"arrow")
            forwardArrow.zRotation = CGFloat.pi
            forwardArrow.setScale(0.35)
            forwardArrow.position = CGPoint(x:self.size.width*0.8,y:self.size.height*0.14)
            forwardArrow.zPosition = 5
            forwardArrow.name = "forwardArrow"
            self.addChild(forwardArrow)
        }
        
        if (self.pageNumber != 1){
        // first page no back arrow
            let backArrow = SKSpriteNode(imageNamed:"arrow")
            backArrow.setScale(0.35)
            backArrow.position = CGPoint(x:self.size.width*0.2,y:self.size.height*0.14)
            backArrow.zPosition = 5
            backArrow.name = "backArrow"
            self.addChild(backArrow)
        }
    }
    
    func checkLevelCount()-> Int{
        var levelCounter:Int = 0
        let leveldata = LevelData()
        for _ in leveldata.blockPosition{
            levelCounter += 1
        }
        return levelCounter
    }
    
    func reset(){
        // clears the page
        for child in self.children{
            
            if let name = child.name{
                if name == "backArrow" || name == "forwardArrow"{
                    child.removeFromParent()
                }
                // reset arrows
                
                if Int(name) != nil{
                    child.removeFromParent()
                }
                // reset numbers
                
                if name == "Lock"{
                    child.removeFromParent()
                }
                // reset locks and ticks
            }
        }
    }
    
    func checkLevelCompletion(levelNumber:Int){
        let lastLevelUnlocked = UserData.getLevelUnlocked()
        if levelNumber > lastLevelUnlocked{
            // User has not unlocked the level yet
            if let levelLabel = self.childNode(withName:"\(levelNumber)"){
                (levelLabel as! SKLabelNode).fontColor = SKColor.white
                popUp(levelNumber - 1,levelLabel)
            }
            
        } 
        else {
            GameScene.levelNumber = levelNumber-1
            startGame()
            }
    }
    func popUp(_ previousLevel:Int, _ levelLabel:SKNode){
        popUpMode = true
        let rectWidth = self.size.width * 0.65
        let rectHeight = self.size.height * 0.13
        let rectDimensions = CGSize(width:rectWidth, height:rectHeight)
        let popUpNode = SKShapeNode(rectOf:rectDimensions,cornerRadius:120)
        popUpNode.zPosition = 11
        popUpNode.position = CGPoint(x:self.size.width*0.5, y:levelLabel.position.y - self.size.height*0.06)
        popUpNode.fillColor = SKColor.darkGray
        popUpNode.name = "PopUp"
        popUpNode.blendMode = SKBlendMode.subtract
        self.addChild(popUpNode)
        
        let popUpLabel1 = Labels()
        popUpLabel1.build(xPos: popUpNode.position.x, yPos: popUpNode.position.y+self.size.height*0.01, fontSize: 75, text: "Unlocked by")
        popUpLabel1.name = "label1"
        self.addChild(popUpLabel1)
        
        let popUpLabel2 = Labels()
        popUpLabel2.build(xPos: popUpNode.position.x, yPos: popUpNode.position.y-self.size.height*0.03, fontSize: 75, text: "completing Lvl.\(previousLevel)")
        popUpLabel2.name = "label2"
        self.addChild(popUpLabel2)
        
    }
    
    func closePopUp(){
        popUpMode = false
        if let popUpNode = self.childNode(withName:"PopUp"){
            popUpNode.removeFromParent()
        }
        if let popUpNode = self.childNode(withName:"label1"){
            popUpNode.removeFromParent()
        }
        if let popUpNode = self.childNode(withName:"label2"){
            popUpNode.removeFromParent()
        }
    }
}

