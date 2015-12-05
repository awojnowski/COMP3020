//
//  ListAddView.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-05.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ListAddViewDelegate;

@interface ListAddView : NSView

@property (nonatomic, weak) id <ListAddViewDelegate> delegate;

@property (nonatomic, readonly, strong) NSTableView *tableView;
@property (nonatomic, readonly, strong) NSSegmentedControl *segmentedControl;

@end

@interface ListAddView (Subclassers)

-(NSString *)title;

@end

@protocol ListAddViewDelegate <NSObject>

@required
-(NSArray *)rowArrayForListAddView:(ListAddView *)listAddView;
-(NSString *)listAddView:(ListAddView *)listAddView stringValueForRowArrayItem:(id)item;
-(void)listAddViewAddedItem:(ListAddView *)listAddView;
-(void)listAddView:(ListAddView *)listAddView removedRowArrayItem:(id)item;

@end
