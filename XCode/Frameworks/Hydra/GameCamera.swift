//
//  GameCamera.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 11/2/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameCamera: SKNode {
    
    var node: SKNode?
    
    func update() {
        
        if let node = self.node {
            let newPosition = node.position
            self.position = CGPoint(
                x: newPosition.x - GameScene.currentSize.width/2,
                y: newPosition.y + GameScene.currentSize.height/2)
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
