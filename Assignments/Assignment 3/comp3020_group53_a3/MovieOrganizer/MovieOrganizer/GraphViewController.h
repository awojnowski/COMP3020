//
//  GraphViewController.h
//  MovieOrganizer
//
//  Created by Kieran on 2015-12-04.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MovieSearchProvider;

@interface GraphViewController : NSViewController

@property (nonatomic, weak) MovieSearchProvider *searchProvider;

@end