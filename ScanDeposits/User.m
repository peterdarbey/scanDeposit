//
//  User.m
//  ScanDeposits
//
//  Created by Peter Darbey on 23/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "User.h"

@interface User ()
{
    
}

//Private members
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *eMail;
@property (strong, nonatomic) NSString *staffID;

@property (strong, nonatomic) NSDictionary *internalDict;

@end



@implementation User

- (void)commonInit:(NSDictionary *)dict {
    
    //init the private properties 
    _name = dict[@"Name"];
    _eMail = dict[@"Email"];
    _staffID = dict[@"StaffID"];
    _internalDict = dict;
    
}

- (id)initWithName:(NSString *)name eMail:(NSString *)eMail staffID:(NSString *)staffId isAdmin:(BOOL)isAdmin {
    
    self = [super init];
    if (self) {
        NSDictionary *dict = @{@"Name" : name, @"Email" : eMail,
                            @"StaffID" : staffId, @"Adminstrator" : @(NO)};//test <- [NSNumber numberWithBool:isAdmin]
        
        DLog(@"init dict has: %@", dict);
        
        [self commonInit:dict];
        
    }
    
    return self;
}

@end




