//
//  Actor.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Movie;

NS_ASSUME_NONNULL_BEGIN

@interface Actor : NSManagedObject

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+(instancetype)actorMatchingName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

NS_ASSUME_NONNULL_END

#import "Actor+CoreDataProperties.h"
