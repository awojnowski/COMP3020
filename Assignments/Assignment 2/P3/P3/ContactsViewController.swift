//
//  ContactsViewController.swift
//  P3
//
//  Created by Lorenzo Gentile on 2015-11-08.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

let uniYears = ["1", "2", "3", "4", "Master's", "Ph.D"]

class ContactsViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var table: NSTableView!
    @IBOutlet weak var slider: NSSliderCell!
    var contacts = [Contact]()
    var displayContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ContactsController.sharedInstance().loadContactsFromFile(ContactsControllerDefaultFileName)
        contacts = ContactsController.sharedInstance().contacts as! [Contact]
        updateDisplayContacts()
    }
    
    override func viewWillAppear() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("newButtonPressed:"), name: "NewButtonPressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("editButtonPressed:"), name: "EditButtonPressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("deleteButtonPressed:"), name: "DeleteButtonPressed", object: nil)
    }
    
    override func viewWillDisappear() {
        ContactsController.sharedInstance().contacts = (contacts as NSArray).mutableCopy() as! NSMutableArray
        ContactsController.sharedInstance().serializeContactsToFile(ContactsControllerDefaultFileName)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    static func newContact() -> Contact {
        let contact = Contact()
        contact.firstName = "First"
        contact.lastName = "Last"
        contact.address = "Location"
        contact.phoneNumber = "Number"
        contact.age = 0
        contact.universityYear = 1
        contact.gender = .Male
        return contact
    }
    
    func updateDisplayContacts() {
        let oldCount = displayContacts.count
        displayContacts = contacts.filter { Int($0.age) <= slider.integerValue }
        
        if oldCount != displayContacts.count {
            table.reloadData()
        }
    }
    
    //MARK: Actions
    
    @IBAction func ageSliderUpdated(sender: NSSliderCell) {
        updateDisplayContacts()
    }
    
    @IBAction func newButtonPressed(sender: AnyObject) {
        contacts.append(ContactsViewController.newContact())
        updateDisplayContacts()
    }
    
    @IBAction func editButtonPressed(sender: AnyObject) {
        table.editColumn(0, row: table.selectedRow, withEvent: nil, select: true)
    }
    
    @IBAction func deleteButtonPressed(sender: AnyObject) {
        print(table.selectedRow)
        if table.selectedRow >= 0 {
            contacts.removeAtIndex(table.selectedRow)
            updateDisplayContacts()
        }
    }
    
    //MARK: NSTableViewDelegagte
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return displayContacts.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let contact = displayContacts[row]
        guard let columnID = tableColumn?.identifier else { return "No Column ID" }
        switch columnID {
        case "firstName":
            return contact.firstName
        case "lastName":
            return contact.lastName
        case "age":
            return contact.age
        case "gender":
            return contact.gender == .Male ? "Male" : "Female"
        case "universityYear":
            return uniYears[contact.universityYear as Int]
        case "phoneNumber":
            return contact.phoneNumber
        case "address":
            return contact.address
        default:
            return "Default"
        }
    }
    
    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        let contact = displayContacts[row]
        guard let columnID = tableColumn?.identifier else { return }
        switch columnID {
        case "firstName":
            contact.firstName = object as! String
        case "lastName":
            contact.lastName = object as! String
        case "age":
            if let strVal = object as? String, intVal = Int(strVal) {
                contact.age = intVal
            }
        case "gender":
            contact.gender = object as? String == "Male" ? .Male : .Female
        case "universityYear":
            if let strVal = object as? String, intVal = uniYears.indexOf(strVal) {
                contact.universityYear = intVal
            }
        case "phoneNumber":
            contact.phoneNumber = object as! String
        case "address":
            contact.address = object as! String
        default:
            return
        }
    }
}
