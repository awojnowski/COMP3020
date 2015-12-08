//
//  MovieDetailViewController.m
//  MovieOrganizer
//
//  Created by Lorenzo Gentile on 2015-12-02.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "CoreDataController.h"
#import "Genre.h"
#import "Actor.h"
#import "Director.h"
#import "Tag.h"
#import "Review.h"

@interface MovieDetailViewController ()

@property (weak) IBOutlet NSTextField *movieTitleLabel;
@property (weak) IBOutlet NSTextField *movieDetailTextField;
@property (weak) IBOutlet NSLevelIndicatorCell *starRatingCell;
@property (weak) IBOutlet NSLevelIndicatorCell *userRatingCell;
@property (weak) IBOutlet NSButton *watchlistButton;
@property (weak) IBOutlet NSButtonCell *submitReviewButton;
@property (weak) IBOutlet NSTextField *userReviewTextField;

@property (weak) IBOutlet NSView *userReviewContainer;

@property (weak) IBOutlet NSImageView *netflixImage;
@property (weak) IBOutlet NSImageView *appleImage;
@property (weak) IBOutlet NSImageView *shomiImage;
@property (weak) IBOutlet NSImageView *artworkImageView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.view setWantsLayer:YES];
    
    [self.userReviewContainer.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    
    [self.userReviewContainer.layer setBorderWidth:1];
    
    [self.view.layer setBackgroundColor:[NSColor whiteColor].CGColor];
    
}

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    [self updateViewsForMovie];
}

- (void)updateViewsForMovie {
    NSMutableArray<NSString *> *genres = [[NSMutableArray<NSString *> alloc] init];
    [self.movie.genres.allObjects enumerateObjectsUsingBlock:^(Genre * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [genres addObject:obj.title];
    }];
    NSString *genreString = [genres componentsJoinedByString:@", "];
    
    NSMutableArray<NSString *> *actors = [[NSMutableArray<NSString *> alloc] init];
    [self.movie.actors.allObjects enumerateObjectsUsingBlock:^(Actor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [actors addObject:obj.name];
    }];
    NSString *actorString = [actors componentsJoinedByString:@", "];
    
    NSString *certification = self.movie.certification;
    if (self.movie.certification == nil) {
        certification = @"None";
    }
    
    NSString *tagsString = @"None";
    if (self.movie.tags.count != 0) {
        NSMutableArray<NSString *> *tags = [[NSMutableArray<NSString *> alloc] init];
        [self.movie.tags.allObjects enumerateObjectsUsingBlock:^(Tag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [tags addObject:obj.title];
        }];
        tagsString = [tags componentsJoinedByString:@", "];
    }
    
    NSString *description = [NSString stringWithFormat:@"Genres: %@\nYear: %@\nRating: %@/10\n\nStars: %@\nDirector: %@\n\nLength: %@\nCertification: %@\n\nTags: %@", genreString, self.movie.year, self.movie.rating, actorString, self.movie.director.name, self.movie.length, certification, tagsString];
    
    [self.movieTitleLabel setStringValue:self.movie.title];
    [self.movieDetailTextField setStringValue:description];
    [self.starRatingCell setIntValue:([self.movie.rating intValue] / 2)+1];
    
    [[self artworkImageView] setImage:[NSImage imageNamed:@"poster"]];
    [[self movie] fetchImageWithCompletionBlock:^(NSImage * _Nonnull image) {
        
        [[self artworkImageView] setImage:image];
        
    }];
        
    if(self.movie.availableOnNetflix.boolValue) {
        
        [self.netflixImage setImage:[NSImage imageNamed:@"netflix"]];
        
    } else {
        
        [self.netflixImage setImage:[NSImage imageNamed:@"netflixGray"]];
        
    }
    
    if(self.movie.availableOnShomi.boolValue) {
        
        [self.shomiImage setImage:[NSImage imageNamed:@"shomi"]];
        
    } else {
        
        [self.shomiImage setImage:[NSImage imageNamed:@"shomiGray"]];
        
    }
    
    if(self.movie.availableOnItunes.boolValue) {
        
        [self.appleImage setImage:[NSImage imageNamed:@"apple"]];
        
    } else {
        
        [self.appleImage setImage:[NSImage imageNamed:@"appleGray"]];
        
    }
    
    [self refreshWatchlistButtonForMovie:[self movie]];
    
    Review * const review = [[[self movie] reviews] anyObject];
    if (review) {
        
        [[self userReviewTextField] setStringValue:[review review]];
        [[self userRatingCell] setIntValue:[[review rating] intValue]];
        [self.userRatingCell setImage:[NSImage imageNamed:@"starSmallOutline"]];
        self.submitReviewButton.title = @"Update";
        
    } else {
        
        [self.userRatingCell setImage:[NSImage imageNamed:@"starSmallOutlineBase"]];
        self.submitReviewButton.title = @"Review";
        [[self userReviewTextField] setStringValue:@""];
        [[self userRatingCell] setIntValue:5];
        
    }
    
}

- (IBAction)backButtonPressed:(id)sender {
    [self.delegate backButtonPressed:self];
}

- (IBAction)addToWatchListPressed:(id)sender {
    [self.delegate addToWatchListPressed:self];
    [self refreshWatchlistButtonForMovie:[self movie]];
}

- (IBAction)ratingLevelTouched:(id)sender {
    
    [self.userRatingCell setImage:[NSImage imageNamed:@"starSmallOutline"]];
    
}

#pragma mark - Watchlist

-(void)refreshWatchlistButtonForMovie:(Movie *)movie {
    
    Tag * __block watchlistTag = nil;
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        watchlistTag = [Tag watchlistInManagedObjectContext:managedObjectContext];
        
    }];
    if (watchlistTag) {
        
        if ([[[self movie] tags] containsObject:watchlistTag]) {
            
            [[self watchlistButton] setTitle:@"Remove From Watchlist"];
            
        } else {
            
            [[self watchlistButton] setTitle:@"Add To Watchlist"];
            
        }
        
    }
    
}

- (IBAction)submitReviewTouched:(id)sender {
    
    BOOL const didRate = ![self.userRatingCell.image.name isEqualToString:@"starSmallOutlineBase"];
    if (!didRate) {
        
        NSAlert * const alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Please choose the rating (in stars) before submitting your review."];
        [alert runModal];
        
        return;
        
    }
    
    self.submitReviewButton.title = @"Update";
    
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        Review *review = [[[self movie] reviews] anyObject];
        if (!review) {
            
            review = [Review createInManagedObjectContext:managedObjectContext];
            [review setMovie:self.movie];
            [self.movie addReviewsObject:review];
            
        }
        
        [review setReview:self.userReviewTextField.stringValue];
        [review setRating:@(self.userRatingCell.intValue)];
        
    }];
    
}

@end
