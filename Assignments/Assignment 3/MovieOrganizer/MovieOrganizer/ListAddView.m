//
//  ListAddView.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-05.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "ListAddView.h"

@interface ListAddView () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, readonly, strong) NSScrollView *tableViewContainerView;

@property (nonatomic, readonly, strong) NSArray *rowArray;

@end

@implementation ListAddView

@synthesize tableViewContainerView=_tableViewContainerView;
-(NSScrollView *)tableViewContainerView {
    
    if (!_tableViewContainerView) {
        
        _tableViewContainerView = [[NSScrollView alloc] init];
        [self addSubview:_tableViewContainerView];
        
    }
    return _tableViewContainerView;
    
}

@synthesize tableView=_tableView;
-(NSTableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[NSTableView alloc] init];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [[self tableViewContainerView] setDocumentView:_tableView];
        
        NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"column"];
        [column setTitle:[self title]];
        [column setWidth:200.0];
        [_tableView addTableColumn:column];
        
    }
    return _tableView;
    
}

@synthesize segmentedControl=_segmentedControl;
-(NSSegmentedControl *)segmentedControl {
    
    if (!_segmentedControl) {
        
        _segmentedControl = [[NSSegmentedControl alloc] init];
        [_segmentedControl setTarget:self];
        [_segmentedControl setAction:@selector(segmentedControlChanged:)];
        [_segmentedControl setSegmentCount:2];
        [_segmentedControl setImage:[NSImage imageNamed:NSImageNameAddTemplate] forSegment:0];
        [_segmentedControl setImage:[NSImage imageNamed:NSImageNameRemoveTemplate] forSegment:1];
        [self addSubview:_segmentedControl];
        
    }
    return _segmentedControl;
    
}

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    // initialize the view
    
    [self tableView];
    
}

-(void)layout {
    
    [super layout];
    
    CGFloat const segmentedControlWidth = 60.0;
    CGFloat const segmentedControlHeight = 25.0;
    [[self segmentedControl] setFrame:NSMakeRect(CGRectGetWidth([self bounds]) - segmentedControlWidth - 2, 0, segmentedControlWidth, segmentedControlHeight)];
    
    [[self tableViewContainerView] setFrame:NSMakeRect(0, segmentedControlHeight + 2, CGRectGetWidth([self bounds]), CGRectGetHeight([self bounds]) - segmentedControlHeight - 2)];
    [[self tableView] setFrame:[[self tableViewContainerView] bounds]];
    
}

#pragma mark - Segmented Control

-(void)segmentedControlChanged:(NSSegmentedControl *)sender {
    
    NSInteger const index = [sender selectedSegment];
    [sender setSelectedSegment:-1];
    
    if (index == 0) {
        
        [[self delegate] listAddViewAddedItem:self];
        
    } else if (index == 1) {
        
        NSInteger const selectedRow = [[self tableView] selectedRow];
        if (selectedRow == -1) {
            
            return;
            
        }
        id const item = [self rowArray][selectedRow];
        [[self delegate] listAddView:self removedRowArrayItem:item];
        
    }
    
}

#pragma mark - Subclasser Defaults

-(NSString *)title {
    
    return @"Default";
    
}

#pragma mark - NSTableViewDelegate

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    _rowArray = [[self delegate] rowArrayForListAddView:self];
    return [[self rowArray] count];
    
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    return [[self delegate] listAddView:self stringValueForRowArrayItem:[self rowArray][row]];
    
}

#pragma mark - Getters & Setters

-(void)setDelegate:(id<ListAddViewDelegate>)delegate {
    
    _delegate = delegate;
    [[self tableView] reloadData];
    
}

@end
