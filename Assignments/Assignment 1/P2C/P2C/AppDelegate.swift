//
//  AppDelegate.swift
//  P2C
//
//  Created by Aaron Wojnowski on 2015-10-05.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {
    
    var delegate: ViewControllerDelegate?
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        delegate = NSApplication.sharedApplication().windows.first!.contentViewController as! ViewController
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        
        // Insert code here to tear down your application
        
    }
    
    @IBAction func openDocument(sender: NSMenuItem) {
        
        delegate?.openDocument()
        
    }
    
}