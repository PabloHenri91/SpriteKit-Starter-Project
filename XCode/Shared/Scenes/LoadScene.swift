//
//  LoadScene.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/5/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class LoadScene: GameScene {
    
    enum state: String {
        case load
        case mainMenu
    }
    
    var state: state = .load
    var nextState: state = .load
    
    init() {
        
        GameScene.defaultSize = CGSize(width: 667, height: 375)
        GameScene.defaultFilteringMode = .nearest
        
        Label.defaultColor = GameColors.fontWhite
        
        super.init()
        
        self.backgroundColor = GameColors.loadSceneBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func load() {
        super.load()
        
        #if DEBUG
            self.view?.showsFPS = true
            //self.view?.showsNodeCount = true
            //self.view?.showsPhysics = true
            
            //MemoryCard.sharedInstance.reset()
        #endif
        
        self.addChild(Control(imageNamed: "launchScreenLandscape", x: 0, y: 0, horizontalAlignment: .center, verticalAlignment: .center))
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self.state == self.nextState {
            
            switch self.state {
                
            case .load:
                self.nextState = .mainMenu
                break
                
            case .mainMenu:
                break
            }
        } else {
            self.state = self.nextState
            
            switch self.nextState {
                
            case .load:
                break
                
            case .mainMenu:
                self.view?.presentScene(MainMenuScene(), transition: GameScene.defaultTransition)
                break
            }
        }
    }
}
