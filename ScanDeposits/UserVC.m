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
    
    _expandedArray = [NSMutableArray array];
    
    userDetailsArray = [NSMutableArray array];
    
    
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
    
    //Only enters here when dataSource is init when thr returnUserModel method is called on confirmBtn press
    if ([userDetailsArray count] >= 1) {//[_dataSource count] {
        //retrieve the user for each section
//        _user = [_dataSource objectAtIndex:indexPath.section];//section as row is constantly 1
        
        
        //all the meaningful data I need -> 3
//        _userArray = [userDetailsArray objectAtIndex:indexPath.section];//assigning a string
        _userArray = userDetailsArray; //assigning 3 objects
        DLog(@"userArray contains: %@ in Section: %i", _userArray, indexPath.section);//different users, starts at 0 index   3 items in section: 0
    
        
        //if expanded add extra items to array
        if (_isSelected) {
            //add array to dataSource if expanded
            [_dataSource addObjectsFromArray:userDetailsArray];
            DLog(@"dataSource now contains >>>: %@", _dataSource);
            //retrieves an array and then a string
            [userNameTF setText:[NSString stringWithFormat:@"%@", [[_dataSource objectAtIndex:indexPath.section]    objectAtIndex:indexPath.row]]];
            
            //set UILabel name with allKey values from _dataSource
            NSArray *allKeys = [_dataSource objectAtIndex:indexPath.section];
//            NSArray *allKeys = [userDict allKeys];
            DLog(@"All keys: %@", allKeys);
//            NSArray *allValues = [allKeys objectAtIndex:indexPath.section];
//            [userNameLbl setText:[NSString stringWithFormat:@"%@", [allValues objectAtIndex:indexPath.section]]];
            [userNameLbl setText:@"Initials"];//needs to be allKeys Again
        }
        
        else //not expanded so just show 1 entry -> the initials
        {
            //Maybe add _dataSource here the inital string
            NSDictionary *entryDict = [_initialsArray objectAtIndex:indexPath.section];
            DLog(@"entryDict>>>: %@", entryDict);//Initial = P;
            [userNameTF setText:[NSString stringWithFormat:@"%@", entryDict[@"Initial"]]];
            //set UILabel name
            [userNameLbl setText:@"Initials"];
        }
        
    }//close if
    else
    {
        DLog(@"Dont display any data");//dont need this condition
    }

    
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //if we have something to display then display
    if ([_dataSource count] >= 1) {
        
        if (_isSelected) {
            return [_dataSource count];
        }
        else //not expanded
        {
            return [_dataSource count];//or _dataSource in theory //should be 1
        }
        
    }//close if
    else
    {
        return 0;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //if we have data
    if ([_dataSource count] >= 1) {
        //then check if its expanded or not
        if (_isSelected) {
            return [[_dataSource objectAtIndex:section]count];
        }
        else //not expanded
        {
//            return [_dataSource count];//or initialsArray in theory
            return 1;//or initialsArray in theory
        }
        
    }//close if
    
    else
    {
        //no data yet so return 0;
        return 0;
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
        if (_isSelected && _isExpanded) {
            [self collaspeMyTableViewWithIndex:selectedIP];
            _isExpanded = NO;
        }
        else
        {
            //expand
            [self expandMyTableViewWithIndex:selectedIP andUser:_user];//crashing here
             _isExpanded = YES;
        }
    }
    
    [_userTV deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)expandMyTableViewWithIndex:(NSIndexPath *)indexPath andUser:(User *)user {
    
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    
    //populate expandArray with these entries
    for (int i = 0; i < [_userTV numberOfRowsInSection:indexPath.section]; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow: i inSection:indexPath.section]; // Note: We offset by 1 because we're not inserting the zeroth item as this is the Parking Authority.//was i+1
        [indexArray addObject:index];
        DLog(@"userDetailsArray before: %@", userDetailsArray);
        [[userDetailsArray objectAtIndex:indexPath.section]addObject:[_initialsArray objectAtIndex:indexPath.section]];//Add selected section to datasource subObj level
        DLog(@"userDetailsArray after: %@", userDetailsArray);
    }
//    [_userTV reloadData];
     [_userTV insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];//indexPath is wrong
    
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
    
    //assign to _user
    _user = user;
    
    
    //Just take what I need the meaningful 3 user properties
    [userDetailsArray addObject:[user userName]];
    [userDetailsArray addObject:[user userEMail]];
    [userDetailsArray addObject:[user userStaffID]];
//    DLog(@"userDetailsArray **********: %@", userDetailsArray);//has what I need
    //ok to add here
    [_dataSource addObject:[user userInitials]];
    DLog(@"_dataSource: %@", _dataSource);//should be initized
    //and the title for header
    //generate headers from user model initials property -> Moved to returnedUserModel instead NOPE HERE
    [initialsDict setObject:[user userInitials] forKey:@"Initial"];//doesnt work in retunedUserModel?
    [_initialsArray addObject:initialsDict];
//    DLog(@"_initialsArray: %@", _initialsArray);//has what I need
    
    
    //Add to the dataSource array
//    [_dataSource addObject:user];
//    DLog(@"_dataSource here in returnUserModel: %@", _dataSource);//note each user is a dict
    
    //populate my initialDict here also (not cellForRow)
    //generate headers from user model initials property
}
//may not need this delegate method
- (void)refreshView {

    [_userTV reloadData];
//    DLog(@"ReloadData called in refreshView");
    //call contractTableView method
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//temp method
- (IBAction)tblViewPress:(id)sender {
    DLog(@"Add Another pressed");
    //ToDO bring up a xib view
    UserPopup *userPopup = [UserPopup loadFromNibNamed:@"UserPopup"];
    //Add delegate if required -> its the UserPopup delegate set to self this UserVC class
    [userPopup setUserDelegate:self];//correct
    [userPopup showOnView:self.view];//test
}
@end
