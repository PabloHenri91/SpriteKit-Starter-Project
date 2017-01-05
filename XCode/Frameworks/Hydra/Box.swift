//
//  Box.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 11/10/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Box: Control {

    
    override init(imageNamed name: String, x: CGFloat? = nil, y: CGFloat? = nil,
                  horizontalAlignment: horizontalAlignment = .center,
                  verticalAlignment: verticalAlignment = .center) {
        
        super.init(imageNamed: name, x: x ?? 0, y: y ?? 0,
                   horizontalAlignment: horizontalAlignment,
                   verticalAlignment: verticalAlignment)
        
        if x == nil {
            self.sketchPosition.x = GameScene.sketchSize.width/2 - self.size.width/2
        }
        if y == nil {
            self.sketchPosition.y = GameScene.sketchSize.height/2 - self.size.height/2
        }
        self.resetPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
