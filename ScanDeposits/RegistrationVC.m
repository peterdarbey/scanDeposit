//
//  RegistrationVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 21/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "RegistrationVC.h"

#import "User.h"
#import "UserVC.h"
#import "PopupTV.h"

@interface RegistrationVC ()
{
    
}

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *eMail;
@property (strong, nonatomic) NSString *staffID;
@property (strong, nonatomic) NSString *initials;
@property (strong, nonatomic) NSString *adminPassword;

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
    
    [textField resignFirstResponder];
    
    return YES;
}

- (UITextField *)returnNextTextField:(UITextField *)textField {
    //retrieve the cell that contains the textField
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [_registerTV indexPathForCell:cell];
    
    //increment the indexPath.row to retrieve the next cell which contains the next textField
    cell = (UITableViewCell *)[_registerTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row +1 inSection:indexPath.section]];
    //the next TextField
    UITextField *nextTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];
    return nextTF;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //for conditional
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [_registerTV indexPathForCell:cell];
    
    UITextField *nextTF;
    
    //textField superview corresponds to
    //Name
    if (indexPath.row == 0) {
        //if TF is not empty resign/assign
        if (![textField.text isEqualToString:@""] && [textField.text length] > 3) {
            [textField resignFirstResponder];//resign 1st
            //assign text to user ivar
             self.name = textField.text;
             DLog(@"Name: %@", _name);
            
            if (self.name) {
                
                //create Initails from userName field
                [self createInitialsFromText:textField.text];
                
            }//close if
            
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
    //Email
    else if (indexPath.row == 1) {
        //if TF is not empty resign/assign
        if (![textField.text isEqualToString:@""] && [textField.text length] > 3) {
            //resign previous responder status
            [textField resignFirstResponder];
            
            //create email with the address apended to it
            textField.text = [self addEMailToString:textField.text];
            
            //next TextField become ist responder
            nextTF = [self returnNextTextField:textField];
            [nextTF becomeFirstResponder];
        }//close inner if
        else
        {
            [textField becomeFirstResponder];
        }
        
    }
    else //Staff ID then generate Adminstrator password
    {   //pass code 6 digits
        if (![textField.text isEqualToString:@""] && [textField.text length] >= 6) {
            //resign previous responder status
            [textField resignFirstResponder];
            //assign text to user ivar
            _staffID = textField.text;
            
            if (_name && _eMail && _staffID && _initials) { //should work fine
                //assign to adminPassword
                _adminPassword = [_staffID stringByAppendingString:_initials];
                //create user model set YES as its the Administrator settings
                //only allow to admin users
                if ([_adminArray count] <= 2) {//shoul be greater than doesnt work cause array is below fix with capacity
                
                    User *user = [[User alloc]initWithName:_name eMail:_eMail
                                                   staffID:_staffID Initials:_initials
                                                   isAdmin:YES withPassword:_adminPassword];                    
                    //Create a local array
                    NSMutableArray *localUserArray = [NSMutableArray array];
                    [localUserArray addObject:[user userName]];
                    [localUserArray addObject:[user userEMail]];
                    [localUserArray addObject:[user userStaffID]];
                    [localUserArray addObject:[user userPassword]];
                   //Add to the overAll collection
                    [_adminArray addObject:localUserArray];
                    DLog(@"_adminArray__: %@ with Count: %i ", _adminArray, [_adminArray count]);
                    
                }//close if
                
                //reloadData
                [_registerTV reloadData];
            }
            
        }//close inner if
        else
        {
            [textField becomeFirstResponder];
        }
    }

    
}


- (void)createInitialsFromText:(NSString *)text {
    
    NSMutableArray *lettersArray = [NSMutableArray array];
    //separates the strings into separate elements in an array
    NSArray *initialsArray = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    DLog(@"initialsArray: %@", initialsArray);//correct
    //iterate over collection
    for (int i = 0; i < [initialsArray count]; i++ ) {
        //each word in array
        NSString *word = [initialsArray objectAtIndex:i];
        //extract 1st letter only
        if ([word length] > 0) {
            NSString *firstLetter = [word substringToIndex:1];//works
            [lettersArray addObject:firstLetter];
        }
        else
        {
            DLog(@"Less than 1 char -> space");
        }
        
    }//close for loop
    
    if ([lettersArray count] == 1) {
        NSString *appendedInitials = [lettersArray objectAtIndex:0];
        self.initials = appendedInitials;
        DLog(@"<< 1 >> self.initials: %@", self.initials);//DH
    }
    
    if ([lettersArray count] == 2) {
        NSString *initials = [lettersArray objectAtIndex:0];
        NSString *appendedInitials = [initials stringByAppendingString:[lettersArray objectAtIndex:1]];
        self.initials = appendedInitials;
        DLog(@"<< 2 >> self.initials: %@", self.initials);//DH
    }
    else if ([lettersArray count] >2)
    {
        NSString *initials = [lettersArray objectAtIndex:0];
        NSString *appendedInitials = [initials stringByAppendingString:[lettersArray objectAtIndex:1]];//crash
        appendedInitials = [appendedInitials stringByAppendingString:[lettersArray objectAtIndex:2]];
        self.initials = appendedInitials;
        DLog(@"<< 3 >> self.initials: %@", self.initials);//DHR
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"@"]) {
        DLog(@"STRING: %@", string);
        [textField resignFirstResponder];
        return NO;//works
    }
    
    return YES;
    
}

//creates a string with @aib.ie appended to the end
- (NSString *)addEMailToString:(NSString *)text {
    
    if (text) {
        
        NSArray *eMailArray = (NSArray *)[text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@"]];
        DLog(@"eMailArray: %@", eMailArray);
        //if eMailArray is initilaized retrieve the first component at index:0
        if (eMailArray) {
            NSString *emailString = [eMailArray objectAtIndex:0];
            _eMail = [emailString stringByAppendingString:AIB];
            DLog(@"_eMail********: %@", _eMail);
        }
        
    }//close if
    
    NSString *eMailPrefix = _eMail;
    
    return eMailPrefix;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
        stringArray = [NSMutableArray array];
    
    //ToDo init admins array with the associated admins if exist from file
    _adminArray = [NSMutableArray arrayWithCapacity:2];
    
     [_registerTV setBackgroundColor:[UIColor clearColor]];
     [_registerTV setBackgroundView:[[UIImageView alloc]initWithImage:
                                     [UIImage imageNamed:@"Default-568h.png"]]];
    //set delegate to self
    [_registerTV setDelegate:self];
    [_registerTV setDataSource:self];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed:)];
    [self.navigationItem setRightBarButtonItem:doneBtn];//Mmm worked
    
//    [self.navigationController.navigationItem setRightBarButtonItem:doneBtn];
    
    
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    
}

- (void)donePressed:(UIButton *)sender {
    
    DLog(@"Done Pressed");
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //ToDo add saving functionality here
        //Save the admins to file here
    }];
}
- (void)addPressed:(UIButton *)sender {
    //ToDo implement NSUserDefaults
    DLog(@"addPressed");
    
    //Push to new User/Reg VC
    UserVC *userVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserVC"];
    [userVC setTitle:NSLocalizedString(@"User Registration", @"User Registration Process Screen")];

    [self.navigationController pushViewController:userVC animated:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {// && ADMIN) {
        //+44 for navigation bar
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _registerTV.frame.size.width, 84)];//130
        [topView setBackgroundColor:[UIColor clearColor]];
        
        //construct an innerView for the admin section
        UIView *innerView = [[UIView alloc]initWithFrame:CGRectMake(10, 77, _registerTV.frame.size.width -20, 80)];
        [innerView setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];//dark white;
        innerView.layer.cornerRadius = 5.0;
        
        //construct a UILabel for the Admin section
        UILabel *adminLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 51.5, 180, 25)];
        [adminLbl setText:@"Administrator Details"];
        [adminLbl setFont:[UIFont fontWithName:@"Helvetica" size:17]];
//        [adminLbl setFont:[UIFont systemFontOfSize:17]];
        [adminLbl setTextColor:[UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0]];//darkGray
        [adminLbl setBackgroundColor:[UIColor clearColor]];
        adminLbl.shadowColor = [UIColor whiteColor];
        adminLbl.shadowOffset = CGSizeMake(0.0, 1.0);
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
        [branchNSCTF setFont:[UIFont systemFontOfSize:15]];
        branchNSCTF.textAlignment = NSTextAlignmentLeft;
        branchNSCTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        branchNSCTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        [branchNSCTF setUserInteractionEnabled:NO];
        [branchNSCTF setText:[NSString stringWithFormat:@"Branch Value"]];//pop dynamically
        //set TextField delegate
        [branchNSCTF setDelegate:self];
        
        //add to view
        [innerView addSubview:branchNSCTF];
        
        //construct a 2nd TextField
        UITextField *offCounterTF = [[UITextField alloc]initWithFrame:CGRectMake(120, 45, 180, 25)];
        [offCounterTF setBackgroundColor:[UIColor clearColor]];
        [offCounterTF setDelegate:self];
        [offCounterTF setFont:[UIFont systemFontOfSize:15]];
        offCounterTF.textAlignment = NSTextAlignmentLeft;
        offCounterTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        offCounterTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        [offCounterTF setUserInteractionEnabled:NO];
        [offCounterTF setText:[NSString stringWithFormat:@"Counter Value"]];//pop dynamically
        //set textField delegate
        [offCounterTF setDelegate:self];
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
        return 180;//180 //84
    }
    else
    {
        return 20;//10
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
        [saveBtn addTarget:self action:@selector(addPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self buttonStyle:saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"USER SETTINGS"];
        
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
    
    //ist time through doesnt exist
    if (cell == nil) {
        
       cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        
        nameTF = [[UITextField alloc]initWithFrame:CGRectMake(90, cell.bounds.size.height/4, 200, 25)];
        [nameTF setBackgroundColor:[UIColor clearColor]];
        nameTF.tag = NAME_TF;
        nameTF.textAlignment = NSTextAlignmentLeft;
//        nameTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        nameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [nameTF setFont:[UIFont systemFontOfSize:15.0]];
        nameTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        [nameTF setUserInteractionEnabled:YES];
        
        //set textField delegate
        [nameTF setDelegate:self];
        
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
        
    }
    else
    {
        //retreive the properties
        nameTF = (UITextField *)[cell.contentView viewWithTag:NAME_TF];
        userLbl = (UILabel *)[cell.contentView viewWithTag:USER_LBL];
        
    }
    
    //create the array of label values for fields
    NSArray *array = @[@"Name", @"Email", @"Staff ID", @"Admin Password"];
    //always remains constant
    [userLbl setText:[NSString stringWithFormat:@"%@", [array objectAtIndex:indexPath.row]]];
    
    if ([_adminArray count] > 1) { //maybe >=1
        //pop tblView with the admin details

        //retrieve the admin at the specified index
//        NSMutableArray *array = [_adminArray objectAtIndex:indexPath.section];
        
//        [userLbl setText:[NSString stringWithFormat:@"%@", [array objectAtIndex:indexPath.row]]];
        [nameTF setText:[NSString stringWithFormat:@"%@", [[_adminArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];
        DLog(@"_adminArray in cellForRowAtIndex: %@", _adminArray);
        
    }
    else
    {
        //use the stored plist of values
        //populate here also
//        [userLbl setText:[NSString stringWithFormat:@"%@", [array objectAtIndex:indexPath.row]]];
        
         [nameTF setPlaceholder:[NSString stringWithFormat:@"Auto generated password"]];
    }
    
    if (indexPath.row == 0) { //indexPath.section && //actually section doesnt matter
//        [userLbl setText:@"Name"];
//        [nameTF setText:[NSString stringWithFormat:@"David Roberts"]];//temp will be dynamic
        [nameTF setPlaceholder:[NSString stringWithFormat:@"Enter Name"]];//temp will be dynamic
        //set keyboard type
        [nameTF setKeyboardType:UIKeyboardTypeDefault];
        [nameTF setReturnKeyType:UIReturnKeyNext];
        [nameTF enablesReturnKeyAutomatically];
        [nameTF setClearsOnBeginEditing:YES];
        [nameTF setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [nameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    else if (indexPath.row == 1)
    {
//        [userLbl setText:@"Email"];//temp will be dynamic
//        [nameTF setText:[NSString stringWithFormat:@"david.h.roberts"]];//hard code here
        [nameTF setPlaceholder:[NSString stringWithFormat:@"Enter Email"]];
        //set keyboard type
        [nameTF setKeyboardType:UIKeyboardTypeEmailAddress];
        [nameTF setReturnKeyType:UIReturnKeyNext];
        [nameTF enablesReturnKeyAutomatically];
        [nameTF setClearsOnBeginEditing:YES];
        [nameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [nameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    else if (indexPath.row == 2)
    {
//        [userLbl setText:@"Staff ID"];//temp will be dynamic
//        [nameTF setText:[NSString stringWithFormat:@"Adminstrator"]];//hard code here
        [nameTF setPlaceholder:[NSString stringWithFormat:@"Staff ID"]];
        //set keyboard type
        [nameTF setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [nameTF setReturnKeyType:UIReturnKeyDone];
        [nameTF enablesReturnKeyAutomatically];
        [nameTF setClearsOnBeginEditing:YES];
        [nameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [nameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    else // Password field
    {
//        [userLbl setText:@"Admin password"];
        //first time wont exist
        if (_adminPassword && [_adminArray count] > 1) {
//            [nameTF setText:[NSString stringWithFormat:@"%@", passwordString]];
            [nameTF setText:[NSString stringWithFormat:@"%@", [[_adminArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];//change to indexPath: 0 perhaps
            DLog(@"_adminArray: %@", _adminArray);
        }
        else
        {
            [nameTF setPlaceholder:[NSString stringWithFormat:@"Auto generated password"]];
        }
        
    }
    
        return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //if _userArray has more than 1 user use its count
    if ([_adminArray count] > 1) {
        return [_adminArray count];//always 2 anyhow
    }
    else //default to 2
    {
        return 2;//Could be 2 admin associated with an account
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //user details will be the count
    if ([_adminArray count] > 1) {
        return 4; //[[_adminArray objectAtIndex:indexPath.section]count];//which will be 4
    }
    else //default to 4
    {
        return 4;
    }
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
