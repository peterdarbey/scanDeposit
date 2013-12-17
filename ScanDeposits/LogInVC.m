//
//  LogInVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 06/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "LogInVC.h"

#import "User.h"

@interface LogInVC ()

@property (strong, nonatomic) NSString *password;
@property (strong, nonatomic) NSString *userOne;
@property (strong, nonatomic) NSString *userTwo;

@end

@implementation LogInVC
{
    UIActivityIndicatorView *loginSpinner;
    UIButton *loginBtn;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loginPressed:(UIButton *)sender {
    
    BOOL __block isAdmin;// -> flag for HomeVC view presentation
    
    //set spinner
    [loginBtn setEnabled:NO];
    [loginSpinner setHidden:NO];
    [loginSpinner setAlpha:1.0];
    
    //if valid administrator
    if (_adminFieldValid) {
        //if 1 admin and 1 user still psuh to Admin settings or is that relevant?
        if ([_admins count] > 0) {
            DLog(@"_password is: %@", _password);
            //iterate through _admins collection to check for a valid admin
            for (NSDictionary *dict in _admins) {
                NSDictionary *aAdmin = dict[_password];//think thats right
                if ([aAdmin[@"Password"] isEqualToString:_password]) {
                    //add to packagedUsers collection
                    [_packagedAdmins setObject:aAdmin forKey:@(1)];
                    DLog(@"_packagedAdmins: %@", _packagedAdmins);
                    isAdmin = [aAdmin[@"Adminstrator"]boolValue];//should be yes dont hardcode YES allow object to control value
                    
                }//close if
                
            }//close for
            
            //if we have an admin allow access to app
            if ([_packagedAdmins count] > 0) {
                
                //ToDo create admin package
                //set spinner
                [loginBtn setEnabled:YES];
                [loginSpinner setHidden:YES];
                [loginSpinner setAlpha:0.0];
                
                //different custom delegate method call
                if ([self.delegate respondsToSelector:@selector(dismissLoginVC: isAdmin:)]) {
                    //dismissLoginVC -> sets isAdmin to YES and isUser to NO
                    [self.delegate performSelector:@selector(dismissLoginVC: isAdmin:) withObject:_packagedAdmins withObject:@(isAdmin)];// -> works @(YES) but dont hardcode
                    DLog(@"New Admin delgate protocol implemented");
                    //dismiss
                    [self dismissViewControllerAnimated:YES completion:nil];//correct
                }//close if
                
            }//close if
            else //display error message
            {
                //display pop up
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Not Authorised" message:@"Invalid password" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                [alertView show];
            }
            
        }//close if
        
    }//close outer if
    
    //if user 1 is valid then add to collection
    if (_userOneFieldValid) {
        
        //iterate through _users collection to check for a valid user
        if ([_users count] > 0) {
        
            for (NSDictionary *dict in _users) {
                NSDictionary *aUser = dict[_userOne];
                //check user exists and allow entry to app -> also check is admin
                if ([aUser[@"Staff ID"] isEqualToString:_userOne]) { // -> User => StaffID CORRECT
                    //aUser is the specified user via Login textField add to collection
                    [_packagedUsers setObject:aUser forKey:@(1)];//number now associated with a user
                    isAdmin = [aUser[@"Adminstrator"]boolValue];// check this user also 
                }//close if
                
            }//close for
        
        }//close if
        
    }//close if
    
        //if valid user
        if (_userOneFieldValid && _userTwoFieldValid) {
            //set spinner
            [loginBtn setEnabled:NO];
            [loginSpinner setHidden:NO];
            [loginSpinner setAlpha:1.0];
        
            if ([_users count] > 0) {
                
                //iterate through _users collection to check for a valid user
                for (NSDictionary *dict in _users) {
                    NSDictionary *aUser = dict[_userTwo];//objectForKey:@"textField.text"]//extract user by staffID
                    if ([aUser[@"Staff ID"] isEqualToString:_userTwo]) {
                        //add to packagedUsers collection
                        [_packagedUsers setObject:aUser forKey:@(2)];//now NSNumbers -> correct
                        DLog(@"_packagedUsers: %@", _packagedUsers);
                        isAdmin = [aUser[@"Adminstrator"]boolValue];// -> should be NO also to allow admin to use app as user else it would bring to admin settings
                    }//close if
                    
                }//close for
                
            }//close if
                if ([_packagedUsers count] == 2) {//set to 2
                
                    //Its cause LoginVC is been presented again for some reason?
                    //check BOOL for _isAdmin auto calling that condition again??
                
                    //set spinner
                    [loginBtn setEnabled:YES];
                    [loginSpinner setHidden:YES];
                    [loginSpinner setAlpha:0.0];
                    
                    //custom delegate method call
                    if ([self.delegate respondsToSelector:@selector(dismissLoginVC: isAdmin:)]) {
                
                        [self.delegate performSelector:@selector(dismissLoginVC: isAdmin:) withObject:_packagedUsers withObject:@(isAdmin)];//isAdmin set to NO and isUser set to YES and then returns
                        //now dismiss the LoginVC once the appropriate values are set in HomeVC conditions
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                
                }//close if
                else //displaying both at the moment???
                {
                    //display pop up
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Not Authorised" message:@"Invalid staff ID" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    [alertView show];
                }//close else

        }//close valid user one and two

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
    
}
//custom method -> different section is why?
- (UITextField *)returnNextTextField:(UITextField *)textField {
    //retrieve the cell that contains the textField
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    while(![cell isKindOfClass:[UITableViewCell class]]) cell = (UITableViewCell *)[cell superview];// iOS 7 fix
    NSIndexPath *indexPath = [_loginTV indexPathForCell:cell];
    
    //increment the indexPath.row to retrieve the next cell which contains the next textField
    cell = (UITableViewCell *)[_loginTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section +1]];
    //the next TextField
    UITextField *nextTF = (UITextField *)[cell.contentView viewWithTag:TEXTFIELD_TAG];//100
    return nextTF;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[textField.superview superview];
	while(![cell isKindOfClass:[UITableViewCell class]]) cell = (UITableViewCell *)[cell superview];// iOS 7 fix

    CGRect rect = self.view.frame;
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
	if(rect.origin.y < 0)
		[self setViewMovedUp:NO];
	if(rect.origin.y >= 0) {
/*
		if(20 + 55 + cell.frame.origin.y > windowSize.height / 2)
			[self setViewMovedUp:YES];
*/

		double origY = origY = [textField convertPoint:CGPointMake(0, 0) toView:self.loginTV].y;
		double offY = self.loginTV.contentOffset.y + 64;
//NSLog(@"textFieldDidBeginEditing    orig %f   off %f", origY, offY);
		if(offY + windowSize.height / 2 < origY) {
			[self setViewMovedUp:YES];
		}
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    CGRect rect = self.view.frame;
	if(rect.origin.y < 0)
		[self setViewMovedUp:NO];

    //retrieve the cell for which the textField was entered
    UITableViewCell *cell = (UITableViewCell *)[textField.superview superview];
    while(![cell isKindOfClass:[UITableViewCell class]]) cell = (UITableViewCell *)[cell superview];// iOS 7 fix
    NSIndexPath *indexPath = [_loginTV indexPathForCell:cell];
    UITextField *nextTF;
    
//	CGSize windowSize = [[UIScreen mainScreen] bounds].size;
	if(self.view.frame.origin.y < 0) {
		[self setViewMovedUp:NO];
	}
    
    //ADMIN ONLY
    if (indexPath.section == 0) {
        DLog(@"<< Administrator section >>");
        
        //[loginBtn setEnabled:NO];
        if (![textField.text isEqualToString:@""] && [textField.text length] > 3) {
            //assign to _password
            _password = textField.text;
            
            //set spinner
            [loginBtn setEnabled:YES];//should be YES
//            [loginSpinner setHidden:NO];
//            [loginSpinner setAlpha:1.0];
            
            _adminFieldValid = YES;
            
            [textField resignFirstResponder];
            
        }//close if
        else
        {
            [textField becomeFirstResponder];
            //if blank display an error message
        }
        
    }//USER 1
    
    else if (indexPath.section == 1) {
        DLog(@"Control User:1 section");
        if (![textField.text isEqualToString:@""] && [textField.text length] > 3) {
            
            //assign to _userOne
            _userOne = textField.text;
            
            //set spinner
            [loginBtn setEnabled:YES];
            _userOneFieldValid = YES;
            
            //get next TextField
            nextTF = [self returnNextTextField:textField];
            [nextTF becomeFirstResponder];
            
        }//close if
        else
        {
            [textField becomeFirstResponder];
            //if blank display an error message
        }
        
    }//close else if
    
    else//USER 2
    {
        DLog(@"Control User:2 section");
        if (![textField.text isEqualToString:@""] && [textField.text length] > 3) {
            
            //assign to _userTwo
            _userTwo = textField.text;
            
            //set spinner
            [loginBtn setEnabled:YES];
            _userTwoFieldValid = YES;
            //last textField so resign TextField as its also valid
            [textField resignFirstResponder];
            
        }//close if
        else
        {
            [textField becomeFirstResponder];
            //if blank display an error message
        }
        
    }//close else
    
}

- (NSString *)getFilePathForName:(NSString *)name {
    
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    
    NSString *fullFilePath = [documentsDirectoryPath stringByAppendingPathComponent:name];//@"users.plist"
    
    return fullFilePath;
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


- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //for now
    [_loginTV setBackgroundColor:[UIColor whiteColor]];
    //set delegates
    [_loginTV setDataSource:self];
    [_loginTV setDelegate:self];
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    //Construct a imageView
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
//    [self.view addSubview:imgView];//for the moment
    [_loginTV setBackgroundView:imgView];
    
    fileManager = [NSFileManager defaultManager];
    //user settings
    if (![fileManager fileExistsAtPath:[self getFilePathForName:@"users.plist"]]) {
        
        NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"users" ofType:@".plist"];
        [fileManager copyItemAtPath:sourcePath toPath:[self getFilePathForName:@"users.plist"] error:nil];
    }//close if
    
    //check it exists and load if not then cant use app
        //ToDo load array from file
        _users = [NSMutableArray arrayWithContentsOfFile:[self getFilePathForName:@"users.plist"]];

//    DLog(@"_users: %@", _users);//correct
    
    //Administrator setting
    if (![fileManager fileExistsAtPath:[self getFilePathForName:@"admins.plist"]]) {
        
        NSString *sourcePath = [[NSBundle mainBundle]pathForResource:@"admins" ofType:@".plist"];
        [fileManager copyItemAtPath:sourcePath toPath:[self getFilePathForName:@"admins.plist"] error:nil];
    }//close if

        //load array from file -> NOTE: dont add max is 2 administrators
        _admins = [NSMutableArray arrayWithContentsOfFile:[self getFilePathForName:@"admins.plist"]];
    
    DLog(@"_admins collection: %@", _admins);//correct -> empty at the moment as still under construction
    if ([_admins count] < 1) {
        DLog(@"if empty construct an array: %@", _admins);
        _admins = [NSMutableArray array];
    }
    
    //create packagedUsersDict
    _packagedUsers = [NSMutableDictionary dictionary];
    //create a packagedAdminDict
    _packagedAdmins = [NSMutableDictionary dictionary];
    
    //loginSpinner setup
    loginSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loginSpinner setHidesWhenStopped:YES];
    [loginSpinner setHidden:YES];
    [loginSpinner setFrame:CGRectMake(loginBtn.frame.size.width - 54, 2, 40, 44)];
    [loginSpinner setAlpha:0.0];
    //add spinner to view but dont display till busy
    [loginBtn addSubview:loginSpinner];
    
    //set login button to disabled
    [loginBtn setEnabled:NO];
    
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    //if 1st section
    if (section == 0) {
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _loginTV.frame.size.width, 90)];
        [aView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *adminLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 54.5, 165, 25)];
        adminLbl.backgroundColor = [UIColor clearColor];
       
        adminLbl.textAlignment = NSTextAlignmentLeft;
        adminLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
//        adminLbl.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        [adminLbl setTextColor:[UIColor whiteColor]];
        adminLbl.shadowColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        adminLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        [adminLbl setUserInteractionEnabled:NO];
        [adminLbl setText:@"Administrator Only"];
        
        [aView addSubview:adminLbl];
        
        return aView;
        
    } //middle section
    else if (section == 1) {
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _loginTV.frame.size.width, 45)];//50
        [aView setBackgroundColor:[UIColor clearColor]];
        //
        UILabel *adminLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 165, 25)];
        //
        adminLbl.textAlignment = NSTextAlignmentLeft;
        adminLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
        adminLbl.textColor = [UIColor whiteColor];//darkGray
        adminLbl.shadowColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        adminLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        adminLbl.backgroundColor = [UIColor clearColor];
        [adminLbl setUserInteractionEnabled:NO];
        [adminLbl setText:@"Control Users Only"];
        
        [aView addSubview:adminLbl];
        
        return aView;

    }
    else //last section
    {
        return nil;
    }

}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    //if the last section
    if (section == [_loginTV numberOfSections] -1) {
        
        return 5;
    }
    //middle section
    else if (section == 1) {
        
        return 45;//50
    }
    else //1st section
    {
        return 90;//100
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
        loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self buttonStyle:loginBtn WithImgName:@"greenButton.png" imgSelectedName:@"greenButtonSelected.png" withTitle:@"LOG IN"];
        
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [loginBtn setFrame:CGRectMake(10, 23, 300, 44)];
        [loginBtn addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
        //disable on construct
        [loginBtn setEnabled:NO];
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
        
        cellTF = [[UITextField alloc]initWithFrame:CGRectMake(145, cell.bounds.size.height/4, 145, 25)];
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
        
        cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 120 , 25)];
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
    NSArray *labelsArray = @[@"Password", @"Control User:1", @"Control User:2"];
    
    //populate the cells textField and Label with data here
    [cellLabel setText:[NSString stringWithFormat:@"%@", [labelsArray objectAtIndex:indexPath.section]]];
    
    if (indexPath.section == 0) {
        [cellTF setPlaceholder:@"Enter your password"];
    }
    else
    {
        [cellTF setPlaceholder:@"Enter your Staff ID"];
    }
    
    //ToDo setup keyBoard
    [cellTF setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [cellTF setReturnKeyType:UIReturnKeyDone];
    [cellTF enablesReturnKeyAutomatically];
    [cellTF setClearsOnBeginEditing:YES];
    [cellTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [cellTF setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    if (indexPath.section == 1) {
        [cellTF setReturnKeyType:UIReturnKeyNext];
    }
    
    
    
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndex = indexPath;
    
    
    [_loginTV deselectRowAtIndexPath:indexPath animated:YES];
    
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

#define kOFFSET_FOR_KEYBOARD 80.0 + 44.0

-(void)keyboardWillShow {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:NO];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:YES];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp {
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
}


@end
