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

    
    
    
//    //construct a 2nd TextField
//    UITextField *offCounterTF = [[UITextField alloc]initWithFrame:CGRectMake(120, 45, 180, 25)];
//    [offCounterTF setBackgroundColor:[UIColor clearColor]];
//    [offCounterTF setDelegate:self];
//    [offCounterTF setFont:[UIFont systemFontOfSize:15]];
//    offCounterTF.textAlignment = NSTextAlignmentLeft;
//    offCounterTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    offCounterTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
//    [offCounterTF setUserInteractionEnabled:NO];
//    [offCounterTF setText:[NSString stringWithFormat:@"Counter Value"]];//pop dynamically
//    //set textField delegate
//    [offCounterTF setDelegate:self];
//    //add to view
//    [innerView addSubview:offCounterTF];
    
    
    
//    - (void)keyboardWillShow:(NSNotification *)notification {
//        
//        if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
//            DLog(@"KeyBoardWillAppear");
//            //keyboard frame
//            kbSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//            NSTimeInterval duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//            
//            //        CGRect areaRect = _registerTV.frame;
//            
//            [UIView animateWithDuration:duration animations:^{
//                //only resize tableView when its in transition
//                _registerTV.frame = CGRectMake(0, 0, 320, _registerTV.frame.size.height - kbSize.height);//keyboard frame
//                //            CGRect rect = _registerTV.frame;
//                
//                UITableViewCell *cell = (UITableViewCell *)[_registerTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//                
//                UITableViewCell *hiddenCell = (UITableViewCell *)[_registerTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
//                
//                CGRect areaRect = _registerTV.frame;//(0, 0, 320, 332) -keyboard
//                
//                DLog(@"cell.frame.origin.x: %f andY %f andX %f andY %f", cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);//(0, 489, 320, 45)
//                //wont
//                if (!CGRectContainsPoint(areaRect, cell.frame.origin)) {
//                    
//                    //if this cells location is not inside the tblView when keyboard appears scroll
//                    if (!CGRectContainsPoint(areaRect, cell.frame.origin)) {
//                        //                [_registerTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                        CGPoint scrollPoint = CGPointMake(0, cell.frame.origin.y - areaRect.size.height);//areaRect.size.height
//                        
//                        [_registerTV setContentOffset:scrollPoint animated:YES];
//                        
//                    }
//                }
//                else if (!CGRectContainsPoint(areaRect, hiddenCell.frame.origin))
//                {
//                    if (!CGRectContainsPoint(areaRect, hiddenCell.frame.origin)) {
//                        //                [_registerTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                        CGPoint scrollPoint = CGPointMake(0, cell.frame.origin.y - areaRect.size.height);//areaRect.size.height
//                        
//                        [_registerTV setContentOffset:scrollPoint animated:YES];
//                        
//                    }
//                }
//                
//                
//            }];
//            
//        }
    
        //    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        //    UITableViewCell *cell = (UITableViewCell*)[_registerTV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
        //    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:NAME_TF];
        //    CGRect textFieldRect = [textField convertRect:textField.frame toView:self.view];
        //    if (textFieldRect.origin.y + textFieldRect.size.height >= [UIScreen mainScreen].bounds.size.height - keyboardSize.height) {
        //        NSDictionary *info = [notification userInfo];
        //        NSNumber *number = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        //        double duration = [number doubleValue];
        //        [UIView animateWithDuration:duration animations:^{
        //            _registerTV.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
        //        }];
        //        NSIndexPath *pathOfTheCell = [_registerTV indexPathForCell:cell];
        //        [_registerTV scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:pathOfTheCell.row inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        //    }
        
        
        
//    }

    
    //CellForRowAtIndex in UserVC
//    if ([_dataSource count] >= 1 && _user) {
//        
//        //if selected add extra items to array in expand method
//        if (_isSelected && _isExpanded) { //add !_isEXpanded
//            
//            //Construct keys for iteration
//            NSArray *userKeys = @[@"Initials", @"Name", @"Email", @"Staff ID"];
//            
//            //_dataSource has the appropreiate _userArray containing the 3 fields of each user
//            [userNameTF setText:[NSString stringWithFormat:@"%@", [[_dataSource objectAtIndex:indexPath.section]    objectAtIndex:indexPath.row]]];
//            [userNameLbl setText:[NSString stringWithFormat:@"%@", [userKeys objectAtIndex:indexPath.row]]];
//            DLog(@"_dataSource structure: %@", _dataSource);
//        }//close if
//        
//        else //not expanded so just show 1 entry -> the initials
//        {
//            //set UITextField Initials
//            [userNameTF setText:[NSString stringWithFormat:@"%@", [[_dataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];//yes
//            //set UILabel name
//            [userNameLbl setText:@"Initials"];
//        }
//        
//    }//close if
    
    

    
}

@end
