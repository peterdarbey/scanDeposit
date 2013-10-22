//
//  UserPopup.h
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPopup : UIView <UITextFieldDelegate>
{
    NSMutableArray *stringArray;
}

-(void)showOnView:(UIView*)view;

+(UserPopup *)loadFromNibNamed:(NSString*)nibName;

@property (strong, nonatomic) IBOutlet UITextField *nameTF;

@property (strong, nonatomic) IBOutlet UITextField *emailTF;

@property (strong, nonatomic) IBOutlet UITextField *staffIDTF;

@property (weak, nonatomic) IBOutlet UIView *zoneBackground;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
//@property (strong, nonatomic) IBOutlet UIImageView *imagePlaceHolder;

@end

