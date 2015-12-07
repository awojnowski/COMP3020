//
//  ViewController.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-29.
//  Copyright © 2015 CS Boys. All rights reserved.
//

// both write ups
// EVERYTHING input validated
// input validation on reviews
// diasble interaction when on movie

// syntax-free interaction?
// add all genres to adv. search?

#import "ViewController.h"

#import "TagsListAddView.h"
#import "DirectorsListAddView.h"
#import "ActorsListAddView.h"

#import "CoreDataController.h"
#import "Movie.h"
#import "Genre.h"
#import "Actor.h"
#import "Director.h"
#import "Tag.h"
#import "SeedDataLoader.h"
#import "MovieDetailViewController.h"
#import "EditMovieViewController.h"
#import "GraphViewController.h"

#import "MovieSearchProvider.h"

@interface ViewController () <NSTableViewDataSource, NSTableViewDelegate, MovieDetailViewControllerDelegate, EditMovieViewControllerDelegate, ListAddViewDelegate>

@property (nonatomic, readonly, assign) NSInteger currentSelectedSegment;
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

@property (weak) IBOutlet DirectorsListAddView *directorsListAddView;
@property (weak) IBOutlet ActorsListAddView *actorsListAddView;
@property (weak) IBOutlet TagsListAddView *tagsListAddView;

@property (weak) IBOutlet NSTableView *movieTableView;
@property (weak) IBOutlet NSTableHeaderView *tableViewHeader;
@property (weak) IBOutlet NSScrollView *movieTableScrollView;

@property (weak) IBOutlet NSSegmentedCell *viewSegmentedControlSelector;
@property (weak) IBOutlet NSSegmentedControl *minRatingControl;
@property (weak) IBOutlet NSPopUpButtonCell *ageRatingPopUpButton;
@property (weak) IBOutlet NSSegmentedCell *graphSegmentedControl;

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

@property (strong, nonatomic) NSWindowController *editMovieWindowController;

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
        
        /*NSArray *actors = [Actor allActorsInManagedObjectContext:managedObjectContext];
        [actors enumerateObjectsUsingBlock:^(id  _Nonnull actor, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [actorNames addObject:[actor name]];
            
        }];
        [self setActors:actors];*/
        
        // load the UI
        
        /*dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [[self actorPullDown] addItemsWithTitles:actorNames];
            
        });*/
        
    }];
    
    // setting up advanced search fields
    
    [[self tagsListAddView] setDelegate:self];
    [[self directorsListAddView] setDelegate:self];
    [[self actorsListAddView] setDelegate:self];
    
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
    
    self.graphVC = [[GraphViewController alloc] initWithNibName:nil bundle:nil];
    self.graphVC.searchProvider = [self searchProvider];
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

#pragma mark - Watchlist

-(Tag *)watchlistTag {
    
    Tag * __block watchlistTag = nil;
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        watchlistTag = [Tag watchlistInManagedObjectContext:managedObjectContext];
        
    }];
    if (!watchlistTag) {
        
        return nil;
        
    }
    return watchlistTag;
    
}

-(void)enableWatchlist {
    
    Tag * const watchlistTag = [self watchlistTag];
    if (!watchlistTag) {
        
        return;
        
    }
    
    NSMutableArray * const mutableTagsArray = [NSMutableArray arrayWithArray:[[self searchProvider] tags]];
    if ([mutableTagsArray containsObject:watchlistTag]) {
        
        return;
        
    }
    [mutableTagsArray addObject:watchlistTag];
    [[self searchProvider] setTags:mutableTagsArray];
    
}

-(void)disableWatchlist {
    
    Tag * const watchlistTag = [self watchlistTag];
    if (!watchlistTag) {
        
        return;
        
    }
    
    NSMutableArray * const mutableTagsArray = [NSMutableArray arrayWithArray:[[self searchProvider] tags]];
    if (![mutableTagsArray containsObject:watchlistTag]) {
        
        return;
        
    }
    [mutableTagsArray removeObject:watchlistTag];
    [[self searchProvider] setTags:mutableTagsArray];
    
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

- (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray<NSSortDescriptor *> *)oldDescriptors {
    
    [self refreshSortDescriptors];
    
}

- (void)showMovie {
    
    self.movieDetailVC.movie = self.movies[self.movieTableView.selectedRow];
    
    self.viewSegmentedControlSelector.enabled = NO;
    
    [self showMovieSelected];
    
}

#pragma mark - Data Manipulation

- (IBAction)addPressed:(id)sender {
    
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        Movie *movie = [Movie createInManagedObjectContext:managedObjectContext];
        
        [self showMovieEditorWithMovie:movie];
        
    }];
    
}

- (IBAction)editPressed:(id)sender {
    
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        [self showMovieEditorWithMovie:self.movies[self.movieTableView.selectedRow]];
        
    }];
    
}

- (IBAction)deletePressed:(id)sender {
    
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        [managedObjectContext deleteObject:self.movies[self.movieTableView.selectedRow]];
        
    }];
    
    [self refreshMovies];
    
}

- (void)showMovieEditorWithMovie:(Movie *)movie {
    
    NSStoryboard *storyboard = [NSStoryboard storyboardWithName:@"MovieEditor" bundle:nil];
    self.editMovieWindowController = [storyboard instantiateInitialController];
    EditMovieViewController *editViewController = (EditMovieViewController *)self.editMovieWindowController.window.contentViewController;
    editViewController.delegate = self;
    editViewController.movie = movie;
    [self.editMovieWindowController showWindow:self];
    
}

#pragma mark - EditMovieViewControllerDelegate

- (void)cancelEditing:(EditMovieViewController *)editMovieViewController {
    
    [self.editMovieWindowController close];
    self.editMovieWindowController = nil;
    
    if (editMovieViewController.movie.title.length == 0) {
        
        // Created a new movie but didn't fill it in
        
        [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
            
            [managedObjectContext deleteObject:editMovieViewController.movie];
            
        }];
        
    }
    
}

- (void)doneEditing:(EditMovieViewController *)editMovieViewController {
    
    [self.editMovieWindowController close];
    self.editMovieWindowController = nil;
    
    [self refreshMovies];
    
}

#pragma mark - Actions

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

- (IBAction)graphSegmentedControlSelected:(id)sender {
    
    if(self.graphSegmentedControl.state == NSOffState) {
        
        [self.graphSegmentedControl setSelected:NO forSegment:0];
        [self viewSegmentedControlSelected:nil];
        
    } else {
        
        [self.graphSegmentedControl setSelected:YES forSegment:0];
        [self showGraphView];
        
    }
    
}

- (IBAction)viewSegmentedControlSelected:(id)sender {
    
    NSInteger segment = [self.viewSegmentedControlSelector selectedSegment];
    if (self.graphSegmentedControl.state == NSOnState) {
        
        if(segment == 0) {
            
            [self disableWatchlist];
            
        } else {
            
            [self enableWatchlist];
            
        }
        
        [self refreshMovies];
        
        return;
        
    }
    _currentSelectedSegment = segment;
    
    if(segment == 0) {
        
        [self showListViewSelected];
        [self disableWatchlist];
        [self refreshMovies];
        
    } else if(segment == 1) {
        
        [self showListViewSelected];
        [self enableWatchlist];
        [self refreshMovies];
        
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

#pragma mark - ListAddViewDelegate

-(NSArray *)rowArrayForListAddView:(ListAddView *)listAddView {
    
    if (listAddView == [self tagsListAddView]) {
        
        return [[self searchProvider] tags] ?: @[];
        
    } else if (listAddView == [self directorsListAddView]) {
        
        return [[self searchProvider] directors] ?: @[];
        
    } else if (listAddView == [self actorsListAddView]) {
        
        return [[self searchProvider] actors] ?: @[];
        
    }
    return nil;
    
}

-(NSString *)listAddView:(ListAddView *)listAddView stringValueForRowArrayItem:(id)item {
    
    if (listAddView == [self tagsListAddView]) {
        
        return [(Tag *)item title];
        
    } else if (listAddView == [self directorsListAddView]) {
        
        return [(Director *)item name];
        
    } else if (listAddView == [self actorsListAddView]) {
        
        return [(Actor *)item name];
        
    }
    return nil;
    
}

-(void)listAddViewAddedItem:(ListAddView *)listAddView {
    
    if (listAddView == [self tagsListAddView]) {
        
        NSString * const itemName = [self fetchItemNameWithPrompt:@"Please enter the name of a tag."];
        if (!itemName) {
            
            return;
            
        }
        id __block item = nil;
        [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
            
            item = [Tag tagMatchingTitle:itemName inManagedObjectContext:managedObjectContext];
            if (!item) {
                
                item = [Tag createInManagedObjectContext:managedObjectContext];
                [item setTitle:itemName];
                
            }
            
        }];
        if (!item) {
            
            return;
            
        }
        
        NSMutableArray * const mutableTags = [NSMutableArray arrayWithArray:[[self searchProvider] tags]];
        [mutableTags addObject:item];
        [[self searchProvider] setTags:mutableTags];
        
    } else if (listAddView == [self directorsListAddView]) {
        
        NSString * const itemName = [self fetchItemNameWithPrompt:@"Please enter a director's name."];
        if (!itemName) {
            
            return;
            
        }
        id __block item = nil;
        [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
            
            item = [Director directorMatchingName:itemName inManagedObjectContext:managedObjectContext];
            
        }];
        if (!item) {
            
            NSAlert * const alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:@"It doesn't look like a director with that name was found."];
            [alert runModal];
            
            return;
            
        }
        
        NSMutableArray * const mutableDirectors = [NSMutableArray arrayWithArray:[[self searchProvider] directors]];
        [mutableDirectors addObject:item];
        [[self searchProvider] setDirectors:mutableDirectors];
        
    } else if (listAddView == [self actorsListAddView]) {
        
        NSString * const itemName = [self fetchItemNameWithPrompt:@"Please enter an actor's name."];
        if (!itemName) {
            
            return;
            
        }
        id __block item = nil;
        [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
            
            item = [Actor actorMatchingName:itemName inManagedObjectContext:managedObjectContext];
            
        }];
        if (!item) {
            
            NSAlert * const alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"Dismiss" alternateButton:nil otherButton:nil informativeTextWithFormat:@"It doesn't look like an actor with that name was found."];
            [alert runModal];
            
            return;
            
        }
        
        NSMutableArray * const mutableActors = [NSMutableArray arrayWithArray:[[self searchProvider] actors]];
        [mutableActors addObject:item];
        [[self searchProvider] setActors:mutableActors];
        
    }
    [self refreshMovies];
    [[listAddView tableView] reloadData];
    
}

-(void)listAddView:(ListAddView *)listAddView removedRowArrayItem:(id)item {
    
    if (listAddView == [self tagsListAddView]) {
        
        NSMutableArray * const mutableTags = [NSMutableArray arrayWithArray:[[self searchProvider] tags]];
        [mutableTags removeObject:item];
        [[self searchProvider] setTags:mutableTags];
        
    } else if (listAddView == [self directorsListAddView]) {
        
        NSMutableArray * const mutableDirectors = [NSMutableArray arrayWithArray:[[self searchProvider] directors]];
        [mutableDirectors removeObject:item];
        [[self searchProvider] setDirectors:mutableDirectors];
        
    } else if (listAddView == [self actorsListAddView]) {
        
        NSMutableArray * const mutableActors = [NSMutableArray arrayWithArray:[[self searchProvider] actors]];
        [mutableActors removeObject:item];
        [[self searchProvider] setActors:mutableActors];
        
    }
    [self refreshMovies];
    [[listAddView tableView] reloadData];
    
}

-(NSString *)fetchItemNameWithPrompt:(NSString *)prompt {
    
    NSAlert * const alert = [NSAlert alertWithMessageText: prompt defaultButton:@"OK" alternateButton:@"Cancel" otherButton:nil informativeTextWithFormat:@""];
    
    NSTextField * const inputField = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 200, 24)];
    [alert setAccessoryView:inputField];
    
    NSInteger const button = [alert runModal];
    if (button == NSAlertDefaultReturn) {
        
        [inputField validateEditing];
        return [inputField stringValue];
        
    }
    return nil;
    
}

@end
