//
//  AppDelegate.swift
//  Hydra
//
//  Created by Pablo Henrique Bertaco on 1/5/17.
//  Copyright © 2017 PabloHenri91. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        MemoryCard.sharedInstance.saveGame()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }


}

