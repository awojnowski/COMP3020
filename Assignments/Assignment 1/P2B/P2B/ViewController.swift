//
//  ViewController.swift
//  P2B
//
//  Created by Aaron Wojnowski on 2015-10-05.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var alertWindowController: AlertWindowController?

    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        
    }
    
    // MARK: Actions
    
    @IBAction func showAlert(sender: AnyObject) {
        
        guard let alertWindowController: AlertWindowController? = AlertWindowController(windowNibName: "AlertWindow") else {
            
            NSLog("Uh-oh. The alertWindowController is nil.")
            return;
            
        }
        self.view.window!.beginSheet(alertWindowController!.window!) {
            (response: NSModalResponse) -> Void in
            
            NSLog("Completed.")
            
        }
        self.alertWindowController = alertWindowController
        
    }

}
