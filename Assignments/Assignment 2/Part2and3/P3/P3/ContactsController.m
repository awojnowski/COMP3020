//
//  ContactsController.m
//  P3
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "Contact.h"
#import "ContactsController.h"

NSString * const ContactsControllerDefaultFileName = @"database.txt";

@implementation ContactsController

-(instancetype)init {
    
    self = [super init];
    if (self) {
        
        ;
        
    }
    return self;
    
}

#pragma mark - File Management

-(NSURL *)fileURLWithName:(NSString *)name {
    
    NSURL * const documentsDirectoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [documentsDirectoryURL URLByAppendingPathComponent:name];
    
}

#pragma mark - Serialization

-(void)loadContactsFromFile:(NSString *)file {
    
    NSURL * const fileURL = [self fileURLWithName:file];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    if (!data) {
        
        [self willChangeValueForKey:@"contacts"];
        _contacts = [NSMutableArray array];
        [self didChangeValueForKey:@"contacts"];
        
        NSLog(@"No contacts data found in file: %@ ... loading empty contact list.",file);
        
        return;
        
    }
    NSArray * const contents = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSMutableArray * const contacts = [NSMutableArray arrayWithCapacity:[contents count]];
    [contents enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull serializedContact, NSUInteger idx, BOOL * _Nonnull stop) {
        
        Contact *contact = [[Contact alloc] initWithContents:serializedContact];
        [contacts addObject:contact];
        
    }];
    [self willChangeValueForKey:@"contacts"];
    _contacts = contacts;
    [self didChangeValueForKey:@"contacts"];
    
    NSLog(@"Loaded contacts: %@ from file: %@",contacts,file);
    
}

-(void)serializeContactsToFile:(NSString *)file {
    
    NSArray <Contact *> * const contacts = [self contacts];
    NSMutableArray <NSDictionary *> * const serializedContacts = [NSMutableArray arrayWithCapacity:[contacts count]];
    [contacts enumerateObjectsUsingBlock:^(Contact * _Nonnull contact, NSUInteger idx, BOOL * _Nonnull stop) {
        
        serializedContacts[idx] = [contact serializedRepresentation];
        
    }];
    
    NSURL * const fileURL = [self fileURLWithName:file];
    NSData * const contents = [NSJSONSerialization dataWithJSONObject:serializedContacts options:0 error:nil];
    [contents writeToURL:fileURL options:NSDataWritingAtomic error:nil];
    
    NSLog(@"Serialized contacts to file: %@",file);
    
}

#pragma mark - Class Methods

+(instancetype)sharedInstance {
    
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if (!instance) {
            
            instance = [[self alloc] init];
            
        }
        
    });
    return instance;
    
}

@end
