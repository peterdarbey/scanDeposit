//
//  UserVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "UserVC.h"
#import "User.h"

#import "PersistenceManager.h"

@interface UserVC ()
{
    NSFileManager *fileManager;
    NSString *fullPath;
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
    
//    _dataSource = [NSMutableArray array];
    
    _eachUserArray = [NSMutableArray array];
    
    //No on launch
    _fileExists = NO;
    
    //retrieve the singleton for writing locally
    fileManager = [NSFileManager defaultManager];
    
    fullPath = [PersistenceManager getFilePath];
    DLog(@"<< fullPath >>: %@", fullPath);//Documents/usersCollection.plist
    
    //if file exists at path init with data
    if ([fileManager fileExistsAtPath:fullPath]) {
         //Load the _dataSource from file if it exists
        _dataSource = [NSMutableArray arrayWithContentsOfFile:fullPath];
        _fileExists = YES;
        DLog(@"_dataSource retrieved from stored plist: %@", _dataSource); //plist:works now
    }
    else //doesnt exist so copy from NSBundle to the destination path
    {
        //create the filePath for writing too file
        NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"usersCollection" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:fullPath error:nil];
        _dataSource = [NSMutableArray array];
    }

    
    
    
}
//not called
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //set conditional for reloadData
//    [_userTV reloadData];

}

- (void)donePressed:(UIButton *)sender {
    
    //ToDo On done save the _dataSource array to Documents folder
    
   
    
    //Test
//    NSArray *writeArray = @[@"Write to file", @"Write to file", @"Write to file", @"Write to file"];//worked
//    NSMutableArray *mutArray = [NSMutableArray array];
//    [mutArray addObject:writeArray];
//    [mutArray writeToFile:fullPath atomically:YES];//works
    
    //create our data persistence model
//    PersistenceManager *persistManager = [[PersistenceManager alloc]init];
//    NSMutableArray *array = [_dataSource objectAtIndex:0];
//    [persistManager writeToCollection:array withPath:fullPath];
    
//    NSArray *writeArray = @[@"Write to file", @"Write to file", @"Write to file", @"Write to file"];//worked
    
    
    DLog(@"_dataSource write too file: %@", _dataSource);
    
//    [self.navigationController popToRootViewControllerAnimated:YES];//Pushes to previous navController as I instaniated another one
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)addUserPressed:(UIButton *)sender {
  
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
//        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _registerTV.frame.size.width, 25)];
//        [topView setBackgroundColor:[UIColor clearColor]];
//
//        //construct a UILabel for the Admin section
//        UILabel *adminLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 180, 25)];
//        [adminLbl setText:@"Administrator 2"];
//
//        [adminLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
//        [adminLbl setTextColor:[UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0]];//darkGray
//        [adminLbl setTextAlignment:NSTextAlignmentLeft];
//        [adminLbl setBackgroundColor:[UIColor clearColor]];
//        adminLbl.shadowColor = [UIColor whiteColor];
//        adminLbl.shadowOffset = CGSizeMake(0.0, 1.0);
//        [topView addSubview:adminLbl];
//
//        return topView;        
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
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _userTV.frame.size.width, 130)];//90
        [bottomView setBackgroundColor:[UIColor clearColor]];
        
        //construct a button to save user details in NSUserDefaults
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setFrame:CGRectMake(10, 23, 300, 44)];
        [saveBtn setUserInteractionEnabled:YES];
        [saveBtn addTarget:self action:@selector(addUserPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self buttonStyle:saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"ADD USERS"];
        
        //add to parent view
        [bottomView addSubview:saveBtn];
        
        //construct a Done button to push back to rootViewController
        //construct a button to save user details in NSUserDefaults
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn setFrame:CGRectMake(10, 77, 300, 44)];
        [doneBtn setUserInteractionEnabled:YES];
        [doneBtn addTarget:self action:@selector(donePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self buttonStyle:doneBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"DONE"];
        
        //add to parent view
        [bottomView addSubview:doneBtn];
        return bottomView;
    }
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section== [_userTV numberOfSections] -1) {
        return 130.0;//90
    }
    else
    {
        return 10.0;
    }
}

- (NSArray *)sortCollectionWithDictionary:(NSDictionary *)dict {
    
    //Sort items first
    NSArray *replaceKeys = (NSArray *)[[dict allKeys]sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSString *s1 = (NSString *) obj1;
        NSString *s2 = (NSString *) obj2;
        return [s1 compare:s2];
    }];
    
    DLog(@"replaceKeys: %@", replaceKeys);
    return replaceKeys;
    
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
        [userNameTF setEnablesReturnKeyAutomatically:YES];
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
        
    }//close if
    
    else
    {   //retrieve the properties
        userNameTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];
        userNameLbl = (UILabel *)[cell.contentView viewWithTag:USER_NAME_LBL];
    }
    
    
    if ([_dataSource count] >= 1 && _user) {
        
        //if selected add extra items to array in expand method
        if (_isSelected && _isExpanded) { //add !_isEXpanded
            
            //Construct keys for iteration
            NSArray *userKeys = @[@"Initials", @"Name", @"Email", @"Staff ID"];
            
            //_dataSource has the appropreiate _userArray containing the 3 fields of each user
            [userNameTF setText:[NSString stringWithFormat:@"%@", [[_dataSource objectAtIndex:indexPath.section]    objectAtIndex:indexPath.row]]];
            [userNameLbl setText:[NSString stringWithFormat:@"%@", [userKeys objectAtIndex:indexPath.row]]];
            DLog(@"_dataSource structure: %@", _dataSource);
        }//close if
        
        else //not expanded so just show 1 entry -> the initials
        {
            //set UITextField Initials
            [userNameTF setText:[NSString stringWithFormat:@"%@", [[_dataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];//yes
            //set UILabel name
            [userNameLbl setText:@"Initials"];
        }
        
    }//close if
    
        if ([_dataSource count] >= 1) {
            
            if (indexPath.row == 0) {
                cell.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];//light white
                cell.imageView.image = [UIImage imageNamed:@"rightArrow.png"];//add resource
                
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
                cell.imageView.image = nil;
            }
        }//close if
    
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //if we have something to display then display
    if ([_dataSource count] >= 1) {
        
        return [_dataSource count];
        
    }//close if
    else
    {
        return 1;//Show the button on launch
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //if we have data
    if ([_dataSource count] >= 1) {
        //then check if its expanded or not
        if (_isSelected) {
            return [[_dataSource objectAtIndex:section]count];//hardcoded 3
        }
        else //not expanded
        {
            return 1;//if not expanded just 1 row
        }
        
    }//close if
    
    else
    {
        return 0; //no data yet so return 0;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIP = indexPath;
    
    //tapped
    _isSelected = YES;
    
    //check we have a tblView 1st before expanding or collasping
    if ([_dataSource count] >= 1) {
        
        //call expand here but also check for expansion 1st]
        if (_isSelected && _isExpanded) {
            [self collaspeMyTableViewWithIndex:selectedIP];
            _isExpanded = NO;
        }
        //selected and data loaded and not expanded
        else if (_isSelected && !_isExpanded) //&& indexPath.row == 0)
        {
            //expand
            _isExpanded = YES;
            [self expandMyTableViewWithIndex:selectedIP];//crashing here
            
        }
    }
    
    [_userTV deselectRowAtIndexPath:indexPath animated:YES];
}

//This method addds the objects to the dataSource not the cellForRow
- (void)expandMyTableViewWithIndex:(NSIndexPath *)indexPath {
    
    //******** Note ********
    //Need a conditional test to check the array as this array has not been created via the returnUserModel call
    NSArray *userValues;
    
    if (_fileExists) {
    
        //retrieve from file first
        userValues = [_dataSource objectAtIndex:indexPath.section];//get selected section
        DLog(@"userValues in fileExists: %@", userValues);
        
    }
    else //Doesnt exist means returnUserModel called
    {
        
        //Now get each _userArray out of the _eachUserArray for the apropriate section /selected section
        userValues = [_eachUserArray objectAtIndex:indexPath.section];//get selected section

    }
    
    //Note indexPath is the selected row and section
    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    
    //check that its not open
    if([[_dataSource objectAtIndex:selectedIP.section]count] == 1) {
        
        for (int i = 0; i < [userValues count]; i++) { //3
            NSIndexPath *index = [NSIndexPath indexPathForRow: i+1 inSection:selectedIP.section];//offset by 1
            [indexArray addObject:index];
            //Add the _userArray to the _dataSource collection
            [[_dataSource objectAtIndex:selectedIP.section]addObject:[userValues objectAtIndex:i]];//_userArray
            
        }//close loop
        
        //Now write to file
        [_dataSource writeToFile:fullPath atomically:YES];//test
        
        
        UITableViewCell *cell = [self.userTV cellForRowAtIndexPath:indexPath];
        iv = cell.imageView;
        [UIView animateWithDuration:0.3 animations:^{
            // Rotate the arrow
            iv.transform = CGAffineTransformMakeRotation(M_PI_2);//rotate down
        }];
        
        [_userTV insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
    }
    
}

- (void)collaspeMyTableViewWithIndex:(NSIndexPath *)indexPath {
    
    NSMutableArray *indexArray = [NSMutableArray array];
    
    if([[_dataSource objectAtIndex:selectedIP.section]count] > 1) {
    // Already expanded, close it up! //check that its not open
    NSInteger numRows = [self.userTV numberOfRowsInSection:selectedIP.section];
    
        [UIView animateWithDuration:0.3 animations:^{
            iv.transform = CGAffineTransformMakeRotation(0);
        }];
        
    for (int i = 1; i < numRows; i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:selectedIP.section];//selected index
        [indexArray addObject:index];
        [[_dataSource objectAtIndex:selectedIP.section]removeLastObject];
    }
    
    [_userTV deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
        
    }//close if check
    
    
}

#pragma custom delegate method from UserPopup
//happens as a result of confirnBtn pressed in xib 
- (void)returnUserModel:(User *)user {
    
    //assign to _user
    _user = user;
    
    //Init the _userArray with the user fields -> array with values/objects
    //Make it local
    NSMutableArray *localUserArray = [NSMutableArray array];
    [localUserArray addObject:(NSString *)[user userName]];
    [localUserArray addObject:(NSString *)[user userEMail]];
    [localUserArray addObject:(NSString *)[user userStaffID]];
//    [localUserArray addObject:[user userInitials]];//add this initials and isAdmin if required
     [_eachUserArray addObject:localUserArray];
     DLog(@"_eachUserArray__: %@ with Count: %i ", _eachUserArray, [_eachUserArray count]);
   
    
    //Construct an array to populate the headers with initials
    NSMutableArray *initArray = [NSMutableArray array];
    [initArray addObject:(NSString *)[user userInitials]];//extract the new user initials
    [_dataSource addObject:initArray];
    DLog(@"_dataSource with initArray: %@", _dataSource);//should be initized correct
    
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
@end
