//
//  ViewController.m
//  P2A
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet NSView *colorView;

@end

@implementation ViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];

    [[[self colorView] layer] setBackgroundColor:[[NSColor orangeColor] CGColor]];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)keyDown:(NSEvent *)theEvent {
    
    NSLog(@"Key down: %@",theEvent);
    
}

-(void)keyUp:(NSEvent *)theEvent {
    
    NSLog(@"Key up: %@",theEvent);
    
}

@end
