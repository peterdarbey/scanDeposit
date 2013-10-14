//
//  InputFundsView.h
//  ScanDeposits
//
//  Created by Peter Darbey on 14/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputFundsView : UIView

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) IBOutlet UIButton *confirmBtn;

@property (strong, nonatomic) IBOutlet UITextField *fiftyTF;
@property (strong, nonatomic) IBOutlet UITextField *twentyTF;
@property (strong, nonatomic) IBOutlet UITextField *tenTF;
@property (strong, nonatomic) IBOutlet UITextField *fiveTF;
@property (strong, nonatomic) IBOutlet UITextField *totalTF;

@property (strong, nonatomic) IBOutlet UIImageView *backgrdIV;

-(void)showOnView:(UIView*)view;

+(InputFundsView*)loadFromNibNamed:(NSString*)nibName;

@end
