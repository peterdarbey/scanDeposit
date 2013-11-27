//
//  SuccessPopup.m
//  ScanDeposits
//
//  Created by Peter Darbey on 19/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "SuccessPopup.h"
#import "DepositsVC.h"

@interface SuccessPopup ()
{
//    CGPoint offset;
   
}

//Private
@property(nonatomic,strong) UIView *backgroundView;


@end

@implementation SuccessPopup


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)okPressed:(id)sender {

    _confirmed = YES;

    [self dismissPopupAndResumeScanning];

}


-(void)dismissPopupAndResumeScanning {
    
    //complete this first to set HomeVC values for viewWillAppear
    if (_confirmed) {
        //Log the user out and reset --> moved to SuccessPopup --> called
        if ([self.delegate respondsToSelector:@selector(resetDataAndPresentWithFlag:)]) {
            [self.delegate performSelector:@selector(resetDataAndPresentWithFlag:) withObject:@(YES)];
        }
    }//close if

    
    //probably has to be NSNotification here
//    [self notifiyViewControllerWithNotification:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        [self notifiyViewController];//works
    }];

}

//works also
//+(void)showAlertFromNibName:(NSString*)nibName OnView:(UIView*)view {
//    
//    [[SuccessPopup loadFromNibNamed:nibName] showOnView:view];
//}

+ (SuccessPopup *)loadFromNibNamed:(NSString*)nibName {
    
    return [[SuccessPopup alloc] initWithNibName:nibName bundle:nil];//@"SuccessPopup"
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    
}

//Unregister for notifications
- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    //could just call the method here
}

-(void)setupView {
    
    //Create semi-transparent background
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    
    //Button styling
    [self buttonStyle:self.okayBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"OK"];
    
   [self.okayBtn addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
    

}

- (void)notifiyViewController {
    
    //custom delegate method
    if ([self.notDelegate respondsToSelector:@selector(DismissUnderlyingVC)]) {
        [self.notDelegate performSelector:@selector(DismissUnderlyingVC)];
        
    }
    
}

//calls viewDidLoad
//- (void)showOnView:(UIView*)view {
- (void)showOnView:(UIView*)view withTitle:(NSString *)title andMessage:(NSString *)message {

//    self.view.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    
    //moved here as nil in Deposits as not init
    self.titleLbl.text = title;
    self.messageLbl.text = message;
    DLog(@"message in showOnView init: %@ and messageLbl.text: %@", message, self.messageLbl.text);
    
    CGPoint offset = CGPointMake(view.center.x, view.center.y -10);
    self.view.center = offset;
    self.view.layer.cornerRadius = 5.0;
    self.view.layer.borderColor = [UIColor whiteColor].CGColor;
    self.view.layer.borderWidth = 1.5;
   //Add view hierarchy
    [view addSubview:_backgroundView];
    [_backgroundView addSubview:self.view];
    //custom anim
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
                         self.view.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             self.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         }];
                     }];
    
}


//Button styling
- (void)buttonStyle:(UIButton *)button WithImgName:(NSString *)imgName imgSelectedName:(NSString *)selectedName withTitle:(NSString *)title
{
    //button parameters
    UIImage *stretchButon = [[UIImage imageNamed:imgName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button setBackgroundImage:stretchButon forState:UIControlStateNormal];
    UIImage *stretchSelectedButton = [[UIImage imageNamed:selectedName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button setBackgroundImage:stretchSelectedButton forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

@end
