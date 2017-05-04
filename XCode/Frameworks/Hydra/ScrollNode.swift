//
//  ScrollNode.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 2/1/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class ScrollNode: Control {
    
    enum scrollDirection {
        /// cells scrolling left and right.
        case horizontal
        
        /// cells scrolling up and down.
        case vertical
    }
 
    var cells: [Control]
    
    var scrollDirection: scrollDirection
    
    private var cellIndex: Int
    private var spacing: CGFloat
    
    init(cells: [Control] = [], spacing: CGFloat = 8, scrollDirection: scrollDirection = .vertical,
         x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top
        ) {
        
        self.cells = cells
        
        self.scrollDirection = scrollDirection
        
        self.cellIndex = 0
        self.spacing = spacing
        
        super.init(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, color: .clear)
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for cell in cells {
            switch scrollDirection {
            case .horizontal:
                cell.position.x = x
                x = x + cell.size.width + spacing
                break
            case .vertical:
                cell.position.y = y
                y = y - cell.size.height - spacing
                break
            }
            
            self.addChild(cell)
            Control.set.remove(cell)
        }
        
        self.size = self.calculateAccumulatedFrame().size
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func remove(at index: Int) {
        switch self.scrollDirection {
        case .horizontal:
            var i = 0
            for cell in self.cells {
                if i > index {
                    let moveEffect = SKTMoveEffect(node: cell, duration: 0.5, startPosition: cell.position, endPosition: cell.position +
                        CGPoint(x: -cell.size.width + -self.spacing, y: 0))
                    moveEffect.timingFunction = SKTTimingFunctionQuinticEaseInOut
                    cell.run(SKAction.actionWithEffect(moveEffect))
                }
                i = i + 1
            }
            break
        case .vertical:
            var i = 0
            for cell in self.cells {
                if i > index {
                    let moveEffect = SKTMoveEffect(node: cell, duration: 0.5, startPosition: cell.position, endPosition: cell.position +
                        CGPoint(x: 0, y: cell.size.height + self.spacing))
                    moveEffect.timingFunction = SKTTimingFunctionQuinticEaseInOut
                    cell.run(SKAction.actionWithEffect(moveEffect))
                }
                i = i + 1
            }
            break
        }
        self.cells.remove(at: index).removeFromParent()
    }
    
    func back() {
        guard self.cellIndex > 0 else { return }
        self.cellIndex = self.cellIndex - 1
        
        switch self.scrollDirection {
        case .horizontal:
            for cell in self.cells {
                let moveEffect = SKTMoveEffect(node: cell, duration: 0.5, startPosition: cell.position, endPosition: cell.position +
                    CGPoint(x: cell.size.width + self.spacing, y: 0))
                moveEffect.timingFunction = SKTTimingFunctionQuinticEaseInOut
                cell.run(SKAction.actionWithEffect(moveEffect))
            }
            break
        case .vertical:
            for cell in self.cells {
                let moveEffect = SKTMoveEffect(node: cell, duration: 0.5, startPosition: cell.position, endPosition: cell.position +
                    CGPoint(x: 0, y: -cell.size.height + -self.spacing))
                moveEffect.timingFunction = SKTTimingFunctionQuinticEaseInOut
                cell.run(SKAction.actionWithEffect(moveEffect))
            }
            break
        }
    }
    
    func forward() {
        guard self.cellIndex < self.cells.count - 1 else { return }
        self.cellIndex = self.cellIndex + 1
        
        switch self.scrollDirection {
        case .horizontal:
            for cell in self.cells {
                let moveEffect = SKTMoveEffect(node: cell, duration: 0.5, startPosition: cell.position, endPosition: cell.position +
                    CGPoint(x: -cell.size.width + -self.spacing, y: 0))
                moveEffect.timingFunction = SKTTimingFunctionQuinticEaseInOut
                cell.run(SKAction.actionWithEffect(moveEffect))
            }
            break
        case .vertical:
            for cell in self.cells {
                let moveEffect = SKTMoveEffect(node: cell, duration: 0.5, startPosition: cell.position, endPosition: cell.position +
                    CGPoint(x: 0, y: cell.size.height + self.spacing))
                moveEffect.timingFunction = SKTTimingFunctionQuinticEaseInOut
                cell.run(SKAction.actionWithEffect(moveEffect))
            }
            break
        }
    }
    
    func touchMoved(touch: UITouch) {
        self.touchMoved(touchDelta: touch.delta)
    }
    
    func touchMoved(touchDelta: CGPoint) {
        
        guard let cellsFirst = self.cells.first else { return }
        guard let cellsLast = self.cells.last else { return }
        
        var x = touchDelta.x * 2 * -1
        var y = touchDelta.y * 2 * -1
        
        switch self.scrollDirection {
        case .horizontal:
            
            if abs(x) > 1 {
                
                if x > 0 {
                    if cellsFirst.position.x + x > 0 {
                        x = -cellsFirst.position.x
                    }
                } else {
                    if cellsLast.position.x + x < 0 {
                        x = -cellsLast.position.x
                    }
                }
                
                for cell in self.cells {
                    cell.position.x = cell.position.x + x
                }
            }
            
            break
        case .vertical:
            
            if abs(y) > 1 {
                
                if y > 0 {
                    if cellsLast.position.y + y > 0 {
                        y = -cellsLast.position.y
                    }
                } else {
                    if cellsFirst.position.y + y < 0 {
                        y = -cellsFirst.position.y
                    }
                }
                
                for cell in self.cells {
                    cell.position.y = cell.position.y + y
                }
            }
            break
        }
    }
    
    
    
    #if os(iOS) || os(tvOS)
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(touch: t) }
    }
    #endif
    
    #if os(OSX)
    override func mouseDragged(with event: UITouch) {
        self.touchMoved(touch: event)
    }
    #endif
}
