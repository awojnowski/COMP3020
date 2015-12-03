//
//  MovieDetailViewController.h
//  MovieOrganizer
//
//  Created by Lorenzo Gentile on 2015-12-02.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Movie.h"

@protocol MovieDetailViewControllerDelegate <NSObject>

- (void)backButtonPressed;

@end

@interface MovieDetailViewController : NSViewController

@property (strong, nonatomic) Movie *movie;
@property (weak, nonatomic) id<MovieDetailViewControllerDelegate> delegate;

@end
