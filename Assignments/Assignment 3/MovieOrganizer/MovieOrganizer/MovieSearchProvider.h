//
//  MovieSearchProvider.h
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-12-03.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Actor, Director, Genre, Movie, Tag;

@interface MovieSearchProvider : NSObject

@property (nonatomic, assign) NSInteger maximumResults;

-(void)searchWithCompletionBlock:(void (^)(NSArray <Movie *> *movies))completionBlock;

@end

#pragma mark - Movie Options
@interface MovieSearchProvider ()

// actors

@property (nonatomic, strong) NSArray <Actor *> *actors;

// certification

@property (nonatomic, strong) NSString *certification;

// director

@property (nonatomic, strong) Director *director;

// genre

@property (nonatomic, strong) NSArray <Genre *> *genres;

// networks

@property (nonatomic, assign) BOOL availableOnItunes;
@property (nonatomic, assign) BOOL availableOnNetflix;
@property (nonatomic, assign) BOOL availableOnShomi;

// ratings

@property (nonatomic, assign) NSInteger minimumRating; // inclusive
@property (nonatomic, assign) NSInteger maximumRating; // inclusive

// tags

@property (nonatomic, strong) NSArray <Tag *> *tags;

// title

@property (nonatomic, copy) NSString *title; // the movie must contain this title

// year

@property (nonatomic, assign) NSInteger minimumYear; // inclusive
@property (nonatomic, assign) NSInteger maximumYear; // inclusive

@end
