//
//  Review.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-06.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "Review.h"
#import "Movie.h"

@implementation Review

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
    
}

@end
