//
//  ViewController.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-29.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "ViewController.h"

#import "CoreDataController.h"
#import "Movie.h"
#import "SeedDataLoader.h"

@implementation ViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[CoreDataController sharedInstance] initialize];
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        [[SeedDataLoader sharedInstance] seedDataInManagedObjectContext:managedObjectContext];
        
    }];

    NSArray __block * movies = nil;
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        NSLog(@"test");
        movies = [Movie allMoviesInManagedObjectContext:managedObjectContext];
        
    }];
    Movie *movie = [movies firstObject];
    NSLog(@"%@",movie);
    
}

-(void)setRepresentedObject:(id)representedObject {
    
    [super setRepresentedObject:representedObject];

    
    
}

@end
