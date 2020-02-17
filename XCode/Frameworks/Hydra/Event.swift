//
//  Event.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 2/8/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit

class Event {
    
    typealias EventHandler = () -> ()
    
    private var eventHandlers = [EventHandler]()
    
    func add(handler: @escaping EventHandler) {
        self.eventHandlers.append(handler)
    }
    
    func raise() {
        for handler in eventHandlers {
            handler()
        }
    }
}
