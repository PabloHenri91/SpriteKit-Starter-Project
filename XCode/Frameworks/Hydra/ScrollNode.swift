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
        
        super.init(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, color: SKColor.clear)
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchMoved(touchDelta: CGPoint) {
        for cell in self.cells {
            switch self.scrollDirection {
            case .horizontal:
                cell.sketchPosition.x = cell.sketchPosition.x + (touchDelta.x * 2)
                break
            case .vertical:
                cell.sketchPosition.y = cell.sketchPosition.y + (touchDelta.y * 2)
                break
            }
            
            cell.resetPosition()
        }
    }
}
