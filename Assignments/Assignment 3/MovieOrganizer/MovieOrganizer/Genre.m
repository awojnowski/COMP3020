//
//  Genre.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "Genre.h"
#import "Movie.h"

@import CoreData;

@implementation Genre

#pragma mark - Class Methods

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
    
}

+(instancetype)genreMatchingTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title ==[c] %@",title]];
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return [results firstObject];
    
}

@end
