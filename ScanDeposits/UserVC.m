//
//  UserVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "UserVC.h"

@interface UserVC ()
{
    
}

@end

@implementation UserVC

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
    
    [textField resignFirstResponder];
    
    return YES;
}
- (UITextField *)returnNextTextField:(UITextField *)textField {
    //retrieve the cell that contains the textField
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [_userTV indexPathForCell:cell];
    
    //increment the indexPath.row to retrieve the next cell which contains the next textField
    cell = (UITableViewCell *)[_userTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row +1 inSection:indexPath.section]];
    //the next TextField
    UITextField *nextTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];
    return nextTF;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //for conditional
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [_userTV indexPathForCell:cell];
    
    UITextField *nextTF;
    
    //textField superview corresponds to
    if (indexPath.row == 0) {
        //if TF is not empty resign/assign
        if (![textField.text isEqualToString:@""] && [textField.text length] > 1) {
            DLog(@"Name textField");
            [textField resignFirstResponder];//resign 1st
            //assign text to user ivar
            
            //next TextField
            nextTF = [self returnNextTextField:textField];
            [nextTF becomeFirstResponder];
        }//close inner if
        else
        {
            //possibly display error message
            [textField becomeFirstResponder];
        }
        
    }
    else if (indexPath.row == 1) {
        //if TF is not empty resign/assign
        if (![textField.text isEqualToString:@""] && [textField.text length] > 1) {
            //resign previous responder status
            [textField resignFirstResponder];
            nextTF = [self returnNextTextField:textField];
            [nextTF becomeFirstResponder];
        }//close inner if
        else
        {
            [textField becomeFirstResponder];
        }
            
    }
    else
    {   //pass code 6 digits
        if (![textField.text isEqualToString:@""] && [textField.text length] >= 6) {
            //resign previous responder status
            [textField resignFirstResponder];
        }//close inner if
        else
        {
            [textField becomeFirstResponder];
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //Set delegate to self
    [_userTV setDataSource:self];
    [_userTV setDelegate:self];
    
    [_userTV setBackgroundColor:[UIColor clearColor]];
    [_userTV setBackgroundView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default-568h.png"]]];
    
    //init userCollection
    _userArray = [NSMutableArray arrayWithCapacity:1];//always at least 1 user to use app
    
    
}

- (void)addUserPressed:(UIButton *)sender {
    DLog(@"Add Another pressed");
    //ToDO bring up a xib view
    
}
#pragma tableView presentation methods
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    if (section == 0) {// && ADMIN) {
//        //+44 for navigation bar
//        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _userTV.frame.size.width, 80)];//130
//        [topView setBackgroundColor:[UIColor greenColor]];
//        
//        //construct a UILabel for the Admin section
//        UILabel *userLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10.5, 110, 25)];
//        [userLbl setText:@"User Details"];
//        [userLbl setFont:[UIFont fontWithName:@"Helvetica" size:17]];
//        [userLbl setTextColor:[UIColor blackColor]];
//        [userLbl setBackgroundColor:[UIColor clearColor]];
//        userLbl.shadowColor = [UIColor grayColor];
//        userLbl.shadowOffset = CGSizeMake(1.0, 1.0);
//        [topView addSubview:userLbl];
//
//        return topView;
//        
//    }//close if
//    
//    else 
//    {
//        return nil;
//    }
//    
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *titleName = [NSString stringWithFormat:@"User Details"];
    return titleName;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 84;
    }
    else
    {
        return 20;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    if (section == [_userTV numberOfSections] -1)
    {
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _userTV.frame.size.width, 90)];
        [bottomView setBackgroundColor:[UIColor clearColor]];
        
        //construct a button to save user details in NSUserDefaults
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setFrame:CGRectMake(10, 23, 300, 44)];
        [saveBtn setUserInteractionEnabled:YES];
        [saveBtn addTarget:self action:@selector(addUserPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self buttonStyle:saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"ADD MORE USERS"];
        
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
    
    if (section== [_userTV numberOfSections] -1) {
        return 90.0;
    }
    else
    {
        return 10.0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"userCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    //properties
    UITextField *userNameTF;
    UILabel *userNameLbl;
   
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        
        userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(90, cell.bounds.size.height/4, 200, 25)];
        [userNameTF setBackgroundColor:[UIColor clearColor]];
        userNameTF.tag = USER_NAME_TF;
        userNameTF.textAlignment = NSTextAlignmentLeft;
        userNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//thats the 1
        [userNameTF setFont:[UIFont systemFontOfSize:15.0]];
        userNameTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        [userNameTF setUserInteractionEnabled:YES];
        
        //set textField delegate
        [userNameTF setDelegate:self];
        //Add TF to cell
        [cell.contentView addSubview:userNameTF];
        
        userNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 70 , 25)];
        userNameLbl.tag = USER_NAME_LBL;
        userNameLbl.textAlignment = NSTextAlignmentLeft;
        userNameLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
        userNameLbl.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        userNameLbl.shadowColor = [UIColor grayColor];
        userNameLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        userNameLbl.backgroundColor = [UIColor clearColor];
        [userNameLbl setUserInteractionEnabled:NO];
        
        [cell.contentView addSubview:userNameLbl];
        
        
    }
    else
    {   //retreive the properties
        userNameTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];
        userNameLbl = (UILabel *)[cell.contentView viewWithTag:USER_NAME_LBL];
    }
    
    if (indexPath.row == 0) {
        [userNameTF setText:[NSString stringWithFormat:@"David Roberts"]];//temp will be dynamic
        [userNameLbl setText:@"Name"];
        //set keyboard type
        [userNameTF setKeyboardType:UIKeyboardTypeDefault];
        [userNameTF setReturnKeyType:UIReturnKeyNext];
        [userNameTF enablesReturnKeyAutomatically];
        [userNameTF setClearsOnBeginEditing:YES];
        [userNameTF setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [userNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    else if (indexPath.row == 1)
    {
        [userNameTF setText:[NSString stringWithFormat:@"david.h.roberts"]];//hard code here
        [userNameLbl setText:@"Email"];//temp will be dynamic
        //set keyboard type
        [userNameTF setKeyboardType:UIKeyboardTypeEmailAddress];
        [userNameTF setReturnKeyType:UIReturnKeyNext];
        [userNameTF enablesReturnKeyAutomatically];
        [userNameTF setClearsOnBeginEditing:YES];
        [userNameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [userNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    else
    {
        [userNameTF setText:[NSString stringWithFormat:@"6 Digit code"]];//hard code here
        [userNameLbl setText:@"Staff ID"];//temp will be dynamic
        //set keyboard type
        [userNameTF setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [userNameTF setReturnKeyType:UIReturnKeyDone];
        [userNameTF enablesReturnKeyAutomatically];
        [userNameTF setClearsOnBeginEditing:YES];
        [userNameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [userNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //    return [_userArray count];
    return 1;//minimum of 1
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIP = indexPath;
    [_userTV deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
