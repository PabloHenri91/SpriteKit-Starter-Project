//
//  Box.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 11/10/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Box: Control {
    
    init(imageNamed name: String, x: CGFloat? = nil, y: CGFloat? = nil,
                  horizontalAlignment: horizontalAlignment = .center,
                  verticalAlignment: verticalAlignment = .center, animated: Bool = true) {
        
        super.init(imageNamed: name, x: x ?? 0, y: y ?? 0,
                   horizontalAlignment: horizontalAlignment,
                   verticalAlignment: verticalAlignment)
        
        self.alignCenter(x: x, y: y)
        
        if animated {
            self.pop()
        }
    }
    
    override init(x: CGFloat? = nil, y: CGFloat? = nil,
         horizontalAlignment: horizontalAlignment = .center,
         verticalAlignment: verticalAlignment = .center,
         color: SKColor = .clear, size: CGSize = CGSize(width: 1, height: 1)) {
        
        
        super.init(x: x ?? 0, y: y ?? 0, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, color: color, size: size)
        
        self.alignCenter(x: x, y: y)
        
        self.pop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func alignCenter(x: CGFloat? = nil, y: CGFloat? = nil) {
        if x == nil {
            self.sketchPosition.x = GameScene.sketchSize.width/2 - self.size.width/2
        }
        if y == nil {
            self.sketchPosition.y = GameScene.sketchSize.height/2 - self.size.height/2
        }
        self.resetPosition()
    }
    
    func pop() {
        
        self.resetPosition()
        
        let duration: Double = 1.0
        
        let x = position.x + (size.width/2)
        let y = position.y - (size.height/2)
        
        self.position = CGPoint(x: x, y: y)
        self.setScale(1)
        
        let effect0 = SKTScaleEffect(node: self, duration: duration, startScale: CGPoint(x: 0.01, y: 0.01), endScale: CGPoint(x: 1, y: 1))
        effect0.timingFunction = SKTTimingFunctionElasticEaseOut
        
        let effect1 = SKTMoveEffect(node: self, duration: duration, startPosition: self.position, endPosition: self.positionWith(sketchPosition: self.sketchPosition))
        effect1.timingFunction = SKTTimingFunctionElasticEaseOut
        
        self.run(SKAction.group([
            SKAction.actionWithEffect(effect0),
            SKAction.actionWithEffect(effect1)
            ]))
    }
    
    override func canForceCenterVerticalAlignment() -> Bool {
        return false
    }
}
