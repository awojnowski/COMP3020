//
//  CoreDataController.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "CoreDataController.h"

@import CoreData;

NSString * const CoreDataControllerManagedObjectsDidChangeNotificationName = @"CoreDataControllerManagedObjectsDidChangeNotificationName";

NSString * const CoreDataControllerStoreName = @"CoreDataController.sqlite";

@interface CoreDataController ()

@property (nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation CoreDataController

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(instancetype)init {
    
    self = [super init];
    if (self) {
        
        ;
        
    }
    return self;
    
}

-(void)initialize {
    
    NSManagedObjectModel *managedObjectModel = [self generateManagedObjectModel];
    _managedObjectModel = managedObjectModel;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [self generatePersistentStoreCoordinatorWithManagedObjectModel:managedObjectModel];
    _persistentStoreCoordinator = persistentStoreCoordinator;
    
    // setup the persistent store
    
    NSError *storeError = nil;
    NSPersistentStore *store = [self generatePersistentStoreInPersistentStoreCoordinator:persistentStoreCoordinator error:&storeError];
    if (!store) {
        
        NSLog(@"Error creating store: %@",storeError);
        abort();
        
    }
    
    // create the managed object context
    
    NSManagedObjectContext *managedObjectContext = [self generateManagedObjectContextWithPersistentStoreCoordinator:persistentStoreCoordinator];
    _managedObjectContext = managedObjectContext;
    
    // add observers
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(managedObjectContextObjectsWillSaveNotification:) name:NSManagedObjectContextWillSaveNotification object:managedObjectContext];
    [notificationCenter addObserver:self selector:@selector(managedObjectContextObjectsDidChangeNotification:) name:NSManagedObjectContextObjectsDidChangeNotification object:managedObjectContext];
    
}

#pragma mark - Actions

-(void)performBlock:(void (^)(NSManagedObjectContext *managedObjectContext))block {
    
    NSManagedObjectContext * const managedObjectContext = [self managedObjectContext];
    [managedObjectContext performBlockAndWait:^{
        
        block ? block(managedObjectContext) : nil;
        
    }];
    [self saveContext:managedObjectContext];
    
}

-(void)removeCoreDataStore {
    
    [[NSFileManager defaultManager] removeItemAtURL:[self storeURLWithName:CoreDataControllerStoreName] error:nil];
    
}

#pragma mark - Helpers

-(NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    
}

-(NSURL *)storeURLWithName:(NSString *)name {
    
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:name];
    
}

-(NSString *)storePathWithName:(NSString *)name {
    
    return [[self storeURLWithName:name] path];
    
}

#pragma mark - Helpers (Store)

-(NSDictionary *)persistentStoreOptions {
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    options[NSMigratePersistentStoresAutomaticallyOption] = @YES;
    options[NSInferMappingModelAutomaticallyOption] = @YES;
    return options;
    
}

#pragma mark - Legacy

-(BOOL)hasDataAtStoreName:(NSString *)storeName {
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[self storePathWithName:storeName]];
    
}

#pragma mark - Notifications

-(void)managedObjectContextObjectsWillSaveNotification:(NSNotification *)notification {
    
    ;
    
}

-(void)managedObjectContextObjectsDidChangeNotification:(NSNotification *)notification {
    
    NSMutableDictionary * const userInfo = [NSMutableDictionary dictionaryWithDictionary:[notification userInfo]];
    [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataControllerManagedObjectsDidChangeNotificationName object:self userInfo:userInfo];
    
}

#pragma mark - Object Context

-(NSManagedObjectContext *)generateManagedObjectContextWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [managedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
    [managedObjectContext setPersistentStoreCoordinator:persistentStoreCoordinator];
    return managedObjectContext;
    
}

#pragma mark - Object Model

-(NSManagedObjectModel *)generateManagedObjectModel {
    
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return managedObjectModel;
    
}

#pragma mark - Persistent Store

-(NSPersistentStore *)generatePersistentStoreInPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator error:(NSError **)error {
    
    NSDictionary *storeOptions = [self persistentStoreOptions];
    NSURL *storeURL = [self storeURLWithName:CoreDataControllerStoreName];
    
    // setup the core data store
    
    NSError *storeError = nil;
    NSPersistentStore *store = [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&storeError];
    return store;
    
}

#pragma mark - Persistent Store Coordinator

-(NSPersistentStoreCoordinator *)generatePersistentStoreCoordinatorWithManagedObjectModel:(NSManagedObjectModel *)managedObjectModel {
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    return persistentStoreCoordinator;
    
}

#pragma mark - Saving

-(void)saveContext:(NSManagedObjectContext *)managedObjectContext {
    
    if (!managedObjectContext) {
        
        return;
        
    }
    
    if (![managedObjectContext hasChanges]) {
        
        return;
        
    }
    
    NSError *error = nil;
    BOOL result = [managedObjectContext save:&error];
    if (!result) {
        
        NSLog(@"Error saving maanged object context %@ with error: %@",managedObjectContext,error);
        
    } else {
        
        NSLog(@"Saved managed object context: %@",managedObjectContext);
        
    }
    
}

#pragma mark - Class Methods

+(instancetype)sharedInstance {
    
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[[self class] alloc] init];
        
    });
    return _instance;
    
}

@end

