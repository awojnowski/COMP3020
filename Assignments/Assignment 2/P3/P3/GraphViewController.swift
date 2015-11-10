//
//  GraphViewController.swift
//  P3
//
//  Created by Lorenzo Gentile on 2015-11-09.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

class GraphViewController: NSViewController {
    @IBOutlet weak var slider: NSSliderCell!
    var contacts = [Contact]()
    var displayContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func updateDisplayContacts() {
        let oldCount = displayContacts.count
        displayContacts = contacts.filter { Int($0.age) <= slider.integerValue }
        
        if oldCount != displayContacts.count {
            // REDRAW
        }
    }
    
}
