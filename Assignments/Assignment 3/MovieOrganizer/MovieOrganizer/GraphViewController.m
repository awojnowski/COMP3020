//
//  GraphViewController.m
//  MovieOrganizer
//
//  Created by Kieran on 2015-12-04.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()

@end

@implementation GraphViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
    
    [self.view.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.view.layer setBorderWidth:1];
    [self.view.layer setBackgroundColor:[NSColor whiteColor].CGColor];

}

- (IBAction)graphBackButtonPressed:(id)sender {
    
    [self.delegate graphBackButtonPressed:self];
    
}

@end
