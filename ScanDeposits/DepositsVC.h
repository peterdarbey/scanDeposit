//
//  DepositsVC.h
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define BAG_AMOUNT_TF 200
#define BAG_AMOUNT 250
#define BAG_NO_LBL 150

@class Deposit;

#import "AppDelegate.h"

@interface DepositsVC : UIViewController <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>
{
    NSIndexPath *selectedIndexPath;
    AppDelegate *appDelegate;
    UIButton *proceedBtn;
}

@property (strong, nonatomic) IBOutlet UITableView *depositsTV;
@property (strong, nonatomic) NSMutableArray *depositsCollection;
@property int bagCount;
@property double totalDepositAmount;
//@property int depositCount;

@end
