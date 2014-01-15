//
//  SuccessPopupVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 20/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "SuccessPopupVC.h"

@interface SuccessPopupVC ()
{
    CGPoint offset;
}

//Private
@property(nonatomic,strong) UIView *backgroundView;

@end

@implementation SuccessPopupVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    
}

-(void)setupView {
    
    //Button styling
    [self buttonStyle:_okBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"OK"];
    [_okBtn addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_bckGrView addSubview:_okBtn];
    
    //Create semi-transparent background
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    
    _bckGrView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    DLog(@"offsetX: %f and Y: %f", offset.x, offset.y);//(160, 252)
    _bckGrView.center = offset;
    _bckGrView.layer.cornerRadius = 5.0;
    _bckGrView.layer.borderColor = [UIColor whiteColor].CGColor;
    _bckGrView.layer.borderWidth = 1.5;
    
    [_backgroundView addSubview:_bckGrView];
    self.view = _backgroundView;

}

- (void)showOnView:(UIView*)view {
//    [self setupView];
        offset = CGPointMake(view.center.x, view.center.y -22);
        
    //calls viewDidLoad when added to the view hierarchy
    [view addSubview:self.view];//Add self to the DepositsVC view hierarchy
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
                         _bckGrView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             _bckGrView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         }];
                     }];
}

- (void)okPressed:(UIButton *)sender {
    
    _confirmed = YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
