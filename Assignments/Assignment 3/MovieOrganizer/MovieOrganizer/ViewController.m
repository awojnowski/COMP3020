//
//  ViewController.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-29.
//  Copyright © 2015 CS Boys. All rights reserved.
//

// starting window size
// layout subviews
// how are we gonna design the advanced search to edit cells to move
// diasble interaction when on profile

#import "ViewController.h"

#import "CoreDataController.h"
#import "Movie.h"
#import "SeedDataLoader.h"

@interface ViewController ()

@property (weak) IBOutlet NSView *advancedSearchMenuBarView;
@property (weak) IBOutlet NSView *menuBarView;
@property (weak) IBOutlet NSTableView *movieTableView;
@property (weak) IBOutlet NSSegmentedControl *minRatingControl;
@property (weak) IBOutlet NSPopUpButtonCell *ageRatingPopUpButton;

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
    [self initializeListView];
    [self createAgeRatingPulldown];
    
    
}

-(void)setRepresentedObject:(id)representedObject {
    
    [super setRepresentedObject:representedObject];

    
    
}

-(void)viewDidLayout {
    
    [super viewDidLayout];
    
    [self.advancedSearchMenuBarView.layer setCornerRadius:1];
    [self.menuBarView.layer setCornerRadius:1];
    [self.advancedSearchMenuBarView.layer setBorderColor:[NSColor blackColor].CGColor];
    [self.menuBarView.layer setBorderColor:[NSColor blackColor].CGColor];
    
    [self.advancedSearchMenuBarView setNeedsDisplay:YES];
    [self.menuBarView setNeedsDisplay:YES];
    [self.view setNeedsDisplay:YES];
    
}

-(void)initializeListView {
    
    NSArray* columnTitles = [NSArray arrayWithObjects: @"Movie Title",@"Genre",@"Year",@"Rating",@"Director",@"Age Rating", nil];
    
    for(int i = 0; i < [columnTitles count]; i++) {
     
        NSTableColumn *column = self.movieTableView.tableColumns[i];
        [column.headerCell setStringValue:columnTitles[i]];
        column.width = self.movieTableView.frame.size.width / 8;
        
    }
    
}

- (IBAction)minRatingControlTouched:(id)sender {
    
    NSSegmentedControl *control = (NSSegmentedControl *)sender;
    int minRating = (int)[control selectedSegment];
    
    for(int i = minRating; i >= 0; i--) {
        
        [control setSelected:YES forSegment:i];
        [control setImage:[NSImage imageNamed:@"star"] forSegment:i];
        
    }
    
    for(int i = minRating + 1; i < [control segmentCount]; i++) {
        
        [control setSelected:NO forSegment:i];
        [control setImage:[NSImage imageNamed:@"starOutline"] forSegment:i];
        
    }
    
}

-(void)createAgeRatingPulldown {
    
    [self.ageRatingPopUpButton removeAllItems];
    
    NSArray* ageTypes = [NSArray arrayWithObjects: @"N/A",@"Any",@"G",@"PG",@"14A",@"18A",@"R", nil];
    
    for(int i = 0; i <= [ageTypes count]; i++) {
        
        [self.ageRatingPopUpButton addItemsWithTitles:ageTypes];
        
    }
    
}

- (IBAction)ageRatingPulledDown:(id)sender {
    
    NSPopUpButtonCell* ageRatingPopUpButton = (NSPopUpButtonCell*)sender;
    [ageRatingPopUpButton setTitle:ageRatingPopUpButton.titleOfSelectedItem];
    
}


@end
