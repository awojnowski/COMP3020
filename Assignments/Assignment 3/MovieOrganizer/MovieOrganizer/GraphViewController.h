//
//  GraphViewController.h
//  MovieOrganizer
//
//  Created by Kieran on 2015-12-04.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol GraphViewControllerDelegate;

@interface GraphViewController : NSViewController

@property (weak, nonatomic) id<GraphViewControllerDelegate> delegate;

@end

@protocol GraphViewControllerDelegate <NSObject>

- (void)graphBackButtonPressed:(GraphViewController *)graphViewController;

@end