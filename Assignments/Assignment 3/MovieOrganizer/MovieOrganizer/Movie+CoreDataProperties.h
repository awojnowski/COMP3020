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

@property (nullable, nonatomic, retain) NSNumber *availableOnNetflix;
@property (nullable, nonatomic, retain) NSNumber *availableOnShomi;
@property (nullable, nonatomic, retain) NSNumber *availableOnItunes;
@property (nullable, nonatomic, retain) NSString *certification;
@property (nullable, nonatomic, retain) NSString *length;
@property (nullable, nonatomic, retain) NSNumber *rating;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *year;
@property (nullable, nonatomic, retain) NSSet<Actor *> *actors;
@property (nullable, nonatomic, retain) Director *director;
@property (nullable, nonatomic, retain) NSSet<Genre *> *genres;
@property (nullable, nonatomic, retain) NSSet<Tag *> *tags;

@end

@interface Movie (CoreDataGeneratedAccessors)

- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSSet<Actor *> *)values;
- (void)removeActors:(NSSet<Actor *> *)values;

- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet<Genre *> *)values;
- (void)removeGenres:(NSSet<Genre *> *)values;

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet<Tag *> *)values;
- (void)removeTags:(NSSet<Tag *> *)values;

@end

NS_ASSUME_NONNULL_END
