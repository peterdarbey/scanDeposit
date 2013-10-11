//
//  PopupVCViewController.m
//  ScanDeposits
//
//  Created by Peter Darbey on 11/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "PopupVC.h"

@interface PopupVC ()

@end

@implementation PopupVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)setupView {
    
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];//correct
    
    [self buttonStyle:_cancelBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Cancel"];
    
    [self buttonStyle:_saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Save"];
    
    
}

-(void)showOnView:(UIView*)view {
    [self setupView];
    
    self.view.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    
    self.view.center = view.center;
    
    [view addSubview:_backgroundView];
    [_backgroundView addSubview:self.view];
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
