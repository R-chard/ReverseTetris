//
//  UserData.swift
//  Reverse Tetris
//
//  Created by user on 10/1/20.
//  Copyright © 2020 Richard. All rights reserved.
//

import Foundation
import SpriteKit

class UserData{
    
    static func checkIfLastLevel(){
        var storedLastLevel = getLevelUnlocked()
        if (GameScene.levelNumber+1 >= storedLastLevel){
            storedLastLevel = GameScene.levelNumber+1
            setLevelUnlocked(lastLevel:storedLastLevel)
        }
    }
    
    static func setLevelUnlocked(lastLevel:Int){
        UserDefaults.standard.set(lastLevel, forKey:"level")
    }
    
    static func getLevelUnlocked() -> Int{
        let levelUnlocked = UserDefaults.standard.integer(forKey:"level")
        if levelUnlocked == 0{
            return 1
        }
        else {return levelUnlocked}
    }
    
}
