//
//  EditMovieViewController.h
//  MovieOrganizer
//
//  Created by Lorenzo Gentile on 2015-12-04.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Movie.h"

@class EditMovieViewController;

@protocol EditMovieViewControllerDelegate <NSObject>

- (void)cancelEditing:(EditMovieViewController *)editMovieViewController;
- (void)doneEditing:(EditMovieViewController *)editMovieViewController;

@end

@interface EditMovieViewController : NSViewController

@property (strong, nonatomic) Movie *movie;
@property (weak, nonatomic) id<EditMovieViewControllerDelegate> delegate;

@end
