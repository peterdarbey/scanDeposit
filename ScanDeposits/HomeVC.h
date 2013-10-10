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


#define kScanditSDKAppKey @"gJ9KL2dapvcyJ9iaR442wIX_s4iCsOemFpOo5ZehUC4"

@interface HomeVC : UIViewController <ScanditSDKOverlayControllerDelegate>

@end
