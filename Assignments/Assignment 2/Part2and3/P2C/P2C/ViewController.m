//
//  ViewController.m
//  P2C
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "ViewController.h"

CGFloat const ViewControllerMinimumTextFieldWidth = 100.0;

@interface ViewController ()

@property (nonatomic, weak) IBOutlet NSScrollView *scrollView;
@property (nonatomic, weak) IBOutlet NSTextField *textField;

@end

@implementation ViewController

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(controlTextDidChange:) name:NSControlTextDidChangeNotification object:[self textField]];
    
    [[self scrollView] setHasVerticalScroller:NO];
    
}

#pragma mark - Notifications

-(void)controlTextDidChange:(NSNotification *)notification {
    
    NSString * const string = [[self textField] stringValue];
    NSLog(@"Updated string to: %@",string);
    
    NSSize size = [string sizeWithAttributes:@{ NSFontAttributeName : [[self textField] font] }];
    size.width += 10.0; // padding
    
    [[[self textField] constraints] enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
    
        if ([constraint firstAttribute] == NSLayoutAttributeWidth) {
            
            [constraint setConstant:MAX(ViewControllerMinimumTextFieldWidth, size.width)];
            *stop = YES;
            
        }
        
    }];
    
    NSView * const documentView = [[self scrollView] documentView];
    [documentView setFrameSize:NSMakeSize(MAX(CGRectGetMaxX([[self textField] frame]) + CGRectGetMinX([[self textField] frame]) * 2, CGRectGetWidth([[[self view] window] frame])), CGRectGetHeight([documentView bounds]))];
    [[[self scrollView] contentView] scrollToPoint:NSMakePoint(CGRectGetWidth([documentView frame]) - CGRectGetWidth([[self scrollView] visibleRect]), 0)];
    
}

@end
