//
//  WarningPopup.m
//  ScanDeposits
//
//  Created by Peter Darbey on 15/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "WarningPopup.h"

@interface WarningPopup ()
{
    
}
//Private
@property(nonatomic,strong) UIView *backgroundView;

@end



@implementation WarningPopup

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        //custom init here
    }
    return self;
}

-(void)setupView {
    
    //Create semi-transparent background
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    
    
    //Button styling
    
    [self buttonStyle:_okBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"OK"];
    [_okBtn addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)okPressed:(UIButton *)sender {
    
    _confirmed = YES;
    
    [self dismissPopupAndResumeScanning];
}

-(void)dismissPopupAndResumeScanning {
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        
        //only executed if user presses ok
        
        if (_confirmed) {
        
            if ([self.delegate respondsToSelector:@selector(resumeScanning)]) {
                [self.delegate performSelector:@selector(resumeScanning)];
            }//close if

        }//close if
        
    }];
    
}

+ (WarningPopup *)loadFromNibNamed:(NSString*)nibName {
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    WarningPopup *view = [xib objectAtIndex:0];
    return view;
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

- (void)showOnView:(UIView*)view {
    [self setupView];
    
    self.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    CGPoint offset = CGPointMake(view.center.x, view.center.y -22);//nav bar
//    self.center = view.center;//pass picker.view.center to view
    self.center = offset;
    self.layer.cornerRadius = 5.0;
//    self.layer.borderColor = [UIColor colorWithRed:212.0/255.0 green:0.0/255.0 blue:20.0/255.5 alpha:0.5].CGColor;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.5;
    
    
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
