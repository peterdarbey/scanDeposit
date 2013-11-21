//
//  SuccessPopup.m
//  ScanDeposits
//
//  Created by Peter Darbey on 19/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "SuccessPopup.h"

@interface SuccessPopup ()
{
//    CGPoint offset;
    UIButton *myBtn;
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

-(void)okPressed:(UIButton *)sender {
    
    _confirmed = YES;
    
    [self dismissPopupAndResumeScanning];
}

-(void)dismissPopupAndResumeScanning {
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        
        if (_confirmed) {
            DLog(@"self.delegate: %@", self.delegate);
            //Log the user out and reset --> moved to SuccessPopup --> called
            if ([self.delegate respondsToSelector:@selector(resetDataAndPresentLogInVC)]) {
                [self.delegate performSelector:@selector(resetDataAndPresentLogInVC)];//doesnt respond to delegate
            }
            [self.navigationController popToRootViewControllerAnimated:YES];//add delay perhaps
        }//close if
        
    }];
    
}

+ (SuccessPopup *)loadFromNibNamed:(NSString*)nibName {
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    SuccessPopup *view = [xib objectAtIndex:0];
    return view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    DLog(@"viewDidLoad");
    
    [self setupView];
    
}

-(void)setupView {
    
    //Create semi-transparent background
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    DLog(@"_bckGrView in setupView: %@", _bckGrdView);//correct --> (0, 0, 260, 175) self.view is the _bckGrdView
    
//    //Button styling
    [self buttonStyle:self.okBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"OK"];
//    [self.okBtn addTarget:self action:@selector(okPressed:) forControlEvents:UIControlEventTouchUpInside];
   
}


- (void)showOnView:(UIView*)view {

    DLog(@"showOnView");
    
//    self.view.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    CGPoint offset = CGPointMake(view.center.x, view.center.y -10);
    self.view.center = offset;//correct
    self.view.layer.cornerRadius = 5.0;
    self.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.view.layer.borderWidth = 1.0;
   
    [view addSubview:_backgroundView];
    [_backgroundView addSubview:self.view];//Add self to _backgroundView --> (30, 156.5, 260, 175);correct
    
    
    
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
