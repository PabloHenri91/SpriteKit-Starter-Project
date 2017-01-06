//
//  Box.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 11/10/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Box: Control {
    
    override init(imageNamed name: String, x: CGFloat? = nil, y: CGFloat? = nil,
                  horizontalAlignment: horizontalAlignment = .center,
                  verticalAlignment: verticalAlignment = .center) {
        
        super.init(imageNamed: name, x: x ?? 0, y: y ?? 0,
                   horizontalAlignment: horizontalAlignment,
                   verticalAlignment: verticalAlignment)
        
        if x == nil {
            self.sketchPosition.x = GameScene.sketchSize.width/2 - self.size.width/2
        }
        if y == nil {
            self.sketchPosition.y = GameScene.sketchSize.height/2 - self.size.height/2
        }
        self.resetPosition()
        
        self.pop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pop() {
        
        self.resetPosition()
        
        let duration: Double = 1.0
        
        let x = position.x + (size.width/2)
        let y = position.y - (size.height/2)
        
        self.position = CGPoint(x: x, y: y)
        self.setScale(1)
        
        self.run(SKAction.group([
            SKAction.actionWithEffect(SKTScaleEffect(node: self, duration: duration, startScale: CGPoint(x: 0.01, y: 0.01), endScale: CGPoint(x: 1, y: 1))),
            SKAction.actionWithEffect(SKTMoveEffect(node: self, duration: duration, startPosition: self.position, endPosition: self.positionWith(sketchPosition: self.sketchPosition)))
            ]))
    }
    
}
