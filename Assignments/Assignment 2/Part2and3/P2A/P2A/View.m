//
//  View.m
//  P2A
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "View.h"

@interface View ()

@property (nonatomic, readonly, strong) NSMutableString *input;

@end

@implementation View

-(instancetype)initWithFrame:(NSRect)frameRect {
    
    self = [super initWithFrame:frameRect];
    if (self) {
        
        [self sharedInit];
        
    }
    return self;
    
}

-(instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        
        [self sharedInit];
        
    }
    return self;
    
}

-(void)sharedInit {
    
    _input = [NSMutableString stringWithString:@""];
    
}

-(BOOL)acceptsFirstResponder {
    
    return YES;
    
}

-(void)keyDown:(NSEvent *)theEvent {
    
    if ([theEvent keyCode] == 36) {
        
        [self commitInput];
        
    } else {
        
        NSString * const characters = [[theEvent characters] lowercaseString];
        unichar const character = [characters characterAtIndex:0];
        [self handleInputCharacter:character];
        
    }
    
}

-(void)handleInputCharacter:(unichar)character {
    
    if ([[self input] length] == 0) {
        
        if (character == 'l' || character == 'r') {
            
            goto append;
            
        }
        
    } else {
        
        if (character >= '0' && character <= '9') {
            
            goto append;
            
        }
        
    }
    return;
    
append:
    [[self input] appendFormat:@"%c",character];
    [[self delegate] viewChangedInputString:[self input]];
    
}

-(void)commitInput {
    
    if ([[self input] length] < 2) {
        
        goto complete;
        
    }
    
    unichar const direction = [[self input] characterAtIndex:0];
    NSInteger const pixels = [[[self input] substringFromIndex:1] integerValue];
    
    NSInteger multiplier = -1;
    if (direction == 'r') {
        
        multiplier = 1;
        
    }
    
    NSInteger const offset = multiplier * pixels;
    [[self window] setFrame:({
        
        NSRect rect = [[self window] frame];
        rect.origin.x += offset;
        rect;
        
    }) display:YES animate:YES];
    
complete:
    [[self input] setString:@""];
    [[self delegate] viewChangedInputString:[self input]];
    
}

@end
