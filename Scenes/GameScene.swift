//
//  GameScene.swift
//  Reverse Tetris
//
//  Created by user on 15/7/19.
//  Copyright © 2019 Richard. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene{
    
    static var levelNumber = 0
    var hasTappedRestart:Bool = false
    var hasTappedMenu:Bool = false
    
    override init(size:CGSize){
        super.init(size:size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        startNewLevel()
    }

    override func update(_ currentTime: TimeInterval){
        // constantly track the position of pieces
        
        self.enumerateChildNodes(withName:"pieceCountLabel"){
            label, stop in
            var counter = 0
            let block = self.childNode(withName:"buildingBlocks")
            if block != nil{
                let piecePos = CGPoint(x:label.position.x, y:label.position.y + 3*(block as! SKSpriteNode).size.height)
                self.enumerateChildNodes(withName: "parentNode"){
                    parentNode, stop in
                    if parentNode.contains(piecePos)&&((parentNode as! ParentNode).draggedPiece == false){
                        counter += 1
                    }
                }
            }
            else {
                self.clearLevel()
                UserData.checkIfLastLevel()
                // saves progress if its the latest level to be unlocked
                
                if GameScene.levelNumber == 20{
                    self.goToEndScene()
                    // if it is the last lvl of the game(level 20), go to end scene
                }
                else {
                    self.goToLevelComplete()
                }
            }
            
            if counter == 0 {
                label.isHidden = true
            }
            else if counter != 0{
                label.isHidden = false
                (label as! SKLabelNode).text = "\(counter)"
            }
        }

        self.enumerateChildNodes(withName: "parentNode") {
            parentNode, stop in
            // cycles through all parentNodes
            if (parentNode as! ParentNode).draggedPiece{
            // if parentNode has been dragged, check if puzzle fits when it is released
                let childNodePos = (parentNode as! ParentNode).addChildNodePositions(parentNode: parentNode as! ParentNode)
                if ((parentNode as! ParentNode).pieceRelease == true){
                self.checkPuzzleAttempt(parentNode:parentNode as! ParentNode, childNodePos:childNodePos)
                }
               // self.updateLabel(parentNode:parentNode as! ParentNode)
                
            }
                
             if (parentNode.zPosition > 1) && (parentNode as! ParentNode).draggedPiece == false{
                // draggedPiece == false excludes the piece that the user is holding on to (Because that piece would have a Z Position of 10 which is >1)
                // draggedPiece refers to the current piece

                let highestParent = self.findHighestParent(startNode:parentNode)
                
                self.enumerateChildNodes(withName:"parentNode"){
                    parentNode, stop in
                    if (parentNode.position == highestParent.position){
                        // if parent node and highestParent share the same location
                        if ((parentNode as! ParentNode).rotationCount != highestParent.rotationCount){
                            (parentNode as! ParentNode).rotate(parentObject:(parentNode as! ParentNode))
                            
                        }
                    }
                }
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let nodeAtPoint = atPoint(touch.location(in:self))
        if nodeAtPoint.name == "Restart"{
            (nodeAtPoint as! Labels).darkenWhenTouched()
            hasTappedRestart = true
        }
        else if nodeAtPoint.name == "Menu"{
            (nodeAtPoint as! Labels).darkenWhenTouched()
            hasTappedMenu = true
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hasTappedRestart{
            hasTappedRestart = false
            if let restartButton = self.childNode(withName:"Restart"){
                (restartButton as! SKLabelNode).fontColor = SKColor.white
                restartLevel()
            }
        }
        
        else if hasTappedMenu{
            hasTappedMenu = false
            if let restartButton = self.childNode(withName:"Restart"){
                (restartButton as! SKLabelNode).fontColor = SKColor.white
                goToMenu()
            }
        }
    }
    
    
    func startNewLevel(){
        GameScene.levelNumber += 1
        buildBlocks()
        buildPieces()
        addRestartLevelLabel()
        addMenuLabel()
    }
    
    func buildBlocks(){
        
        let columnsInLevel = 10
        // Columns are vertical
        let levelData = LevelData()
        let baseHeight:CGFloat = self.size.height*0.3
        let objectBlock = SKSpriteNode(imageNamed:"Block")
        objectBlock.setScale(0.35)
        let baseBlocksCount = levelData.retrieveBaseBlocksCount(levelNumber:GameScene.levelNumber)
        let FirstBlockXPos = (self.size.width/2) - (baseBlocksCount+1)/2 * objectBlock.size.width
        let FirstBlockPosition = CGPoint(x:FirstBlockXPos, y:baseHeight)
        // Bottom left corner of first block relative to screen size
        
        // creating an object to access the class LevelData
        let blockPosition = levelData.retrieveBlockPosition(levelNumber: GameScene.levelNumber)
        // blockPosition is an int array containing numbers representing position of blocks
        
        for element in blockPosition{
            let xPosition = element % columnsInLevel
            let yPosition = Int(element/columnsInLevel)
            // element refers to the position of each block represented by an int
            // X and Y position of each block relative to the corner left most block
            let block = SKSpriteNode(imageNamed:"Block")
            block.name = "buildingBlocks"
            block.setScale(0.35)
            let relativeHeight = CGFloat(xPosition) * block.size.height
            let relativeWidth = CGFloat(yPosition) * block.size.width
            // blockHeight and blockWidth represents absolute height and width of each block relative to corner left most block
            block.position = CGPoint(x:FirstBlockPosition.x + relativeHeight, y:FirstBlockPosition.y + relativeWidth)
            self.addChild(block)
        }
    }
    
    func buildPieces(){
        
        let levelData = LevelData()
        let row1Height:CGFloat = 0.9 * self.size.height
        // height of first row in terms of percentage of total screen height
        let row2Height:CGFloat = 0.72 * self.size.height
        let totalPieces = levelData.retrieveTotalPiecesNumber(levelNumber: GameScene.levelNumber)
        var piecesPosTuple:(distBetweenRow1Piece:CGFloat, distBetweenRow2Piece:CGFloat, row2:Bool)
        piecesPosTuple = calculatePiecePos(numberOfPieces: totalPieces)
        // We now have info on the gap between pieces on row 1 and 2, if applicable
        var pieceYPos:CGFloat = 0
        var pieceCount:Int = 1
        // To track how many pieces have been created on the screen
        
        func findPieceXPos(pieceCount:Int) -> CGFloat{
            
            var pieceXPos:CGFloat = 0
            
            if totalPieces == 4{
                if (pieceCount <= 2){
                    pieceXPos = piecesPosTuple.distBetweenRow1Piece * CGFloat(pieceCount)
                }
                else if(pieceCount > 2){
                    pieceXPos = piecesPosTuple.distBetweenRow2Piece * CGFloat(pieceCount - 2)
                }
            }
            else if !piecesPosTuple.row2{
                pieceXPos = piecesPosTuple.distBetweenRow1Piece * CGFloat(pieceCount)
            }
            else if piecesPosTuple.row2{
                if (pieceCount <= 3){
                    pieceXPos = piecesPosTuple.distBetweenRow1Piece * CGFloat(pieceCount)
                }
                else if (pieceCount > 3){
                    pieceXPos = piecesPosTuple.distBetweenRow2Piece * CGFloat(pieceCount - 3)
                }
            }
            
            // Checks total number of pieces. If >4, 3 pieces will remain on top row while the rest becomes the 2nd row. Else all 4 pieces on top row
            return pieceXPos
    }
        
    let piecesTypeAndCountDict = levelData.retrievePiecesTypeAndCount(levelNumber: GameScene.levelNumber)
        
    for key in piecesTypeAndCountDict.keys{
            
        if (totalPieces==4){
            if (pieceCount<=2){
                pieceYPos = row1Height
            }
            else {
                pieceYPos = row2Height
            }
        }
        else if (pieceCount < 4) && (piecesPosTuple.row2 == false){
            pieceYPos = row1Height
        }
        else if (pieceCount < 4) && (piecesPosTuple.row2 == true){
            pieceYPos = row1Height
        }
        else if (pieceCount >= 4) && (piecesPosTuple.row2 == true){
            pieceYPos = row2Height
        }
        // Determines y value of piece. If only 1 row is present/ there are less than 3 pieces already present(when creating the 4th piece), Y value is higher
            
            switch key{
                case 1:
                    let spawnPoint = CGPoint(x:findPieceXPos(pieceCount: pieceCount),y:pieceYPos)
                    let pieceCount = piecesTypeAndCountDict[key]
                    // finds the value stored in the dict, which represents number of a particular piece
                    for i in 1 ... pieceCount!{
                        let iPiece = IPiece()
                        let parentNode = ParentNode()
                        parentNode.addNode(pieceObject:iPiece, spawnPoint: spawnPoint)
                        parentNode.name = "parentNode"
                        parentNode.zPosition = CGFloat(i)
                        addChild(parentNode)
                    }
                    
                    addLabel(spawnPoint:spawnPoint)
                
                case 2:
                    let spawnPoint = CGPoint(x:findPieceXPos(pieceCount: pieceCount),y:pieceYPos)
                    let pieceCount = piecesTypeAndCountDict[key]
                    // finds the value stored in the dict, which represents number of a particular piece
                    for i in 1 ... pieceCount!{
                        let jPiece = JPiece()
                        let parentNode = ParentNode()
                        parentNode.addNode(pieceObject:jPiece, spawnPoint: spawnPoint)
                        parentNode.name = "parentNode"
                        parentNode.zPosition = CGFloat(i)
                        addChild(parentNode)
                    }
                    
                    addLabel(spawnPoint:spawnPoint)
                
                case 3:
                    let spawnPoint = CGPoint(x:findPieceXPos(pieceCount: pieceCount),y:pieceYPos)
                    let pieceCount = piecesTypeAndCountDict[key]
                    // finds the value stored in the dict, which represents number of a particular piece
                    for i in 1 ... pieceCount!{
                        let lPiece = LPiece()
                        let parentNode = ParentNode()
                        parentNode.addNode(pieceObject:lPiece, spawnPoint: spawnPoint)
                        parentNode.name = "parentNode"
                        parentNode.zPosition = CGFloat(i)
                        addChild(parentNode)
                    }
                    
                    addLabel(spawnPoint:spawnPoint)
                
                case 4:
                    let spawnPoint = CGPoint(x:findPieceXPos(pieceCount: pieceCount),y:pieceYPos)
                    let pieceCount = piecesTypeAndCountDict[key]
                    // finds the value stored in the dict, which represents number of a particular piece
                    for i in 1 ... pieceCount!{
                        let oPiece = OPiece()
                        let parentNode = ParentNode()
                        parentNode.addNode(pieceObject:oPiece, spawnPoint: spawnPoint)
                        parentNode.name = "parentNode"
                        parentNode.zPosition = CGFloat(i)
                        addChild(parentNode)
                    }
                    addLabel(spawnPoint:spawnPoint)
                
                case 5:
                    let spawnPoint = CGPoint(x:findPieceXPos(pieceCount: pieceCount),y:pieceYPos)
                    let pieceCount = piecesTypeAndCountDict[key]
                    // finds the value stored in the dict, which represents number of a particular piece
                    for i in 1 ... pieceCount!{
                        let sPiece = SPiece()
                        let parentNode = ParentNode()
                        parentNode.addNode(pieceObject:sPiece, spawnPoint: spawnPoint)
                        parentNode.name = "parentNode"
                        parentNode.zPosition = CGFloat(i)
                        addChild(parentNode)
                    }
                    
                    addLabel(spawnPoint:spawnPoint)
                
                case 6:
                    let spawnPoint = CGPoint(x:findPieceXPos(pieceCount: pieceCount),y:pieceYPos)
                    let pieceCount = piecesTypeAndCountDict[key]
                    // finds the value stored in the dict, which represents number of a particular piece
                    for i in 1...pieceCount!{
                        let tPiece = TPiece()
                        let parentNode = ParentNode()
                        parentNode.addNode(pieceObject:tPiece, spawnPoint: spawnPoint)
                        parentNode.name = "parentNode"
                        parentNode.zPosition = CGFloat(i)
                        addChild(parentNode)
                    }

                    addLabel(spawnPoint:spawnPoint)
                
                case 7:
                    let spawnPoint = CGPoint(x:findPieceXPos(pieceCount: pieceCount),y:pieceYPos)
                    let pieceCount = piecesTypeAndCountDict[key]
                    // finds the value stored in the dict, which represents number of a particular piece
                    for i in 1 ... pieceCount!{
                        let zPiece = ZPiece()
                        let parentNode = ParentNode()
                        parentNode.addNode(pieceObject:zPiece, spawnPoint: spawnPoint)
                        parentNode.name = "parentNode"
                        parentNode.zPosition = CGFloat(i)
                        addChild(parentNode)
                    }

                    addLabel(spawnPoint:spawnPoint)
                
                default: print("Error")
            }
            pieceCount += 1
        }
        
        }

    func calculatePiecePos(numberOfPieces:Int) -> (CGFloat,CGFloat,Bool){
        // func to call to determine X value of pieces
        let lengthOfScene = self.frame.size.width
        var distBetweenRow1Piece:CGFloat = 0
        var distBetweenRow2Piece:CGFloat = 0
        var row2:Bool = false
        if (numberOfPieces < 4) {
            distBetweenRow1Piece = lengthOfScene/CGFloat(numberOfPieces+1)
        }
            // If numberOfPieces <4, Pieces will be spaced out evenly on one row
        else if(numberOfPieces == 4){
            distBetweenRow1Piece = lengthOfScene/3
            row2 = true
            distBetweenRow2Piece = lengthOfScene/3
        }
            // 2 pieces on both first and 2nd
        else if (numberOfPieces > 4) {
            distBetweenRow1Piece = lengthOfScene/4
            // If numberOfPieces = 5/6/7, 3 pieces will be on the first row and the rest will be on second
            let numberOfRow2Pieces: Int = numberOfPieces - 3
            distBetweenRow2Piece = lengthOfScene/CGFloat(numberOfRow2Pieces+1)
            row2 = true
            // If >4 pieces, 3 pieces will remain on top row while the rest becomes the 2nd row
        }
        
        return (distBetweenRow1Piece,distBetweenRow2Piece,row2)
        
    }
    
    func addLabel(spawnPoint: CGPoint){
        let block = childNode(withName:"buildingBlocks")
        let label = SKLabelNode(fontNamed:"Connection")

        var counter: Int = 0
        enumerateChildNodes(withName:"parentNode"){
            parentNode, stop in
            if (parentNode.position == spawnPoint){
                counter += 1
            }
        }
        label.text = "\(counter)"
        label.name = "pieceCountLabel"
        label.fontColor = SKColor.white
        label.fontSize = 50
        label.zPosition = 1
        label.position = CGPoint(x:spawnPoint.x, y:spawnPoint.y - 3*((block as! SKSpriteNode).size.height))
        self.addChild(label)
    }
    
    func checkPuzzleAttempt(parentNode:ParentNode, childNodePos:[CGPoint]){
        
        var counter:Int = 0
        
        for i in 0...3{
            self.enumerateChildNodes(withName: "buildingBlocks"){
            block, stop in
            
                if (block.frame.contains(childNodePos[i])){
                    counter += 1
                    stop.initialize(to: true)
                    // stops the loop
                }
            }
        }
        
        if (counter == 4){
            // if counter = 4, the puzzle pieces fits. Hence checks which blocks contains the pieces and remove them
            parentNode.removeFromParent()
            // deletes piece
            self.enumerateChildNodes(withName: "buildingBlocks"){
                block, stop in
                var blockYPos:CGFloat
                var blockXPos:CGFloat
                for i in 0...3{
                    if (block.frame.contains(childNodePos[i])){
                        blockYPos = block.position.y
                        blockXPos = block.position.x
                        
                        var moveTopBlocksCount = 0
                        // represents the number of blocks above the piece to be removed
                        
                    // handles the situation when >1 block has to be removed
                       self.enumerateChildNodes(withName:"buildingBlocks"){
                            block, stop in
                            if blockXPos == block.position.x{
                                for i in 0...3{
                                    if block.frame.contains(childNodePos[i]){
                                        moveTopBlocksCount += 1
                                        block.removeFromParent()
                                    }
                                }
                            }
                        }
                        
                        self.enumerateChildNodes(withName:"buildingBlocks"){
                            block, stop in
                                if (blockYPos < block.position.y) && blockXPos == block.position.x && moveTopBlocksCount != 0 {
                                    let moveBlockAction = SKAction.moveTo(y:block.position.y - CGFloat(moveTopBlocksCount) * (block as! SKSpriteNode).size.height, duration: 0.2 * Double(moveTopBlocksCount))
                                    block.run(moveBlockAction)
                                }
                            
                        }
                        block.removeFromParent()
                        
                    }
                }
            }
        }
        parentNode.position = parentNode.initialPosition!
        parentNode.draggedPiece = false
        
    }
    
    func findHighestParent(startNode:SKNode) -> ParentNode{
        var highestParent:SKNode
        
        highestParent = startNode
        // wont be nil because function will only be called if zPos > 1
        self.enumerateChildNodes(withName: "parentNode"){
            parentNode, stop in
        
            if (parentNode.zPosition > highestParent.zPosition && parentNode.position == highestParent.position){
                highestParent = parentNode
            }

        }
        return highestParent as! ParentNode
    }
    
    func goToLevelComplete() {
        
        let sceneToMoveTo = LevelCompletedScene(size: self.size)
        // Move to a new SKScene and set it to be the same size
        sceneToMoveTo.scaleMode = self.scaleMode
        // Similar to how when current scene is first created, it takes in a tuple as an initializer for its size. We also had to set the scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func addRestartLevelLabel(){
        let restartButton = Labels()
        restartButton.build(xPos: self.size.width*0.7, yPos: self.size.height*0.15, fontSize: 80, text: "Restart")
        self.addChild(restartButton)
    }
    
    func clearLevel(){
        // func to delete nodes created in this scene
        enumerateChildNodes(withName:"pieceCountLabel"){
            label, stop in
            label.removeFromParent()
        }
        // deletes pieceCountLabel
        enumerateChildNodes(withName:"buildingBlocks"){
            block, stop in
            block.removeFromParent()
        }
        enumerateChildNodes(withName:"parentNode"){
            parentNode, stop in
            parentNode.removeFromParent()
        }
        childNode(withName:"restartLevelLabel")?.removeFromParent()
    }
    
    func restartLevel(){
        clearLevel()
        buildBlocks()
        buildPieces()
        addRestartLevelLabel()
        addMenuLabel()
    }
    
    func addMenuLabel(){
        let menuButton = Labels()
        menuButton.build(xPos: self.size.width*0.3, yPos: self.size.height*0.15, fontSize: 80, text: "Menu")
        self.addChild(menuButton)
    }
        
    func goToMenu(){
        self.removeAllChildren()
        let sceneToMoveTo = MenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    func goToEndScene(){
        self.removeAllChildren()
        let sceneToMoveTo = EndScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
}
