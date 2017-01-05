//
//  LoadScene.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/5/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class LoadScene: GameScene {

    override func load() {
        super.load()
        
        #if DEBUG
            //self.view?.showsFPS = true
            //self.view?.showsNodeCount = true
            //self.view?.showsPhysics = true
        #endif
        
        self.addChild(Control(imageNamed: "launchScreen", x: 0, y: 0, horizontalAlignment: .center, verticalAlignment: .center))
    }
}
