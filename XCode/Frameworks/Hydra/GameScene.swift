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
        
        let blackSpriteNode = BlackSpriteNode()
        self.blackSpriteNode = blackSpriteNode
        
        super.init(size: GameScene.currentSize)
        self.anchorPoint = CGPoint(x: 0, y: 1)
        self.backgroundColor = GameColors.background
        
        self.addChild(self.blackSpriteNode)
        self.blackSpriteNode.isHidden = true
        
        GameScene.lastInstance = self
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
        
        GameScene.translate.dx = (GameScene.currentSize.width - GameScene.sketchSize.width) / 2
        GameScene.translate.dy = (GameScene.currentSize.height - GameScene.sketchSize.height) / 2
        
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
    
    override func addChild(_ node: SKNode) {
        if let control = node as? Control {
            if GameScene.iPhoneX && control.canForceCenterVerticalAlignment() {
                control.verticalAlignment = .center
                control.resetPosition()
            }
        }
        super.addChild(node)
    }
    
    static var iPhoneX: Bool = {
        #if os(iOS)
        return UIDevice().type == Model.unrecognized
        #endif
        return false
    }()
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

enum Model : String {
    case
    iPod1            = "iPod 1",
    iPod2            = "iPod 2",
    iPod3            = "iPod 3",
    iPod4            = "iPod 4",
    iPod5            = "iPod 5",
    iPad2            = "iPad 2",
    iPad3            = "iPad 3",
    iPad4            = "iPad 4",
    iPhone4          = "iPhone 4",
    iPhone4S         = "iPhone 4S",
    iPhone5          = "iPhone 5",
    iPhone5S         = "iPhone 5S",
    iPhone5C         = "iPhone 5C",
    iPadMini1        = "iPad Mini 1",
    iPadMini2        = "iPad Mini 2",
    iPadMini3        = "iPad Mini 3",
    iPadAir1         = "iPad Air 1",
    iPadAir2         = "iPad Air 2",
    iPadPro9_7       = "iPad Pro 9.7\"",
    iPadPro9_7_cell  = "iPad Pro 9.7\" cellular",
    iPadPro10_5      = "iPad Pro 10.5\"",
    iPadPro10_5_cell = "iPad Pro 10.5\" cellular",
    iPadPro12_9      = "iPad Pro 12.9\"",
    iPadPro12_9_cell = "iPad Pro 12.9\" cellular",
    iPhone6          = "iPhone 6",
    iPhone6plus      = "iPhone 6 Plus",
    iPhone6S         = "iPhone 6S",
    iPhone6Splus     = "iPhone 6S Plus",
    iPhoneSE         = "iPhone SE",
    iPhone7          = "iPhone 7",
    iPhone7plus      = "iPhone 7 Plus",
    iPhone8          = "iPhone 8",
    iPhone8plus      = "iPhone 8 Plus",
    unrecognized     = "?unrecognized?"
}

#if os(iOS)
extension UIDevice {
    
    var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)

            }
        }
        let modelMap : [ String : Model ] = [
            "iPod1,1"    : .iPod1,
            "iPod2,1"    : .iPod2,
            "iPod3,1"    : .iPod3,
            "iPod4,1"    : .iPod4,
            "iPod5,1"    : .iPod5,
            "iPad2,1"    : .iPad2,
            "iPad2,2"    : .iPad2,
            "iPad2,3"    : .iPad2,
            "iPad2,4"    : .iPad2,
            "iPad2,5"    : .iPadMini1,
            "iPad2,6"    : .iPadMini1,
            "iPad2,7"    : .iPadMini1,
            "iPhone3,1"  : .iPhone4,
            "iPhone3,2"  : .iPhone4,
            "iPhone3,3"  : .iPhone4,
            "iPhone4,1"  : .iPhone4S,
            "iPhone5,1"  : .iPhone5,
            "iPhone5,2"  : .iPhone5,
            "iPhone5,3"  : .iPhone5C,
            "iPhone5,4"  : .iPhone5C,
            "iPad3,1"    : .iPad3,
            "iPad3,2"    : .iPad3,
            "iPad3,3"    : .iPad3,
            "iPad3,4"    : .iPad4,
            "iPad3,5"    : .iPad4,
            "iPad3,6"    : .iPad4,
            "iPhone6,1"  : .iPhone5S,
            "iPhone6,2"  : .iPhone5S,
            "iPad4,1"    : .iPadAir1,
            "iPad4,2"    : .iPadAir2,
            "iPad4,4"    : .iPadMini2,
            "iPad4,5"    : .iPadMini2,
            "iPad4,6"    : .iPadMini2,
            "iPad4,7"    : .iPadMini3,
            "iPad4,8"    : .iPadMini3,
            "iPad4,9"    : .iPadMini3,
            "iPad6,3"    : .iPadPro9_7,
            "iPad6,11"   : .iPadPro9_7,
            "iPad6,4"    : .iPadPro9_7_cell,
            "iPad6,12"   : .iPadPro9_7_cell,
            "iPad6,7"    : .iPadPro12_9,
            "iPad6,8"    : .iPadPro12_9_cell,
            "iPad7,3"    : .iPadPro10_5,
            "iPad7,4"    : .iPadPro10_5_cell,
            "iPhone7,1"  : .iPhone6plus,
            "iPhone7,2"  : .iPhone6,
            "iPhone8,1"  : .iPhone6S,
            "iPhone8,2"  : .iPhone6Splus,
            "iPhone8,4"  : .iPhoneSE,
            "iPhone9,1"  : .iPhone7,
            "iPhone9,2"  : .iPhone7plus,
            "iPhone9,3"  : .iPhone7,
            "iPhone9,4"  : .iPhone7plus,
            "iPhone10,1" : .iPhone8,
            "iPhone10,2" : .iPhone8plus
        ]

    if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            return model
        }
        return Model.unrecognized
    }
}
#endif
