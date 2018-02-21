//
//  GameManager.swift
//  Snake
//
//  Created by Malcolm Kumwenda on 2018/02/20.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import Foundation

class GameManager {
    
    fileprivate let scene: GameScene!
    fileprivate var nextTime: Double?
    fileprivate var timeExtended: Double = 0.3
    fileprivate var playerDirection: Direction = .left
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func initGame() {
        self.scene.apendPlayerPosition(positions: [(10,10),
                                                   (10,11),
                                                   (10,12)])
        self.render()
    }
    
    fileprivate func render(){
        for (node, x, y) in self.scene.gameArray {
            if contains(a: self.scene.playerPosition, v: (x,y)){
                node.fillColor = #colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)
            }else {
                node.fillColor = .clear
            }
        }
    }
    
    fileprivate func contains(a:[Position], v:Position) -> Bool {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    fileprivate func updatePlayerPosition() {
        
        var xChange = -1
        var yChange = 0
        
        switch playerDirection {
        case .left:
            xChange = -1
            yChange = 0
        case .right:
            xChange = 1
            yChange = 0
        case .up:
            xChange = 0
            yChange = -1
        case .down:
            xChange = 0
            yChange = 1
        }
        
        if self.scene.playerPosition.count > 0 {
            var start = self.scene.playerPosition.count - 1
            while start > 0 {
                self.scene.setPlayerPosition(at: start,
                                             to: self.scene.playerPosition[start - 1])
                start -= 1
            }
            self.scene.setPlayerPosition(at: 0,
                                         to: (self.scene.playerPosition[0].0 + yChange, self.scene.playerPosition[0].1 + xChange))
        }
        
        self.render()
    }
    
    func update(time: Double) {
        if nextTime == nil {
            nextTime = time + timeExtended
        } else {
            if time >= nextTime! {
                nextTime = time + timeExtended
                self.updatePlayerPosition()
            }
        }
    }
}

enum Direction : Int {
    case left, right, up, down
}
