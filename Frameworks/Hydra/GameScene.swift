//
//  GameScene.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 10/17/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

#if os(watchOS)
    import WatchKit
    typealias SKColor = UIColor
#endif

#if os(OSX)
    typealias UITouch = NSEvent
#endif

class GameScene: SKScene {
    
    static func current() -> GameScene? {
        return GameScene.lastInstance
    }
    private static weak var lastInstance: GameScene? = nil
    
    static var currentTime: TimeInterval = 0
    
    static let defaultTransition = SKTransition.crossFade(withDuration: 0.25)
    static let defaultFilteringMode: SKTextureFilteringMode = .linear
    
    static let defaultSize = CGSize(width: 667, height: 375)
    static var viewBoundsSize = CGSize.zero
    static var sketchSize = CGSize.zero
    static var currentSize = CGSize.zero
    static var translate = CGVector.zero
    
    override init(size: CGSize = defaultSize) {
        
        Control.set = Set<Control>()
        
        GameScene.sketchSize = size
        GameScene.updateSize()
        
        super.init(size: GameScene.currentSize)
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.backgroundColor = GameColors.background
        
        GameScene.lastInstance = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func updateSize() {
        
        let xScale = viewBoundsSize.width / sketchSize.width
        let yScale = viewBoundsSize.height / sketchSize.height
        let scale = min(xScale, yScale)
        
        self.currentSize.width = self.viewBoundsSize.width / scale
        self.currentSize.height = self.viewBoundsSize.height / scale
        
        self.translate.dx = (self.currentSize.width - self.sketchSize.width)/2
        self.translate.dy = (self.currentSize.height - self.sketchSize.height)/2
        
        Control.resetPosition()
    }
    
    func load() {
        self.scaleMode = SKSceneScaleMode.aspectFit
    }
    
    #if os(watchOS)
    override func sceneDidLoad() {
        self.load()
    }
    #else
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        self.load()
    }
    #endif
    
    override func update(_ currentTime: TimeInterval) {
        GameScene.currentTime = currentTime
    }
    
    func touchDown(touch: UITouch) {
        
    }
    
    func touchMoved(touch: UITouch) {
        
    }
    
    func touchUp(touch: UITouch) {
        
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
    
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        default:
            print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
            break
        }
    }
    
    #endif
}
