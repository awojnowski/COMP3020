//
//  ViewController.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-29.
//  Copyright © 2015 CS Boys. All rights reserved.
//

// starting window size
// layout subviews not updating
// how are we gonna design the advanced search to edit cells to move
// diasble interaction when on profile
// need to change to scrollviews

#import "ViewController.h"

#import "CoreDataController.h"
#import "Movie.h"
#import "Genre.h"
#import "Actor.h"
#import "Director.h"
#import "SeedDataLoader.h"
#import "MovieDetailViewController.h"

#import "MovieSearchProvider.h"

@interface ViewController () <NSTableViewDataSource, NSTableViewDelegate, MovieDetailViewControllerDelegate>

@property (strong, nonatomic) MovieDetailViewController *movieDetailVC;
@property (strong, nonatomic) NSView *movieDetailView;
@property (weak) IBOutlet NSView *showMovieView;
@property (weak) IBOutlet NSView *advancedSearchMenuBarView;
@property (weak) IBOutlet NSView *menuBarContainerView;
@property (weak) IBOutlet NSView *minRatingContainerView;
@property (weak) IBOutlet NSView *yearContainerView;
@property (weak) IBOutlet NSView *tagsContainerView;
@property (weak) IBOutlet NSView *ageContainerView;
@property (weak) IBOutlet NSView *availibilityContainerView;
@property (weak) IBOutlet NSView *genreContainerView;
@property (weak) IBOutlet NSView *actorsContainerView;
@property (weak) IBOutlet NSView *directorContainerView;
//@property (weak) IBOutlet NSView *userReviewContainer;
//@property (weak) IBOutlet NSView *otherReviewsContainer;
//@property (weak) IBOutlet NSView *exampleUserReviewOne;
//@property (weak) IBOutlet NSView *exampleUserReviewTwo;

@property (weak) IBOutlet NSTableView *movieTableView;
@property (weak) IBOutlet NSTableHeaderView *tableViewHeader;
@property (weak) IBOutlet NSScrollView *movieTableScrollView;

@property (weak) IBOutlet NSSegmentedControl *minRatingControl;
@property (weak) IBOutlet NSPopUpButtonCell *ageRatingPopUpButton;
@property (weak) IBOutlet NSPopUpButton *actorPullDown;
@property (weak) IBOutlet NSPopUpButton *directorPullDown;

// Properties related to looking at movie field
//@property (weak) IBOutlet NSLevelIndicator *movieRatingIndicator;
//@property (weak) IBOutlet NSTextField *movieDescriptionField;
//@property (weak) IBOutlet NSImageView *moviePosterImage;

// Database of actors & directors
@property (nonatomic) NSMutableArray* actorArray;
@property (nonatomic) NSMutableArray* directorArray;

// Currently selected actors & directors for advanced search
@property (nonatomic) NSMutableArray* selectedActorsArray;
@property (nonatomic) NSMutableArray* selectedDirectorsArray;

@property (nonatomic) NSArray<Actor *>* actors;
@property (nonatomic) NSArray<Movie *>* movies;

@end

@implementation ViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[CoreDataController sharedInstance] initialize];
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        [[SeedDataLoader sharedInstance] seedDataInManagedObjectContext:managedObjectContext];
        
        NSArray *movies = [Movie allMoviesInManagedObjectContext:managedObjectContext];
        [self setMovies:movies];
        
        NSMutableArray * __block actorNames = [NSMutableArray array];
        /*NSArray *actors = [Actor allActorsInManagedObjectContext:managedObjectContext];
        [actors enumerateObjectsUsingBlock:^(id  _Nonnull actor, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [actorNames addObject:[actor name]];
            
        }];
        [self setActors:actors];*/
        
        // load the UI
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [[self actorPullDown] addItemsWithTitles:actorNames];
            [self.movieTableView reloadData];
            
        });
        
    }];
    
    // setting up advanced search fields
    
    [self createActorListPullDown];
    [self createDirectorListPullDown];
    [self createAgeRatingPullDown];
    
    [self setMovieDetailView];
    self.showMovieView.hidden = YES;
    [self.movieTableView setDoubleAction:@selector(showMovie)];

}

-(void)setMovieDetailView {
    
    self.movieDetailVC = [[MovieDetailViewController alloc] init];
    self.movieDetailVC.delegate = self;
    self.movieDetailView = self.movieDetailVC.view;
    [self.movieDetailView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.showMovieView addConstraint:[NSLayoutConstraint constraintWithItem:self.movieDetailView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.showMovieView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.showMovieView addConstraint:[NSLayoutConstraint constraintWithItem:self.movieDetailView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.showMovieView
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.showMovieView addConstraint:[NSLayoutConstraint constraintWithItem:self.movieDetailView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.showMovieView
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.showMovieView addConstraint:[NSLayoutConstraint constraintWithItem:self.movieDetailView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.showMovieView
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.showMovieView addSubview:self.movieDetailView];
    
}

-(void)viewDidLayout {
    
    [super viewDidLayout];
    
    [self.view setWantsLayer:YES];
    
    NSColor *lightGrayColor = [NSColor colorWithSRGBRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];
    
    NSColor *grayColor = [NSColor colorWithSRGBRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1];
    
    [self.advancedSearchMenuBarView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.menuBarContainerView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.minRatingContainerView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.yearContainerView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.tagsContainerView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.ageContainerView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.availibilityContainerView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.genreContainerView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.actorsContainerView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.directorContainerView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    
    [self.advancedSearchMenuBarView.layer setBorderWidth:1];
    [self.menuBarContainerView.layer setBorderWidth:1];
    [self.minRatingContainerView.layer setBorderWidth:1];
    [self.yearContainerView.layer setBorderWidth:1];
    [self.tagsContainerView.layer setBorderWidth:1];
    [self.ageContainerView.layer setBorderWidth:1];
    [self.availibilityContainerView.layer setBorderWidth:1];
    [self.genreContainerView.layer setBorderWidth:1];
    [self.actorsContainerView.layer setBorderWidth:1];
    [self.directorContainerView.layer setBorderWidth:1];
    
    [self.advancedSearchMenuBarView.layer setBackgroundColor:grayColor.CGColor];
    [self.menuBarContainerView.layer setBackgroundColor:grayColor.CGColor];
    [self.view.layer setBackgroundColor:lightGrayColor.CGColor];
    
}

#pragma MARK - MovieDetailViewControllerDelegate

- (void)backButtonPressed {
    [self showListViewTapped:nil];
}

#pragma MARK - NSTableView

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.movies.count;
    
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    
    NSString *columnID = aTableColumn.identifier;
    
    if ([columnID isEqualToString:@"movieTitle"]) {
        return self.movies[rowIndex].title;
    } else if ([columnID isEqualToString:@"movieGenre"]) {
//        NSLog(@"%@", self.movies[rowIndex].genres.anyObject.title);           // genres aren't properly fetched
        return self.movies[rowIndex].genres.anyObject.title;
    } else if ([columnID isEqualToString:@"movieYear"]) {
        return [NSString stringWithFormat:@"%@", self.movies[rowIndex].year];
    } else if ([columnID isEqualToString:@"movieRating"]) {
        return self.movies[rowIndex].rating;
    } else if ([columnID isEqualToString:@"movieDirector"]) {
        return self.movies[rowIndex].director.name;
    } else if ([columnID isEqualToString:@"movieAgeRating"]) {
        return self.movies[rowIndex].rating;                    // age rating needs to be added (certification)
    }
    return NULL;
    
}

- (void)showMovie {
    
    self.movieDetailVC.movie = self.movies[self.movieTableView.selectedRow];
    [self showMovieTapped:nil];
    
}



#pragma MARK - Actions

- (IBAction)minRatingControlTouched:(id)sender {
    
    NSSegmentedControl *control = (NSSegmentedControl *)sender;
    int minRating = (int)[control selectedSegment];
    
    for(int i = minRating; i >= 0; i--) {
        
        [control setSelected:YES forSegment:i];
        [control setImage:[NSImage imageNamed:@"starYellow"] forSegment:i];
        
    }
    
    for(int i = minRating + 1; i < [control segmentCount]; i++) {
        
        [control setSelected:NO forSegment:i];
        [control setImage:[NSImage imageNamed:@"starOutline"] forSegment:i];
        
    }
    
}

-(void)createAgeRatingPullDown {
    
    [self.ageRatingPopUpButton removeAllItems];
    
    NSArray* ageTypes = [NSArray arrayWithObjects: @"N/A",@"Any",@"G",@"PG",@"14A",@"18A",@"R", nil];
    
    for(int i = 0; i <= [ageTypes count]; i++) {
        
        [self.ageRatingPopUpButton addItemsWithTitles:ageTypes];
        
    }
    
}

-(void)createActorListPullDown {
    
    [self.actorPullDown removeAllItems];
    
    self.actorArray = [[NSMutableArray alloc] init];
    self.selectedActorsArray = [[NSMutableArray alloc] init];
    [self.actorArray addObject:@"N/A"];
    [self.actorArray addObject:@"Tom Cruise"];
    [self.actorArray addObject:@"Brad Pitt"];
    [self.actorArray addObject:@"Angelia Jolie"];
    
    for(int i = 0; i <= [self.actorArray count]; i++) {
        
        [self.actorPullDown addItemsWithTitles:self.actorArray];
        
    }
    
}

-(void)createDirectorListPullDown {
    
    [self.directorPullDown removeAllItems];
    
    self.directorArray = [[NSMutableArray alloc] init];
    self.selectedDirectorsArray = [[NSMutableArray alloc] init];
    [self.directorArray addObject:@"N/A"];
    [self.directorArray addObject:@"Steven Spielberg"];
    [self.directorArray addObject:@"George Lucas"];
    [self.directorArray addObject:@"Kieran Cairney"];
    
    for(int i = 0; i <= [self.directorArray count]; i++) {
        
        [self.directorPullDown addItemsWithTitles:self.directorArray];
        
    }
    
}

- (IBAction)ageRatingPulledDown:(id)sender {
    
    NSPopUpButtonCell* ageRatingPopUpButton = (NSPopUpButtonCell*)sender;
    [ageRatingPopUpButton setTitle:ageRatingPopUpButton.titleOfSelectedItem];
    
}

- (IBAction)addActorTouched:(id)sender {
    
    if([self.selectedActorsArray indexOfObject:self.actorPullDown.titleOfSelectedItem] == NSNotFound) {
        
        if(![self.actorPullDown.titleOfSelectedItem isEqual:@"N/A"]) {
            
            [self.selectedActorsArray addObject: self.actorPullDown.titleOfSelectedItem];
            [self updateActorList];
            
        }
        
    }
    
}

- (IBAction)addDirectorTouched:(id)sender {
    
    if([self.selectedDirectorsArray indexOfObject:self.directorPullDown.titleOfSelectedItem] == NSNotFound ) {
        
        if(![self.directorPullDown.titleOfSelectedItem isEqual:@"N/A"]) {
            
            [self.selectedDirectorsArray addObject: self.directorPullDown.titleOfSelectedItem];
            
        }
        
    }
    
}

- (void)updateActorList {
    
    int baseOriginX = self.actorPullDown.frame.origin.x + 2;
    int baseOriginY = 120;
    int baseWidth = self.actorPullDown.frame.size.width - 4;
    int baseHeight = 22;
    
    for(int i = 0; i < [self.selectedActorsArray count]; i++) {
        
        NSTextField* actor = [[NSTextField alloc] init];
        actor.stringValue = [self.selectedActorsArray objectAtIndex:i];
        [actor setFrame: CGRectMake(baseOriginX,baseOriginY - (baseHeight * i),baseWidth,baseHeight)];
        [self.view addSubview:actor];
        
        [self.directorContainerView removeFromSuperview];
        
        [self.directorContainerView setFrame: CGRectMake(self.directorContainerView.frame.origin.x,baseOriginY + (baseHeight * i) - 8,self.directorContainerView.frame.size.width,self.directorContainerView.frame.size.height)];
        
        [self.view addSubview:self.directorContainerView];
    }
    
    //NSLog(@"Pulldown: %f %f %f %f",self.actorPullDown.frame.origin.x,self.actorPullDown.frame.origin.y,self.actorPullDown.frame.size.width,self.actorPullDown.frame.size.height);
    //NSLog(@"Text: %f %f %f %f",actor.frame.origin.x,actor.frame.origin.y,actor.frame.size.width,actor.frame.size.height);
    
}

- (IBAction)showMovieTapped:(id)sender {

    dispatch_async( dispatch_get_main_queue(), ^{
        
        self.showMovieView.hidden = NO;
        self.movieTableView.hidden = YES;
        self.tableViewHeader.hidden = YES;
        self.movieTableScrollView.hidden = YES;
        
    });
    
}

- (IBAction)showListViewTapped:(id)sender {
        
    dispatch_async( dispatch_get_main_queue(), ^{
        
        self.showMovieView.hidden = YES;
        self.movieTableView.hidden = NO;
        self.tableViewHeader.hidden = NO;
        self.movieTableScrollView.hidden = NO;
        
    });
    
}

- (IBAction)actorSelectionTouched:(id)sender {
    
    
}

- (IBAction)directorSelectionTouched:(id)sender {
    
    
}

@end
