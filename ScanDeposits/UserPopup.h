//
//  UserPopup.h
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopUpTV;
@class User;
@class UserVC;

@class UserPopup;

@protocol UserModelDelegate <NSObject>

- (void)returnUserModel:(User *)user;
- (void)refreshView;

@end

@interface UserPopup : UIView <UITextFieldDelegate>
{
    NSMutableArray *stringArray;
}

-(void)showOnView:(UIView*)view;

+(UserPopup *)loadFromNibNamed:(NSString*)nibName;

//custom delegate ivar
@property (weak, nonatomic) id<UserModelDelegate> userDelegate;

@property (weak, nonatomic) IBOutlet UIView *zoneBackground;
@property (strong, nonatomic) IBOutlet UIView *popupView;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
//@property (strong, nonatomic) IBOutlet UIImageView *imagePlaceHolder;
@property (strong, nonatomic) PopUpTV *popupTV;

@end

