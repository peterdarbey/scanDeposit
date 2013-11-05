//
//  ComposeEmailVCViewController.m
//  ScanDeposits
//
//  Created by Peter Darbey on 05/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "ComposeEmailVC.h"

@interface ComposeEmailVC ()

@end

@implementation ComposeEmailVC

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
	
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
    
    
}
//email button pressed
- (void)donePressed:(UIButton *)sender {
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
