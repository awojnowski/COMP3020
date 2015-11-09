//
//  ContactsViewController.swift
//  P3
//
//  Created by Lorenzo Gentile on 2015-11-08.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

class ContactsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var table: NSTableView!
    var data = ["1", "2", "3", "4", "5"];

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return 5
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        return data[row]
    }
    
    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        data[row] = object as? String ?? "NULL"
    }
}
