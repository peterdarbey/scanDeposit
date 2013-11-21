//
//  SuccessPopup.h
//  ScanDeposits
//
//  Created by Peter Darbey on 19/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SuccessPopup;

@protocol ResetAndPresentDelegate <NSObject>

- (void)resetDataAndPresentLogInVC;

@end

@interface SuccessPopup : UIViewController
{
    
}


- (void)showOnView:(UIView*)view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
+ (SuccessPopup *)loadFromNibNamed:(NSString*)nibName;

//custom delegate
@property (weak, nonatomic) id <ResetAndPresentDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *messageLbl;
@property (strong, nonatomic) IBOutlet UIView *bckGrdView;

@property (strong, nonatomic) IBOutlet UIButton *okBtn;


@property BOOL confirmed;

@end
