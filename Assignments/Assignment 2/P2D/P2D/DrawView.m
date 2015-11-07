//
//  DrawView.m
//  P2D
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "DrawView.h"

@interface DrawView ()



@end

@implementation DrawView

-(void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    
    
}

#pragma mark - First Responder

-(BOOL)acceptsFirstResponder {
    
    return YES;
    
}

-(void)mouseMoved:(NSEvent *)theEvent {
    
    NSLog(@"Mouse moved: %@",theEvent);
    
}

-(void)mouseEntered:(NSEvent *)theEvent {
    
    NSLog(@"Mouse entered: %@",theEvent);
    
    
}

@end
