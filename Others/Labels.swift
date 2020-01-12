//
//  Labels.swift
//  Reverse Tetris
//
//  Created by user on 7/1/20.
//  Copyright © 2020 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class Labels: SKLabelNode{
    
    override init(){
        super.init()
        self.fontName = "Connection"
        self.fontColor = SKColor.white
        self.zPosition = 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // function that constructs the labelnode
    func build(xPos:CGFloat,yPos:CGFloat,fontSize:CGFloat,text:String){
        self.position = CGPoint(x:xPos,y:yPos)
        self.fontSize = fontSize
        self.text = "\(text)"
        self.name = "\(text)"
        
    }
    
    func build(centre:CGPoint,fontSize:CGFloat,text:String){
        self.position = centre
        self.fontSize = fontSize
        self.text = "\(text)"
        self.name = "\(text)"
    }
    func darkenWhenTouched(){
        // Aesthethic effect of darkerning nodes when touches
            self.fontColor = SKColor.gray
    }
    
}
