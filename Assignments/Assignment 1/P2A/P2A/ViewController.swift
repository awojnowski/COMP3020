//
//  ViewController.swift
//  P2A
//
//  Created by Aaron Wojnowski on 2015-10-05.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    private lazy var data: [[String]] = {
        
        let inputPath = NSBundle.mainBundle().pathForResource("data", ofType: "txt")
        let inputData = NSData(contentsOfFile: inputPath!)
        let inputString: NSString = NSString(data: inputData!, encoding: NSUTF8StringEncoding)!
        let inputArray = inputString.componentsSeparatedByString("\n")
        
        var data = [[String]]()
        for (var i = 0; i < inputArray.count; i++) {
            
            let elementArray = inputArray[i].componentsSeparatedByString(",")
            
            var element = [String]()
            for (var j = 0; j < elementArray.count; j++) {
                
                element.append(elementArray[j])
                
            }
            data.append(element)
            
        }
        return data
        
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        
    }

    override var representedObject: AnyObject? {
        didSet {
            
        }
    }
    
    // MARK: NSTableViewDataSource
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        
        let column = tableView.tableColumns.indexOf(tableColumn!)
        return self.data[row][column!]
        
    }
    
    // MARK: NSTableViewDelegate
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        
        return self.data.count;
        
    }

}

