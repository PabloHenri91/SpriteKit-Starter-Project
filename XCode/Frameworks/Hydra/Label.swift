//
//  Label.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 10/31/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Label: Control {
    
    static var defaultColor = GameColors.fontBlack
    static var defaultFontName = fontName.default
    static var defaultSize = fontSize.fontSize16
    
    enum fontName: String {
        case `default` = "Verdana"
        case kenPixel = "KenPixel Regular"
    }
    
    enum fontSize: CGFloat {
        case fontSize8 = 8
        case fontSize16 = 16
        case fontSize24 = 24
        case fontSize32 = 32
    }
    
    var text: String {
        get {
            return self.labelNode.text ?? ""
        }
        set(newValue) {
            self.labelNode.text = newValue
            for labelNode in self.shadowLabelNodes {
                labelNode.text = newValue
            }
        }
    }
    
    var fontSize: fontSize {
        get {
            return Label.fontSize(rawValue: self.labelNode.fontSize)!
        }
        set(newValue) {
            self.labelNode.fontSize = newValue.rawValue
        }
    }
    
    private weak var labelNode: SKLabelNode!
    private var shadowLabelNodes: [SKLabelNode]
    
    init(text: String,
         horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .center,
         verticalAlignmentMode: SKLabelVerticalAlignmentMode = .center,
         fontName: fontName = Label.defaultFontName,
         fontSize: fontSize = Label.defaultSize,
         fontColor: SKColor = Label.defaultColor,
         x: CGFloat = 0, y: CGFloat = 0,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top
        ) {
        
        let labelNode = SKLabelNode(fontNamed: fontName.rawValue)
        labelNode.fontSize = fontSize.rawValue
        labelNode.fontColor = fontColor
        labelNode.horizontalAlignmentMode = horizontalAlignmentMode
        labelNode.verticalAlignmentMode = verticalAlignmentMode
        labelNode.text = text
        
        self.shadowLabelNodes = [SKLabelNode]()
        
        super.init(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment)
        
        self.addChild(labelNode)
        self.labelNode = labelNode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addShadow(color: SKColor = GameColors.fontWhite, x: Int = 1, y: Int = -1) {
        let shadowLabelNode = SKLabelNode(fontNamed: self.labelNode.fontName)
        shadowLabelNode.fontSize = self.labelNode.fontSize
        shadowLabelNode.fontColor = color
        shadowLabelNode.horizontalAlignmentMode = self.labelNode.horizontalAlignmentMode
        shadowLabelNode.verticalAlignmentMode = self.labelNode.verticalAlignmentMode
        shadowLabelNode.text = self.labelNode.text
        shadowLabelNode.position = CGPoint(x: x, y: y)
        
        self.shadowLabelNodes.append(shadowLabelNode)
        self.addChild(shadowLabelNode)
        self.labelNode.bringToFront()
    }
    
    func addBorder(color: SKColor = GameColors.fontWhite, thickness: Int = 1) {
        for x in -1...1 {
            for y in -1...1 {
                if !(x == 0 && y == 0) {
                    self.addShadow(color: color, x: x, y: y)
                }
            }
        }
    }
    
    override func set(color: SKColor, blendMode: SKBlendMode = .alpha) {
        self.labelNode.fontColor = color
    }
    
    #if os(OSX)
    static func printFonts() {
        let fonts = NSFontManager.shared.availableFontFamilies
        for name in fonts {
            print("\(name)")
        }
    }
    #endif
}

extension String {
    
    func translation() -> String {
        let translated = NSLocalizedString(self, comment: self)
        if translated == self {
            //print(self)
        }
        return translated
    }
}
