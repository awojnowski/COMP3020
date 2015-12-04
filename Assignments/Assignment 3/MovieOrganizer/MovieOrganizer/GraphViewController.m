//
//  GraphViewController.m
//  MovieOrganizer
//
//  Created by Kieran on 2015-12-04.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "GraphViewController.h"

#import "ScatterplotView.h"

#import "Movie.h"
#import "MovieSearchProvider.h"

static void * GraphViewControllerContextPointer = &GraphViewControllerContextPointer;

@interface GraphViewController ()

@property (nonatomic, readonly, strong) ScatterplotView *scatterplotView;

@end

@implementation GraphViewController

@synthesize scatterplotView=_scatterplotView;
-(ScatterplotView *)scatterplotView {
    
    if (!_scatterplotView) {
        
        _scatterplotView = [[ScatterplotView alloc] init];
        [[self view] addSubview:_scatterplotView];
        
    }
    return _scatterplotView;
    
}

-(void)dealloc {
    
    [self setSearchProvider:nil];
    
}

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.view setWantsLayer:YES];
    
    [self.view.layer setBorderColor:[NSColor lightGrayColor].CGColor];
    [self.view.layer setBorderWidth:1];
    [self.view.layer setBackgroundColor:[NSColor whiteColor].CGColor];

}

-(void)viewDidLayout {
    
    [super viewDidLayout];
    
    [[self scatterplotView] setFrame:[[self view] bounds]];
    
}

#pragma mark - Movies

-(void)refreshMovies:(MovieSearchProvider *)searchProvider {
    
    [[self scatterplotView] redrawWithSearchProvider:searchProvider];
    
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (object == [self searchProvider]) {
        
        if ([keyPath isEqualToString:@"previousSearchResults"]) {
            
            [self refreshMovies:[self searchProvider]];
            
        }
        
    }
    
}

#pragma mark - Getters & Setters

-(void)setSearchProvider:(MovieSearchProvider *)searchProvider {
    
    [_searchProvider removeObserver:self forKeyPath:@"previousSearchResults"];
    _searchProvider = searchProvider;
    [_searchProvider addObserver:self forKeyPath:@"previousSearchResults" options:0 context:GraphViewControllerContextPointer];
    
    if (searchProvider) {
        
        [self refreshMovies:searchProvider];
        
    }
    
}

@end
