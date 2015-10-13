//
//  ViewController.swift
//  P2C
//
//  Created by Aaron Wojnowski on 2015-10-05.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

protocol ViewControllerDelegate {
    
    func openDocument()
    
}

class ViewController: NSViewController, ViewControllerDelegate {
    
    @IBOutlet weak var imageView: NSImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override var representedObject: AnyObject? {
        
        didSet {
            
            // Update the view, if already loaded.
            
        }
        
    }
    
    func openDocument() {
        
        if let documentURL = NSOpenPanel().selectUrl, path = documentURL.path {
            
            print("file selected = \(path)")
            
        } else {
            
            print("cancelled.")
            
        }
        
    }
}

extension NSOpenPanel {
    
    var selectUrl: NSURL? {
        
        let fileOpenPanel = NSOpenPanel()
        
        let types = ["doc"]
        fileOpenPanel.allowedFileTypes = types
        
        fileOpenPanel.title = "Select File"
        fileOpenPanel.allowsMultipleSelection = true
        fileOpenPanel.canChooseDirectories = false
        fileOpenPanel.canChooseFiles = true
        fileOpenPanel.canCreateDirectories = false
        fileOpenPanel.runModal()
        return fileOpenPanel.URLs.first
        
    }
    
}