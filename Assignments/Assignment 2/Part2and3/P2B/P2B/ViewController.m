//
//  ViewController.m
//  P2B
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "ViewController.h"

NSInteger const ViewControllerTimerInterval = 10.0;

@interface ViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, readonly, strong) NSArray <NSImage *> *images;
@property (nonatomic, readonly, assign) NSInteger currentImageIndex;
@property (nonatomic, readonly, strong) NSTimer *timer;

@property (nonatomic, weak) IBOutlet NSImageView *imageView;
@property (nonatomic, weak) IBOutlet NSTableView *tableView;

@end

@implementation ViewController

@synthesize images=_images;
-(NSArray <NSImage *> *)images {
    
    if (!_images) {
        
        _images = @[
                    [NSImage imageNamed:@"aw_fuk_bye"],
                    [NSImage imageNamed:@"cya"],
                    [NSImage imageNamed:@"hamster_banana"],
                    [NSImage imageNamed:@"jenna"],
                    [NSImage imageNamed:@"orangoutan"],
                    ];
        
    }
    return _images;
    
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    _currentImageIndex = 0;
    _timer = [NSTimer timerWithTimeInterval:ViewControllerTimerInterval target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:[self timer] forMode:NSRunLoopCommonModes];
    
    // setup tableView
    
    [[self tableView] setDataSource:self];
    [[self tableView] setDelegate:self];
    [[self tableView] setAllowsColumnResizing:NO];
    [[self tableView] setAllowsColumnSelection:NO];
        
    // setup the view
    
    [self showImageAtIndex:[self currentImageIndex]];
    
}

#pragma mark - Images

-(void)showImageAtIndex:(NSInteger)index {
    
    [[self imageView] setImage:[self images][index]];
    [[self tableView] selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    
}

#pragma mark - Timer

-(void)timerFired:(NSTimer *)sender {
    
    _currentImageIndex ++;
    if ([self currentImageIndex] >= [[self images] count]) {
        
        _currentImageIndex = 0;
        
    }
    [self showImageAtIndex:[self currentImageIndex]];
    
}

#pragma mark - NSTableViewDelegate

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    return [[self images] count];
    
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    return [[self images][row] name];
    
}

-(BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    
    return NO;
    
}

@end
