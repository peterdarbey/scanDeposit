//
//  HomeVC.h
//  ScanDeposits
//
//  Created by Peter Darbey on 09/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanditSDKOverlayController.h"
#import "ScanditSDKBarcodePicker.h"


//custom xib imports
#import "WarningPopup.h"
#import "QRPopup.h"
#import "ITFPopup.h"
#import "SuccessPopup.h"

@class Barcode;
@class QRBarcode;
@class EightBarcode;
@class Deposit;
@class RegistrationVC;
@class StringParserHelper;
@class UserVC;

#import "LogInVC.h"
#import "RegistrationVC.h"
#import "DepositsVC.h"


//#define kScanditSDKAppKey @"4w8vXjD2EeOZw8u2pkkjQH4S+hfplxDDtzKnte2lX4s"//current community version

#define kScanditSDKAppKey @"tKjFyk0cEeOBqwy+jrUhbfCJDNgUVhVIAzazaaLmsvw"//trial version
                            

@interface HomeVC : UIViewController <ScanditSDKOverlayControllerDelegate,  DismissLoginWithValidationDelegate, LogoutDelegate, ResumeScanMode, ResumeScanningModeDelegate, ResumeScanDelegate, ResetAndPresentDelegate>
{
    NSString *dateString;//not very OO
    NSNotificationCenter *notificationCenter;
    UIButton *scanDeviceBtn, *scanBagBtn, *logOutBtn;
    UIBarButtonItem *barBtnFinished;

}

@property (strong, nonatomic) NSMutableArray *array;

//internal collection for existing barcodes
@property(strong, nonatomic) NSMutableArray *uniqueBagArray;

@property (strong, nonatomic) NSMutableArray *barcodeArray;
@property (strong, nonatomic) NSMutableArray *depositsArray;
@property BOOL isAdmin;
@property BOOL isUser;
@property BOOL isSetup;
@property BOOL isLoggedOut;

//could be a enum
@property BOOL scanModeIsQR;
//new BOOL for dismissOfSuccessPopup
@property BOOL shouldDismiss;
@property BOOL didCancelDeposit;
@property BOOL didCancelScan;

@end
