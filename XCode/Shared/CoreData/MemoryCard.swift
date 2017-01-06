//
//  MemoryCard.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/6/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import SpriteKit
import CoreData

class MemoryCard {
    
    static let sharedInstance = MemoryCard()
    
    private var autoSave: Bool = false
    
    var playerData: PlayerData!
    
    init() {
        self.loadGame()
    }
    
    func newGame() {
        //print("MemoryCard.newGame()")
        self.playerData = self.newPlayerData()
        self.autoSave = true
        self.saveGame()
    }
    
    func saveGame() {
        //print("MemoryCard.saveGame()")
        if self.autoSave {
            self.autoSave = false
            self.saveContext()
            self.autoSave = true
        }
    }
    
    func loadGame() {
        guard self.playerData == nil else { return }
        //print("MemoryCard.loadGame()")
        
        let fetchRequestData = self.fetchRequest()
        
        if(fetchRequestData.count > 0) {
            self.playerData = fetchRequestData.last
            self.updateModelVersion()
            self.autoSave = true
        } else {
            self.newGame()
        }
    }
    
    func reset() {
        //print("MemoryCard.reset()")
        
        let fetchRequestData = self.fetchRequest()
        
        for item in fetchRequestData {
            self.managedObjectContext.delete(item)
        }
        
        self.playerData = nil
        
        self.autoSave = false
        self.newGame()
    }
    
    func fetchRequest() -> [PlayerData] {
        let fetchRequest: NSFetchRequest<PlayerData> = PlayerData.fetchRequest()
        return try! self.managedObjectContext.fetch(fetchRequest)
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        let url = urls.last!.appendingPathComponent(Bundle.main.bundleIdentifier!)
        
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: url.path) {
            try! fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        
        return url
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let url = Bundle.main.url(forResource: "Model", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: url)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let productName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let url = self.applicationDocumentsDirectory.appendingPathComponent("\(productName).sqlite")
        
        try! coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        if self.managedObjectContext.hasChanges {
            try! managedObjectContext.save()
        }
    }
}
