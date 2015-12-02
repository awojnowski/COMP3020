//
//  DrawView.m
//  P2D
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "DrawView.h"

@interface DrawView ()

@property (nonatomic, strong) NSBezierPath *currentPath;
@property (nonatomic, strong) NSMutableArray <NSBezierPath *> *paths;

@end

@implementation DrawView

-(NSMutableArray <NSBezierPath *> *)paths {
    
    if (!_paths) {
        
        _paths = [NSMutableArray array];
        
    }
    return _paths;
    
}

-(void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    [[NSColor blackColor] setStroke];
    [[self paths] enumerateObjectsUsingBlock:^(NSBezierPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self drawBezierPath:obj];
        
        
    }];
    if ([self currentPath]) {
        
        [self drawBezierPath:[self currentPath]];
        
    }
    
}

-(void)drawBezierPath:(NSBezierPath *)bezierPath {
    
    [bezierPath setLineWidth:2.0];
    [bezierPath stroke];
    
}

#pragma mark - First Responder

-(BOOL)acceptsFirstResponder {
    
    return YES;
    
}

-(void)mouseDown:(NSEvent *)theEvent {
    
    [self setCurrentPath:[NSBezierPath bezierPath]];
    
}

-(void)mouseDragged:(NSEvent *)theEvent {
    
    NSPoint point = [theEvent locationInWindow];
    [[self currentPath] appendBezierPathWithPoints:(NSPointArray)&point count:1];
    [self setNeedsDisplay:YES];
    
}

-(void)mouseUp:(NSEvent *)theEvent {
    
    [[self paths] addObject:[self currentPath]];
    [self setCurrentPath:nil];
    
}

@end
