//
//  ParentNode.swift
//  Reverse Tetris
//
//  Created by user on 21/7/19.
//  Copyright © 2019 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class ParentNode: SKNode {
    // Mainly to deal with touch functions (what to do when parentNode is being tapped upon)
    
    var draggedPiece: Bool = false
    var checkedPuzzleAttempt: Bool = false
    var hasTapped: Bool = false
    // bool variable to differentiate drags from taps (drags means that pieces do not rotate)
    var initialPosition:CGPoint?
    // stored at a class var so all touches functions can access it
    var pieceRelease: Bool = false
    var rotationCount: Int = 0
    var originalZPos: CGFloat = 0.0
    
    
    override init(){
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hasTapped = true
        initialPosition = self.position
        pieceRelease = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
         for touch: AnyObject in touches{
            if scene != nil {
            self.position = touch.location(in:scene!)
            // self.position = position of SKnode in the scene that is displayed
            hasTapped = false
            // sets hasTapped property back to false so that piece does not rotate
            self.draggedPiece = true
            // trigger function in gameScene to check if piece was dragged into building blocks
            originalZPos = self.zPosition
            self.zPosition = 10
            // make zPosition higher so that it wont be covered by anything else
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if hasTapped {
            self.rotate(parentObject:self)
            // only rotate if its a tap and not a drag
            // pieces rotate when players remove their fingers (end of a tap)
            hasTapped = false
        }
        
        if (draggedPiece) {
            pieceRelease = true
            self.zPosition = originalZPos
        }
        // if piece was dragged, need to determine when piece was released to run the function in gamescene.update
        
        // if its not a tap, it is a drag, hence position must be changed back to the original one
            
    }
    
    func rotate(parentObject:ParentNode){
        let rotateMovement = SKAction.rotate(byAngle: CGFloat(-Double.pi/2), duration:0.1)
        parentObject.run(rotateMovement)
        self.rotationCount += 1
        if (self.rotationCount == 4){
            rotationCount = 0
        }
    }
    
    func addNode(pieceObject:Pieces, spawnPoint:CGPoint){
        
        self.position = spawnPoint
        self.isUserInteractionEnabled = true
        // allows us to interact with node through touches
        self.addChild(pieceObject.block1)
        self.addChild(pieceObject.block2)
        self.addChild(pieceObject.block3)
        self.addChild(pieceObject.block4)
    }
    
    func addChildNodePositions(parentNode:ParentNode) -> [CGPoint]{
        
        var childPositions = [CGPoint](repeating: CGPoint.zero, count:4)
        // array to store position of child nodes in scene
        var childXPos = [CGFloat](repeating:0, count:4)
        var childYPos = [CGFloat](repeating:0, count:4)
        // represents the x and y value of each SKSpriteNode child in scene
        
            // the switch statements below checks how many times the piece has been rotated, to determine the new X and Y value of the spritenode
            // It follows the rule below
            /*          Rotation = 0 --> (x,y)
                        Rotation = 1 --> (-y,x)
                        Rotation = 2 --> (-x,-y)
                        Rotation = 3 --> (y,-x)
             */
        switch rotationCount{
            case 0:
                for i in 0...3{
                    childXPos[i] = parentNode.childNode(withName:"piecesBlock\(i+1)")!.position.x
                    childYPos[i] = parentNode.childNode(withName:"piecesBlock\(i+1)")!.position.y
            }
            case 1:
                for i in 0...3{
                    childXPos[i] = parentNode.childNode(withName:"piecesBlock\(i+1)")!.position.y
                    childYPos[i] = -parentNode.childNode(withName:"piecesBlock\(i+1)")!.position.x
            }
            case 2:
                for i in 0...3{
                    childXPos[i] = -parentNode.childNode(withName:"piecesBlock\(i+1)")!.position.x
                    childYPos[i] = -parentNode.childNode(withName:"piecesBlock\(i+1)")!.position.y
            }
            case 3:
                for i in 0...3{
                    childXPos[i] = -parentNode.childNode(withName:"piecesBlock\(i+1)")!.position.y
                    childYPos[i] = parentNode.childNode(withName:"piecesBlock\(i+1)")!.position.x
            }
            default: print("Error retrieving child node positions")
        }
        
        for i in 0 ... 3{
            childPositions[i] = (CGPoint(x:childXPos[i] + self.position.x,y:childYPos[i] + self.position.y))
            // adds positions of nodes in SKNode to position of SKNode to find positions of child nodes in scene
        }
        return childPositions
    }
    
}
