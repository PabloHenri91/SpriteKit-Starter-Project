//
//  Button.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 11/2/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Button: Control {
    
    var text: String {
        get {
            return self.label?.text ?? ""
        }
        set {
            self.label?.text = newValue
        }
    }
    
    weak var label: Label?
    
    weak var icon: SKSpriteNode?
    
    private var touchUpEvent: Event?
    
    func addHandler(block: @escaping () -> Void) {
        if self.touchUpEvent == nil  {
            self.touchUpEvent = Event()
        }
        self.touchUpEvent?.add(handler: block)
    }
    
    func removeAllHandlers() {
        self.touchUpEvent = nil
    }
    
    init(imageNamed name: String, text: String = "", x: CGFloat, y: CGFloat,
                  horizontalAlignment: horizontalAlignment = .left,
                  verticalAlignment: verticalAlignment = .top) {
        
        super.init(imageNamed: name, x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        if text != "" {
            self.set(label: Label(text: text))
        }
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(label: Label) {
        label.sketchPosition = label.sketchPosition +  CGPoint(x: self.size.width/2, y: self.size.height/2)
        label.resetPosition()
        self.addChild(label)
        self.label = label
    }
    
    override func set(color: SKColor, blendMode: SKBlendMode = .alpha) {
        super.set(color: color, blendMode: blendMode)
        self.icon?.color = color
        self.icon?.colorBlendFactor = 1
        self.icon?.blendMode = blendMode
    }
    
    func setIcon(imageNamed name: String) {
        
        let texture = SKTexture(imageNamed: name, filteringMode: GameScene.defaultFilteringMode)
        
        let icon = SKSpriteNode(texture: texture, color: self.color, size: texture.size())
        self.set(color: self.color, blendMode: self.blendMode)
        
        icon.setScaleToFit(size: self.size)
        
        icon.position = CGPoint(x: self.size.width/2, y: -self.size.height/2)
        
        self.addChild(icon)
        self.icon?.removeFromParent()
        self.icon = icon
    }
    
    func touchDown(touch: UITouch) {
        
        self.resetPosition()
        
        let duration:Double = 0.125
        
        let x = position.x + (size.width/2) * 0.05
        let y = position.y - (size.height/2) * 0.05
        
        self.run(SKAction.group([
            SKAction.scale(to: 0.95 , duration: duration),
            SKAction.move(to: CGPoint(x: x, y: y), duration: duration)
            ]))
    }
    
    func touchMoved(touch: UITouch) {
        
    }
    
    func touchUp(touch: UITouch) {
        
        let duration:Double = 0.125
        
        self.run(SKAction.group([
            SKAction.scale(to: 1.0 , duration: duration),
            SKAction.move(to: self.positionWith(sketchPosition: self.sketchPosition), duration: duration)
            ]))
        
        if let parent = self.parent {
            if self.contains(touch.location(in: parent)) {
                self.touchUpEvent?.raise()
            }
        }
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        self.removeAllHandlers()
    }
    
    #if os(iOS) || os(tvOS)
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(touch: t) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(touch: t) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(touch: t) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(touch: t) }
    }
    
    #endif
    
    #if os(OSX)
    
    override func mouseDown(with event: UITouch) {
        self.touchDown(touch: event)
    }
    
    override func mouseDragged(with event: UITouch) {
        self.touchMoved(touch: event)
        
    }
    
    override func mouseUp(with event: UITouch) {
        self.touchUp(touch: event)
    }
    
    #endif
}
