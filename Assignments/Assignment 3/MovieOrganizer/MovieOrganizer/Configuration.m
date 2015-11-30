//
//  Configuration.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "Configuration.h"

@import CoreData;

@implementation Configuration

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
    
}

+(instancetype)globalConfigurationInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return [results firstObject];
    
}

@end
