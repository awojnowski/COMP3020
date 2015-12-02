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
#import "SeedDataLoader.h"

@interface ViewController ()

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
@property (weak) IBOutlet NSView *userReviewContainer;
@property (weak) IBOutlet NSView *otherReviewsContainer;
@property (weak) IBOutlet NSView *exampleUserReviewOne;
@property (weak) IBOutlet NSView *exampleUserReviewTwo;

@property (weak) IBOutlet NSTableView *movieTableView;
@property (weak) IBOutlet NSTableHeaderView *tableViewHeader;
@property (weak) IBOutlet NSScrollView *movieTableScrollView;

@property (weak) IBOutlet NSSegmentedControl *minRatingControl;
@property (weak) IBOutlet NSPopUpButtonCell *ageRatingPopUpButton;
@property (weak) IBOutlet NSPopUpButton *actorPullDown;
@property (weak) IBOutlet NSPopUpButton *directorPullDown;

// Properties related to looking at movie field
@property (weak) IBOutlet NSLevelIndicator *movieRatingIndicator;
@property (weak) IBOutlet NSTextField *movieDescriptionField;
@property (weak) IBOutlet NSImageView *moviePosterImage;

// Database of actors & directors
@property (nonatomic) NSMutableArray* actorArray;
@property (nonatomic) NSMutableArray* directorArray;

// Currently selected actors & directors for advanced search
@property (nonatomic) NSMutableArray* selectedActorsArray;
@property (nonatomic) NSMutableArray* selectedDirectorsArray;

@end

@implementation ViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[CoreDataController sharedInstance] initialize];
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        [[SeedDataLoader sharedInstance] seedDataInManagedObjectContext:managedObjectContext];
        
    }];

    NSArray __block * movies = nil;
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        NSLog(@"test");
        movies = [Movie allMoviesInManagedObjectContext:managedObjectContext];
        
    }];
    Movie *movie = [movies firstObject];
    NSLog(@"%@",movie);
    
    // setting up advanced search fields
    [self initializeMovieTableView];
    [self createActorListPullDown];
    [self createDirectorListPullDown];
    [self createAgeRatingPullDown];
    
    self.movieTableView.hidden = YES;
    self.showMovieView.hidden = YES;

}

-(void)setRepresentedObject:(id)representedObject {
    
    [super setRepresentedObject:representedObject];

    
    
}

-(void)viewDidLayout {
    
    [super viewDidLayout];
    
    dispatch_async( dispatch_get_main_queue(), ^{
        
        [self.view setWantsLayer:YES];
        
        [self.showMovieView.layer setBorderColor:[NSColor lightGrayColor].CGColor];
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
        [self.userReviewContainer.layer setBorderColor:[NSColor lightGrayColor].CGColor];
        [self.otherReviewsContainer.layer setBorderColor:[NSColor lightGrayColor].CGColor];
        [self.exampleUserReviewOne.layer setBorderColor:[NSColor lightGrayColor].CGColor];
        [self.exampleUserReviewTwo.layer setBorderColor:[NSColor lightGrayColor].CGColor];
        
        [self.showMovieView.layer setBorderWidth:1];
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
        [self.userReviewContainer.layer setBorderWidth:1];
        [self.otherReviewsContainer.layer setBorderWidth:1];
        [self.exampleUserReviewOne.layer setBorderWidth:1];
        [self.exampleUserReviewTwo.layer setBorderWidth:1];
        
        [self.advancedSearchMenuBarView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
        [self.menuBarContainerView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
        [self.showMovieView.layer setBackgroundColor:[NSColor whiteColor].CGColor];
        [self.otherReviewsContainer.layer setBackgroundColor:[NSColor whiteColor].CGColor];
        
    });
    
}

-(void)initializeMovieTableView {
    
    NSArray* columnTitles = [NSArray arrayWithObjects: @"Movie Title",@"Genre",@"Year",@"Rating",@"Director",@"Age Rating", nil];
    
    for(int i = 0; i < [columnTitles count]; i++) {
     
        NSTableColumn *column = self.movieTableView.tableColumns[i];
        [column.headerCell setStringValue:columnTitles[i]];
        column.width = self.movieTableView.frame.size.width / 8;
        
    }
    
}

-(int)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return 1;
    
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    NSTableCellView *result = [tableView makeViewWithIdentifier:@"MovieTableViewIdentifer" owner:self];
    
    result.textField.stringValue = @"test";
    
    //NSLog(@"in delegate");
    
    return result;
    
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

@end
