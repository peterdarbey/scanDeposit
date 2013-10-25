//
//  Bag.m
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "Bag.h"

@interface Bag ()
{
    
}
//Private members
@property int *number;
@property double total;
@property (strong, nonatomic) NSString *barcode;

@end


@implementation Bag
{
    
    
    //set inidivual cells
//    if (indexPath.row == 0) {
//        //        [userNameTF setText:[NSString stringWithFormat:@"David Roberts"]];//temp will be dynamic
//        //Test
//        [userNameTF setText:[NSString stringWithFormat:@"%@", [_user userName]]];//works
//        [userNameLbl setText:@"Name"];
//        //set keyboard type
//        [userNameTF setKeyboardType:UIKeyboardTypeDefault];
//        [userNameTF setReturnKeyType:UIReturnKeyNext];
//        [userNameTF enablesReturnKeyAutomatically];
//        [userNameTF setClearsOnBeginEditing:YES];
//        [userNameTF setAutocapitalizationType:UITextAutocapitalizationTypeWords];
//        [userNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
//    }
//    else if (indexPath.row == 1)
//    {
//        [userNameTF setText:[NSString stringWithFormat:@"%@", [_user userEMail]]];//hard code here
//        [userNameLbl setText:@"Email"];//temp will be dynamic
//        //set keyboard type
//        [userNameTF setKeyboardType:UIKeyboardTypeEmailAddress];
//        [userNameTF setReturnKeyType:UIReturnKeyNext];
//        [userNameTF enablesReturnKeyAutomatically];
//        [userNameTF setClearsOnBeginEditing:YES];
//        [userNameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//        [userNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
//    }
//    else if (indexPath.row == 2)//probably just 3 cells as initials will be on section header
//    {
//        [userNameTF setText:[NSString stringWithFormat:@"%@", [_user userStaffID]]];//hard code here
//        [userNameLbl setText:@"Staff ID"];//temp will be dynamic
//        //set keyboard type
//        [userNameTF setKeyboardType:UIKeyboardTypeEmailAddress];
//        [userNameTF setReturnKeyType:UIReturnKeyNext];
//        [userNameTF enablesReturnKeyAutomatically];
//        [userNameTF setClearsOnBeginEditing:YES];
//        [userNameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//        [userNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
//    }
//    
//    else //or leave as 3 entries
//    {
//        [userNameTF setText:[NSString stringWithFormat:@"%@", [_user userInitials]]];//hard code here
//        [userNameLbl setText:@"Initials"];//temp will be dynamic
//        //set keyboard type
//        [userNameTF setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
//        [userNameTF setReturnKeyType:UIReturnKeyDone];
//        [userNameTF enablesReturnKeyAutomatically];
//        [userNameTF setClearsOnBeginEditing:YES];
//        [userNameTF setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//        [userNameTF setAutocorrectionType:UITextAutocorrectionTypeNo];
//    }

    
    
    
    
    
    
    
    
    
//    //Only enters here when dataSource is init when thr returnUserModel method is called on confirmBtn press
//    if ([_dataSource count] >= 1) {//[_dataSource count] {
//        //retrieve the user for each section
//        //        _user = [_dataSource objectAtIndex:indexPath.section];//section as row is constantly 1
//        
//        
//        //all the meaningful data I need -> 3
//        //        _userArray = [userDetailsArray objectAtIndex:indexPath.section];//assigning a string
//        [_userArray addObject:[userDetailsArray objectAtIndex:indexPath.section]];//assigning 3 objects was
//        //        _userArray = userDetailsArray;
//        DLog(@"userArray contains: %@ in Section: %i", _userArray, indexPath.section);//different users, starts at 0 index   3 items in section: 0
//        //        [[_dataSource objectAtIndex:indexPath.section]addObject:_user];
//        DLog(@"test dataSource now -> %@", _dataSource);
//        
//        //if expanded add extra items to array
//        if (_isSelected) {
//            //add array to dataSource if expanded
//            //            [[_dataSource objectAtIndex:indexPath.section]addObject:_user];
//            //            [[_dataSource objectAtIndex:indexPath.section]addObject:[_user userName]];//all user details here
//            //            [[_dataSource objectAtIndex:indexPath.section]addObject:[_user userEMail]];
//            //            [[_dataSource objectAtIndex:indexPath.section]addObject:[_user userStaffID]];
//            
//            //            [_dataSource addObjectsFromArray:userDetailsArray];//userDetailsArray user represents a section
//            DLog(@"dataSource now contains->: %@", _dataSource);
//            //retrieves an array and then a string
//            //            [userNameTF setText:[NSString stringWithFormat:@"%@", [[_dataSource objectAtIndex:indexPath.section]    objectAtIndex:indexPath.row]]];
//            [userNameTF setText:[NSString stringWithFormat:@"%@", [[_dataSource objectAtIndex:indexPath.section]    objectAtIndex:indexPath.row]]];
//            
//            //set UILabel name with allKey values from _dataSource
//            //            NSDictionary *userDict = (NSDictionary *)[_dataSource objectAtIndex:indexPath.section];
//            //            NSArray *allKeys = [userDict allKeys];
//            //            DLog(@"All keys: %@", allKeys);
//            //            NSArray *allValues = [userDict allValues];
//            //            [userNameLbl setText:[NSString stringWithFormat:@"%@", [allValues objectAtIndex:indexPath.row]]];
//            
//            NSArray *array = (NSArray *)[_dataSource objectAtIndex:indexPath.section];
//            //            NSArray *allValues = [array objectAtIndex:indexPath.section];
//            [userNameLbl setText:[NSString stringWithFormat:@"%@", [array objectAtIndex:indexPath.row]]];
//            //            [userNameLbl setText:@"Initials"];//needs to be allKeys Again
//        }
//        
//        else //not expanded so just show 1 entry -> the initials
//        {
//            //Maybe add _dataSource here the inital string
//            NSDictionary *entryDict = [_initialsArray objectAtIndex:indexPath.row];
//            DLog(@"entryDict>>>: %@", entryDict);//Initial = P;
//            [userNameTF setText:[NSString stringWithFormat:@"%@", [[_dataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];//yes
//            //set UILabel name
//            [userNameLbl setText:@"Initials"];
//        }
//        
//    }//close if

    
}

@end
