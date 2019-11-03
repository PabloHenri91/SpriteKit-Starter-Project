//
//  BlackSpriteNode.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/5/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BlackSpriteNode: Control {
    
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

    init() {
        super.init(x: 0, y: 0, color: GameColors.blackSpriteNode, size: GameScene.currentSize)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resetPosition() {
        super.resetPosition()
        self.size = GameScene.currentSize
    }
    
    func touchUp(touch: UITouch) {
        if let parent = self.parent {
            if self.contains(touch.location(in: parent)) {
                self.touchUpEvent?.raise()
            }
        }
    }
    
    #if os(iOS) || os(tvOS)
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(touch: t) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(touch: t) }
    }
    
    #endif
    
    #if os(OSX)
    
    override func mouseUp(with event: UITouch) {
        self.touchUp(touch: event)
    }
    
    #endif
    
    override func canForceCenterVerticalAlignment() -> Bool {
        return false
    }
}
