//
//  Contact.m
//  P3
//
//  Created by Aaron Wojnowski on 2015-11-07.
//  Copyright © 2015 CS Boys. All rights reserved.
//

#import "Contact.h"

NSString * const ContactNameKey = @"name";
NSString * const ContactAddressKey = @"address";
NSString * const ContactPhoneNumberKey = @"phoneNumber";
NSString * const ContactInfoKey = @"info";

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
        
        _name = contents[ContactNameKey];
        _address = contents[ContactAddressKey];
        _phoneNumber = contents[ContactPhoneNumberKey];
        _info = contents[ContactInfoKey];
        
    }
    return self;
    
}

#pragma mark - Description

-(NSString *)description {
    
    return [NSString stringWithFormat:@"<%@ %p: name = %@; address = %@; phoneNumber = %@>",NSStringFromClass([self class]),self,[self name],[self address],[self phoneNumber]];
    
}

#pragma mark - Serialization

-(NSDictionary *)serializedRepresentation {
    
    return @{
             ContactNameKey : [self name] ?: @"",
             ContactAddressKey : [self address] ?: @"",
             ContactPhoneNumberKey : [self phoneNumber] ?: @"",
             ContactInfoKey : [self info] ?: @"",
             };
    
}

@end
