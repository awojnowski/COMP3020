//
//  Contact.h
//  P3
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ContactGender) {
    ContactGenderMale,
    ContactGenderFemale
};

@interface Contact : NSObject

@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, copy) NSNumber *age;
@property (nonatomic, copy) NSNumber *universityYear;
@property (nonatomic, assign) ContactGender gender;

-(instancetype)init;
-(instancetype)initWithContents:(NSDictionary *)contents;

-(NSDictionary *)serializedRepresentation;

@end
