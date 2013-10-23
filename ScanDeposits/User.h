//
//  User.h
//  ScanDeposits
//
//  Created by Peter Darbey on 23/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    
}

- (id)initWithName:(NSString *)name eMail:(NSString *)eMail staffID:(NSString *)staffId Initials:(NSString *)initials isAdmin:(BOOL)isAdmin;

//getters

+ (BOOL)isAdminUser;

- (NSString *)userName;
- (NSString *)userEMail;
- (NSString *)userStaffID;
- (NSString *)userInitials;
- (int)count;

@end
