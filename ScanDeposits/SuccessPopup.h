//
//  SuccessPopup.h
//  ScanDeposits
//
//  Created by Peter Darbey on 19/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DepositsVC;

@class SuccessPopup;

@protocol ResetAndPresentDelegate <NSObject>

- (void)resetDataAndPresentWithFlag:(NSNumber *)shouldDismiss;

@end


//test
@protocol NotificationDelegate <NSObject>

- (void)NotificationOfButtonPressed:(NSNotification *)notification;

@end


@interface SuccessPopup : UIViewController
{
    NSNotificationCenter *defaultCenter;
}


- (void)okPressed:(id)sender;

- (void)showOnView:(UIView*)view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;

+ (SuccessPopup *)loadFromNibNamed:(NSString*)nibName;

//custom delegate
@property (weak, nonatomic) id <ResetAndPresentDelegate> delegate;
//test
@property (weak, nonatomic) id <NotificationDelegate> notDelegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *messageLbl;

@property (strong, nonatomic) IBOutlet UIButton *okayBtn;

@property BOOL confirmed;
@property BOOL buttonPressed;

@end
