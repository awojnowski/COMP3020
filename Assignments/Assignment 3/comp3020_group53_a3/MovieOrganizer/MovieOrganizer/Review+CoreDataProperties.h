//
//  Review+CoreDataProperties.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-06.
//  Copyright © 2015 CS Boys. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Review.h"

NS_ASSUME_NONNULL_BEGIN

@interface Review (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSString *review;
@property (nullable, nonatomic, retain) Movie *movie;

@end

NS_ASSUME_NONNULL_END
