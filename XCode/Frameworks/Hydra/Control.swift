//
//  Control.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 10/18/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Control: SKSpriteNode {
    
    static var set = Set<Control>()
    
    enum horizontalAlignment: CGFloat {
        case left = 0
        case center = 1
        case right = 2
    }
    
    enum verticalAlignment: CGFloat {
        case top = 0
        case center = 1
        case bottom = 2
    }
    
    
    var verticalAlignment: verticalAlignment = .top
    var horizontalAlignment: horizontalAlignment = .left
    
    var sketchPosition: CGPoint = CGPoint.zero
    
    init(x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top,
         color: SKColor = SKColor.clear, size: CGSize = CGSize(width: 1, height: 1)) {
        
        super.init(texture: nil, color: color, size: size)
        
        self.load(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
    }
    
    init(imageNamed name: String, x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        
        let texture = SKTexture(imageNamed: name)
        texture.filteringMode = GameScene.defaultFilteringMode
        
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.load(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
    }
    
    private func load(x: CGFloat, y: CGFloat,
                      horizontalAlignment: horizontalAlignment = .left,
                      verticalAlignment: verticalAlignment = .top) {
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.sketchPosition = CGPoint(x: x, y: y)
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        
        self.resetPosition()
        
        Control.set.insert(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contains(_ touch: UITouch) -> Bool {
        if self.isHidden {
            return false
        }
        if let parent = self.parent {
            return self.contains(touch.location(in: parent))
        }
        return false
    }
    
    func resetPosition() {
        self.position = CGPoint(
            x: self.sketchPosition.x + (GameScene.translate.dx * self.horizontalAlignment.rawValue),
            y: -self.sketchPosition.y + -(GameScene.translate.dy * self.verticalAlignment.rawValue)
        )
    }
    
    func positionWith(sketchPosition: CGPoint) -> CGPoint {
        
        return CGPoint(
            x: sketchPosition.x + (GameScene.translate.dx * self.horizontalAlignment.rawValue),
            y: -sketchPosition.y + -(GameScene.translate.dy * self.verticalAlignment.rawValue)
        )
    }
    
    override func removeFromParent() {
        
        for node in self.children {
            node.removeFromParent()
        }
        
        self.removeAllActions()
        self.removeAllChildren()
        super.removeFromParent()
        
        Control.set.remove(self)
    }
    
    static func resetPosition() {
        for control in Control.set {
            control.resetPosition()
        }
    }
}

extension SKSpriteNode {
    
    func setScaleToFit(width: CGFloat, height: CGFloat) {
        self.setScale(1)
        let xScale = width / self.size.width
        let yScale = height / self.size.height
        self.setScale(min(xScale, yScale))
        
        if self.xScale > 1 {
            self.setScale(1)
        }
    }
    
    func setScaleToFit(size: CGSize) {
        self.setScaleToFit(width: size.width, height: size.height)
    }
}

extension SKNode {
    
    func destroy() {
        
        for node in self.children {
            node.destroy()
        }
        
        self.removeAllActions()
        self.removeAllChildren()
        self.removeFromParent()
    }
}
