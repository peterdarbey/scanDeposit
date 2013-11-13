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
    UIBarButtonItem *editBtn;
    UIButton *doneBtn;
    
    CGSize keyboardSize;
    
    
    NSFileManager *fileManager;
    NSString *filePath;
    NSString *adminsPath;
    
    UITextField *activeTF;
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

//Unregister for notifications
- (void)viewDidDisappear:(BOOL)animated{
    
    [notificationCenter removeObserver:self];
    [super viewDidDisappear:YES];
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
    
    editBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    [self.navigationItem setRightBarButtonItem:editBtn];
    //disable on load
    [editBtn setEnabled:YES];
    
    
    //enable when the user has successfully been created
    //if one admin setup enable button
    if (_isSetup) {
        
        [doneBtn setEnabled:YES];
    }
    //else no admin setup dont enable Done button
    else
    {
        
        [doneBtn setEnabled:NO];
    }
    
    
    
    //Add a notification for the keyboard
    notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:Nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:Nil];
    
    

    
    //retrieve the singleton for writing locally
    fileManager = [NSFileManager defaultManager];
    
    filePath = [self getFilePathForName:@"adminsCollection.plist"];//Documents/adminsCollection.plist
    
    //if file exists at path init with data
    if (![fileManager fileExistsAtPath:filePath]) {
        //construct the filePath and copy to the Documents folder for writing too file
        NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"adminsCollection" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:filePath error:nil];
        
    }
    
    _fileExists = YES;
    
    
    if (_fileExists) {
        //load data from file
        _adminArray = [NSMutableArray arrayWithContentsOfFile:filePath];//correct adminsCollection
        DLog(@"_adminArray loaded from file: %@", _adminArray);//correct
        
        if ([_adminArray count] < 1) {
            _adminArray = [NSMutableArray array];
             DLog(@"if empty create an _adminArray: %@", _adminArray);
        }
    }
    
    
    //ADMIN -> initialize adminsDict or load from file if exist
    _adminsDict = [NSMutableDictionary dictionary];
    //retrieve users collection
    adminsPath = [self getFilePathForName:@"admins.plist"];
    
    //_usersDict functionality
    //check file exists at path if not copy to destination path
    if (![fileManager fileExistsAtPath:adminsPath]) {
        //construct the filePath and copy to the Documents folder for writing too file
        NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"admins" ofType:@"plist"];
        [fileManager copyItemAtPath:sourcePath toPath:[self getFilePathForName:@"admins.plist"] error:nil];
    }
    
    //load _users from file
    _administratorArray = [NSMutableArray arrayWithContentsOfFile:adminsPath];
    
    //if its empty create one for returnUserModel
    if ([_administratorArray count] < 1) {
        _administratorArray = [NSMutableArray array];
    }
    DLog(@"_administratorArray: %@", _administratorArray);//possible viewwillAppear
    
    
}

- (NSString *)getFilePathForName:(NSString *)name {
    
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    
    NSString *fullFilePath = [documentsDirectoryPath stringByAppendingPathComponent:name];//@"admins.plist"
    
    return fullFilePath;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
   
    //retrieve the keyboard size.height -> 216
     keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSDictionary *info = [notification userInfo];
    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    double duration = [number doubleValue];
    
   
    
    //for hit test condition
    CGRect aRect = self.view.frame;//self.view -> (0, 0,320, 548);
    aRect.size.height -= keyboardSize.height;
    CGPoint scrollPoint;
    

    //textField is assigned
    if (activeTF) { // && _isSelectedTF) {
        
        //retrieve the cell for the hidden content
        UITableViewCell *cell = (UITableViewCell *)[activeTF.superview superview];
        
        //if it doesnt contain the activeTF (0, 0, 320, 332) -> (0, 356)
        if (!CGRectContainsPoint(aRect, cell.frame.origin) && _isSelectedTF) { //activeTF.frame.origin
            scrollPoint = CGPointMake(0, cell.frame.origin.y - keyboardSize.height);//0 - 216
            
            DLog(@"cell.frame.origin X: %f andY: %f", cell.frame.origin.x, cell.frame.origin.y);//(0, 356)
            
        [UIView animateWithDuration:duration animations:^{
            
            self.registerTV.transform = CGAffineTransformMakeTranslation(0, - (keyboardSize.height - 50));//works
        }];
           
//            _isSelectedTF = NO;
        }
        
    }//close if
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    DLog(@"KeyBoardWillHide");
    
//    NSDictionary *info = [notification userInfo];
//    NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    double duration = [number doubleValue];
    
    
    if (activeTF && _isSelectedTF) {
        
        //retrieve the cell for the hidden content
        UITableViewCell *cell = (UITableViewCell *)[activeTF.superview superview];
        
        CGRect aRect = self.view.frame;// -> (0, 0,320, 548);
        aRect.size.height -= keyboardSize.height;
        CGPoint scrollPoint;
        
        
        //if it doesnt contain the activeTF
        if (!CGRectContainsPoint(aRect, cell.frame.origin) && _isSelectedTF) { //active.frame.origin
            scrollPoint = CGPointMake(0, cell.frame.origin.y - keyboardSize.height);//0 - 216
            
//            [UIView animateWithDuration:duration animations:^{
//                self.registerTV.transform = CGAffineTransformMakeTranslation(0, 0);//- keyboardSize.height);//works
//             }];
        
        }
        
    }//close if
    
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[textField.superview superview];
    NSIndexPath *indexPath = [_registerTV indexPathForCell:cell];
    
    //added to a specific cell
    if (indexPath.section == 1 && indexPath.row == 0) {
        activeTF = textField;
        DLog(@"activeTF is: %@", activeTF);
        _isSelectedTF = YES;
    }
    else
    {
        _isSelectedTF = NO;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    //for conditional -> retrieve the cell and use its index
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [_registerTV indexPathForCell:cell];
    
    UITextField *nextTF;
    
    //textField superview corresponds to
    //Name
    if (indexPath.row == 0) {
        //if TF is not empty resign/assign
        if (![textField.text isEqualToString:@""] && [textField.text length] > 6) {
            
            //assign text to user ivar
             self.name = textField.text;
            
            if (self.name) {
                //create Initails from userName field
                [self createInitialsFromText:textField.text];
                
            }//close if
            
            //next TextField
            nextTF = [self returnNextTextField:textField];
            [nextTF becomeFirstResponder];//[self.view endEditing:yes];
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
        if (![textField.text isEqualToString:@""] && [textField.text length] > 4) {
            
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
    //Staff ID then generate Adminstrator password
    else if (indexPath.row == 2)
    {
        
        if (![textField.text isEqualToString:@""] && [textField.text length] >= 6) {
            //resign previous responder status
            [textField resignFirstResponder];
            //assign text to user ivar
            _staffID = textField.text;
            
            //if these ivars are set then we have enough data to proceed
            if (_name && _eMail && _staffID && _initials) {
                //assign to adminPassword
                _adminPassword = [_staffID stringByAppendingString:_initials];
                
                //only enter if 2 or less admin/users -> updating this
//                if ([_adminArray count] < 2) {//on second iteration still less than 2
                
                //create user model set YES for Administrator, add required fields to local array and add to _adminArray
                [self createUserFactoryWithIndexPath:indexPath];//fixed //adminFactory
                    
//                }//close if
                
                //set to NO again when kB dismissed
                [self doneEditingPressed:nil];//even better -> _allowEdit = NO;
//                [_registerTV reloadData];//dont need now as doneEditingPressed does that
            }
            
        }//close inner if
        else
        {
            [textField becomeFirstResponder];
        }
    }//close else
    
    else //Password field
    {
    
    }
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        
        //dont hard code time use duration from userInfo dict
        [UIView animateWithDuration:.3 animations:^{
            self.registerTV.transform = CGAffineTransformMakeTranslation(0, 0);//works
            
//                [_registerTV setContentOffset:scrollPoint animated:YES];
        }];
    }


}
//factory method -> auto sets admin = YES
- (void)createUserFactoryWithIndexPath:(NSIndexPath *)indexPath {
    //Auto set here that they are ADMINs because of context they are in i.e. Admins settings
    
    User *user = [[User alloc]initWithName:_name eMail:_eMail
                                   staffID:_staffID Initials:_initials
                                   isAdmin:YES withPassword:_adminPassword];
    
    
    //Construct for the LoginVC functionality and add in the conditions below
    NSDictionary *adminsDict = [user adminDict];//administrator with password
    DLog(@"adminsDict: %@", adminsDict);
    
    
    //Create a local specific array and add in conditioins below
    NSMutableArray *localUserArray = [NSMutableArray array];
    [localUserArray addObject:[user userName]];
    [localUserArray addObject:[user userEMail]];
    [localUserArray addObject:[user userStaffID]];
    [localUserArray addObject:[user userPassword]];
    
    DLog(@"AdminArray count>>>>>>>>>: %i", [_adminArray count]);
    
    //in editing mode -> Note: only gets here in editing mode
    if (_allowEdit) {
        
        //if empty we can add to users from index:0
        if ([_adminArray count] == 0) {
            //add each object to its particular collection at index 1
            [_administratorArray addObject:adminsDict];//will auto be index:0 if empty
//            [_administratorArray insertObject:adminsDict atIndex:indexPath.section];//might crash out of bounds
            //write to file here also
            [_administratorArray writeToFile:adminsPath atomically:YES];
            
            //Add to the overAll collection
            [_adminArray addObject:localUserArray];//ordered with only 1entry
//            [_adminArray insertObject:localUserArray atIndex:indexPath.section];//insert might be the better way
            //write to file here also
            [_adminArray writeToFile:filePath atomically:YES];
            _isWritten = YES;
            
        }
        //need to allow overwriting of data for admins here
        else if ([_adminArray count] == 1) { //only one admin setup
            
            //add each object to its particular collection at index 1
            [_administratorArray insertObject:adminsDict atIndex:indexPath.section];//might crash out of bounds, ordered with only 1entry -> should be correct?
            //write to file here also
            [_administratorArray writeToFile:adminsPath atomically:YES];
            
            //Add to the overAll collection
            [_adminArray insertObject:localUserArray atIndex:indexPath.section];//might crash out of bounds
            //write to file here also
            [_adminArray writeToFile:filePath atomically:YES];
            _isWritten = YES;
            
        }
        else if ([_adminArray count] == 2) {
            //add each object to its particular collection at index 1
            [_administratorArray replaceObjectAtIndex:indexPath.section withObject:adminsDict];
            //write to file here also
            [_administratorArray writeToFile:adminsPath atomically:YES];
            
            //Add to the overAll collection
            [_adminArray replaceObjectAtIndex:indexPath.section withObject:localUserArray];
            //write to file here also
            [_adminArray writeToFile:filePath atomically:YES];
            _isWritten = YES;
            
        }//close else if
        
    }//close if
    
    DLog(@"_adminArray__: %@ with Count: %i ", _adminArray, [_adminArray count]);
    
    DLog(@"_administratorArray: %@ with Count: %i ", _administratorArray, [_administratorArray count]);
    
    
    //set gobal ivar for admin setup completed
    if ([User isAdminUser] && user && _isWritten) {
        //Now at least 1 admin setup so proceed and create gobal ivar
        
        //NSUserDefaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:@YES forKey:@"Is Administrator"];
        [userDefaults setObject:@YES forKey:@"Is Setup"];//setup complete
        [userDefaults synchronize];
        
        //enable when the user has successfully been created
        [doneBtn setEnabled:YES];
    }

}

- (void)createInitialsFromText:(NSString *)text {
    
    NSMutableArray *lettersArray = [NSMutableArray array];
    //separates the strings into separate elements in an array
    NSArray *initialsArray = [text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   
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
    }
    
    if ([lettersArray count] == 2) {
        NSString *initials = [lettersArray objectAtIndex:0];
        NSString *appendedInitials = [initials stringByAppendingString:[lettersArray objectAtIndex:1]];
        self.initials = appendedInitials;
    }
    else if ([lettersArray count] >2)
    {
        NSString *initials = [lettersArray objectAtIndex:0];
        NSString *appendedInitials = [initials stringByAppendingString:[lettersArray objectAtIndex:1]];//crash
        appendedInitials = [appendedInitials stringByAppendingString:[lettersArray objectAtIndex:2]];
        self.initials = appendedInitials;
//        DLog(@"<< 3 >> self.initials: %@", self.initials);//DHR
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([string isEqualToString:@"@"]) {
        [textField resignFirstResponder];//ah could be this causing the keyboard to call hideKeyboard notification
        return NO;
    }
    
    return YES;
    
}

//creates a string with @aib.ie appended to the end
- (NSString *)addEMailToString:(NSString *)text {
    
    if (text) {
        
        NSArray *eMailArray = (NSArray *)[text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"@"]];

        //if eMailArray is initilaized retrieve the first component at index:0
        if (eMailArray) {
            NSString *emailString = [eMailArray objectAtIndex:0];
            _eMail = [emailString stringByAppendingString:AIB];
        }
        
    }//close if
    
    NSString *eMailPrefix = _eMail;
    
    return eMailPrefix;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 0 ) {
        if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singleCell.png"]];
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singleCellSelected.png"]];
        }
    }
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    _allowEdit = NO;
    
    //call cellForRow
    [_registerTV reloadData];
    
}

- (void)doneEditingPressed:(UIButton *)sender {
    
    //set editing to NO
    _allowEdit = NO;
    
    //call cellForRow
    [_registerTV reloadData];
    
    //set barButton back to edit
    [self.navigationItem setRightBarButtonItem:editBtn animated:YES];
}

- (void)editPressed:(UIButton *)sender {
    
    DLog(@"Edit pressed");
    _allowEdit = YES;
    
    //call cellForRow
    [_registerTV reloadData];
    
    UIBarButtonItem *doneEditingBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditingPressed:)];
    
    [self.navigationItem setRightBarButtonItem:doneEditingBtn animated:YES];
    
}

- (void)addPressed:(UIButton *)sender {
    //ToDo implement NSUserDefaults
    
    
    //Push to new User/Reg VC
    UserVC *userVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserVC"];
    [userVC setTitle:NSLocalizedString(@"User Settings", @"User Settings Process Screen")];

    [self.navigationController pushViewController:userVC animated:YES];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {// && ADMIN) {
        //+44 for navigation bar
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _registerTV.frame.size.width, 143)];//128
        [topView setBackgroundColor:[UIColor clearColor]];
        
        //construct an innerView for the admin section
        UIView *innerView = [[UIView alloc]initWithFrame:CGRectMake(10, 64, _registerTV.frame.size.width -20, 44)];
        [innerView setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];//dark white;
        innerView.layer.cornerRadius = 5.0;
        
        //construct a UILabel for the Admin section
        UILabel *adminLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 118, 180, 25)];
        [adminLbl setText:@"Administrator 1"];
//        [adminLbl setFont:[UIFont fontWithName:@"Helvetica" size:17]];
        [adminLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
        [adminLbl setTextAlignment:NSTextAlignmentLeft];
        [adminLbl setTextColor:[UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0]];//darkGray
        [adminLbl setBackgroundColor:[UIColor clearColor]];
        adminLbl.shadowColor = [UIColor whiteColor];
        adminLbl.shadowOffset = CGSizeMake(0.0, 1.0);
        [topView addSubview:adminLbl];
        
        
        //construct a UITextField for branch NSC
        UITextField *branchNSCTF = [[UITextField alloc]initWithFrame:CGRectMake(105, 10, 185, 25)];
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

        //construct a UILabel for text
        UILabel *branchNSCLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 115, 25)];
        [branchNSCLbl setBackgroundColor:[UIColor clearColor]];
        [branchNSCLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        branchNSCLbl.textAlignment = NSTextAlignmentLeft;
        branchNSCLbl.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        branchNSCLbl.shadowColor = [UIColor grayColor];
        branchNSCLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        [branchNSCLbl setText:[NSString stringWithFormat:@"Branch NSC"]];
        [branchNSCLbl setUserInteractionEnabled:NO];
        //add to view
        [innerView addSubview:branchNSCLbl];
                
        //add to UIView hierarchy
        [topView addSubview:innerView];
        
        return topView;
        
    }//close if
    
    else
    {
        
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _registerTV.frame.size.width, 25)];
        [topView setBackgroundColor:[UIColor clearColor]];
        
        //construct a UILabel for the Admin section
        UILabel *adminLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 180, 25)];
        [adminLbl setText:@"Administrator 2"];
        
        [adminLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:17]];
        [adminLbl setTextColor:[UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0]];//darkGray
        [adminLbl setTextAlignment:NSTextAlignmentLeft];
        [adminLbl setBackgroundColor:[UIColor clearColor]];
        adminLbl.shadowColor = [UIColor whiteColor];
        adminLbl.shadowOffset = CGSizeMake(0.0, 1.0);
        [topView addSubview:adminLbl];

        return topView;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 143;//+ height for string title -> 128 + 25
    }
    else
    {
        return 25;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    if (section == [_registerTV numberOfSections] -1)
    {
        
        UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _registerTV.frame.size.width, 120)];//90
        [bottomView setBackgroundColor:[UIColor clearColor]];
        
        //construct a button to save user details in NSUserDefaults
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveBtn setFrame:CGRectMake(10, 23, 300, 44)];
        [saveBtn setUserInteractionEnabled:YES];
        [saveBtn addTarget:self action:@selector(addPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self buttonStyle:saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"USER SETTINGS"];
        
        //add to parent view
        [bottomView addSubview:saveBtn];
        
        
        //construct a button to save user details in NSUserDefaults
        doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneBtn setFrame:CGRectMake(10, 74, 300, 44)];
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

- (void)donePressed:(UIButton *)sender {
    
    //unbalanced calls because its dismissing and then pushing back up from viewDIdLoad and cant do that if anim here as its conflicting
    //so Q is where does admin go from here currently back here
    
    
    //NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL isAdmin = [[userDefaults objectForKey:@"Is Administrator"]boolValue];
    
    //retrieve the setup value from NSUserDefaults
    _isSetup = [[userDefaults objectForKey:@"Is Setup"]boolValue];
    
    //if one admin setup allow dismissal of VC
    if (_isSetup && isAdmin) {
       
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
    //else no admin setup so display error message -> custom popup if time
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error: No Administrator setup" message:@"Please create an Administrator" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
    }

    
    [self dismissViewControllerAnimated:NO completion:nil];
        //ToDo add saving functionality here
        //        //Save the admins to file here
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section== [_registerTV numberOfSections] -1) {
        return 120.0;
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
        
        nameTF = [[UITextField alloc]initWithFrame:CGRectMake(105, cell.bounds.size.height/4, 185, 25)];
        [nameTF setBackgroundColor:[UIColor clearColor]];
        nameTF.tag = NAME_TF;
        nameTF.textAlignment = NSTextAlignmentLeft;
//        nameTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        nameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [nameTF setFont:[UIFont systemFontOfSize:15.0]];
        nameTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        //change to NO
        [nameTF setUserInteractionEnabled:NO];
        
        //set textField delegate
        [nameTF setDelegate:self];
        
        [cell.contentView addSubview:nameTF];
        
        //Construct Label
        userLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 85 , 25)];
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
    NSArray *array = @[@"Name", @"Email", @"Staff ID", @"Password"];
    //always remains constant
    [userLbl setText:[NSString stringWithFormat:@"%@", [array objectAtIndex:indexPath.row]]];
    
    DLog(@"_adminArray is: %@ and count: %i", _adminArray, [_adminArray count]);
    
//    if (_adminPassword && [_adminArray count] == 1) {
    if ([_adminArray count] == 1) {
        //Only 1 user so set just the first section
        if (indexPath.section == 0) {
            [nameTF setText:[NSString stringWithFormat:@"%@", [[_adminArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];//section 0 pop section 0
        }
        
    }//else if adminPassword set and 2 admins created
    else if ([_adminArray count] > 1) { // && _adminPassword) {
        
        [nameTF setText:[NSString stringWithFormat:@"%@", [[_adminArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];
    }
    else //first time _adminPassword wont exist
    {
        [nameTF setPlaceholder:[NSString stringWithFormat:@"Auto Generated"]];
    }
    

    //setup of keyboard prefs
    if (indexPath.row == 0) {
        
        [nameTF setPlaceholder:[NSString stringWithFormat:@"Enter Name"]];
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
        [nameTF setPlaceholder:[NSString stringWithFormat:@"Staff ID"]];
        //set keyboard type
        [nameTF setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        [nameTF setReturnKeyType:UIReturnKeyDone];
        [nameTF enablesReturnKeyAutomatically];
        [nameTF setClearsOnBeginEditing:YES];
        [nameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [nameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    }
    //if not the password field and allows editing is YES
    if (_allowEdit && indexPath.row != 3) {
        [nameTF setUserInteractionEnabled:YES];
    }
    else if (!_allowEdit) {
        
        //change to NO
        [nameTF setUserInteractionEnabled:NO];
        DLog(@"disable userInteraction again");//good works
        //use allowEdit to overwrite file settings
        
    }
    
    return cell;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //if _userArray has more than 1 user use its count
    if ([_adminArray count] > 1) {
        return [_adminArray count];//always 2
    }
    else //default to 2
    {
        return 2;//Could be 2 admin associated with an account
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //user details will be the count
    if ([_adminArray count] > 1) {
        return [[_adminArray objectAtIndex:section]count];//always 4
    }
    else
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
}

@end
