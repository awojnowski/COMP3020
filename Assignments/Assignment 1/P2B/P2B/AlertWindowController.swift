//
//  AlertWindowController.swift
//  P2B
//
//  Created by Aaron Wojnowski on 2015-10-06.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

class AlertWindowController: NSWindowController {

    override func windowDidLoad() {
        
        super.windowDidLoad()
    
        
        
    }
    
    // MARK: Actions
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.window!.sheetParent!.endSheet(self.window!, returnCode: NSModalResponseCancel)
        self.window!.orderOut(sender)
        
    }

}
