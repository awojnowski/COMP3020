//
//  Tag+CoreDataProperties.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-03.
//  Copyright © 2015 CS Boys. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Tag.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tag (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *readonly;
@property (nullable, nonatomic, retain) NSSet<Movie *> *movies;

@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addMoviesObject:(Movie *)value;
- (void)removeMoviesObject:(Movie *)value;
- (void)addMovies:(NSSet<Movie *> *)values;
- (void)removeMovies:(NSSet<Movie *> *)values;

@end

NS_ASSUME_NONNULL_END
