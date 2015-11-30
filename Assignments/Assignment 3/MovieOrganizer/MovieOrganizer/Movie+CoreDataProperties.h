//
//  Movie+CoreDataProperties.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movie (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *year;
@property (nullable, nonatomic, retain) NSString *length;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *actors;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *genres;
@property (nullable, nonatomic, retain) NSManagedObject *director;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *tags;

@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addActorsObject:(NSManagedObject *)value;
- (void)removeActorsObject:(NSManagedObject *)value;
- (void)addActors:(NSSet<NSManagedObject *> *)values;
- (void)removeActors:(NSSet<NSManagedObject *> *)values;

- (void)addGenresObject:(NSManagedObject *)value;
- (void)removeGenresObject:(NSManagedObject *)value;
- (void)addGenres:(NSSet<NSManagedObject *> *)values;
- (void)removeGenres:(NSSet<NSManagedObject *> *)values;

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet<NSManagedObject *> *)values;
- (void)removeTags:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
