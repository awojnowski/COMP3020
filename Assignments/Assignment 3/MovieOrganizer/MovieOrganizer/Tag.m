//
//  Tag.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "Tag.h"
#import "Movie.h"

@implementation Tag

NSString * const WatchlistTagName = @"Your Watchlist";

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
    
}

+(instancetype)tagMatchingTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title ==[c] %@",title]];
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return [results firstObject];
    
}

+(instancetype)watchlistInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title ==[c] %@",WatchlistTagName]];
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return [results firstObject];
    
}

@end
