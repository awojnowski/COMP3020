//
//  Configuration+CoreDataProperties.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Configuration.h"

NS_ASSUME_NONNULL_BEGIN

@interface Configuration (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isCreated;

@end

NS_ASSUME_NONNULL_END
