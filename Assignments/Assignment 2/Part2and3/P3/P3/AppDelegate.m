//
//  AppDelegate.m
//  P3
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactsController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (IBAction)newPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewButtonPressed" object:NULL];
}

- (IBAction)editPressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditButtonPressed" object:NULL];
}

- (IBAction)deletePressed:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteButtonPressed" object:NULL];
}

@end
