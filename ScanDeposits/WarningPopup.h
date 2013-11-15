//
//  WarningPopup.h
//  ScanDeposits
//
//  Created by Peter Darbey on 15/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ResumeScanDelegate <NSObject>

- (void)resumeScanning;

@end

@interface WarningPopup :UIView


- (void)showOnView:(UIView*)view;

+ (WarningPopup *)loadFromNibNamed:(NSString*)nibName;

@property (weak, nonatomic) id <ResumeScanDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UILabel *messageLbl;

@property (strong, nonatomic) IBOutlet UIButton *okBtn;
@property BOOL confirmed;

@end
