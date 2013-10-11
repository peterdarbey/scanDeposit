//
//  PopupAV.m
//  ScanDeposits
//
//  Created by Peter Darbey on 11/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "PopupAV.h"

@implementation PopupAV

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//       
//        
//    }
//    return self;
//}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];//test
//    [self showOnView:_backgroundView];
}

-(void)setupView {
    
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.0]];//correct
   
    [_backgroundView setCenter:self.view.center];//correct
//    [_backgroundView addSubview:_bgView];
    [self.view addSubview:_backgroundView];
//    [_backgroundView bringSubviewToFront:self.view];
    
//    [_backgroundView addSubview:self.view];//No
//    [self.view insertSubview:_backgroundView aboveSubview:self.view];
    
    [self buttonStyle:_cancelBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Cancel"];
    
    [_cancelBtn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self buttonStyle:_saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Save"];
    
    
}

-(void)cancelPressed:(UIButton *)sender {
    
    DLog(@"Cancel Pressed");
}

-(void)showOnView:(UIView*)view {
//    [self setupView];
    
    self.view.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    self.view.center = view.center;//picker.view.center-correct
    
   
//    [_backgroundView addSubview:self.view];
     [view addSubview:self.view];
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_backgroundView setBackgroundColor:[[UIColor blueColor] colorWithAlphaComponent:0.5]];
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

@end
