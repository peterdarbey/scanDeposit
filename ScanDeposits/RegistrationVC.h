//
//  RegistrationVC.h
//  ScanDeposits
//
//  Created by Peter Darbey on 21/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NAME_TF 100
#define USER_LBL 250
#define EMAIL_PREPOP 200

#define AIB @"@aib.ie"

@interface RegistrationVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSIndexPath *selectedIP;
}

@property (strong, nonatomic) IBOutlet UITableView *registerTV;

@end