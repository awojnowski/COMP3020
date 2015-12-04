//
//  MovieSearchProvider.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-03.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "CoreDataController.h"
#import "MovieSearchProvider.h"

#import "Actor.h"
#import "Director.h"
#import "Genre.h"
#import "Movie.h"
#import "Tag.h"

@interface MovieSearchProvider ()

@end

@implementation MovieSearchProvider

-(instancetype)init {
    
    self = [super init];
    if (self) {
        
        _maximumResults = INT_MAX;
        _minimumRating = 0;
        _maximumRating = 10;
        _minimumYear = 0;
        _maximumYear = INT_MAX;
        
    }
    return self;
    
}

-(void)searchWithCompletionBlock:(void (^)(NSArray <Movie *> *movies))completionBlock {
    
    if (!completionBlock) {
        
        return;
        
    }
    
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        NSPredicate * const predicate = [NSPredicate predicateWithFormat:@"\
                                         TRUEPREDICATE AND (\
                                         (%@ == NO OR (%@ == YES AND ANY actors IN %@)) AND \
                                         (%@ == NO OR (%@ == YES AND certification ==[c] %@)) AND\
                                         (%@ == NO OR (%@ == YES AND director == %@)) AND\
                                         (%@ == NO OR (%@ == YES AND ANY genres IN %@)) AND\
                                         (rating >= %@ AND rating <= %@) AND\
                                         (%@ == NO OR (%@ == YES AND availableOnItunes == %@)) AND\
                                         (%@ == NO OR (%@ == YES AND availableOnNetflix == %@)) AND\
                                         (%@ == NO OR (%@ == YES AND availableOnShomi == %@)) AND\
                                         (%@ == NO OR (%@ == YES AND ANY tags IN %@)) AND\
                                         (%@ == NO OR (%@ == YES AND title CONTAINS[c] %@)) AND\
                                         (year >= %@ AND year <= %@)\
                                         )\
                                         ",
                                         
                                         @([[self actors] count] > 0),
                                         @([[self actors] count] > 0),
                                         [self actors] ?: @[],
                                         
                                         @([[self certification] length] > 0),
                                         @([[self certification] length] > 0),
                                         [self certification],
                                         
                                         @([self director] != nil),
                                         @([self director] != nil),
                                         [self director],
                                         
                                         @([[self genres] count] > 0),
                                         @([[self genres] count] > 0),
                                         [self genres] ?: @[],
                                         
                                         @([self minimumRating]),
                                         @([self maximumRating]),
                                         
                                         @([self availableOnItunes]),
                                         @([self availableOnItunes]),
                                         @([self availableOnItunes]),
                                         
                                         @([self availableOnNetflix]),
                                         @([self availableOnNetflix]),
                                         @([self availableOnNetflix]),
                                         
                                         @([self availableOnShomi]),
                                         @([self availableOnShomi]),
                                         @([self availableOnShomi]),
                                         
                                         @([[self tags] count] > 0),
                                         @([[self tags] count] > 0),
                                         [self tags] ?: @[],
                                         
                                         @([[self title] length] > 0),
                                         @([[self title] length] > 0),
                                         [self title],
                                         
                                         @([self minimumYear]),
                                         @([self maximumYear])
                                    ];
        
        NSFetchRequest * const fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Movie class])];
        [fetchRequest setFetchLimit:[self maximumResults]];
        [fetchRequest setPredicate:predicate];
        
        NSArray * const results = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            completionBlock(results);
            
        });
        
    }];
    
}

@end
