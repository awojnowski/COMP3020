//
//  Movie.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor;
@class Director;
@class Genre;
@class Tag;

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSManagedObject

@property (nonatomic, readonly, strong) NSImage *image;

-(void)fetchImageWithCompletionBlock:(void (^)(NSImage *image))completionBlock;

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+(instancetype)movieMatchingTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
+(NSArray <Movie *> *)allMoviesInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end

NS_ASSUME_NONNULL_END

#import "Movie+CoreDataProperties.h"
