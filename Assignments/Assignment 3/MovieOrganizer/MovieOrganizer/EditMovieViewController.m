//
//  EditMovieViewController.m
//  MovieOrganizer
//
//  Created by Lorenzo Gentile on 2015-12-04.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "EditMovieViewController.h"

@interface EditMovieViewController ()

@property (weak) IBOutlet NSTextField *movieTitleTextField;

@end

@implementation EditMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)donePressed:(id)sender {
    
    // Validate
    
    self.movie.title = self.movieTitleTextField.stringValue;
    
    [self.delegate doneEditing:self];
    
}

- (IBAction)cancelPressed:(id)sender {
    
    [self.delegate cancelEditing:self];
    
}

@end
