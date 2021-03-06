//
//  GameViewController.swift
//  tvOS
//
//  Created by Pablo Henrique Bertaco on 1/5/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameScene.viewBoundsSize = self.view.bounds.size
        
        let scene = LoadScene()
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let view = self.view as? SKView {
            if let scene = view.scene {
                GameScene.viewBoundsSize = self.view.bounds.size
                GameScene.updateSize()
                scene.size = GameScene.currentSize
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
