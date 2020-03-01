//
//  Pieces.swift
//  Reverse Tetris
//
//  Created by user on 15/7/19.
//  Copyright © 2019 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class Pieces{
    
    let spawnPoint: CGPoint
    // spawnPoint is (0,0) because by default node is already spawned onto the centre of the parent node. All we have to do is to adjust parent node
    let zPosition:CGFloat = 1
    // Parent Node to group all 4 blocks together so that they can be refered to as one entity
    let block1 = SKSpriteNode(imageNamed:"BlockforPieces")
    let block2 = SKSpriteNode(imageNamed:"BlockforPieces")
    let block3 = SKSpriteNode(imageNamed:"BlockforPieces")
    let block4 = SKSpriteNode(imageNamed:"BlockforPieces")
    // Since each piece is made up of 4 blocks, 4 same spritenodes are created
    
    init(){
        // spawnPoint is also centrePoint
        
        self.spawnPoint = CGPoint(x:0, y:0)
        block1.setScale(0.35)
        block2.setScale(0.35)
        block3.setScale(0.35)
        block4.setScale(0.35)
        block1.zPosition = 1
        block2.zPosition = 1
        block3.zPosition = 1
        block4.zPosition = 1
        block1.name = "piecesBlock1"
        block2.name = "piecesBlock2"
        block3.name = "piecesBlock3"
        block4.name = "piecesBlock4"
    }
    
    func positionBlocks (_ pos:CGPoint) -> CGPoint{
        // func to build blocks relative to centre
        let lengthOfBlock = block1.size.width
        let heightOfBlock = block1.size.height
        
        let newX: CGFloat = spawnPoint.x + pos.x * lengthOfBlock
        let newY: CGFloat = spawnPoint.y + pos.y * heightOfBlock
        return CGPoint(x: newX, y: newY)
    }
    
}

class IPiece:Pieces{
    override init(){
        super.init()
        block1.position = positionBlocks(CGPoint(x:0,y:1.5))
        block2.position = positionBlocks(CGPoint(x:0,y:0.5))
        block3.position = positionBlocks(CGPoint(x:0,y:-0.5))
        block4.position = positionBlocks(CGPoint(x:0,y:-1.5))
        // The 4 coords above are the coords of the blocks relative to the centre point (0,0)
    }
}

class JPiece:Pieces{
    override init(){
        super.init()
        block1.position = positionBlocks(CGPoint(x:-0.5,y:-1))
        block2.position = positionBlocks(CGPoint(x:0.5,y:-1))
        block3.position = positionBlocks(CGPoint(x:0.5,y:0))
        block4.position = positionBlocks(CGPoint(x:0.5,y:1))
    }
}

class LPiece:Pieces{
    override init(){
        super.init()
        block1.position = positionBlocks(CGPoint(x:0.5,y:-1))
        block2.position = positionBlocks(CGPoint(x:-0.5,y:-1))
        block3.position = positionBlocks(CGPoint(x:-0.5,y:0))
        block4.position = positionBlocks(CGPoint(x:-0.5,y:1))
    }
}

class OPiece:Pieces{
    override init(){
        super.init()
        block1.position = positionBlocks(CGPoint(x:0.5,y:0.5))
        block2.position = positionBlocks(CGPoint(x:-0.5,y:0.5))
        block3.position = positionBlocks(CGPoint(x:0.5,y:-0.5))
        block4.position = positionBlocks(CGPoint(x:-0.5,y:-0.5))
    }
}

class SPiece:Pieces{
    override init(){
        super.init()
        block1.position = positionBlocks(CGPoint(x:-1,y:-0.5))
        block2.position = positionBlocks(CGPoint(x:0,y:-0.5))
        block3.position = positionBlocks(CGPoint(x:0,y:0.5))
        block4.position = positionBlocks(CGPoint(x:1,y:0.5))
    }
}

class TPiece:Pieces{
    override init(){
        super.init()
        block1.position = positionBlocks(CGPoint(x:0,y:-0.5))
        block2.position = positionBlocks(CGPoint(x:-1,y:0.5))
        block3.position = positionBlocks(CGPoint(x:0,y:0.5))
        block4.position = positionBlocks(CGPoint(x:1,y:0.5))
    }
}

class ZPiece:Pieces{
    override init(){
        super.init()
        block1.position = positionBlocks(CGPoint(x:-1,y:0.5))
        block2.position = positionBlocks(CGPoint(x:0,y:0.5))
        block3.position = positionBlocks(CGPoint(x:0,y:-0.5))
        block4.position = positionBlocks(CGPoint(x:1,y:-0.5))
    }
}
