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
#import "Tag.h"
#import "SeedDataLoader.h"
#import "MovieDetailViewController.h"
#import "GraphViewController.h"

#import "MovieSearchProvider.h"

@interface ViewController () <NSTableViewDataSource, NSTableViewDelegate, MovieDetailViewControllerDelegate, GraphViewControllerDelegate>

@property (nonatomic, readonly, assign) BOOL movieDetailShowing;

@property (strong, nonatomic) MovieDetailViewController *movieDetailVC;
@property (strong, nonatomic) GraphViewController *graphVC;
@property (strong, nonatomic) NSView *movieDetailView;
@property (strong, nonatomic) NSView *graphDetailView;
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
@property (weak) IBOutlet NSView *graphView;
@property (weak) IBOutlet NSSearchField *movieSearchField;
@property (weak) IBOutlet NSTextField *minYearTextField;
@property (weak) IBOutlet NSTextField *maxYearTextField;

@property (weak) IBOutlet NSTableView *movieTableView;
@property (weak) IBOutlet NSTableHeaderView *tableViewHeader;
@property (weak) IBOutlet NSScrollView *movieTableScrollView;

@property (weak) IBOutlet NSSegmentedCell *viewSegmentedControlSelector;
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

@property (nonatomic, readonly, strong) MovieSearchProvider *searchProvider;

@property (nonatomic) NSArray<Actor *>* actors;
@property (nonatomic, readonly) NSArray<Movie *>* movies;

@end

@implementation ViewController

@synthesize searchProvider=_searchProvider;
-(MovieSearchProvider *)searchProvider {
    
    if (!_searchProvider) {
        
        _searchProvider = [[MovieSearchProvider alloc] init];
        [_searchProvider setAvailableOnItunes:NO];
        [_searchProvider setAvailableOnNetflix:NO];
        [_searchProvider setAvailableOnShomi:NO];
        
    }
    return _searchProvider;
    
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[[CoreDataController sharedInstance] removeCoreDataStore];
    [[CoreDataController sharedInstance] initialize];
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        [[SeedDataLoader sharedInstance] seedDataInManagedObjectContext:managedObjectContext];
        
        NSMutableArray * __block actorNames = [NSMutableArray array];
        /*NSArray *actors = [Actor allActorsInManagedObjectContext:managedObjectContext];
        [actors enumerateObjectsUsingBlock:^(id  _Nonnull actor, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [actorNames addObject:[actor name]];
            
        }];
        [self setActors:actors];*/
        
        // load the UI
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [[self actorPullDown] addItemsWithTitles:actorNames];
            
        });
        
    }];
    
    // setting up advanced search fields
    
    [self createActorListPullDown];
    [self createDirectorListPullDown];
    [self createAgeRatingPullDown];
    
    [self setMovieDetailView];
    [self setGraphDetailView];
    self.showMovieView.hidden = YES;
    self.graphView.hidden = YES;
    [self.movieTableView setDoubleAction:@selector(showMovie)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(movieSearchTextChanged:) name:NSControlTextDidChangeNotification object:self.movieSearchField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(minYearTextChanged:) name:NSControlTextDidChangeNotification object:self.minYearTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(maxYearTextChanged:) name:NSControlTextDidChangeNotification object:self.maxYearTextField];
    
    // finish up
    
    [self refreshMovies];

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

-(void)setGraphDetailView {
    
    self.graphVC = [[GraphViewController alloc] init];
    self.graphVC.delegate = self;
    self.graphDetailView = self.graphVC.view;
    [self.graphDetailView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.graphView addConstraint:[NSLayoutConstraint constraintWithItem:self.graphDetailView
                                                                   attribute:NSLayoutAttributeTop
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.graphView
                                                                   attribute:NSLayoutAttributeTop
                                                                  multiplier:1.0
                                                                    constant:0.0]];
    
    [self.graphView addConstraint:[NSLayoutConstraint constraintWithItem:self.graphDetailView
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.graphView
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:0.0]];
    
    [self.graphView addConstraint:[NSLayoutConstraint constraintWithItem:self.graphDetailView
                                                                   attribute:NSLayoutAttributeBottom
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.graphView
                                                                   attribute:NSLayoutAttributeBottom
                                                                  multiplier:1.0
                                                                    constant:0.0]];
    
    [self.graphView addConstraint:[NSLayoutConstraint constraintWithItem:self.graphDetailView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.graphView
                                                                   attribute:NSLayoutAttributeTrailing
                                                                  multiplier:1.0
                                                                    constant:0.0]];
    
    [self.graphView addSubview:self.graphDetailView];
    
}

#pragma mark - Movies

-(void)refreshMovies {
    
    [[self searchProvider] searchWithCompletionBlock:^(NSArray<Movie *> *movies) {
        
        _movies = [self moviesWithSortDescriptors:self.movieTableView.sortDescriptors fromMovies:movies];
        [[self movieTableView] reloadData];
        
    }];
    
}

-(void)refreshSortDescriptors {
    
    _movies = [self moviesWithSortDescriptors:self.movieTableView.sortDescriptors fromMovies:[self movies]];
    [[self movieTableView] reloadData];
    
}

-(NSArray *)moviesWithSortDescriptors:(NSArray *)sortDescriptors fromMovies:(NSArray *)movies {
    
    return [movies sortedArrayUsingDescriptors:sortDescriptors];
    
}

#pragma mark - MovieDetailViewControllerDelegate

- (void)backButtonPressed:(MovieDetailViewController *)movieDetailViewController {
    
    self.viewSegmentedControlSelector.enabled = YES;
    [self showListViewSelected];
    [self refreshMovies];
    
}

#pragma mark - GraphDetailViewControllerDelegate

- (void)graphBackButtonPressed:(GraphViewController *)graphViewController {
    
    self.viewSegmentedControlSelector.enabled = YES;
    [self showListViewSelected];
    [self refreshMovies];
    
}

- (void)addToWatchListPressed:(MovieDetailViewController *)movieDetailViewController {
    
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        Tag * const watchlistTag = [Tag watchlistInManagedObjectContext:managedObjectContext];
        if (!watchlistTag) {
            
            return;
            
        }
        Movie * const movie = [movieDetailViewController movie];
        if ([[movie tags] containsObject:watchlistTag]) {
            
            [movie removeTagsObject:watchlistTag];
            
        } else {
            
            [movie addTagsObject:watchlistTag];
            
        }
        
    }];
    
}

#pragma mark - NSTableView

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return self.movies.count;
    
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    
    Movie * const movie = [self movies][rowIndex];
    
    NSString * const columnID = aTableColumn.identifier;
    if ([columnID isEqualToString:@"movieTitle"]) {
        return movie.title;
    } else if ([columnID isEqualToString:@"movieGenre"]) {
        
        NSArray * const genres = [[[movie genres] allObjects] sortedArrayUsingComparator:^NSComparisonResult(Genre *  _Nonnull obj1, Genre * _Nonnull obj2) {
            return [[obj1 title] compare:[obj2 title]];
        }];
        NSMutableArray * const titles = [NSMutableArray array];
        [genres enumerateObjectsUsingBlock:^(Genre * _Nonnull genre, NSUInteger idx, BOOL * _Nonnull stop) {
            [titles addObject:[genre title]];
        }];
        return [titles componentsJoinedByString:@", "];
        
    } else if ([columnID isEqualToString:@"movieYear"]) {
        return [NSString stringWithFormat:@"%@", movie.year];
    } else if ([columnID isEqualToString:@"movieRating"]) {
        return movie.rating;
    } else if ([columnID isEqualToString:@"movieDirector"]) {
        return movie.director.name;
    } else if ([columnID isEqualToString:@"movieAgeRating"]) {
        return movie.certification;
    }
    return nil;
    
}

- (void)showMovie {
    
    self.movieDetailVC.movie = self.movies[self.movieTableView.selectedRow];
    
    self.viewSegmentedControlSelector.enabled = NO;
    
    [self showMovieSelected];
    
}

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors {
    
    [self refreshSortDescriptors];
    
}

#pragma mark - Actions

-(IBAction)watchlistClicked:(id)sender {
    
    // show the list view
    
    [self showListViewSelected];
    
    // update the watchlist
    
    Tag * __block watchlistTag = nil;
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        watchlistTag = [Tag watchlistInManagedObjectContext:managedObjectContext];
        
    }];
    if (!watchlistTag) {
        
        return;
        
    }
    
    NSMutableArray * const mutableTagsArray = [NSMutableArray arrayWithArray:[[self searchProvider] tags]];
    if ([[[self searchProvider] tags] containsObject:watchlistTag]) {
        
        [mutableTagsArray removeObject:watchlistTag];
        
    } else {
        
        [mutableTagsArray addObject:watchlistTag];
        
    }
    [[self searchProvider] setTags:mutableTagsArray];
    [self refreshMovies];
    
}

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
    
    [self.searchProvider setMinimumRating:(minRating*2)];
    
    [self refreshMovies];
    
}

-(void)createAgeRatingPullDown {
    
    [self.ageRatingPopUpButton removeAllItems];
    
    NSArray* ageTypes = [NSArray arrayWithObjects: @"N/A",@"Any",@"G",@"PG",@"PG-13",@"R", nil];
    
    for(int i = 0; i <= [ageTypes count]; i++) {
        
        [self.ageRatingPopUpButton addItemsWithTitles:ageTypes];
        
    }
    
}

-(void)createActorListPullDown {
    
    [self.actorPullDown removeAllItems];
    
    // how to add actors to a list
    
    //[self.actorPullDown addItemsWithTitles:self.actors];
    
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
    NSString* ageRating = ageRatingPopUpButton.titleOfSelectedItem;
    [ageRatingPopUpButton setTitle:ageRating];
    
    if([ageRating isEqualToString:@"Any"]) {
        
        ageRating = nil;
        
    }
    
    [self.searchProvider setCertification:ageRating];
    
    [self refreshMovies];
    
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

- (void)showMovieSelected {
    
    if ([self movieDetailShowing]) {
        
        return;
        
    }
    _movieDetailShowing = YES;
    
    self.showMovieView.hidden = NO;
    self.movieTableView.hidden = YES;
    self.tableViewHeader.hidden = YES;
    self.movieTableScrollView.hidden = YES;
    
}

- (void)showListViewSelected {
    
    /*if (![self movieDetailShowing]) {
        
        return;
        
    }*/
    _movieDetailShowing = NO;
    
    self.graphView.hidden = YES;
    self.showMovieView.hidden = YES;
    self.movieTableView.hidden = NO;
    self.tableViewHeader.hidden = NO;
    self.movieTableScrollView.hidden = NO;
    
}

- (void)showGraphView {
    
    _movieDetailShowing = NO;
    
    self.graphView.hidden = NO;
    self.showMovieView.hidden = YES;
    self.movieTableView.hidden = YES;
    self.tableViewHeader.hidden = YES;
    self.movieTableScrollView.hidden = YES;
    
}

- (IBAction)addActorTouched:(id)sender {
    
    if([self.selectedActorsArray indexOfObject:self.actorPullDown.titleOfSelectedItem] == NSNotFound) {
        
        if(![self.actorPullDown.titleOfSelectedItem isEqualToString:@"N/A"]) {
            
            [self.selectedActorsArray addObject: self.actorPullDown.titleOfSelectedItem];
            [self updateActorList];
            
        }
        
    }
    
}

- (IBAction)addDirectorTouched:(id)sender {
    
    if([self.selectedDirectorsArray indexOfObject:self.directorPullDown.titleOfSelectedItem] == NSNotFound ) {
        
        if(![self.directorPullDown.titleOfSelectedItem isEqualToString:@"N/A"]) {
            
            [self.selectedDirectorsArray addObject: self.directorPullDown.titleOfSelectedItem];
            NSLog(@"%@",self.directorPullDown.titleOfSelectedItem);
            
        }
        
    }
    
}

- (IBAction)actorSelectionTouched:(id)sender {
    
    
}

- (IBAction)directorSelectionTouched:(id)sender {
    
    /*NSPopUpButtonCell* directorSelectionButton = (NSPopUpButtonCell*)sender;
    NSString* selectedDirector = directorSelectionButton.titleOfSelectedItem;
    directorSelectionButton.state = NSOnState;*/

}

- (void)movieSearchTextChanged:(NSNotification *)notification {
    
    NSString* searchString = self.movieSearchField.stringValue;
    
    if([searchString isEqual: @""]) {
        
        searchString = nil;
        
    }
    
    [self.searchProvider setTitle:searchString];
    
    [self refreshMovies];
    
}

- (void)minYearTextChanged:(NSNotification *)notification {
    
    NSInteger minYear = self.minYearTextField.integerValue;
    if (self.minYearTextField.stringValue.length == 0) {
        
        minYear = 0;
        
    }
    
    [self.searchProvider setMinimumYear:minYear];
    
    [self refreshMovies];
    
}

- (void)maxYearTextChanged:(NSNotification *)notification {
    
    NSInteger maxYear = self.maxYearTextField.integerValue;
    if (self.maxYearTextField.stringValue.length == 0) {
        
        maxYear = INT_MAX;
        
    }
    
    if(maxYear == 0) {
        
        [self.searchProvider setMaximumYear:INT_MAX];
        
    } else {
        
        [self.searchProvider setMaximumYear:maxYear];
        
    }
    
    [self refreshMovies];
    
}

- (IBAction)viewSegmentedControlSelected:(id)sender {
    
    NSSegmentedControl *control = (NSSegmentedControl *)sender;
    int segment = (int)[control selectedSegment];
    
    if(segment == 0) {
        
        [self watchlistClicked:nil];
        
    } else if(segment == 1) {
        
        [self watchlistClicked:nil];
        
    } else if(segment == 2) {
        
        [self showGraphView];
        
    }
    
}

- (IBAction)netflixButtonTouched:(id)sender {
    
    if ([sender state] == NSOnState) {
        
        [self.searchProvider setAvailableOnNetflix:YES];
        
    } else {
        
        [self.searchProvider setAvailableOnNetflix:NO];
        
    }
    
    [self refreshMovies];
    
}

- (IBAction)itunesButtonTouched:(id)sender {
    
    if ([sender state] == NSOnState) {
        
        [self.searchProvider setAvailableOnItunes:YES];
        
    } else {
        
        [self.searchProvider setAvailableOnItunes:NO];
        
    }
    
    [self refreshMovies];
    
}

- (IBAction)shomiButtonTouched:(id)sender {
    
    if ([sender state] == NSOnState) {
        
        [self.searchProvider setAvailableOnShomi:YES];
        
    } else {
        
        [self.searchProvider setAvailableOnShomi:NO];
        
    }
    
    [self refreshMovies];
    
}

- (IBAction)horrorButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

- (IBAction)comedyButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

- (IBAction)romanceButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

- (IBAction)adventureButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

- (IBAction)documentaryButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

- (IBAction)sciFiButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

- (IBAction)dramaButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

- (IBAction)actionButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

- (IBAction)thrillerButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

- (IBAction)fantasyButtonTouched:(id)sender {
    [self genreButtonChanged:sender];
}

-(void)genreButtonChanged:(NSButton *)genreButton {
    
    NSString * const title = [genreButton title];
    
    Genre * __block genre = nil;
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        genre = [Genre genreMatchingTitle:title inManagedObjectContext:managedObjectContext];
        
    }];
    if (!genre) {
        
        return;
        
    }
    
    NSMutableArray * const genres = [NSMutableArray arrayWithArray:[[self searchProvider] genres]];
    if ([genres containsObject:genre]) {
        
        [genres removeObject:genre];
        
    } else {
        
        [genres addObject:genre];
        
    }
    [[self searchProvider] setGenres:genres];
    [self refreshMovies];
    
}

@end
