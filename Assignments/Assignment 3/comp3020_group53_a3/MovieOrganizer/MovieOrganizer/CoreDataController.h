//
//  CoreDataController.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CoreDataControllerManagedObjectsDidChangeNotificationName;

@class NSManagedObjectContext;

@interface CoreDataController : NSObject

// call when the application begins
-(void)initialize;

+(instancetype)sharedInstance;

@end

@interface CoreDataController (Accessors)

-(NSManagedObjectContext *)managedObjectContext;

@end

@interface CoreDataController (Actions)

-(void)performBlock:(void (^)(NSManagedObjectContext *managedObjectContext))block;
-(void)removeCoreDataStore;

@end
