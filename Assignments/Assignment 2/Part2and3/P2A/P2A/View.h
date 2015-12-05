//
//  View.h
//  P2A
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ViewDelegate;

@interface View : NSView

@property (nonatomic, weak) id <ViewDelegate> delegate;

@end

@protocol ViewDelegate <NSObject>

@required
-(void)viewChangedInputString:(NSString *)inputString;

@end
