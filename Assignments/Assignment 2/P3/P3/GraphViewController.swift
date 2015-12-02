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
    @IBOutlet weak var graphView: GraphView!
    var contacts = [Contact]()
    var displayContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = ContactsController.sharedInstance().contacts as! [Contact]
    }
    
    func updateDisplayContacts() {
        let oldCount = displayContacts.count
        displayContacts = contacts.filter { Int($0.universityYear) <= slider.integerValue }
        
        if oldCount != displayContacts.count {
            // REDRAW
            graphView.contacts = displayContacts
        }
    }
    
    @IBAction func sliderChanged(sender: AnyObject) {
        updateDisplayContacts()
    }
}
