//
//  MovieDetailViewController.m
//  MovieOrganizer
//
//  Created by Lorenzo Gentile on 2015-12-02.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "Genre.h"
#import "Actor.h"
#import "Director.h"

@interface MovieDetailViewController ()

@property (weak) IBOutlet NSTextField *movieTitleLabel;
@property (weak) IBOutlet NSTextField *movieDetailTextField;
@property (weak) IBOutlet NSLevelIndicatorCell *starRatingCell;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view setWantsLayer:YES];
    [self.view.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.view.layer setBorderWidth:1];
    [self.view.layer setBackgroundColor:[[NSColor whiteColor] CGColor]];
}

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    [self updateViewsForMovie];
}

- (void)updateViewsForMovie {
    NSString *description = [NSString stringWithFormat:@"Genre: FILL THIS IN\nYear: %@\nRating: %@/10\nStars: %@\nDirector: %@\nLength: %@\n\nTags: %@", self.movie.year, self.movie.rating, self.movie.actors.anyObject.name, self.movie.director.name, self.movie.length, self.movie.tags.anyObject];
    [self.movieTitleLabel setStringValue:self.movie.title];
    [self.movieDetailTextField setStringValue:description];
    [self.starRatingCell setIntValue:([self.movie.rating intValue]+1) / 2];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.delegate backButtonPressed];
}

- (IBAction)addToWatchListPressed:(id)sender {
    
}

@end
