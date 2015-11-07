//
//  ViewController.m
//  P2D
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "DrawView.h"
#import "ViewController.h"

@interface ViewController ()

@property (weak) IBOutlet DrawView *drawView;

@end

@implementation ViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];


    
}

-(void)viewDidAppear {
    
    [super viewDidAppear];
    
    [[[self view] window] makeFirstResponder:[self drawView]];
    
}

@end
