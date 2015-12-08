//
//  SeedDataLoader.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObjectContext;

@interface SeedDataLoader : NSObject

-(void)seedDataInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

+(instancetype)sharedInstance;

@end
