//
//  GraphView.swift
//  P3
//
//  Created by Lorenzo Gentile on 2015-11-09.
//  Copyright © 2015 CS Boys. All rights reserved.
//

import Cocoa

class GraphView: NSView {
    var contacts = [Contact]() {
        didSet {
            setNeedsDisplayInRect(frame)
        }
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        for contact in contacts {
            if contact.gender == .Male {
                NSColor.blueColor().setFill()
            } else {
                NSColor.redColor().setFill()
            }
            drawCircle(50+(contact.age as Int)*3, y: 57+(contact.universityYear as Int)*25, rad: 5)
        }
    }
    
    func drawCircle(x: Int, y: Int, rad: Int) {
        let path = NSBezierPath(ovalInRect: NSRect(origin: CGPoint(x: x-rad, y: y-rad), size: CGSize(width: rad*2, height: rad*2)))
        path.stroke()
        path.fill()
    }
    
}
