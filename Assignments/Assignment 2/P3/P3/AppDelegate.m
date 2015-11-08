//
//  AppDelegate.m
//  P3
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactsController.h"
#import "Contact.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    [[ContactsController sharedInstance] loadContactsFromFile:ContactsControllerDefaultFileName];
    
    Contact *contact = [[Contact alloc] init];
    [contact setName:@"Aaron"];
    [[[ContactsController sharedInstance] contacts] addObject:contact];
    
    [[ContactsController sharedInstance] serializeContactsToFile:ContactsControllerDefaultFileName];
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
