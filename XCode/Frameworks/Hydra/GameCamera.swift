//
//  GameCamera.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 11/2/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameCamera: SKNode {
    
    weak var node: SKNode?
    
    func update(useLerp: Bool = false) {
        
        if let node = self.node {
            let newPosition = CGPoint(
                x: node.position.x - GameScene.currentSize.width/2,
                y: node.position.y + GameScene.currentSize.height/2)
            
            if useLerp {
                self.position = lerp(start: self.position, end: newPosition, t: 0.05)
            } else {
                self.position = newPosition
            }
        }
        
        self.scene?.centerOnNode(node: self)
    }
}

extension SKScene {
    
    func centerOnNode(node: SKNode) {
        if let parent = node.parent {
            if let cameraPositionInScene = parent.scene?.convert(node.position, from: parent) {
                parent.position = CGPoint(
                    x: CGFloat(parent.position.x - cameraPositionInScene.x),
                    y: CGFloat(parent.position.y - cameraPositionInScene.y))
            }
        }
    }
}
