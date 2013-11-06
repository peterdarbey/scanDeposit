//
//  LogInVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 06/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "LogInVC.h"

@interface LogInVC ()

@end

@implementation LogInVC
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

- (void)donePressed:(UIButton *)sender {
    
    
}

- (void)loginPressed:(UIButton *)sender {
    
    //enable if the users creds yield YES
    [doneBtn setEnabled:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //for now
    [_loginTV setBackgroundColor:[UIColor whiteColor]];
    //set delegates
    [_loginTV setDataSource:self];
    [_loginTV setDelegate:self];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    
    [self.navigationItem setRightBarButtonItem:doneBtn];
    //disable doneBtn on launch only enable when the user creds yield true
    [doneBtn setEnabled:NO];
    
    //Construct a imageView
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
//    [self.view addSubview:imgView];//for the moment
    [_loginTV setBackgroundView:imgView];
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;//static
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //if the last section make two rows
    if (section == [_loginTV numberOfSections] -1) {
        return 1;//was 2
    }
    else
    {
        return 1;
    }
    
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //if the last section
    if (section == [_loginTV numberOfSections] -1) {
        
        return 20;
    }
    //middle section
    else if (section != 0) {
        
        return 5;//for now
    }
    else //1st section
    {
        return 100;
    }
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    //if the last section
    if (section == [_loginTV numberOfSections] -1) {
        
        return 90;
    }
    //middle section
    else if (section != 0) {
        
        return 5;//for now
    }

    else //1st section
    {
        return 40;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    //if the last section
    if (section == [_loginTV numberOfSections] -1) {
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _loginTV.frame.size.width, 90)];
        [aView setBackgroundColor:[UIColor clearColor]];
        
        
        //maybe add to the tableView section
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self buttonStyle:loginBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Log In"];
        
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [loginBtn setFrame:CGRectMake(10, 23, 300, 44)];
        [loginBtn addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
        //add to view
        [aView addSubview:loginBtn];
        
        return aView;
    }
    else
    {
        return nil;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"loginCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    UITextField *cellTF;
    UILabel *cellLabel;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        
        cellTF = [[UITextField alloc]initWithFrame:CGRectMake(115, cell.bounds.size.height/4, 175, 25)];
        [cellTF setBackgroundColor:[UIColor clearColor]];
        cellTF.tag = TEXTFIELD_TAG;
        cellTF.textAlignment = NSTextAlignmentLeft;
        cellTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [cellTF setFont:[UIFont systemFontOfSize:15.0]];
        cellTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        
        [cellTF setUserInteractionEnabled:YES];
        [cellTF setEnablesReturnKeyAutomatically:YES];
        //set textField delegate
        [cellTF setDelegate:self];
        
        //Add TF to cell
        [cell.contentView addSubview:cellTF];
        
        cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 95 , 25)];
        cellLabel.tag = LABEL_TAG;
        cellLabel.textAlignment = NSTextAlignmentLeft;
        cellLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
        cellLabel.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        cellLabel.shadowColor = [UIColor grayColor];
        cellLabel.shadowOffset = CGSizeMake(1.0, 1.0);
        cellLabel.backgroundColor = [UIColor clearColor];
        [cellLabel setUserInteractionEnabled:NO];
        
        //Add Label to cell
        [cell.contentView addSubview:cellLabel];
        
    }
    
    else
    {
        cellTF = (UITextField *)[cell.contentView viewWithTag:TEXTFIELD_TAG];
        cellLabel = (UILabel *)[cell.contentView viewWithTag:LABEL_TAG];
    }
    
    //populate the cells textField and Label with data here
    [cellTF setPlaceholder:@"Enter your ID"];
    cellLabel.text = @"Password";
    
    
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
