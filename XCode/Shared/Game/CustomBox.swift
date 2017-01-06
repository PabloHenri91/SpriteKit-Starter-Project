//
//  CustomBox.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/5/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class CustomBox: Box {

    init() {
        super.init(imageNamed: "boxWhite233x233")
        
        if let scene = GameScene.current() {
            scene.blackSpriteNode.isHidden = false
            scene.blackSpriteNode.zPosition = 100000
        }
        
        self.zPosition = 1000000
        
        let button = Button(imageNamed: "buttonBlue144x34", text: "OK", x: 45, y: 189)
        button.touchUpEvent = { [weak self] in
            self?.removeFromParent()
        }
        
        self.addChild(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        
        if let scene = GameScene.current() {
            scene.blackSpriteNode.isHidden = true
        }
    }
}
