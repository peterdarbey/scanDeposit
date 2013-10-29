//
//  PopupTV.m
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "PopupTV.h"
//#import "User.h"

@implementation PopUpTV

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
//        [self setRowHeight:44];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *view = [[UIView alloc]init];
        view.frame = self.bounds;
        view.backgroundColor = [UIColor clearColor];
        self.backgroundView = view;//works
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topWhiteDropCell.png"]];//waiting for a cell for this
//        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topWhiteDropCellSelected.png"]];
//    }
//    else if (indexPath.row == [self numberOfRowsInSection:0] -1) {
//        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottomWhiteDropCell.png"]];
//        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottomWhiteDropCellSelected.png"]];
//    }
//    else {
//        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"midWhiteDropCell.png"]];
//        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"midWhiteDropCellSelected.png"]];
//    }
}

#pragma Delegate textField methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (UITextField *)returnNextTextField:(UITextField *)textField {
    //retrieve the cell that contains the textField
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    
    //increment the indexPath.row to retrieve the next cell which contains the next textField
    cell = (UITableViewCell *)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row +1 inSection:indexPath.section]];
    //the next TextField
    UITextField *nextTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];//100
    return nextTF;
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
    
- (void)textFieldDidEndEditing:(UITextField *)textField {
    //for conditional
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    
    UITextField *nextTF;
    
    //textField superview corresponds to
    if (indexPath.row == 0) {
        //if TF is not empty resign/assign
        if (![textField.text isEqualToString:@""] && [textField.text length] > 1) {
            
            [textField resignFirstResponder];//resign 1st
            //assign text to user ivar
            self.name = textField.text;//Mmm
            if (self.name) { //Watch for doble spaces
                
                //create Initials from userName field
                [self createInitialsFromText:textField.text];
                
            }//close if
            
            DLog(@"NameString: %@", _name);
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
            self.eMail = textField.text;
            DLog(@"eMailString: %@", _eMail);
            //next textFiueld
            nextTF = [self returnNextTextField:textField];
            [nextTF becomeFirstResponder];
        }//close inner if
        else
        {
            [textField becomeFirstResponder];
        }
        
    }
    else
    {   //pass code 6 digits -> staffID field
        if (![textField.text isEqualToString:@""] && [textField.text length] >= 6) {
            //resign previous responder status
            [textField resignFirstResponder];
            
            //assign staffID here
            self.staffID = textField.text;
            DLog(@"staffID: %@", self.staffID);
            
        }//close inner if
        else
        {
            [textField becomeFirstResponder];
        }
    }
    
    if (_name && _eMail && _staffID) {
        DLog(@"<<<<<<<<<<<< Enter create User model conditional >>>>>>>>>");
        //Not right place for User model init
        //no confirm button to enable
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//always minimum 1
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"popCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    UITextField *userNameTF;
    UILabel *userNameLbl;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        
        userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(75, cell.bounds.size.height/4, 165, 25)];
        [userNameTF setBackgroundColor:[UIColor clearColor]];
        userNameTF.tag = USER_NAME_TF;
        userNameTF.textAlignment = NSTextAlignmentLeft;
        userNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//thats the 1
        [userNameTF setFont:[UIFont systemFontOfSize:15.0]];
        //set the minimum size of this email field
        [userNameTF setMinimumFontSize:14.0];
        [userNameTF setEnablesReturnKeyAutomatically:YES];
        
        userNameTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        [userNameTF setUserInteractionEnabled:YES];
        
        //set textField delegate
        [userNameTF setDelegate:self];
        //Add TF to cell
        [cell.contentView addSubview:userNameTF];
        
        userNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 60 , 25)];
        userNameLbl.tag = USER_NAME_LBL;
        userNameLbl.textAlignment = NSTextAlignmentLeft;
        userNameLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        userNameLbl.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        userNameLbl.shadowColor = [UIColor grayColor];
        userNameLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        userNameLbl.backgroundColor = [UIColor clearColor];
        [userNameLbl setUserInteractionEnabled:NO];
        
        [cell.contentView addSubview:userNameLbl];
        
    }
    else
    {
        userNameTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];
        userNameLbl = (UILabel *)[cell.contentView viewWithTag:USER_NAME_LBL];
        
    }
    
    if (indexPath.row == 0) {
//        [userNameTF setText:[NSString stringWithFormat:@"David Roberts"]];//temp will be dynamic
        [userNameLbl setText:@"Name"];
        
        //set keyboard type
        [userNameTF setKeyboardType:UIKeyboardTypeDefault];
        [userNameTF setReturnKeyType:UIReturnKeyNext];
        [userNameTF enablesReturnKeyAutomatically];
        [userNameTF setClearsOnBeginEditing:YES];
        [userNameTF setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [userNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
        
    }
    else if (indexPath.row == 1) {
        
        [userNameLbl setText:@"Email"];
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
//        [userNameTF setPlaceholder:@"Staff ID"];
        [userNameLbl setText:@"Staff ID"];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIP = indexPath;
    
    //deselect
    [self deselectRowAtIndexPath:indexPath animated:YES];
}


@end
