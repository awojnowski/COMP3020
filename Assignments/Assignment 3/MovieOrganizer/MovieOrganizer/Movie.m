//
//  Movie.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "Movie.h"

@implementation Movie

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
    
}

+(instancetype)movieMatchingTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title ==[c] %@",title]];
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return [results firstObject];
    
}

+(NSArray <Movie *> *)allMoviesInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return results;
    
}

@end
