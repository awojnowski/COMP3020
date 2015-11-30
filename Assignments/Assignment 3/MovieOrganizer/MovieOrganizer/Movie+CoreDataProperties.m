//
//  Movie+CoreDataProperties.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Movie+CoreDataProperties.h"

@implementation Movie (CoreDataProperties)

@dynamic title;
@dynamic year;
@dynamic length;
@dynamic rating;
@dynamic actors;
@dynamic genres;
@dynamic director;
@dynamic tags;

@end
