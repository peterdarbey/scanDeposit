//
//  PopupVCViewController.h
//  ScanDeposits
//
//  Created by Peter Darbey on 11/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupVC : UIViewController
{
    
}

@property(nonatomic,strong) UIView *backgroundView;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UILabel *barcodeString;

@end
