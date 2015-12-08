//
//  Movie.m
//  MovieOrganizer
//
//  Created by Aaron Wojnowski on 2015-11-30.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "Movie.h"

#import <Cocoa/Cocoa.h>

@implementation Movie

@synthesize image=_image;

-(void)fetchImageWithCompletionBlock:(void (^)(NSImage *image))completionBlock {
    
    if ([self image]) {
        
        completionBlock ? completionBlock([self image]) : nil;
        return;
        
    }
    
    NSString * const pageURLString = [NSString stringWithFormat:@"http://api.movieposterdb.com/console?type=JSON&api_key=demo&secret=demo&imdb_code=&title=%@&width=300",[[self title] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSURLSession * const session = [NSURLSession sharedSession];
    NSURLSessionDataTask * const pageDataTask = [session dataTaskWithURL:[NSURL URLWithString:pageURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSString * const pageContents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray * const components = [pageContents componentsSeparatedByString:@"<strong>Javascript source:</strong><br />"];
        if ([components count] == 1) {
            
            return;
            
        }
        NSArray * const secondComponents = [components[1] componentsSeparatedByString:@"</div"];
        NSString * const apiURLString = ({
            
            NSString * apiURLString = [secondComponents firstObject];
            apiURLString = [apiURLString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            apiURLString = [apiURLString stringByReplacingOccurrencesOfString:@"&callback=process" withString:@""];
            apiURLString = [apiURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            apiURLString;
            
        });
        
        NSURLSessionDataTask * const imageDataTask = [session dataTaskWithURL:[NSURL URLWithString:apiURLString] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary * const jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([jsonResponse[@"errors"] count] > 0) {
                
                NSLog(@"Failed to receive image with URL: %@",apiURLString);
                return;
                
            }
            NSLog(@"Received image response: %@ with URL: %@",jsonResponse,apiURLString);
            
            NSArray * const posters = jsonResponse[@"posters"];
            if (![posters count]) {
                
                return;
                
            }
            NSDictionary * const poster = [posters firstObject];
            NSString * const imageLocationString = poster[@"image_location"];
            NSURL * const imageLocationURL = [NSURL URLWithString:imageLocationString];
            if (!imageLocationURL) {
                
                return;
                
            }
            
            NSURLSessionDataTask * const imageTask = [session dataTaskWithURL:imageLocationURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                NSImage * const image = [[NSImage alloc] initWithData:data];
                if (!image) {
                    
                    NSLog(@"Failed to generate image: %@ error: %@",image,error);
                    return;
                    
                }
                
                [self willChangeValueForKey:@"image"];
                _image = image;
                [self didChangeValueForKey:@"image"];
                
                completionBlock ? completionBlock(image) : nil;
                
            }];
            [imageTask resume];
            
        }];
        [imageDataTask resume];
        
    }];
    [pageDataTask resume];
    
}

#pragma mark - Class

+(instancetype)createInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    return [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:managedObjectContext];
    
}

+(instancetype)movieMatchingTitle:(NSString *)title inManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title ==[c] %@",title]];
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return [results firstObject];
    
}

+(NSArray <Movie *> *)allMoviesInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([self class])];
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:NULL];
    return results;
    
}

@end
