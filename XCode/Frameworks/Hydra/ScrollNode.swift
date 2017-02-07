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
    
    init(cells: [Control] = [], spacing: CGFloat = 8, scrollDirection: scrollDirection = .vertical,
         x: CGFloat, y: CGFloat,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top
        ) {
        
        self.cells = cells
        
        self.scrollDirection = scrollDirection
        
        super.init(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, color: .clear)
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for cell in cells {
            switch scrollDirection {
            case .horizontal:
                cell.sketchPosition.x = x
                x = x + cell.size.width + spacing
                break
            case .vertical:
                cell.sketchPosition.y = y
                y = y + cell.size.height + spacing
                break
            }
            
            self.addChild(cell)
            cell.resetPosition()
        }
        
        self.size = self.calculateAccumulatedFrame().size
        
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchMoved(touch: UITouch) {
        self.touchMoved(touchDelta: touch.delta)
    }
    
    func touchMoved(touchDelta: CGPoint) {
        
        guard let cellsFirst = self.cells.first else { return }
        guard let cellsLast = self.cells.last else { return }
        
        var x = touchDelta.x * 2 * -1
        var y = touchDelta.y * 2
        
        switch self.scrollDirection {
        case .horizontal:
            
            if abs(x) > 1 {
                
                if x > 0 {
                    if cellsFirst.sketchPosition.x + x > 0 {
                        x = -cellsFirst.sketchPosition.x
                    }
                } else {
                    if cellsLast.sketchPosition.x + x < 0 {
                        x = -cellsLast.sketchPosition.x
                    }
                }
                
                for cell in self.cells {
                    cell.sketchPosition.x = cell.sketchPosition.x + x
                    cell.resetPosition()
                }
            }
            
            break
        case .vertical:
            
            if abs(y) > 1 {
                
                if y > 0 {
                    if cellsFirst.sketchPosition.y + y > 0 {
                        y = -cellsFirst.sketchPosition.y
                    }
                } else {
                    if cellsLast.sketchPosition.y + y < 0 {
                        y = -cellsLast.sketchPosition.y
                    }
                }
                
                for cell in self.cells {
                    cell.sketchPosition.y = cell.sketchPosition.y + y
                    cell.resetPosition()
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
