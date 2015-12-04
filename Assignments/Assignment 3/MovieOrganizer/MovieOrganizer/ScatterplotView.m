//
//  ScatterplotView.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-04.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "ScatterplotView.h"

#import "Movie.h"
#import "MovieSearchProvider.h"

@interface ScatterplotView ()

@property (nonatomic, readonly, strong) MovieSearchProvider *searchProvider;

@end

@implementation ScatterplotView

-(instancetype)init {
    
    self = [super init];
    if (self) {
        
        
        
    }
    return self;
    
}

-(void)drawRect:(NSRect)dirtyRect {
    
    [super drawRect:dirtyRect];
    
    NSInteger const lowerYearBound = MAX([[self searchProvider] minimumYear], 1900);
    NSInteger const upperYearBound = MIN([[self searchProvider] maximumYear], 2010);
    NSInteger const yearDifference = upperYearBound - lowerYearBound;

    CGFloat const leftXPadding = 48.0;
    CGFloat const rightXPadding = 32.0;
    CGFloat const upperYPadding = 16.0;
    CGFloat const lowerYPadding = 48.0;
    CGFloat const dotSize = 8.0;
    
    NSRect const graphRect = NSMakeRect(leftXPadding, lowerYPadding, (dirtyRect.size.width - leftXPadding - rightXPadding), (dirtyRect.size.height - upperYPadding - lowerYPadding));
    CGFloat const graphContentYHeight = graphRect.size.height - 64.0;
    CGFloat const graphContentY = graphRect.origin.y + 64.0 / 2.0;
    
    // draw the graph background
    
    [[NSColor colorWithWhite:0.975 alpha:1.0] setFill];
    NSRectFill(graphRect);
    
    // draw the lines
    
    [[NSColor blackColor] setFill];
    NSRectFill(NSMakeRect(graphRect.origin.x, graphRect.origin.y, 1, graphRect.size.height));
    NSRectFill(NSMakeRect(graphRect.origin.x, graphRect.origin.y, graphRect.size.width, 1));
    
    // draw the results
    
    [[NSColor redColor] setFill];
    
    [[[self searchProvider] previousSearchResults] enumerateObjectsUsingBlock:^(Movie * _Nonnull movie, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat const yearRatio = (CGFloat)([[movie year] integerValue] - lowerYearBound) / (CGFloat)MAX(yearDifference, 1);
        CGFloat const ratingRatio = (CGFloat)([[movie rating] integerValue]) / (CGFloat)9;
    
        NSBezierPath * const moviePath = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(graphRect.origin.x + yearRatio * graphRect.size.width - dotSize / 2.0, graphContentY + ratingRatio * graphContentYHeight - dotSize / 2.0, dotSize, dotSize)];
        [moviePath fill];
        
    }];
    
    // draw the rating
    
    CGFloat const ratingIncrement = graphContentYHeight / 9.0;
    CGFloat const ratingTextHeight = 20.0;
    
    NSMutableParagraphStyle * const ratingParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [ratingParagraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [ratingParagraphStyle setAlignment:NSTextAlignmentRight];
    [ratingParagraphStyle setMinimumLineHeight:ratingTextHeight];
    [ratingParagraphStyle setMaximumLineHeight:ratingTextHeight];
    
    for (NSInteger i = 0; i <= 9; i++) {
        
        NSString * const string = [NSString stringWithFormat:@"%ld",(long)i];
        NSRect const stringRect = NSMakeRect(0, graphContentY + ratingIncrement * i - ratingTextHeight / 2.0, leftXPadding - 8.0, ratingTextHeight);
        
        [[NSColor blackColor] setFill];
        [string drawInRect:stringRect withAttributes:@{ NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue" size:16.0], NSParagraphStyleAttributeName : ratingParagraphStyle }];
        
    }
    
    // draw the years
    
    CGFloat const yearTextHeight = 20.0;
    CGFloat const yearTextWidth = 45.0;
    CGFloat const yearIncrement = graphRect.size.width / MAX(yearDifference, 1);
    
    NSMutableParagraphStyle * const yearParagraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [yearParagraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [yearParagraphStyle setAlignment:NSTextAlignmentCenter];
    [yearParagraphStyle setMinimumLineHeight:yearTextHeight];
    [yearParagraphStyle setMaximumLineHeight:yearTextHeight];
    
    CGFloat lastYearMaxX = -10000.0;
    for (NSInteger i = 0; i <= yearDifference; i++) {
        
        NSInteger const year = lowerYearBound + i;
        if (year % 5 != 0 && i > 0 && i < yearDifference) {
            
            continue;
            
        }
        
        NSString * const string = [NSString stringWithFormat:@"%ld",(long)year];
        NSRect const stringRect = NSMakeRect(graphRect.origin.x + i * yearIncrement - yearTextWidth / 2.0, graphRect.origin.y - yearTextHeight - 8.0, yearTextWidth, yearTextHeight);
        if (stringRect.origin.x < lastYearMaxX) {
            
            continue;
            
        }
        
        lastYearMaxX = stringRect.origin.x + stringRect.size.width;
        
        [[NSColor blackColor] setFill];
        [string drawInRect:stringRect withAttributes:@{ NSFontAttributeName : [NSFont fontWithName:@"HelveticaNeue" size:16.0], NSParagraphStyleAttributeName : yearParagraphStyle }];
        
    }
    
}

-(void)redrawWithSearchProvider:(MovieSearchProvider *)searchProvider {
    
    _searchProvider = searchProvider;
    [self setNeedsDisplay:YES];
    
}

@end
