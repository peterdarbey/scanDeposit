//
//  BagBCPopup.h
//  ScanDeposits
//
//  Created by Peter Darbey on 14/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol ResumeScanningModeDelegate <NSObject>

- (void)startScanningWithScanMode:(NSNumber *)mode;

@end


@interface QRPopup : UIView
{
    
    
}

-(void)showOnView:(UIView*)view;

+(QRPopup *)loadFromNibNamed:(NSString*)nibName;



//conditional test for init custom deposit model object
@property BOOL confirmed;//ivar so is NO by default

//delegate property
@property (weak, nonatomic) id <ResumeScanningModeDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *branchLbl;

@property (strong, nonatomic) IBOutlet UILabel *processLbl;
@property (strong, nonatomic) IBOutlet UILabel *safeIDLbl;


@property (weak, nonatomic) IBOutlet UIButton *proceedBtn;

@property (strong, nonatomic) IBOutlet UIImageView *imagePlaceHolder;

@end
