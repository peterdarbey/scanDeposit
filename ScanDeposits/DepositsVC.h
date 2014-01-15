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

@class SuccessPopup;

@class HomeVC;

#define BAG_AMOUNT_TF 200
#define BAG_AMOUNT 250
#define BAG_NO_LBL 150


//other URL
#define kURLGavin @"http://10.28.111.95:9080/ie.aib.coindrop/CoinDrop"
#define kURLNOEL @"http://10.28.111.25:9080/ie.aib.coindrop/CoinDrop"


@interface DepositsVC : UIViewController <UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate, NotificationDelegate, UITextFieldDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>
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
@property BOOL valueEdited;


@end
