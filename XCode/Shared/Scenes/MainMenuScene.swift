//
//  MainMenuScene.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/5/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class MainMenuScene: GameScene {
    
    weak var buttonBox: Button!
    
    init() {
        super.init()
        
        self.backgroundColor = #colorLiteral(red: 0.0862745098, green: 0.05882352941, blue: 0.1490196078, alpha: 1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func load() {
        super.load()
        
        self.addChild(Label(text: "Main Menu", x: 332, y: 26, horizontalAlignment: .center, verticalAlignment: .top))
        
        
        self.addChild(Button(imageNamed: "buttonBlue144x34", text: "Button", x: 59, y: 171, horizontalAlignment: .center, verticalAlignment: .center))
        
        
        self.buttonBox = Button(imageNamed: "buttonBlue144x34", text: "Box", x: 262, y: 171, horizontalAlignment: .center, verticalAlignment: .center)
        self.addChild(self.buttonBox)
        
        self.buttonBox.touchUpEvent = { [weak self] in
            self?.addChild(CustomBox())
        }
    }
}
