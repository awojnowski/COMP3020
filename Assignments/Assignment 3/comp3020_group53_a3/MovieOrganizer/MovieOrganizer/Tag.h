//
//  Tag.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-03.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const TagWatchlistTitle;

@interface Tag : NSManagedObject

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+(instancetype)tagMatchingTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+(instancetype)watchlistInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

NS_ASSUME_NONNULL_END

#import "Tag+CoreDataProperties.h"
