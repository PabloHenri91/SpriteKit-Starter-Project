//
//  BlackSpriteNode.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/5/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class BlackSpriteNode: Control {

    init() {
        super.init(x: 0, y: 0, color: GameColors.blackSpriteNode, size: GameScene.currentSize)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func resetPosition() {
        super.resetPosition()
        self.size = GameScene.currentSize
    }
}
