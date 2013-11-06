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

@class ComposeEmailVC;


#define USER_NAME_TF 100
#define USER_NAME_LBL 200


@interface UserVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UserModelDelegate>
{
    NSIndexPath *selectedIP;
    
    UIImageView *iv;
    
    NSMutableArray *tempArray;
    NSMutableArray *loadArray;
    
    UIBarButtonItem *editBtn;
    
}

@property (strong, nonatomic) IBOutlet UITableView *userTV;
@property (strong, nonatomic) NSString *nameString, *emailString, *staffIDString;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) User *user;

//new collection for validation
@property (strong, nonatomic) NSMutableDictionary *usersDict;
@property (strong, nonatomic) NSMutableArray *usersArray;
@property BOOL usersWritten;

@property (strong, nonatomic) NSMutableArray *storedArray;
@property (strong, nonatomic) NSMutableArray *displayArray;

@property BOOL isSelected;
@property BOOL isExpanded;
@property BOOL fileExists;

@property BOOL isWritten;



@end
