//
//  SubmitVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 18/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "SubmitVC.h"

@interface SubmitVC ()
{
    
}

@end

@implementation SubmitVC
{
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
-(void)resetPressed:(UIButton *)sender {
    
    DLog(@"Reset Pressed");
    //clear appDelegate.bagCount 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonStyle:resetBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"RESET"];

//    resetBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    [resetBtn.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [resetBtn setFrame:CGRectMake(20, self.view.frame.size.height -60, 280, 44)];
    [resetBtn addTarget:self action:@selector(resetPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetBtn];
}
//- (UIButton *)setupButtonAndAction:(UIButton *)button {
//    
//    [self buttonStyle:button WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"RESET"];
//    [button.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
//    [button setFrame:CGRectMake(20, self.view.frame.size.height -60, 280, 44)];
//    [button addTarget:self action:@selector(resetPressed:) forControlEvents:UIControlEventTouchUpInside];
////    [self.view addSubview:button];
//    return button;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
