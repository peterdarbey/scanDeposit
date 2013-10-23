//
//  UserVC.h
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserPopup.h"


#define USER_NAME_TF 100
#define USER_NAME_LBL 200


@interface UserVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UserModelDelegate>
{
    NSIndexPath *selectedIP;
}

@property (strong, nonatomic) IBOutlet UITableView *userTV;
@property (strong, nonatomic) NSMutableArray *userArray;
@property (strong, nonatomic) NSString *nameString, *emailString, *staffIDString;

@end
