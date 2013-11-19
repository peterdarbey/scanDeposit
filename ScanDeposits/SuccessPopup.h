//
//  SuccessPopup.h
//  ScanDeposits
//
//  Created by Peter Darbey on 19/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuccessPopup : UIView
{
    
}

- (void)showOnView:(UIView*)view;

+ (SuccessPopup *)loadFromNibNamed:(NSString*)nibName;

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *messageLbl;

@property (strong, nonatomic) IBOutlet UIButton *okBtn;

@property BOOL confirmed;

@end
