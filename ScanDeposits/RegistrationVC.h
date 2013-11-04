//
//  RegistrationVC.h
//  ScanDeposits
//
//  Created by Peter Darbey on 21/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;
@class UserVC;


#define NAME_TF 100
#define USER_LBL 250
#define EMAIL_PREPOP 200

#define AIB @"@aib.ie"

@interface RegistrationVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSIndexPath *selectedIP;
    NSMutableArray *stringArray;
    NSNotificationCenter *notificationCenter;

}

@property (strong, nonatomic) IBOutlet UITableView *registerTV;

@property (strong,nonatomic) NSMutableArray *adminArray;

@property BOOL fileExists;

@property BOOL isWritten;

@end
