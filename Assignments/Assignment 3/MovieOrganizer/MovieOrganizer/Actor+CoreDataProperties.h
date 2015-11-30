//
//  Actor+CoreDataProperties.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Actor.h"

NS_ASSUME_NONNULL_BEGIN

@interface Actor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Movie *> *movies;

@end

@interface Actor (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet<Movie *> *)values;
- (void)removeMovies:(NSSet<Movie *> *)values;

@end

NS_ASSUME_NONNULL_END
