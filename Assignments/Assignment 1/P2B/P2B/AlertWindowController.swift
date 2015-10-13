//
//  AlertWindowController.swift
//  P2B
//
//  Created by Aaron Wojnowski on 2015-10-06.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

class AlertWindowController: NSWindowController {
    
    @IBOutlet weak var detailsButton: NSButton!
    var detailsShowing = false {
        didSet {
            updateDetails(true)
        }
    }

    override func windowDidLoad() {
        
        super.windowDidLoad()
        updateDetails(false)
        
    }
    
    func updateDetails(animated: Bool) {
        
        guard let window = self.window else {
            print("No window")
            return
        }
        
        let newTitle = detailsShowing ? "▴Details" : "▾Details"
        let heightChage: CGFloat = detailsShowing ? 100 : -100
        
        detailsButton.title = newTitle
        
        var newFrame = window.frame
        newFrame.size.height += heightChage
        newFrame.origin.y -= heightChage // So top stays in place (by default it's the bottom)
        window.setFrame(newFrame, display: true, animate: animated)
        
    }
    
    // MARK: Actions
    
    @IBAction func cancel(sender: AnyObject) {
        
        window?.close()
        
    }
    
    @IBAction func okPressed(sender: AnyObject) {
        
        window?.close()
        
    }
    
    @IBAction func detailsPressed(sender: AnyObject) {
        
        detailsShowing = !detailsShowing
        
    }

}
