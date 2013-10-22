//
//  UserPopup.h
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PopupTV.h"

@interface UserPopup : UIView <UITextFieldDelegate>
{
    NSMutableArray *stringArray;
}

-(void)showOnView:(UIView*)view;

+(UserPopup *)loadFromNibNamed:(NSString*)nibName;


@property (weak, nonatomic) IBOutlet UIView *zoneBackground;
@property (strong, nonatomic) IBOutlet UIView *popupView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
//@property (strong, nonatomic) IBOutlet UIImageView *imagePlaceHolder;
@property (strong, nonatomic) PopUpTV *popupTV;

@end

