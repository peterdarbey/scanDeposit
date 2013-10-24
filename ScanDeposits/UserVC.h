//
//  UserVC.h
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserPopup.h"
@class User;


#define USER_NAME_TF 100
#define USER_NAME_LBL 200


@interface UserVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UserModelDelegate>
{
    NSIndexPath *selectedIP;
    NSDictionary *initialsDict;
    
}

@property (strong, nonatomic) IBOutlet UITableView *userTV;
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) NSString *nameString, *emailString, *staffIDString;
@property (strong, nonatomic) NSMutableArray *initialsArray;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) User *user;
@property BOOL isSelected;

@end
