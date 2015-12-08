//
//  ScatterplotView.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-04.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MovieSearchProvider;

@interface ScatterplotView : NSView

-(void)redrawWithSearchProvider:(MovieSearchProvider *)searchProvider;

@end
