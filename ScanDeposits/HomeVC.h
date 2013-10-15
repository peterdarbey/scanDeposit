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
#import "Barcode.h"
#import "DepositsVC.h"

#import "AlertView.h"


#define kScanditSDKAppKey @"4w8vXjD2EeOZw8u2pkkjQH4S+hfplxDDtzKnte2lX4s"

@interface HomeVC : UIViewController <ScanditSDKOverlayControllerDelegate, ResumeScanMode>
{
    
}

@property (strong, nonatomic) NSMutableArray *barcodeArray;
@end
