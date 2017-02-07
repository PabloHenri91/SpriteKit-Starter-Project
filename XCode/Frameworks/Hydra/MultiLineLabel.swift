//
//  MultiLineLabel.swift
//  Hydra
//
//  Created by Paulo Henrique dos Santos on 06/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class MultiLineLabel: Control {

    init(text: String,
         maxWidth: CGFloat = 610,
         horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .left,
         verticalAlignmentMode: SKLabelVerticalAlignmentMode = .baseline,
         fontName: Label.fontName = Label.defaultFontName,
         fontSize: Label.fontSize = .fontSize16,
         fontColor: SKColor = Label.defaultColor,
         x: CGFloat = 0, y: CGFloat = 0,
         horizontalAlignment: horizontalAlignment = .left,
         verticalAlignment: verticalAlignment = .top
        ) {
    
        let verticalAlignmentMode: SKLabelVerticalAlignmentMode = .baseline
        
        let words = text.components(separatedBy: " ")
        var labels = [Label]()
        var wordsIterator = words.makeIterator()
        
        while let word = wordsIterator.next() {
            
            var label = Label(text: word, horizontalAlignmentMode: horizontalAlignmentMode, verticalAlignmentMode: verticalAlignmentMode, fontName: fontName, fontSize: fontSize, fontColor: fontColor)
            
            while label.calculateAccumulatedFrame().size.width < maxWidth {
                guard let word = wordsIterator.next() else { break }
                
                let text = label.text
                label.text = label.text + " " + word
                if label.calculateAccumulatedFrame().size.width > maxWidth {
                    label.text = text
                    labels.append(label)
                    label = Label(text: word, horizontalAlignmentMode: horizontalAlignmentMode, verticalAlignmentMode: verticalAlignmentMode, fontName: fontName, fontSize: fontSize, fontColor: fontColor)
                }
            }
            labels.append(label)
        }
        
        super.init(x: x, y: y, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, color: .clear)
        
        var y: CGFloat = fontSize.rawValue
        for label in labels {
            self.addChild(label)
            label.sketchPosition.y = y
            label.resetPosition()
            
            y = y + fontSize.rawValue + 1
        }
        
        self.size.height = self.calculateAccumulatedFrame().size.height
        self.size.width = maxWidth
        
        var x: CGFloat = 0
        switch horizontalAlignmentMode {
        case .center:
            x = self.size.width/2
            break
        case .left:
            break
        case .right:
            x = self.size.width
            break
        }
        for label in labels {
            label.sketchPosition.x = x
            label.resetPosition()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
