//
//  SeedDataLoader.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "CoreDataController.h"
#import "SeedDataLoader.h"

#import "Actor.h"
#import "Configuration.h"
#import "Director.h"
#import "Genre.h"
#import "Movie.h"
#import "Tag.h"

@import CoreData;

NSString * const SeedDataLoaderSeedDataFileName = @"seedData.json";

@implementation SeedDataLoader

-(void)seedDataInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
 
    Configuration * configuration = [Configuration globalConfigurationInManagedObjectContext:managedObjectContext];
    if ([[configuration isCreated] boolValue]) {
        
        return;
        
    }
    if (!configuration) {
        
        configuration = [Configuration createInManagedObjectContext:managedObjectContext];
        
    }
    
    // load the data file
    
    NSURL * const seedDataURL = [[NSBundle mainBundle] URLForResource:SeedDataLoaderSeedDataFileName withExtension:@""];
    NSDictionary * const data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:seedDataURL] options:0 error:NULL];
    NSArray * const movies = [data valueForKeyPath:@"movielist.movie"];
    
    // import the data into core data
    
    [movies enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull movieDictionary, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx % 500 == 0) {
            
            NSLog(@"Imported %ld movies.",(long)idx);
            
        }
        
        NSString * const movieTitle = [movieDictionary[@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        Movie * const existingMovie = [Movie movieMatchingTitle:movieTitle inManagedObjectContext:managedObjectContext];
        if (existingMovie) {
            
            return;
            
        }
        
        NSInteger const movieYear = [movieDictionary[@"year"] integerValue];
        NSString * const movieLength = movieDictionary[@"length"];
        NSInteger const movieRating = [movieDictionary[@"rating"] integerValue];
        
        NSString * const directorName = movieDictionary[@"director"];
        
        NSArray * const genres = [movieDictionary[@"genre"] isKindOfClass:[NSString class]] ? @[movieDictionary[@"genre"]] : movieDictionary[@"genre"];
        NSArray * const actors = [movieDictionary[@"actor"] isKindOfClass:[NSString class]] ? @[movieDictionary[@"actor"]] : movieDictionary[@"actor"];
        
        Movie * movie = [Movie createInManagedObjectContext:managedObjectContext];
        [movie setTitle:movieTitle];
        [movie setYear:@(movieYear)];
        [movie setLength:movieLength];
        [movie setRating:@(movieRating)];
        
        // add the director
        
        Director * const director = ({
            
            Director *director = [Director directorMatchingName:directorName inManagedObjectContext:managedObjectContext];
            if (!director) {
                
                director = [Director createInManagedObjectContext:managedObjectContext];
                
            }
            director;
            
        });
        [director setName:directorName];
        [movie setDirector:director];
        
        // add the genres
        
        [genres enumerateObjectsUsingBlock:^(NSString * _Nonnull genreTitle, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Genre * const genre = ({
                
                Genre *genre = [Genre genreMatchingTitle:genreTitle inManagedObjectContext:managedObjectContext];
                if (!genre) {
                    
                    genre = [Genre createInManagedObjectContext:managedObjectContext];
                    
                }
                genre;
                
            });
            [genre setTitle:genreTitle];
            [movie addGenresObject:genre];
            
        }];
        
        // add the actors
        
        [actors enumerateObjectsUsingBlock:^(NSString * _Nonnull actorName, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Actor * const actor = ({
                
                Actor *actor = [Actor actorMatchingName:actorName inManagedObjectContext:managedObjectContext];
                if (!actor) {
                    
                    actor = [Actor createInManagedObjectContext:managedObjectContext];
                    
                }
                actor;
                
            });
            [actor setName:actorName];
            [movie addActorsObject:actor];
            
        }];
        
    }];
    
    // create the watchlist
    
    Tag *watchList = [Tag createInManagedObjectContext:managedObjectContext];
    [watchList setTitle:WatchlistTagName];
    [watchList setReadonly:@(YES)];
    
    // all done!
    
    [configuration setIsCreated:@YES];
    
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
