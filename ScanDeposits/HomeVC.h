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

//delegate method need import
#import "AlertView.h"

@class Barcode;
@class Deposit;
@class DepositsVC;
@class RegistrationVC;

@class UserVC;

#import "LogInVC.h"

//#define kScanditSDKAppKey @"KJpKMq+6EeGFMRBVrjSCgiia2gavuhHhm6SvQEFkLzs" -> scanRedeem


#define kScanditSDKAppKey @"4w8vXjD2EeOZw8u2pkkjQH4S+hfplxDDtzKnte2lX4s"

@interface HomeVC : UIViewController <ScanditSDKOverlayControllerDelegate, ResumeScanMode, DismissLoginWithValidationDelegate>
{
    NSString *dateString;//not very OO
    NSNotificationCenter *notificationCenter;
    UIButton *scanDeviceBtn, *scanBagBtn;
    UIBarButtonItem *barBtnFinished;
}

@property (strong, nonatomic) NSMutableArray *array;

@property (strong, nonatomic) IBOutlet UITextView *howToUseTV;

@property (strong, nonatomic) NSMutableArray *barcodeArray;
@property (strong, nonatomic) NSMutableArray *depositsArray;
@property BOOL isAdmin;
@property BOOL isUser;
//could be a enum
@property BOOL scanModeIsDevice;

@end
