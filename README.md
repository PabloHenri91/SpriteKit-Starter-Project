# SpriteKit-Starter-Project
This is a starter project that I use as reference when I start developing new games with SpriteKit in Swift


GameScene and transition between Scenes
```
import SpriteKit

class LoadScene: GameScene {
    
    enum state: String {
        case load
        case mainMenu
    }
    
    var state: state = .load
    var nextState: state = .load
    
    init() {
        GameScene.defaultSize = CGSize(width: 375, height: 667)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func load() {
        super.load()
        
        #if DEBUG
            self.view?.showsFPS = true
        #endif
        
        self.backgroundColor = GameColors.loadSceneBackground
        
        self.addChild(Control(imageNamed: "launchScreenPortrait", x: 0, y: 0, horizontalAlignment: .center, verticalAlignment: .center))
        
        self.afterDelay(1) { [weak self] in
            self?.nextState = .mainMenu
        }
        
        Label.defaultFontName = .kenPixel
    }
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        if self.state == self.nextState {
            
            switch self.state {
                
            case .load:
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
```


Control
```
        let coins = Control(imageNamed: "Coins", x: 45, y: 73)
        coins.setScaleToFit(size: CGSize(width: 55, height: 55))
        coins.set(color: GameColors.controlBlue)
        self.addChild(coins)
```


Button
```
        let buttonPlay = Button(imageNamed: "button233x55", x: 71, y: 604, horizontalAlignment: .center, verticalAlignment: .bottom)
        buttonPlay.setIcon(imageNamed: "Play")
        buttonPlay.set(color: GameColors.controlRed, blendMode: .add)
        self.addChild(buttonPlay)
        buttonPlay.touchUpEvent = { [weak self] in
            self?.nextState = .battle
        }
```


Label

```
self.addChild(Label(text: "title", fontColor: GameColors.fontWhite, x: 117, y: 40))
```

Custom Dialog Box
```
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
        
        self.addChild(MultiLineLabel(text: "Lorem ipsum dolor sit amet.", maxWidth: self.size.width - 16, x: 8, y: 8))
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
```


ScrollNode
```
        let playerData = MemoryCard.sharedInstance.playerData!
        
        var cellsPlayerDataSpaceships = [SpaceshipHangarCell]()
        
        if let playerDataSpaceships = (playerData.spaceships as? Set<SpaceshipData>)?.sorted(by: {
            $0.baseDamage > $1.baseDamage
        }) {
            for spaceshipData in playerDataSpaceships {
                let spaceship = Spaceship(spaceshipData: spaceshipData)
                cellsPlayerDataSpaceships.append(SpaceshipHangarCell(spaceship: spaceship))
            }
        }
        
        let scrollNode = ScrollNode(cells: cellsPlayerDataSpaceships, spacing: 71, scrollDirection: .horizontal, x: 71, y: 369, horizontalAlignment: .center, verticalAlignment: .center)
        scrollNode.isUserInteractionEnabled = false
        self.addChild(scrollNode)
```
