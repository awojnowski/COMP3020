//
//  ContactsController.h
//  P3
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const ContactsControllerDefaultFileName;

@class Contact;

@interface ContactsController : NSObject

@property (nonatomic, strong) NSMutableArray <Contact *> *contacts;

-(void)loadContactsFromFile:(NSString *)file;
-(void)serializeContactsToFile:(NSString *)file;

+(instancetype)sharedInstance;

@end
