//
//  PlayerData+CoreDataProperties.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/6/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension MemoryCard {

    func newPlayerData() -> PlayerData {
        let playerData = NSEntityDescription.insertNewObject(forEntityName: "PlayerData", into: self.managedObjectContext) as! PlayerData
        
        playerData.modelVersion = 1
        playerData.name = ""
        
        return playerData
    }
    
    func updateModelVersion() {
        if self.playerData.modelVersion < 1 {
            self.playerData.modelVersion = 1
        }
    }
}

extension PlayerData {
    
    func addData(value: NSManagedObject) {
        let items = self.mutableSetValue(forKey: "")
        items.add(value)
    }
    
    func removeData(value: NSManagedObject) {
        let items = self.mutableSetValue(forKey: "")
        items.remove(value)
    }
}
