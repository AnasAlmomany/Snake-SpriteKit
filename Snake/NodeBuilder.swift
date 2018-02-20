//
//  NodeBuilder.swift
//  Snake
//
//  Created by Malcolm Kumwenda on 2018/02/20.
//  Copyright © 2018 Malcolm Kumwenda. All rights reserved.
//

import SpriteKit

class NodeBuilder {
    
    // MARK: Labels
    static func makeLabelNode() -> SKLabelNode {
        return SKLabelNode()
    }
    
    static func makeLabelNode(font: String = "Avenir",
                              fontColor: UIColor,
                              fontSize: CGFloat,
                              text: String) -> SKLabelNode {
        let skLabel = SKLabelNode(fontNamed: font)
        skLabel.fontColor = fontColor
        skLabel.fontSize = fontSize
        skLabel.text = text
        skLabel.zPosition = 1
        return skLabel
    }
    
    // MARK: Shapes
    static func makeShapeNode() -> SKShapeNode {
        return SKShapeNode()
    }
    
    static func makeShapeNode(name: NodeNames, color: UIColor) -> SKShapeNode {
        let skShape = SKShapeNode()
        skShape.name = name.rawValue
        skShape.fillColor = color
        skShape.zPosition = 1
        return skShape
    }
}
