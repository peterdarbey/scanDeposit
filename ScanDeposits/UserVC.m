//
//  UserVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "UserVC.h"
#import "User.h"


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
    UITextField *nextTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];//100
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
    
    //inititize all userCollections
    _userArray = [NSMutableArray array];//Empty always at least 1 user to use app just stop user deleting last 1 or 2 entries
    
    _initialsArray = [NSMutableArray array];
    
    _dataSource = [NSMutableArray array];
    
    initialsDict = [NSMutableDictionary dictionary];
    
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    [self.navigationController.navigationItem setRightBarButtonItem:doneBtn];
    
    
}
//not called
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //set conditional for reloadData
//    [_userTV reloadData];
}

- (void)donePressed:(UIButton *)sender {
    
    DLog(@"Done Pressed");
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{
//        //ToDo add saving functionality here
//    }];
}

- (void)addUserPressed:(UIButton *)sender {
    DLog(@"Add Another pressed");
    //ToDO bring up a xib view
    UserPopup *userPopup = [UserPopup loadFromNibNamed:@"UserPopup"];
    //Add delegate if required -> its the UserPopup delegate set to self this UserVC class
    [userPopup setUserDelegate:self];//correct
    [userPopup showOnView:self.view];//test
    
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


//-(void)checkForExpansionOfZones:(NSIndexPath *)path
//{
//    NSMutableArray *zoneNames = [NSMutableArray array];
//    
//    _isSelected = YES;
//    
//    //Added to fix issue with arrows
//    for (int i = 0; i < [self numberOfSectionsInTableView:self.userTV]; i++) {
//        if ([[_dataSource objectAtIndex:i]count] == 1 && i != selectedIP.section) {
//            [UIView animateWithDuration:0.3 animations:^{
////                iv.transform = CGAffineTransformMakeRotation(0);imageView
//            }];
//        }
//    }//close loop

//    if (path) {
//        NSMutableArray *indexArray = [[NSMutableArray alloc] init];

//        if([[_dataSource objectAtIndex:selectedIP.section]count] == 1) {
//            //iterate over filtered names
//            for (int j = 0; j < _dataSource.count; j++) {
//                _user = [_dataSource objectAtIndex:j];
//                [zoneNames addObject:_user.userName];

//                NSIndexPath *index = [NSIndexPath indexPathForRow: j+1 inSection:path.section]; // Note: We offset by 1 because we're not inserting the zeroth item as this is the Parking Authority.
//                [indexArray addObject:index];

//                [[_dataSource objectAtIndex:path.section]addObject:[zoneNames objectAtIndex:j]];//Add selected section to datasource subObj level
//            }
//            //Selected section and opening
//            if (([_dataSource objectAtIndex:selectedIP.section]) && ([[_dataSource objectAtIndex:selectedIP.section]count] > 1)) {
////                UITableViewCell *cell = [self.userTV cellForRowAtIndexPath:path];
////                iv = cell.imageView;
//                [UIView animateWithDuration:0.3 animations:^{
//                    // Rotate the arrow
////                    iv.transform = CGAffineTransformMakeRotation(M_PI_2);//rotate down
//                }];
//            }
//            [_userTV insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
//            
//            //while still sections in tblView that are not selected close
//            for (int i = 0; i < [self numberOfSectionsInTableView:self.userTV]; i++) {
//                if (i != selectedIP.section) {//if not selected call
////                    [self closeSectionIfOpen:i];//close
//                }
//            }
//        }
//        else {
//            // Already expanded, close it up!
////            [self closeSections:path];
//        }
//    }
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
        [self buttonStyle:saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"ADD USERS"];
        
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
        //ToDo add a BOOL for editable or not
//        [userNameTF setUserInteractionEnabled:YES];
        
        [userNameTF setUserInteractionEnabled:NO];
        [userNameTF setEnablesReturnKeyAutomatically:YES];//Test
        
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
    {   //retrieve the properties
        userNameTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];
        userNameLbl = (UILabel *)[cell.contentView viewWithTag:USER_NAME_LBL];
    }
    
    //After cell creation process only, show a tableView if the datasource is init with users
    
    //init users here
    if ([_dataSource count] >= 1) {
        //retrieve the user for each section
        _user = [_dataSource objectAtIndex:indexPath.section];//section as row is constantly 1
        DLog(@"_dataSource array contains: %@ and Row: %i", _dataSource, indexPath.section);//different users, starts at 0 index
       
        //generate headers from user model initials property -> Moved to returnedUserModel instead
        
        if (_initialsArray) {
            NSDictionary *entryDict = [_initialsArray objectAtIndex:indexPath.section];
            DLog(@"entryDict>>>: %@", entryDict);
            [userNameTF setText:[NSString stringWithFormat:@"%@", entryDict[@"Initial"]]];
            //set UILabel name
            [userNameLbl setText:@"Initials"];
        };
        
    }//close if
    else
    {
        DLog(@"Dont display any data");//dont need this condition
    }

    //If expanded only
    if (_isExpanded) {
        
        //set inidivual cells
        if (indexPath.row == 0) {
    //        [userNameTF setText:[NSString stringWithFormat:@"David Roberts"]];//temp will be dynamic
            //Test
            [userNameTF setText:[NSString stringWithFormat:@"%@", [_user userName]]];//works
            [userNameLbl setText:@"Name"];
            //set keyboard type
        }
        else if (indexPath.row == 1)
        {
            [userNameTF setText:[NSString stringWithFormat:@"%@", [_user userEMail]]];//hard code here
            [userNameLbl setText:@"Email"];//temp will be dynamic
            //set keyboard type
        }
        else if (indexPath.row == 2)//probably just 3 cells as initials will be on section header
        {
            [userNameTF setText:[NSString stringWithFormat:@"%@", [_user userStaffID]]];//hard code here
            [userNameLbl setText:@"Staff ID"];//temp will be dynamic
            //set keyboard type
        }

        else //or leave as 3 entries
        {
            [userNameTF setText:[NSString stringWithFormat:@"%@", [_user userInitials]]];//hard code here
            [userNameLbl setText:@"Initials"];//temp will be dynamic
            //set keyboard type
        }
        
    }//close if expanded
    
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([_dataSource count] >= 1) {
        return [_dataSource count];//minimum 1 or 2 oh watch section data 
    }
    else
    {
        return 1;//minimum of 1
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([_dataSource count] >= 1) {
//        return [[_dataSource objectAtIndex:section]count];//NOTE user doesnt have a count method
        
        //user doesnt have a count method
        return 1; //for now
    }
    else
    {
//        return 3;//static not dynamic
        return 0;//dont display anything
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIP = indexPath;
    
    //tapped
    _isSelected = YES;
    
    //check we have a tblView 1st before expanding or collasping
    if (_user) {
        
        //call expand here but also check for expansion 1st]
        if (_isExpanded) {
            [self collaspeMyTableViewWithIndex:selectedIP];
        }
        else
        {
            //expand
            [self expandMyTableViewWithIndex:selectedIP andUser:_user];
        }
    }
    
    
    [_userTV deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)expandMyTableViewWithIndex:(NSIndexPath *)indexPath andUser:(User *)user {
    
    NSMutableArray *indexArray = [NSMutableArray array];
     NSUInteger count = indexPath.row + 1;
    
    for (NSDictionary *userDict in _dataSource) {
        [_dataSource addObject:[NSIndexPath indexPathForRow:count inSection:0]];
        [_dataSource insertObject:user atIndex:count];
    }
     [_userTV insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];

}

- (void)collaspeMyTableViewWithIndex:(NSIndexPath *)indexPath {
    
    NSMutableArray *indexArray = [NSMutableArray array];
    NSUInteger count = indexPath.row + 1;
    
        if ([_dataSource count] >= 1) {
            [_dataSource removeObjectAtIndex:count];//was indexes
            [_userTV deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
        }
}

#pragma custom delegate method from UserPopup
//happens as a result of confirnBtn pressed in xib 
- (void)returnUserModel:(User *)user {
    
    //ToDo add the returned user model to an array and use to pop the TableView
    [_userArray addObject:user];//dict
    //Ad to the dataSource array
    [_dataSource addObject:user];
    DLog(@"_dataSource here in returnUserModel: %@", _dataSource);//note each user is a dict
    //populate my initialDict here also (not cellForRow)
    //generate headers from user model initials property
    [initialsDict setObject:[user userInitials] forKey:@"Initial"];
    //Add to collection
    [_initialsArray addObject:initialsDict];
    DLog(@"initialsArray in returnUserModel: %@", _initialsArray)
    
//    [_userTV reloadData];
//    DLog(@"ReloadData called in returnUserModel");
}
//may not need this delegate method
- (void)refreshView {

    [_userTV reloadData];
    DLog(@"ReloadData called in refreshView");
    //call contractTableView method
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
