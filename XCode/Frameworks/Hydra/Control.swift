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
    
    weak var control: Control?
    
    init(x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top,
         color: SKColor = .clear, size: CGSize = CGSize(width: 1, height: 1)) {
        
        super.init(texture: nil, color: color, size: size)
        
        self.load(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
    }
    
    init(imageNamed name: String, x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top) {
        
        let words = name.components(separatedBy: "_")
        if words.count > 1 {
            let control = Control(imageNamed: words[0], x: 0, y: 0)
            let words = words[1].components(separatedBy: "x")
            let size = CGSize(width: Int(words[0]) ?? 0, height: Int(words[1]) ?? 0)
            super.init(texture: nil, color: .clear, size: size)
            self.addChild(control)
            self.control = control
            control.centerRect = CGRect(origin: CGPoint(x: 0.5, y: 0.5), size: CGSize(width: 0, height: 0))
            control.xScale = self.size.width / control.size.width
            control.yScale = self.size.height / control.size.height
        } else {
            let texture = SKTexture(imageNamed: name, filteringMode: GameScene.defaultFilteringMode)
            super.init(texture: texture, color: .clear, size: texture.size())
        }
        
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
        let x = (GameScene.translate.dx * self.horizontalAlignment.rawValue)
        let y = -(GameScene.translate.dy * self.verticalAlignment.rawValue)
        self.position = CGPoint(
            x: self.sketchPosition.x + x,
            y: -self.sketchPosition.y + y
        )
    }
    
    func positionWith(sketchPosition: CGPoint) -> CGPoint {
        let x = (GameScene.translate.dx * self.horizontalAlignment.rawValue)
        let y = -(GameScene.translate.dy * self.verticalAlignment.rawValue)
        return CGPoint(
            x: sketchPosition.x + x,
            y: -sketchPosition.y + y
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
    
    override func addChild(_ node: SKNode) {
        let yScale = node.yScale
        let xScale = node.xScale
        super.addChild(node)
        node.xScale = xScale/self.xScale
        node.yScale = yScale/self.yScale
    }
    
    override func set(color: SKColor, blendMode: SKBlendMode = .alpha) {
        if let control = self.control {
            control.set(color: color, blendMode: blendMode)
        } else {
            super.set(color: color, blendMode: blendMode)
        }
    }
    
    func canForceCenterVerticalAlignment() -> Bool {
        return true
    }
}

extension SKSpriteNode {
    
    convenience init(imageNamed name: String, filteringMode: SKTextureFilteringMode = GameScene.defaultFilteringMode) {
        self.init(imageNamed: name)
        self.texture?.filteringMode = filteringMode
    }
    
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
    
    @objc func set(color: SKColor, blendMode: SKBlendMode = .alpha) {
        self.color = color
        self.colorBlendFactor = 1
        self.blendMode = blendMode
    }
    
    override open func move(toParent parent: SKNode) {
        super.removeFromParent()
        parent.addChild(self)
    }
}

extension SKTexture {
    convenience init(imageNamed name: String, filteringMode: SKTextureFilteringMode = GameScene.defaultFilteringMode) {
        self.init(imageNamed: name)
        self.filteringMode = filteringMode
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
