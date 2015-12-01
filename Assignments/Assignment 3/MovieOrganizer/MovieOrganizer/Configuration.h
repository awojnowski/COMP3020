//
//  Configuration.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObjectContext;

NS_ASSUME_NONNULL_BEGIN

@interface Configuration : NSManagedObject

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+(instancetype)globalConfigurationInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

NS_ASSUME_NONNULL_END

#import "Configuration+CoreDataProperties.h"
