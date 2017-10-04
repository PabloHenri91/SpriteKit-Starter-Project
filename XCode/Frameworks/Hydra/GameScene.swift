//
//  GameScene.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 10/17/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

#if os(iOS)
    import UserNotifications
#endif

#if os(watchOS)
    import WatchKit
    typealias SKColor = UIColor
#endif

#if os(OSX)
    typealias UITouch = NSEvent
#endif

class GameScene: SKScene {
    
    private var fps = 0
    private var lastSecond: TimeInterval = 0
    var needMusic = true
    
    static func current() -> GameScene? {
        return GameScene.lastInstance
    }
    private static weak var lastInstance: GameScene? = nil
    
    static var currentTime: TimeInterval = 0
    
    static var defaultTransition = SKTransition.crossFade(withDuration: 1)
    static var defaultFilteringMode: SKTextureFilteringMode = .linear
    
    static var defaultSize = CGSize(width: 375, height: 667) // iPhone 6 Portrait
    static var viewBoundsSize = CGSize.zero
    static var sketchSize = CGSize.zero
    static var currentSize = CGSize.zero
    static var translate = CGVector.zero
    
    weak var blackSpriteNode: BlackSpriteNode!
    
    override init(size: CGSize = defaultSize) {
        
        Control.set = Set<Control>()
        
        GameScene.sketchSize = size
        GameScene.updateSize()
        
        self.blackSpriteNode = BlackSpriteNode()
        
        super.init(size: GameScene.currentSize)
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.backgroundColor = GameColors.background
        
        self.addChild(self.blackSpriteNode)
        self.blackSpriteNode.isHidden = true
        
        GameScene.lastInstance = self
        
        Metrics.loadScene(sceneName: "\(type(of: self).description().components(separatedBy: ".").last!)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func updateSize() {
        
        let xScale = GameScene.viewBoundsSize.width / GameScene.sketchSize.width
        let yScale = GameScene.viewBoundsSize.height / GameScene.sketchSize.height
        let scale = min(xScale, yScale)
        
        GameScene.currentSize.width = GameScene.viewBoundsSize.width / scale
        GameScene.currentSize.height = GameScene.viewBoundsSize.height / scale
        
        GameScene.translate.dx = (GameScene.currentSize.width - GameScene.sketchSize.width)/2
        GameScene.translate.dy = (GameScene.currentSize.height - GameScene.sketchSize.height)/2
        
        Control.resetPosition()
        
        GameScene.current()?.updateSize()
    }
    
    func updateSize() {
        
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
        self.fps = self.fps + 1
        
        if currentTime - self.lastSecond > 1 {
            self.lastSecond = currentTime
            self.fpsCountUpdate(fps: self.fps)
            self.fps = 0
        }
    }
    
    func fpsCountUpdate(fps: Int) {
        
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
    
    
    func registerUserNotificationSettings() {
        #if os(iOS)
            if #available(iOS 10.0, *) {
                let authorizationOptions: UNAuthorizationOptions = [.badge, .sound, .alert]
                UNUserNotificationCenter.current().requestAuthorization(options: authorizationOptions) { (granted: Bool, error: Error?) in
                    
                }
            } else {
                let userNotificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(userNotificationSettings)
            }
        #endif
    }
}

extension UITouch {
    var delta: CGPoint {
        get {
            #if os(iOS) || os(tvOS)
                return self.previousLocation(in: GameScene.current()!) - self.location(in: GameScene.current()!)
                #endif
            
            #if os(OSX)
                return CGPoint(x: -self.deltaX, y: self.deltaY)
            #endif
        }
    }
}

extension SKNode {
    
    #if DEBUG
    
    func printTree(count: Int = 0, name: String = "root") {
        for node in self.children {
            let className = type(of: node).description().components(separatedBy: ".").last!
            print("\(count + 1) \(name) \(className) \(node.zPosition)")
            node.printTree(count: count + 1, name: "\(name) \(className)")
        }
    }
    
    #endif
}

extension MutableCollection {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            self.swapAt(firstUnshuffled, i)
        }
    }
}

extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }
}
