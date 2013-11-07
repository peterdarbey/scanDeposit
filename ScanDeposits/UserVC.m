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
    NSString *usersPath;
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
    //for display only
    _displayArray = [NSMutableArray array];
    
    //No on launch
    _fileExists = NO;
    
    //retrieve the singleton for writing locally
    fileManager = [NSFileManager defaultManager];
    
//    fullPath = [PersistenceManager getFilePath];//Documents/usersCollection.plist
    //retrieve usersCollection
    fullPath = [self getFilePathForName:@"usersCollection.plist"];//Documents/usersCollection.plist
    
    //if file exists at path init with data
    if (![fileManager fileExistsAtPath:fullPath]) {
        //construct the filePath and copy to the Documents folder for writing too file
        NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"usersCollection" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:fullPath error:nil];

    }
    
    _fileExists = YES;
    
    //we have a path
    if (_fileExists) {
        //load data from file
        _storedArray = [NSMutableArray arrayWithContentsOfFile:fullPath];//correct
        DLog(@"_storedArray loaded from file: %@", _storedArray);//correct
        
        //if _storedArray has data and _displayArray has no entries for section headers (returnUserModel not called yet) pop from loaded file
        if (_storedArray && [_displayArray count] < 1) {
            
            //Construct an array to populate the headers with initials
            for (int i = 0; i < [_storedArray count]; i++) {
                 NSMutableArray *initArray = [NSMutableArray array];
                [initArray addObject:[[_storedArray objectAtIndex:i]objectAtIndex:0]];//extract the new user initials
                [_displayArray insertObject:initArray atIndex:i];
                DLog(@"initArray: %@ with index is: %i", initArray, i);
            }
            
            DLog(@"_display with initArray: %@", _displayArray);//correct
        }//close inner if

    }//close outer if
    else
    {
        //Add to the existing stored array
        _storedArray = [NSMutableArray array];//correct

    }
    
    //initialize usersDict or load from file if exist
    _usersDict = [NSMutableDictionary dictionary];//ToDo -> construct plist
    //retrieve users collection
    usersPath = [self getFilePathForName:@"users.plist"];
    
    //_usersDict functionality
    //check file exists at path if not copy to destination path
    if (![fileManager fileExistsAtPath:usersPath]) {
        //construct the filePath and copy to the Documents folder for writing too file
        NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"users" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:[self getFilePathForName:@"users.plist"] error:nil];
    }
    
    //load _users from file
    _usersArray = [NSMutableArray arrayWithContentsOfFile:usersPath];
    
    //if its empty create one for returnUserModel
    if ([_usersArray count] < 1) {
        _usersArray = [NSMutableArray array];//test
    }
    DLog(@"_usersArray: %@", _usersArray);//possible viewwillAppear
    
    editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    
    [self.navigationItem setRightBarButtonItem:editBtn animated:YES];
    
}

- (void)editPressed:(UIButton *)sender {
    DLog(@"Edit pressed");
    if (!_isExpanded) {
        //set the editing to YES
        [_userTV setEditing:YES animated:YES];

     UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditingPressed:)];
    
    [self.navigationItem setRightBarButtonItem:doneBtn animated:YES];
        
    }//close if
    
    //    //set the editing to YES
    //    [_userTV setEditing:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //remove and write to file -> works but using reloadData instead of deleteRowsAtIndex with anim
//        if ([_userTV numberOfRowsInSection:indexPath.section] == 1) {
              //remove entire entry
//            [_displayArray removeObjectAtIndex:indexPath.section];
        
              //remove data from storedArray also
//            [_storedArray removeObjectAtIndex:indexPath.section];
//            [_storedArray writeToFile:fullPath atomically:YES];
        
              //reload data into _storedArray from file
//            _storedArray = [NSMutableArray arrayWithContentsOfFile:fullPath];
//            [_userTV reloadData];//works no smooth anim though
//        }//close if
        
        
        DLog(@"_storedArray before deletion>>: %@", _storedArray);
        
        //works correctly with smooth animation
        if ([_userTV numberOfRowsInSection:indexPath.section] == 1)
        {
            [[_displayArray objectAtIndex:indexPath.section]removeObjectAtIndex:indexPath.row];//perfect
            DLog(@"_displayArray after deletion>>: %@", _displayArray);
            //remove the data from our counterpart storedArray object
            [_storedArray removeObjectAtIndex:indexPath.section];//except remove whole entry
            
            [_userTV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        //write to file
        [_storedArray writeToFile:fullPath atomically:YES];
        //reload data into _storedArray from file
        _storedArray = [NSMutableArray arrayWithContentsOfFile:fullPath];
         DLog(@"_storedArray after deletion>>: %@", _storedArray);//correct count _displayArray wrong count
        
        /**** Removing the all data from _display and reloading from _storedArray ****/
        [_displayArray removeAllObjects];
        //Construct an array to populate the headers with initials
        for (int i = 0; i < [_storedArray count]; i++) {
            NSMutableArray *initArray = [NSMutableArray array];
            [initArray addObject:[[_storedArray objectAtIndex:i]objectAtIndex:0]];//extract the new user initials
            [_displayArray insertObject:initArray atIndex:i];
        }
        [_userTV reloadData];//leave this block of code here as is for now
        
    }//close editingStyle if
    
}

- (void)doneEditingPressed:(UIButton *)sender {
    DLog(@"Done pressed");
    //set the editing to YES
    [_userTV setEditing:NO animated:YES];
    
    //refresh now to remove the section title
//    [_userTV reloadData];
    
    //set barButton back to edit
    [self.navigationItem setRightBarButtonItem:editBtn animated:YES];
    
}


//not called
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

}

- (void)donePressed:(UIButton *)sender {
    
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
    
    NSString *titleName = [NSString stringWithFormat:@"Control User: %i", section];
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
        return 130.0;
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
    
    //if we have data from user model(returnUsermodel called returning a user) or data loaded from file to display
    if (([_displayArray count] >= 1 && _user) || ([_displayArray count] >= 1 && _fileExists)) {
    
        //Construct keys for iteration
        NSArray *userKeys = @[@"Initials", @"Name", @"Email", @"Staff ID"];
        
        //if selected add extra entries to array in expand method
        if (_isSelected && _isExpanded) {
            
            //_dataSource has the appropreiate _userArray containing the 3 fields of each user
            [userNameTF setText:[NSString stringWithFormat:@"%@", [[_displayArray objectAtIndex:indexPath.section]    objectAtIndex:indexPath.row]]];
            [userNameLbl setText:[NSString stringWithFormat:@"%@", [userKeys objectAtIndex:indexPath.row]]];
            
        }//close if -> NOTE: dont need else here as the numOf rows and sections take care of count etc..
        
        //not expanded and not selected so just show 1 entry -> the initials -> NOTE: these should probably be treated uniform also
        else
        {
            //Added this -> if file exists display its data
//            if (_fileExists && _isWritten) {
                [userNameTF setText:[NSString stringWithFormat:@"%@", [[_displayArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];//0
                //set UILabel name, should be uniform
                [userNameLbl setText:[NSString stringWithFormat:@"%@", [userKeys objectAtIndex:indexPath.row]]];
//              [userNameLbl setText:@"Initials"];//was in an else within this else
//            }
        }//close else
        
    }//close if
    
        if ([_displayArray count] >= 1) {//was _dataSource
            
            if (indexPath.row == 0) {
                
                //retrieve the properties
//                userNameTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];
//                userNameLbl = (UILabel *)[cell.contentView viewWithTag:USER_NAME_LBL];
//                //if row 0 move frame to accomadate the arrow
//                [userNameTF setFrame:CGRectMake(190, cell.bounds.size.height/4, 100, 25)];
//                [userNameTF setBackgroundColor:[UIColor greenColor]];//test
//                [userNameLbl setFrame:CGRectMake(110, cell.bounds.size.height/4, 70 , 25)];
//                [userNameLbl setBackgroundColor:[UIColor orangeColor]];//test
                
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
    if ([_displayArray count] >= 1) {
        
        DLog(@"_displayedArray: %@", _displayArray);
        return [_displayArray count];//thinks that there is 6 but only 5now after delete
//        return [_storedArray count];//hack but didnt work
        
    }//close if
    //else if no data yet
    else if ([_displayArray count] < 1) {
        
        return 1;//Show the button on launch
    }
    else
    {

        return [_displayArray count];//Show the button on launch returns 1
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //if we have data
    DLog(@"_displayed ? %@", _displayArray);
    
    if ([_displayArray count] >= 1) {
        //then check if its expanded or not
        if (_isSelected) {
            return [[_displayArray objectAtIndex:section]count];//hardcoded 3
        }
        else //not expanded
        {
            //if not expanded just 1 row
//            DLog(@"_displayArray: %@ with count here crash: %i", _displayArray, [[_displayArray objectAtIndex:section]count]);//count 1 correct
            return [[_displayArray objectAtIndex:section]count];//crash here cause reading 1 which we want
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
    if ([_displayArray count] >= 1) {
        
        //retrieve the selected cell
        UITableViewCell *cell = (UITableViewCell *)[_userTV cellForRowAtIndexPath:indexPath];
        //retreive its index
        NSIndexPath *index = [_userTV indexPathForCell:cell];
        DLog(@"index: %@", index);
        
        //call expand here but also check for expansion 1st]
        if (_isSelected && _isExpanded) {
            [self collaspeMyTableViewWithIndex:selectedIP];
//            _isExpanded = NO;
        }
        //selected and data loaded and not expanded && selection index is the same as the cells index
        else if (_isSelected && !_isExpanded) //&& indexPath.row == index.row)
        {
            
            [self expandMyTableViewWithIndex:selectedIP];//crashing here
            
        }
    }//close if
    
    [_userTV deselectRowAtIndexPath:indexPath animated:YES];
}

//This method addds the objects to the dataSource not the cellForRow
- (void)expandMyTableViewWithIndex:(NSIndexPath *)indexPath {
    
    //Need a conditional test to check the collection as it has not been created via the returnUserModel call

    if (_fileExists && _storedArray) {
       
        //retrieve from stored file first Note values/entries already in the collection dont add again
        DLog(@"_storedArray contains in expandMyTableView: %@", _storedArray);//correct
        
        //retrieve the selected section out of the stored collection
        NSMutableArray *sectionArray = [_storedArray objectAtIndex:indexPath.section];
        DLog(@"<<<< sectionArray >>>>: %@", sectionArray);//correct
        tempArray = [NSMutableArray array];
        
        //construct to pass 3 entries to display and offset by 1 as we have initials already
        for (int i = 0; i < [sectionArray count]-1; i++) {
            [tempArray addObject:[sectionArray objectAtIndex:i +1]];
        }
        
    }//close if
  
        NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    
    if ([[_displayArray objectAtIndex:indexPath.section]count] == 1) {
        
        for (int i = 0; i < [tempArray count]; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i+1 inSection:indexPath.section];//offset by 1
            [indexArray addObject:index];
            //Add just 3 entries to displayArray
            [[_displayArray objectAtIndex:indexPath.section]addObject:[tempArray objectAtIndex:i]];
        }
         DLog(@"new _displayArray: %@", _displayArray);//correct
        
        [_userTV insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
    }//close if
    
    _isExpanded = YES;
}

- (void)collaspeMyTableViewWithIndex:(NSIndexPath *)indexPath {
    
    NSMutableArray *indexArray = [NSMutableArray array];
    
    if([[_displayArray objectAtIndex:selectedIP.section]count] > 1) {
    // Already expanded, close it up! //check that its not open
    NSInteger numRows = [self.userTV numberOfRowsInSection:selectedIP.section];
    
        [UIView animateWithDuration:0.3 animations:^{
            iv.transform = CGAffineTransformMakeRotation(0);
        }];
        //May need if here to stop removing from file if exists dont writew to file here as will lose entries
        //also watch that when it calls cellForRow again it doesnt overwrite withput the add user details?
    for (int i = 1; i < numRows; i++)
    {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:selectedIP.section];//selected index
        [indexArray addObject:index];
        [[_displayArray objectAtIndex:selectedIP.section]removeLastObject];
    }
    
    [_userTV deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
        
    }//close if check
    
    _isExpanded = NO;
}

- (NSString *)getFilePathForName:(NSString *)name {
    
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    
    NSString *fullFilePath = [documentsDirectoryPath stringByAppendingPathComponent:name];//@"users.plist"
    
    return fullFilePath;
}


#pragma custom delegate method from UserPopup
//happens as a result of confirnBtn pressed in xib 
- (void)returnUserModel:(User *)user {
    
    //assign to _user
    _user = user;

    //implement write to file in a array try a NSDictionary instead of NSArray
    NSDictionary *userDict = [user userDict];//was @{user.userStaffID : user};
    DLog(@"-- userDict --: %@", userDict);
    [_usersArray addObject:userDict];//-> NSArray
    

    //then write to file
    [_usersArray writeToFile:[self getFilePathForName:@"users.plist"] atomically:YES];//users.plist
    //for conditional
//    _usersWritten = YES;
    DLog(@"**** new _usersArray **** %@", _usersArray);
    
    //read from new plist for Modal new class on log in
    //NSDictionary *userDict = [NSDictionary dictionaryWithContentsOfFile:@"users.plist"];
    
   
    
//    //Construct an array to populate the headers with initials
    NSMutableArray *initArray = [NSMutableArray array];
    [initArray addObject:(NSString *)[user userInitials]];//extract the new user initials
    [_displayArray addObject:initArray];
    DLog(@"_display with initArray: %@", _displayArray);//should be initized correct

    
    //NOTE only write to file if its not already written to file?
    if (_fileExists) {
        //New construct for saving only
        NSMutableArray *writableArray = [NSMutableArray array];
        [writableArray addObject:[user userInitials]];
        [writableArray addObject:[user userName]];
         [writableArray addObject:[user userEMail]];
         [writableArray addObject:[user userStaffID]];
       
    
        //Before adding/writing to file check that there is no data already stored
        if (_storedArray) {
            //Add new user to _storedArray
            [_storedArray addObject:writableArray];
        }
        
        //write here
        [_storedArray writeToFile:fullPath atomically:YES];
        _isWritten = YES;
        DLog(@"Writing _storedArray to file: %@", _storedArray);
        //refresh data
        [_userTV reloadData];
        
    }//close if
    
    
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
