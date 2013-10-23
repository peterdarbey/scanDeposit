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
//@property BOOL adminstrator;

@property (strong, nonatomic) NSDictionary *internalDict;

@end



@implementation User

static BOOL __isAdmin;

- (void)commonInit:(NSDictionary *)dict {
    
    //init and assign the private properties 
    _name = dict[@"Name"];
    _eMail = dict[@"Email"];
    _staffID = dict[@"StaffID"];
//    _adminstrator = [dict[@"Administrator"] boolValue];//assigning NO as default to adminstrator
    __isAdmin = [dict[@"Adminstrator"] boolValue];//assign to static variable
    _internalDict = dict;
    
}

- (id)initWithName:(NSString *)name eMail:(NSString *)eMail staffID:(NSString *)staffId isAdmin:(BOOL)isAdmin {
    
    self = [super init];
    if (self) {
        //construct a dict
        NSDictionary *dict = @{@"Name" : name, @"Email" : eMail,
                               @"StaffID" : staffId, @"Adminstrator" : [NSNumber numberWithBool:isAdmin]};//@(NO)};test <-
        
        __isAdmin = isAdmin;//could be smarter
        
        DLog(@"init dict has: %@", dict);
        
        [self commonInit:dict];
        
    }
    
    return self;
}

+ (BOOL)isAdminUser {
    
    return __isAdmin;
}

@end




