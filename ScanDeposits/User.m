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
@property (strong, nonatomic) NSString *initials;//for section header

@property (strong, nonatomic) NSString *password;
//@property BOOL adminstrator;

@property (strong, nonatomic) NSDictionary *internalDict;

@end



@implementation User

static BOOL __isAdmin;

- (void)commonInit:(NSDictionary *)dict {
    
    //init and assign the private properties 
    _name = dict[@"Name"];
    _eMail = dict[@"Email"];
    _staffID = dict[@"Staff ID"];
    _initials = dict[@"Initials"];//test
    __isAdmin = [dict[@"Adminstrator"] boolValue];//assign to static variable, NO as default unless admin
    //if admin they have a password so assign to ivar/property
    if (__isAdmin) {
        _password = dict[@"Password"];
    }
    else //not admin so set to nil
    {
        _password = nil;
    }
    _internalDict = dict;
    
}

- (id)initWithName:(NSString *)name eMail:(NSString *)eMail staffID:(NSString *)staffId
          Initials:(NSString *)initials isAdmin:(BOOL)isAdmin withPassword:(NSString *)password {
    
    self = [super init];
    if (self) {
        //construct a dict
        NSDictionary *dict = @{@"Name" : name, @"Email" : eMail,
                               @"Staff ID" : staffId, @"Initials" : initials, @"Adminstrator" : [NSNumber numberWithBool:isAdmin], @"Password" : password};//@(NO)};test <- //@YES
        
//        __isAdmin = isAdmin;//could be smarter
        
        DLog(@"init dict has: %@", dict);
        
        [self commonInit:dict];
        
    }
    
    return self;
}

+ (BOOL)isAdminUser {
    
    return __isAdmin;
}

- (NSString *)userName {
    return _name;
}

- (NSString *)userEMail {
    return _eMail;
}
- (NSString *)userStaffID {
    
    return _staffID;
}
- (NSString *)userInitials {
    
    return _initials;
}
- (NSString *)userPassword {
    return _password;
}

- (int)count {
    return [_internalDict count];
//    return 4;
}

@end




