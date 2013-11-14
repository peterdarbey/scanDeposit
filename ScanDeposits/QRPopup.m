//
//  BagBCPopup.m
//  ScanDeposits
//
//  Created by Peter Darbey on 14/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "QRPopup.h"

@interface QRPopup ()
{
    
    
}

//Private
@property(nonatomic,strong) UIView *backgroundView;

@end



@implementation QRPopup


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init here
        
    }
    
    return self;
}

-(void)setupView {
    
    
    //Create semi-transparent background
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
   
    
    [self buttonStyle:_proceedBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"Proceed"];
    [_proceedBtn addTarget:self action:@selector(proceedPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)dismissPopupAndResumeScanning {
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        
//        //only executed if user presses confirm
//        if (_confirmed) {
//            
//            //Init custom model object and add to collection before passing to delegate
//            Deposit *deposit = [self createDepositModelObject];
//            //call this delegate method from HomeVC if _confirmPressed
//            if ([self.delegate respondsToSelector:@selector(passScannedData:)]) {
//                [self.delegate performSelector:@selector(passScannedData:) withObject:deposit];
//            }
//            
//        }//close if
//        
        //dismissed popup and resume scanning mode and save barcode data if applicable
        if ([self.delegate respondsToSelector:@selector(startScanningWithScanMode:)]) {
            [self.delegate performSelector:@selector(startScanningWithScanMode:) withObject:@(NO)];
            DLog(@"Delegate performSelector for QRPopup");
        }
        
    }];
    
}

//proceedBtn
-(void)proceedPressed:(UIButton *)sender {
    
    _confirmed = YES;
    [self dismissPopupAndResumeScanning];
    //need a custom delegate method here to pass a BOOL to set the _scanIsDeviceModel to YES to 2/5 interleaved if its YES and if NO _scanIsDeviceModel is not set to NO
    //ToDo delegate method ........
    
}

+(QRPopup *)loadFromNibNamed:(NSString*)nibName {
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    QRPopup *view = [xib objectAtIndex:0];
    return view;
}

//Button styling
-(void)buttonStyle:(UIButton *)button WithImgName:(NSString *)imgName imgSelectedName:(NSString *)selectedName withTitle:(NSString *)title
{
    //button parameters
    UIImage *stretchButon = [[UIImage imageNamed:imgName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button setBackgroundImage:stretchButon forState:UIControlStateNormal];
    UIImage *stretchSelectedButton = [[UIImage imageNamed:selectedName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button setBackgroundImage:stretchSelectedButton forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

-(void)showOnView:(UIView*)view {
    [self setupView];
    
    self.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    CGPoint offset = CGPointMake(view.center.x, view.center.y -20);
    //    self.center = view.center;//pass picker.view.center to view
    self.center = offset;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    
    [view addSubview:_backgroundView];
    [_backgroundView addSubview:self];//Need to add self to background
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
                         self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         }];
                     }];
}




@end
