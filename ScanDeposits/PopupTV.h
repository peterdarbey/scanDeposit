//
//  PopupTV.h
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class User;
#import "User.h"

#define USER_NAME_TF 100
#define USER_NAME_LBL 200

@interface PopUpTV : UITableView  <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSIndexPath *selectedIP;
}

@property  (strong, nonatomic) NSString *name;
@property  (strong, nonatomic) NSString *eMail;
@property  (strong, nonatomic) NSString *staffID;
@property  (strong, nonatomic) NSString *initials;

@end

