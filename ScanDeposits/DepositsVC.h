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
//local
#import "AppDelegate.h"
#import "WarningPopup.h"
//#import "HomeVC.h"

@class SuccessPopup;

@class HomeVC;

#define BAG_AMOUNT_TF 200
#define BAG_AMOUNT 250
#define BAG_NO_LBL 150

//@class Deposit;


@interface DepositsVC : UIViewController <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate, NotificationDelegate, UITextFieldDelegate>
{
    NSIndexPath *selectedIndexPath;
    AppDelegate *appDelegate;
    UIButton *proceedBtn;
}


//- (void)NotificationOfButtonPressed:(NSNotification *)notification;

@property (strong, nonatomic) IBOutlet UITableView *depositsTV;
@property (strong, nonatomic) NSMutableArray *depositsCollection;
@property int bagCount;
@property double totalDepositAmount;

@property (strong, nonatomic) NSMutableDictionary *usersDict;
@property (strong, nonatomic) NSMutableDictionary *adminsDict;
//collection of all the data for attachment
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableArray *barcodeArray;

@property BOOL allowEdit;

@property BOOL valueRemoved;


@end
