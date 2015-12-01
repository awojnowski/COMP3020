//
//  Tag.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

NS_ASSUME_NONNULL_BEGIN

@interface Tag : NSManagedObject

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+(instancetype)tagMatchingTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

NS_ASSUME_NONNULL_END

#import "Tag+CoreDataProperties.h"
