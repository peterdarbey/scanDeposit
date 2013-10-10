//
//  PopupView.m
//  ScanDeposits
//
//  Created by Peter Darbey on 10/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self buttonStyle:_cancelBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Cancel"];
//        
//        [self buttonStyle:_saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Save"];
    }
    return self;
}

-(void)setupView {
    
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];//correct
    
    UIView *bgStretchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 100)];
    bgStretchView.backgroundColor = [UIColor whiteColor];

    [self insertSubview:bgStretchView atIndex:0];
    
//    [self insertSubview:bgStretchView aboveSubview:_alertView];//nope
//    [self.alertView addSubview:bgStretchView];

    [self buttonStyle:_cancelBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Cancel"];
    
    [self buttonStyle:_saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Save"];
    
    
}

-(void)showOnView:(UIView*)view {
    [self setupView];
    
    self.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    
    self.center = view.center;
    
    [view addSubview:_backgroundView];
    [_backgroundView addSubview:self];
    
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
