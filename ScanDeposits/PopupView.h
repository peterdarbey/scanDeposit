//
//  PopupView.h
//  ScanDeposits
//
//  Created by Peter Darbey on 10/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView
{
    
}

@property(nonatomic,strong) UIView *backgroundView;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIView *alertView;

-(void)showOnView:(UIView*)view;
-(void)setupView;

@end
