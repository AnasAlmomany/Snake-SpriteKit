//
//  GameScene.swift
//  Snake
//
//  Created by Malcolm Kumwenda on 2018/02/20.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

typealias Position = (Int,Int)

enum NodeNames : String {
    case playButton = "com.mdevsa.snake.play_button"
    case gameBackground = "com.mdevsa.snake.game_background"
}

class GameScene: SKScene {
    
    fileprivate lazy var gameLogoLabel : SKLabelNode = {
        return NodeBuilder.makeLabelNode(fontColor: .red, fontSize: 70, text: "SNAKE")
    }()
    
    fileprivate lazy var bestScoreLabel : SKLabelNode = {
        return NodeBuilder.makeLabelNode(fontColor: .white, fontSize: 40, text: "BEST SCORE: 0")
    }()
    
    fileprivate lazy var playButton : SKShapeNode = {
        let button = NodeBuilder.makeShapeNode(name: .playButton, color: #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1))
        let topCorner = CGPoint(x: -50, y: 50)
        let bottomCorner = CGPoint(x: -50, y: -50)
        let middleCorner = CGPoint(x: 50, y: 0)
        let path = CGMutablePath()
        path.addLines(between: [topCorner, bottomCorner, middleCorner])
        button.path = path
        return button
    }()
    
    fileprivate lazy var currentScoreLabel: SKLabelNode = {
        let label = NodeBuilder.makeLabelNode(fontColor: .white, fontSize: 40, text: "SCORE: 0")
        label.isHidden = true
        return label
    }()
    
    fileprivate lazy var gameBackground: SKShapeNode = {
        let gameViewWidth = 600
        let gameViewHeight = 1200
        let gameViewRect = CGRect(x: -gameViewWidth/2, y: (-gameViewHeight/2)+35, width: gameViewWidth, height: gameViewHeight)
        let background = SKShapeNode(rect: gameViewRect, cornerRadius: 0.03)
        background.zPosition = 2
        background.isHidden = true
        background.fillColor = SKColor.darkGray
        return background
    }()
    
    fileprivate var game: GameManager!
    private(set) var playerPosition: [Position] = []
    private(set) var gameArray: [(node:SKShapeNode, x:Int, y:Int)] = []
}


// MARK: Lyfe Cycle
extension GameScene {
    override func didMove(to view: SKView) {
        self.initializeMenu()
        
        self.game = GameManager(scene: self)
        
        self.initializeGameView()
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.game.update(time: currentTime)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes {
                if node.name == NodeNames.playButton.rawValue {
                    self.startGame()
                }
            }
        }
    }
}

// MARK:- Game Methods
extension GameScene {
    fileprivate func initializeMenu() {
        self.gameLogoLabel.position = CGPoint(x: 0, y: (frame.size.height/2)-200)
        self.addChild(self.gameLogoLabel)
        
        self.bestScoreLabel.position = CGPoint(x: 0, y: self.gameLogoLabel.position.y - 50)
        self.addChild(self.bestScoreLabel)
        
        self.playButton.position = CGPoint(x: 0, y: (frame.size.height / -2) + 200)
        self.addChild(self.playButton)
    }
    
    fileprivate func initializeGameView() {
        self.currentScoreLabel.position = CGPoint(x: 0, y: (frame.size.height / -2) + 60)
        
        self.addChild(self.currentScoreLabel)
        
        self.addChild(self.gameBackground)
        
        self.createGameGrid(width: self.gameBackground.frame.width,
                            height: self.gameBackground.frame.height)
    }
    
    fileprivate func startGame(){
        self.animateLabels()
        self.game.initGame()
    }
    
    fileprivate func animateLabels() {
        self.gameLogoLabel.run(SKAction.move(by: CGVector(dx: -50, dy: 600), duration: 0.5)){
            self.gameLogoLabel.isHidden = true
        }
        
        self.playButton.run(SKAction.scale(to: 0, duration: 0.3)) {
            self.playButton.isHidden = true
        }
        
        let bottom = CGPoint(x: 0, y: (frame.size.height / -2) + 20)
        self.bestScoreLabel.run(SKAction.move(to: bottom, duration: 0.3)) {
            self.gameBackground.setScale(0)
            self.currentScoreLabel.setScale(0)
            self.gameBackground.isHidden = false
            self.currentScoreLabel.isHidden = false
            self.gameBackground.run(SKAction.scale(to: 1, duration: 0.3))
            self.currentScoreLabel.run(SKAction.scale(to: 1, duration: 0.5))
        }
    }
    
    func apendPlayerPosition(positions: [Position]) {
        for position in positions {
            self.playerPosition.append(position)
        }
    }
    
    func setPlayerPosition(at index: Int, to value: Position) {
        self.playerPosition[index] = value
    }
}

// MARK:- Grid Creation
extension GameScene {
    fileprivate func createGameGrid(width: CGFloat, height: CGFloat) {
        let cellWidth : CGFloat = 30
        let numberOfRows = 40
        let numberOfColumns = 20
        
        var xPosition = (width / -2) + ( cellWidth / 2)
        var yPosition = (height / 2) + 35 - ( cellWidth / 2)
        
        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let cellNode = SKShapeNode(rectOf: CGSize(width: cellWidth, height: cellWidth))
                cellNode.strokeColor = .black
                cellNode.zPosition = 2
                cellNode.position = CGPoint(x: xPosition, y: yPosition)
                
                self.gameArray.append((node: cellNode, x: row, y: column))
                self.gameBackground.addChild(cellNode)
                
                xPosition += cellWidth
            }
            xPosition = (width / -2) + ( cellWidth / 2)
            yPosition -= cellWidth
        }
        
    }
}
