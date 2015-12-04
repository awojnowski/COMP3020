//
//  Contact.m
//  P3
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "Contact.h"

NSString * const ContactFirstNameKey = @"firstName";
NSString * const ContactLastNameKey = @"lastName";
NSString * const ContactAddressKey = @"address";
NSString * const ContactPhoneNumberKey = @"phoneNumber";
NSString * const ContactInfoKey = @"info";
NSString * const ContactAgeKey = @"age";
NSString * const ContactUniversityYearKey = @"universityYear";
NSString * const ContactGenderKey = @"gender";

@implementation Contact

-(instancetype)init {
    
    self = [super init];
    if (self) {
        
        ;
        
    }
    return self;
    
}

-(instancetype)initWithContents:(NSDictionary *)contents {
    
    self = [super init];
    if (self) {
        
        _firstName = contents[ContactFirstNameKey];
        _lastName = contents[ContactLastNameKey];
        _address = contents[ContactAddressKey];
        _phoneNumber = contents[ContactPhoneNumberKey];
        _info = contents[ContactInfoKey];
        _age = contents[ContactAgeKey];
        _universityYear = contents[ContactUniversityYearKey];
        _gender = [contents[ContactGenderKey] integerValue];
        
    }
    return self;
    
}

#pragma mark - Description

-(NSString *)description {
    
    return [NSString stringWithFormat:@"<%@ %p: name = %@ %@; address = %@; phoneNumber = %@>",NSStringFromClass([self class]),self,[self firstName],[self lastName],[self address],[self phoneNumber]];
    
}

#pragma mark - Serialization

-(NSDictionary *)serializedRepresentation {
    
    return @{
             ContactFirstNameKey : [self firstName] ?: @"",
             ContactLastNameKey : [self lastName] ?: @"",
             ContactAddressKey : [self address] ?: @"",
             ContactPhoneNumberKey : [self phoneNumber] ?: @"",
             ContactInfoKey : [self info] ?: @"",
             ContactAgeKey : [self age] ?: @(0),
             ContactUniversityYearKey : [self universityYear] ?: @(0),
             ContactGenderKey : @([self gender]),
             };
    
}

@end
