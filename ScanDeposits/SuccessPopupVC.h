//
//  SuccessPopupVC.h
//  ScanDeposits
//
//  Created by Peter Darbey on 20/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessPopupVC : UIViewController
{
    
}

@property (strong, nonatomic) IBOutlet UIView *bckGrView;

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;

@property (strong, nonatomic) IBOutlet UIButton *okBtn;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(void)setupView;
- (void)showOnView:(UIView*)view;

@end
