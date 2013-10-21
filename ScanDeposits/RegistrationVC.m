//
//  RegistrationVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 21/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "RegistrationVC.h"

@interface RegistrationVC ()

@end

@implementation RegistrationVC

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
#pragma Delegate textField methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@"Name"]) {
        DLog(@"Name textField");
//        UITextField *nextTF = (UITextField *)
        //next textField
//        [textField becomeFirstResponder];
    }
    else if ([textField.text isEqualToString:@"Email"])
    {
        
    }
    else
    {
        
        [textField resignFirstResponder];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    
     [_registerTV setBackgroundColor:[UIColor clearColor]];
     [_registerTV setBackgroundView:[[UIImageView alloc]initWithImage:
                                     [UIImage imageNamed:@"Default-568h.png"]]];
    //set delegate to self
    [_registerTV setDelegate:self];
    [_registerTV setDataSource:self];
    
//    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
//    [self.navigationController.navigationItem setRightBarButtonItem:doneBtn];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
    
}

- (void)donePressed:(UIButton *)sender {
    
    DLog(@"Done Pressed");
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //ToDo add saving functionality here
    }];
}
- (void)savePressed:(UIButton *)sender {
    //ToDo implement NSUserDefaults
//    DLog(@"savePressed");
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //ToDo add saving functionality here
    }];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {// && ADMIN) {
        //+44 for navigation bar
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _registerTV.frame.size.width, 180)];//130
        [topView setBackgroundColor:[UIColor clearColor]];
        
        //construct an innerView for the admin section
        UIView *innerView = [[UIView alloc]initWithFrame:CGRectMake(10, 77, _registerTV.frame.size.width -20, 80)];
        [innerView setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];//dark white;
        innerView.layer.cornerRadius = 5.0;
        
        //construct a UILabel for the Admin section
        UILabel *adminLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 51.5, 110, 25)];
        [adminLbl setText:@"Adminstrator"];
        [adminLbl setFont:[UIFont fontWithName:@"Helvetica" size:17]];//check spelling
        [adminLbl setTextColor:[UIColor blackColor]];
        [adminLbl setBackgroundColor:[UIColor clearColor]];
        adminLbl.shadowColor = [UIColor grayColor];
        adminLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        [topView addSubview:adminLbl];
        
        
        //construct a UILabel for text
        UILabel *branchNSCLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 25)];
        [branchNSCLbl setBackgroundColor:[UIColor clearColor]];
        [branchNSCLbl setFont:[UIFont systemFontOfSize:17]];
        branchNSCLbl.textAlignment = NSTextAlignmentLeft;
        branchNSCLbl.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        branchNSCLbl.shadowColor = [UIColor whiteColor];
        branchNSCLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        [branchNSCLbl setText:[NSString stringWithFormat:@"Branch NSC"]];
        
        [branchNSCLbl setUserInteractionEnabled:NO];
        //add to view
        [innerView addSubview:branchNSCLbl];
        
        
        //Construct another label for amount
        UILabel *offCounterLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 120, 25)];
        offCounterLbl.textAlignment = NSTextAlignmentLeft;
        [offCounterLbl setFont:[UIFont systemFontOfSize:17]];
        offCounterLbl.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        offCounterLbl.shadowColor = [UIColor whiteColor];
        offCounterLbl.shadowOffset = CGSizeMake(1.0, 1.0);//better
        offCounterLbl.backgroundColor = [UIColor clearColor];
        [offCounterLbl setUserInteractionEnabled:NO];
        //retrieve the total bag amount from the class method here
        [offCounterLbl setText:[NSString stringWithFormat:@"Off-Counter"]];
        //add to innerView
        [innerView addSubview:offCounterLbl];
        
        
        //construct a UITextField for branch NSC
        UITextField *branchNSCTF = [[UITextField alloc]initWithFrame:CGRectMake(120, 10, 180, 25)];
        [branchNSCTF setBackgroundColor:[UIColor clearColor]];
        [branchNSCTF setDelegate:self];
        [branchNSCTF setFont:[UIFont systemFontOfSize:17]];
        branchNSCTF.textAlignment = NSTextAlignmentLeft;
        branchNSCTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        [branchNSCTF setUserInteractionEnabled:NO];
        [branchNSCTF setText:[NSString stringWithFormat:@"Branch Value"]];//pop dynamically
        
        //add to view
        [innerView addSubview:branchNSCTF];
        
        //construct a 2nd TextField
        UITextField *offCounterTF = [[UITextField alloc]initWithFrame:CGRectMake(120, 45, 180, 25)];
        [offCounterTF setBackgroundColor:[UIColor clearColor]];
        [offCounterTF setDelegate:self];
        [offCounterTF setFont:[UIFont systemFontOfSize:17]];
        offCounterTF.textAlignment = NSTextAlignmentLeft;
        offCounterTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        [offCounterTF setUserInteractionEnabled:NO];
        [offCounterTF setText:[NSString stringWithFormat:@"Counter Value"]];//pop dynamically
        
        //add to view
        [innerView addSubview:offCounterTF];
        
        //add to UIView hierarchy
        [topView addSubview:innerView];
        
        return topView;
        
    }//close if
    
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
//        return 130;//+44
        return 180;
    }
    else
    {
        return 10;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    if (section == [_registerTV numberOfSections] -1)
    {
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _registerTV.frame.size.width, 90)];
        [bottomView setBackgroundColor:[UIColor clearColor]];
        
        //construct a button to save user details in NSUserDefaults
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setFrame:CGRectMake(10, 23, 300, 44)];
        [saveBtn setUserInteractionEnabled:YES];
        [saveBtn addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self buttonStyle:saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"SAVE"];
        
        //add to parent view
        [bottomView addSubview:saveBtn];
        return bottomView;
    }
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section== [_registerTV numberOfSections] -1) {
        return 90.0;
    }
    else
    {
        return 10.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"regCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    UITextField *nameTF;
    UILabel *userLbl;
    UILabel *prePopLbl;
    
    //ist time through doesnt exist
    if (cell == nil) {
        
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        
        nameTF = [[UITextField alloc]initWithFrame:CGRectMake(80, cell.bounds.size.height/4, 210, 25)];
        [nameTF setBackgroundColor:[UIColor clearColor]];
        nameTF.tag = NAME_TF;
        nameTF.textAlignment = NSTextAlignmentLeft;
        nameTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [nameTF setFont:[UIFont systemFontOfSize:17.0]];
        nameTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        [nameTF setUserInteractionEnabled:NO];
        
        [cell.contentView addSubview:nameTF];
        
        //Construct Label
        userLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 70 , 25)];
        userLbl.tag = USER_LBL;
        userLbl.textAlignment = NSTextAlignmentLeft;
        userLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        userLbl.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        userLbl.shadowColor = [UIColor grayColor];
        userLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        userLbl.backgroundColor = [UIColor clearColor];
        [userLbl setUserInteractionEnabled:NO];
        
        [cell.contentView addSubview:userLbl];
        
        //construct prePop label
        prePopLbl = [[UILabel alloc]initWithFrame:CGRectMake(230, cell.bounds.size.height/4, 60, 25)];
        prePopLbl.tag = EMAIL_PREPOP;
        prePopLbl.textAlignment = NSTextAlignmentRight;
        prePopLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        prePopLbl.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        prePopLbl.shadowColor = [UIColor grayColor];
        prePopLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        prePopLbl.backgroundColor = [UIColor clearColor];
        [prePopLbl setUserInteractionEnabled:NO];
        [prePopLbl setText:AIB];//"@aib.ie"

    }
    else
    {
        //retreive the properties
        nameTF = (UITextField *)[cell.contentView viewWithTag:NAME_TF];
//        prePopLbl = (UILabel *)[cell.contentView viewWithTag:EMAIL_PREPOP];
        userLbl = (UILabel *)[cell.contentView viewWithTag:USER_LBL];
        
    }
    
//        [nameTF setText:[NSString stringWithFormat:@"David Roberts"]];
    
    if (indexPath.row == 0) {
        [userLbl setText:@"Name"];
        [nameTF setText:[NSString stringWithFormat:@"David Roberts"]];//temp will be dynamic
    }
    else if (indexPath.row == 1)
    {
        [userLbl setText:@"Email"];//temp will be dynamic
        [nameTF setText:[NSString stringWithFormat:@"david.h.roberts"]];//hard code here
        //show label with email perfix
        [cell.contentView addSubview:prePopLbl];
        
    }
    else
    {
        [userLbl setText:@"Staff ID"];//temp will be dynamic
        [nameTF setText:[NSString stringWithFormat:@"Adminstrator"]];//hard code here
    }
    
    
        return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    return [_depositsCollection count];
    return 1;//minimum of 1
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3; //should be 2 for the moment
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIP = indexPath;
    [_registerTV deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
