//
//  EditMovieViewController.m
//  MovieOrganizer
//
//  Created by Lorenzo Gentile on 2015-12-04.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "EditMovieViewController.h"
#import "CoreDataController.h"
#import "Director.h"
#import "Actor.h"
#import "Genre.h"
#import "Tag.h"

@interface EditMovieViewController ()

@property (weak) IBOutlet NSTextField *movieTitleTextField;
@property (weak) IBOutlet NSPopUpButton *ratingPopUpButton;
@property (weak) IBOutlet NSPopUpButton *certificationPopUpButton;
@property (weak) IBOutlet NSTextField *yearTextField;
@property (weak) IBOutlet NSTextField *lengthTextField;
@property (weak) IBOutlet NSTextField *directorTextField;
@property (weak) IBOutlet NSTextField *actorsTextField;
@property (weak) IBOutlet NSTextField *genreTextField;
@property (weak) IBOutlet NSTextField *tagsTextField;
@property (weak) IBOutlet NSButton *itunesCheckBox;
@property (weak) IBOutlet NSButton *netflixCheckBox;
@property (weak) IBOutlet NSButton *shomiCheckBox;

@end

@implementation EditMovieViewController

- (void)setMovie:(Movie *)movie {
    
    _movie = movie;
    
    if (movie.title != nil) {
        
        // Is editing movie
        
        self.movieTitleTextField.stringValue = movie.title;
        [self.ratingPopUpButton selectItemAtIndex:[self.movie.rating integerValue]];
        
        [self.certificationPopUpButton selectItemWithTitle:self.movie.certification];
        if(self.certificationPopUpButton.titleOfSelectedItem == nil && self.movie.certification != nil) {
            [self.certificationPopUpButton addItemWithTitle:self.movie.certification];
            [self.certificationPopUpButton selectItemWithTitle:self.movie.certification];
        }
        
        self.yearTextField.stringValue = [NSString stringWithFormat:@"%@", self.movie.year];
        self.lengthTextField.stringValue = [self.movie.length componentsSeparatedByString:@" min"].firstObject;
        self.directorTextField.stringValue = self.movie.director.name;
        self.actorsTextField.stringValue = [self stringWithActors:self.movie.actors];
        self.genreTextField.stringValue = [self stringWithGenres:self.movie.genres];
        self.tagsTextField.stringValue = [self stringWithTags:self.movie.tags];
        [self.itunesCheckBox setState:[self.movie.availableOnItunes integerValue]];
        [self.netflixCheckBox setState:[self.movie.availableOnNetflix integerValue]];
        [self.shomiCheckBox setState:[self.movie.availableOnShomi integerValue]];
        
    }
    
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message {
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:title];
    [alert setInformativeText:message];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
    
}

- (BOOL)containsOnlyLetters:(NSString *)string {
    
    NSString *regex = @"[A-Za-z, ]*";
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [test evaluateWithObject:string];
    
}

#pragma mark - Data Conversion

- (NSArray<NSString *> *)trimmedComponents:(NSString *)string {
    
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSArray<NSString *> *components = [string componentsSeparatedByString:@","];
    NSMutableArray *trimmedComponents = [[NSMutableArray alloc] init];
    
    [components enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            [trimmedComponents addObject:[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        }
    }];
    
    return trimmedComponents;
    
}

- (NSSet<Actor *> *)actorSetFromString:(NSString *)string {
    
    NSArray<NSString *> *components = [self trimmedComponents:string];
    NSMutableArray<Actor *> *actors = [[NSMutableArray<Actor *> alloc] init];
            
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        [components enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Actor *actor = [Actor actorMatchingName:obj inManagedObjectContext:managedObjectContext];
            if (actor == nil) {
                actor = [Actor createInManagedObjectContext:managedObjectContext];
                actor.name = obj;
            }
            [actors addObject: actor];
        }];
        
    }];
    
    return [NSSet setWithArray:actors];
    
}

- (NSString *)stringWithActors:(NSSet<Actor *> *)actorSet {
    
    NSArray<Actor *> *actors = actorSet.allObjects;
    NSMutableArray<NSString *> *actorNames = [[NSMutableArray<NSString *> alloc] init];
    [actors enumerateObjectsUsingBlock:^(Actor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [actorNames addObject:obj.name];
    }];
    
    return [actorNames componentsJoinedByString:@", "];
    
}

- (NSSet<Genre *> *)genreSetFromString:(NSString *)string {
    
    NSArray<NSString *> *components = [self trimmedComponents:string];
    NSMutableArray<Genre *> *genres = [[NSMutableArray<Genre *> alloc] init];
    
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        [components enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Genre *genre = [Genre genreMatchingTitle:obj inManagedObjectContext:managedObjectContext];
            if (genre == nil) {
                genre = [Genre createInManagedObjectContext:managedObjectContext];
                genre.title = obj;
            }
            [genres addObject:genre];
        }];
        
    }];
    
    return [NSSet setWithArray:genres];
    
}

- (NSString *)stringWithGenres:(NSSet<Genre *> *)genreSet {
    
    NSArray<Genre *> *genres = genreSet.allObjects;
    NSMutableArray<NSString *> *genreTitles = [[NSMutableArray<NSString *> alloc] init];
    [genres enumerateObjectsUsingBlock:^(Genre * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [genreTitles addObject:obj.title];
    }];
    
    return [genreTitles componentsJoinedByString:@", "];
    
}

- (NSSet<Tag *> *)tagSetFromString:(NSString *)string {
    
    NSArray<NSString *> *components = [self trimmedComponents:string];
    NSMutableArray<Tag *> *tags = [[NSMutableArray<Tag *> alloc] init];
    
    [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
        
        [components enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Tag *tag = [Tag tagMatchingTitle:obj inManagedObjectContext:managedObjectContext];
            if (tag == nil) {
                tag = [Tag createInManagedObjectContext:managedObjectContext];
                tag.title = obj;
            }
            [tags addObject:tag];
        }];
        
    }];
    
    if (tags.count > 0) {
        return [NSSet setWithArray:tags];
    } else {
        return [[NSSet<Tag *> alloc] init];
    }
    
}

- (NSString *)stringWithTags:(NSSet<Tag *> *)tagSet {
    
    NSArray<Tag *> *tags = tagSet.allObjects;
    NSMutableArray<NSString *> *tagTitles = [[NSMutableArray<NSString *> alloc] init];
    [tags enumerateObjectsUsingBlock:^(Tag * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tagTitles addObject:obj.title];
    }];
    
    return [tagTitles componentsJoinedByString:@", "];
    
}

#pragma mark - Actions

- (IBAction)donePressed:(id)sender {
    
    // Validate
    
    if ([self.movieTitleTextField.stringValue isEqualToString:@""]) {
        
        [self showAlertWithTitle:@"Invalid Movie Title" andMessage:@"The movie title can not be empty."];
        [self.movieTitleTextField becomeFirstResponder];
        
    } else if (self.yearTextField.intValue == 0) {
        
        [self showAlertWithTitle:@"Invalid Movie Year" andMessage:@"The movie year can not be empty."];
        [self.yearTextField becomeFirstResponder];
        
    } else if (self.lengthTextField.intValue == 0) {
        
        [self showAlertWithTitle:@"Invalid Movie Length" andMessage:@"The movie length can not be empty."];
        [self.lengthTextField becomeFirstResponder];
        
    } else if ([self.directorTextField.stringValue isEqualToString:@""]) {
        
        [self showAlertWithTitle:@"Invalid Movie Director" andMessage:@"The movie director can not be empty."];
        [self.directorTextField becomeFirstResponder];
        
    } else if (![self containsOnlyLetters:self.directorTextField.stringValue]) {
        
        [self showAlertWithTitle:@"Invalid Movie Director" andMessage:@"The movie director can only contain letters."];
        [self.directorTextField becomeFirstResponder];
        
    } else if ([self.actorsTextField.stringValue isEqualToString:@""]) {
        
        [self showAlertWithTitle:@"Invalid Movie Actors" andMessage:@"The movie actors can not be empty."];
        [self.actorsTextField becomeFirstResponder];
        
    } else if (![self containsOnlyLetters:self.actorsTextField.stringValue]) {
        
        [self showAlertWithTitle:@"Invalid Movie Actors" andMessage:@"The movie actors can only contain letters."];
        [self.actorsTextField becomeFirstResponder];
        
    } else if ([self.genreTextField.stringValue isEqualToString:@""]) {
        
        [self showAlertWithTitle:@"Invalid Movie Genre" andMessage:@"The movie genre can not be empty."];
        [self.genreTextField becomeFirstResponder];
        
    } else if (![self containsOnlyLetters:self.genreTextField.stringValue]) {
        
        [self showAlertWithTitle:@"Invalid Movie Genre" andMessage:@"The movie genre can only contain letters."];
        [self.genreTextField becomeFirstResponder];
        
    } else {
        
        // Good to go
        
//        NSLog(@"Title: %@", self.movieTitleTextField.stringValue);
//        NSLog(@"Rating: %@", [NSNumber numberWithInteger:self.ratingPopUpButton.indexOfSelectedItem]);
//        NSLog(@"Certification: %@", self.certificationPopUpButton.titleOfSelectedItem);
//        NSLog(@"Year: %@", [NSNumber numberWithInt:self.yearTextField.intValue]);
//        NSLog(@"Length: %@", [NSNumber numberWithInt:self.lengthTextField.intValue]);
//        NSLog(@"Director: %@", self.directorTextField.stringValue);
//        NSLog(@"Actors: %@", [self setFromString:self.actorsTextField.stringValue]);
//        NSLog(@"Genre: %@", self.genreTextField.stringValue);
//        NSLog(@"Tags: %@", [self setFromString:self.tagsTextField.stringValue]);
//        NSLog(@"iTunes: %@", [NSNumber numberWithInt:self.itunesCheckBox.intValue]);
//        NSLog(@"Netflix: %@", [NSNumber numberWithInt:self.netflixCheckBox.intValue]);
//        NSLog(@"Shomi: %@\n", [NSNumber numberWithInt:self.shomiCheckBox.intValue]);
        
        [[CoreDataController sharedInstance] performBlock:^(NSManagedObjectContext *managedObjectContext) {
            
            NSString *trimmedDirector = [self.directorTextField.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            Director *director = [Director directorMatchingName:trimmedDirector inManagedObjectContext:managedObjectContext];
            if (director == nil) {
                director = [Director createInManagedObjectContext:managedObjectContext];
                director.name = trimmedDirector;
            }
            
            self.movie.title = self.movieTitleTextField.stringValue;
            self.movie.rating = [NSNumber numberWithInteger:self.ratingPopUpButton.indexOfSelectedItem];
            self.movie.certification = self.certificationPopUpButton.titleOfSelectedItem;
            self.movie.year = [NSNumber numberWithInt:self.yearTextField.intValue];
            self.movie.length = [NSString stringWithFormat:@"%d min", self.lengthTextField.intValue];
            self.movie.director = director;
            self.movie.actors = [self actorSetFromString:self.actorsTextField.stringValue];
            self.movie.genres = [self genreSetFromString:self.genreTextField.stringValue];
            self.movie.tags = [self tagSetFromString:self.tagsTextField.stringValue];
            self.movie.availableOnItunes = [NSNumber numberWithInt:self.itunesCheckBox.intValue];
            self.movie.availableOnNetflix = [NSNumber numberWithInt:self.netflixCheckBox.intValue];
            self.movie.availableOnShomi = [NSNumber numberWithInt:self.shomiCheckBox.intValue];
            
        }];
        
        [self.delegate doneEditing:self];
        
    }
    
}

- (IBAction)cancelPressed:(id)sender {
    
    [self.delegate cancelEditing:self];
    
}

@end
