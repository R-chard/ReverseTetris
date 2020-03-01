//
//  LevelData.swift
//  Reverse Tetris
//
//  Created by user on 15/7/19.
//  Copyright © 2019 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class LevelData{
    
    var blockPosition = [[Int]]()
    var level1BlockPosition:[Int] = [1,2,3,4,5,12,14,24]
    var level2BlockPosition:[Int] = [1,2,3,4,5,13,14,15]
    var level3BlockPosition:[Int] = [1,2,3,4,11,12,13,14,22,23,32,33]
    var level4BlockPosition:[Int] = [1,2,3,4,11,12,13,14,21,22,31,32]
    var level5BlockPosition:[Int] = [1,2,3,4,11,12,13,14,21,22,23,24]
    var level6BlockPosition:[Int] = [1,2,3,4,5,11,12,13,14,21,22,31]
    var level7BlockPosition:[Int] = [1,2,3,4,5,12,13,14,23,24,22,32]
    var level8BlockPosition:[Int] = [1,2,3,4,11,12,13,14,21,22,23,32]
    var level9BlockPosition:[Int] = [1,2,3,4,5,11,12,13,14,15,21,22,23,25,32,33]
    var level10BlockPosition:[Int] = [1,2,3,4,5,11,12,13,14,21,22,23,32,33,42,43]
    var level11BlockPosition:[Int] = [1,2,3,4,11,12,13,14,21,22,23,24,31,32,33,34]
    var level12BlockPosition:[Int] = [1,2,3,4,5,6,12,13,14,15,23,24,25,34,35,45]
    var level13BlockPosition:[Int] = [1,2,3,4,5,11,12,13,14,15,21,22,23,24,25,33]
    var level14BlockPosition:[Int] = [1,2,3,4,5,6,7,12,13,14,15,16,17,22,24,26,32,34,36,44]
    var level15BlockPosition:[Int] = [1,2,3,4,5,11,12,13,14,15,21,22,23,24,25,31,33,34,43,53]
    var level16BlockPosition:[Int] = [1,2,3,4,5,6,11,12,13,14,15,16,21,22,23,24,25,26,32,35]
    var level17BlockPosition:[Int] = [1,2,3,4,5,6,12,13,14,15,16,22,23,25,26,33,35,36,43,46]
    var level18BlockPosition:[Int] = [1,2,3,4,5,6,11,12,13,14,15,16,21,22,23,24,25,26,31,32,33,34,35,36]
    var level19BlockPosition:[Int] = [1,2,3,4,5,6,7,11,12,13,14,15,16,21,22,23,24,25,26,31,32,33,35,45]
    var level20BlockPosition:[Int] = [1,2,3,4,5,6,11,12,13,14,15,16,21,22,23,24,26,31,32,33,34,36,42,43,44,52,53,54]
    // Blocks position
    
    var piecesNumber = [[Int]]()
    var level1PiecesNumber:[Int] = [0,0,1,0,0,1,0]
    var level2PiecesNumber:[Int] = [1,0,1,0,0,0,0]
    var level3PiecesNumber:[Int] = [1,1,1,0,0,0,0]
    var level4PiecesNumber:[Int] = [0,0,2,0,1,0,1]
    var level5PiecesNumber:[Int] = [0,0,2,0,1,0,0]
    var level6PiecesNumber:[Int] = [1,0,1,0,1,1,0]
    var level7PiecesNumber:[Int] = [0,1,0,1,1,1,0]
    var level8PiecesNumber:[Int] = [0,0,0,1,1,0,2]
    var level9PiecesNumber:[Int] = [0,1,1,1,0,1,0]
    var level10PiecesNumber:[Int] = [0,2,1,0,0,0,1]
    var level11PiecesNumber:[Int] = [0,0,1,0,0,2,1]
    var level12PiecesNumber:[Int] = [1,0,1,0,0,0,2]
    var level13PiecesNumber:[Int] = [0,1,1,0,1,2,0]
    var level14PiecesNumber:[Int] = [0,1,1,1,0,1,1]
    var level15PiecesNumber:[Int] = [0,0,4,0,0,1,0]
    var level16PiecesNumber:[Int] = [0,0,0,1,2,0,2]
    var level17PiecesNumber:[Int] = [1,1,0,0,1,2,1]
    var level18PiecesNumber:[Int] = [0,0,0,0,0,6,0]
    var level19PiecesNumber:[Int] = [1,0,1,0,1,2,1]
    var level20PiecesNumber:[Int] = [1,1,1,1,1,1,1]
    // Pieces are stored alphabetically in the order of I,J,L,O,S,T,Z
    
    init(){
        loadData()
    }
    
    func loadData() {
        blockPosition.append(level1BlockPosition)
        blockPosition.append(level2BlockPosition)
        blockPosition.append(level3BlockPosition)
        blockPosition.append(level4BlockPosition)
        blockPosition.append(level5BlockPosition)
        blockPosition.append(level6BlockPosition)
        blockPosition.append(level7BlockPosition)
        blockPosition.append(level8BlockPosition)
        blockPosition.append(level9BlockPosition)
        blockPosition.append(level10BlockPosition)
        blockPosition.append(level11BlockPosition)
        blockPosition.append(level12BlockPosition)
        blockPosition.append(level13BlockPosition)
        blockPosition.append(level14BlockPosition)
        blockPosition.append(level15BlockPosition)
        blockPosition.append(level16BlockPosition)
        blockPosition.append(level17BlockPosition)
        blockPosition.append(level18BlockPosition)
        blockPosition.append(level19BlockPosition)
        blockPosition.append(level20BlockPosition)
        piecesNumber.append(level1PiecesNumber)
        piecesNumber.append(level2PiecesNumber)
        piecesNumber.append(level3PiecesNumber)
        piecesNumber.append(level4PiecesNumber)
        piecesNumber.append(level5PiecesNumber)
        piecesNumber.append(level6PiecesNumber)
        piecesNumber.append(level7PiecesNumber)
        piecesNumber.append(level8PiecesNumber)
        piecesNumber.append(level9PiecesNumber)
        piecesNumber.append(level10PiecesNumber)
        piecesNumber.append(level11PiecesNumber)
        piecesNumber.append(level12PiecesNumber)
        piecesNumber.append(level13PiecesNumber)
        piecesNumber.append(level14PiecesNumber)
        piecesNumber.append(level15PiecesNumber)
        piecesNumber.append(level16PiecesNumber)
        piecesNumber.append(level17PiecesNumber)
        piecesNumber.append(level18PiecesNumber)
        piecesNumber.append(level19PiecesNumber)
        piecesNumber.append(level20PiecesNumber)
    }
    
    func retrieveBlockPosition(levelNumber:Int) -> [Int]{
        return blockPosition[levelNumber-1]
        // Retrieve data of block positions stored at level X
    }
    
    func retrievePiecesTypeAndCount(levelNumber:Int)-> [Int:Int]{
        // Find out which type of piece is stored and how many piece of each type
        let levelPiecesNumber = piecesNumber[levelNumber-1]
        var counter:Int = 0
        var numberOfParticularPiece:Int
        // Number of a particular Piece
        var piecesAndNumberDict: [Int:Int] = [:]
        
        
        for i in levelPiecesNumber {
            counter += 1
            // counter number will determine which puzzle piece it is
            if (i >= 1){
                // i >= 1 means that there is at least one particular piece present on that level
                numberOfParticularPiece = i
                piecesAndNumberDict[counter] = numberOfParticularPiece
            }
            
        }
        return piecesAndNumberDict
    }
    
    func retrieveTotalPiecesNumber(levelNumber:Int) -> Int{
        
        let levelPiecesNumber = piecesNumber[levelNumber-1]
        var numberOfPieces:Int = 0
        // Number of puzzle pieces on that level
        
        for i in levelPiecesNumber{
            if (i >= 1){
                numberOfPieces += 1
            }
        }
        return numberOfPieces
    }
    
    func retrieveBaseBlocksCount(levelNumber:Int) -> CGFloat{
        
        let levelBlocksData = blockPosition[levelNumber-1]
        var baseBlocksCount:CGFloat = 0
        for i in levelBlocksData{
            if i < 10{
                baseBlocksCount += 1
            }
        }
        return baseBlocksCount
    }
}
