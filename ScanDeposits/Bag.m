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
    
    

    
    
//    - (void)returnUserModel:(User *)user {
//        
//        //assign to _user
//        _user = user;
//        
//        //Construct an array to populate the headers with initials
//        NSMutableArray *initArray = [NSMutableArray array];
//        [initArray addObject:(NSString *)[user userInitials]];//extract the new user initials
//        [_dataSource addObject:initArray];
//        DLog(@"_dataSource with initArray: %@", _dataSource);//should be initized correct
//        
//        
//        //Init the _userArray with the user fields -> array with values/objects
//        //Make it local
//        NSMutableArray *localUserArray = [NSMutableArray array];
//        [localUserArray addObject:[user userName]];
//        [localUserArray addObject:[user userEMail]];
//        [localUserArray addObject:[user userStaffID]];
//        //Add to the array
//        [_eachUserArray addObject:localUserArray];
//        //     DLog(@"_eachUserArray__: %@ with Count: %i ", _eachUserArray, [_eachUserArray count]);
//        
//        
//        //NOTE only write to file if its not already written to file?
//        if (_fileExists) {
//            //Now write to file
//            //New construct for saving only
//            NSMutableArray *writableArray = [NSMutableArray array];
//            [writableArray addObject:[user userInitials]];
//            [writableArray addObject:[user userName]];
//            [writableArray addObject:[user userEMail]];
//            [writableArray addObject:[user userStaffID]];
//            //Add to the existing stored array
//            NSMutableArray *loadArray = [NSMutableArray arrayWithContentsOfFile:fullPath];//correct
//            DLog(@"loadArray in returnUserModel: %@", loadArray);
//            [loadArray addObject:writableArray];
//            //write here
//            [loadArray writeToFile:fullPath atomically:YES];
//            DLog(@"Writing loadArray to file: %@", loadArray);
//            
//        }//close if
//        
//        
//    }
    
    
    
//    - (void)expandMyTableViewWithIndex:(NSIndexPath *)indexPath {
//        
//        //******** Note ********
//        //Need a conditional test to check the array as this array has not been created via the returnUserModel call
//        NSArray *userValues;
//        
//        if (_fileExists) {
//            
//            NSMutableArray *containerArray = [NSMutableArray array];
//            
//            //retrieve from file first Note values/entries already in the collection dont add again
//            //Moved from else if _fileExists in cellForRowAtIndexPath:
//            NSMutableArray *array =  [NSMutableArray arrayWithContentsOfFile:fullPath];//correct data
//            DLog(@"<< array stored contains >>: %@", array);//correct data
//            DLog(@"indexPath.section is: %i", indexPath.section);//actually correct ?
//            NSMutableArray *sectionArray = [array objectAtIndex:indexPath.section];
//            //                NSMutableArray *sectionArray = [array lastObject];//works but not good practice
//            DLog(@"sectionArray: %@", sectionArray);//index:0 instead of index:1? is the issue
//            tempArray = [NSMutableArray array];
//            
//            //        for (int j = 0; j < [array count]; j++) {
//            //
//            //            NSMutableArray *sectArray = [array objectAtIndex:j];
//            //            for (int i = 0; i < [sectArray count]-1; i++) {//sectionArray
//            //                [tempArray addObject:[sectArray objectAtIndex:i +1]];
//            //            }
//            //            DLog(@"tempArray: %@", tempArray);
//            //
//            //            [containerArray addObject:tempArray];//adding entry 1 twice ?//HIDE
//            //        }
//            //ContainerArray is used for adding to the _dataSource so that it expands with 3 entries
//            //Add as to not overwrite -> adding again when I press user settings ?
//            //dont add here make local -> but needs to add twice
//            //need to ensure enters twice
//            
//            
//            for (int i = 0; i < [sectionArray count]-1; i++) {//sectionArray
//                [tempArray addObject:[sectionArray objectAtIndex:i +1]];
//            }
//            DLog(@"tempArray: %@", tempArray);
//            [containerArray addObject:tempArray];//adding entry 1 twice ?//HIDE
//            DLog(@"containerArray: %@ and count: %i", containerArray, [containerArray count]);
//            
//            
//            
//            userValues = [containerArray objectAtIndex:indexPath.section];//crash only 1 obj thats y as its local
//            DLog(@"In expandMyTblView method containerArray: %@ andCount: %i", containerArray, [containerArray count]);
//            DLog(@"userValues in fileExists*****: %@", userValues);//wrong section object ?
//            
//            NSMutableArray *indexArray = [[NSMutableArray alloc]init];
//            
//            if([[_dataSource objectAtIndex:selectedIP.section]count] > 1) {
//                
//                for (int i = 1; i < 4; i++)
//                {
//                    NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:selectedIP.section];//selected index
//                    [indexArray addObject:index];
//                    [[_dataSource objectAtIndex:selectedIP.section]removeLastObject];
//                    DLog(@"_dataSource contains in loop: %@", _dataSource);
//                }
//                
//            }//close if check
//            
//            
//        }
//        else //Doesnt exist means returnUserModel called
//        {
//            //uniform treat the same
//            //Now get each _userArray out of the _eachUserArray for the apropriate section /selected section
//            userValues = [_eachUserArray objectAtIndex:indexPath.section];//get selected section
//        }
//        
//        //Note indexPath is the selected row and section
//        NSMutableArray *indexArray = [[NSMutableArray alloc]init];
//        
//        //check that its not open -> Note if fileExists its not entering here as it fails count == 1
//        if([[_dataSource objectAtIndex:selectedIP.section]count] == 1) {
//            
//            for (int i = 0; i < [userValues count]; i++) { //3 //new test try i again instead i+1
//                NSIndexPath *index = [NSIndexPath indexPathForRow:i+1 inSection:selectedIP.section];//offset by 1
//                [indexArray addObject:index];
//                //Add the _userArray to the _dataSource collection
//                [[_dataSource objectAtIndex:selectedIP.section]addObject:[userValues objectAtIndex:i]];//_userArray
//                DLog(@"_dataSource contains in expand loop (count == 1) : %@", _dataSource);
//                
//            }//close loop
//            
//            UITableViewCell *cell = [self.userTV cellForRowAtIndexPath:indexPath];
//            iv = cell.imageView;
//            [UIView animateWithDuration:0.3 animations:^{
//                // Rotate the arrow
//                iv.transform = CGAffineTransformMakeRotation(M_PI_2);//rotate down
//            }];
//            
//            [_userTV insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
//            
//        }//close if
//        
//    }

    
    
    
    
    
    //    //Note indexPath is the selected row and section
    //    NSMutableArray *indexArray = [[NSMutableArray alloc]init];
    //
    //    //check that its not open -> Note if fileExists its not entering here as it fails count == 1
    //    if([[_dataSource objectAtIndex:selectedIP.section]count] == 1) {
    //
    //        for (int i = 0; i < [userValues count]; i++) { //3 //new test try i again instead i+1
    //            NSIndexPath *index = [NSIndexPath indexPathForRow:i+1 inSection:selectedIP.section];//offset by 1
    //            [indexArray addObject:index];
    //            //Add the _userArray to the _dataSource collection
    //            [[_dataSource objectAtIndex:selectedIP.section]addObject:[userValues objectAtIndex:i]];//_userArray
    //             DLog(@"_dataSource contains in expand loop (count == 1) : %@", _dataSource);
    //
    //        }//close loop
    //
    //        UITableViewCell *cell = [self.userTV cellForRowAtIndexPath:indexPath];
    //        iv = cell.imageView;
    //        [UIView animateWithDuration:0.3 animations:^{
    //            // Rotate the arrow
    //            iv.transform = CGAffineTransformMakeRotation(M_PI_2);//rotate down
    //        }];
    //
    //        [_userTV insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
    //        
    //    }//close if

    
    
    //CORRECT CELLFORROWATINDEXPATH in USERVC
    
//    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//        
//        static NSString *myIdentifier = @"userCell";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
//        //properties
//        UITextField *userNameTF;
//        UILabel *userNameLbl;
//        
//        
//        if (cell == nil) {
//            
//            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
//            
//            userNameTF = [[UITextField alloc]initWithFrame:CGRectMake(90, cell.bounds.size.height/4, 200, 25)];
//            [userNameTF setBackgroundColor:[UIColor clearColor]];
//            userNameTF.tag = USER_NAME_TF;
//            userNameTF.textAlignment = NSTextAlignmentLeft;
//            userNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;//thats the 1
//            [userNameTF setFont:[UIFont systemFontOfSize:15.0]];
//            userNameTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
//            //ToDo add a BOOL for editable or not
//            //        [userNameTF setUserInteractionEnabled:YES];
//            
//            [userNameTF setUserInteractionEnabled:NO];
//            [userNameTF setEnablesReturnKeyAutomatically:YES];
//            //set textField delegate
//            [userNameTF setDelegate:self];
//            //Add TF to cell
//            [cell.contentView addSubview:userNameTF];
//            
//            userNameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 70 , 25)];
//            userNameLbl.tag = USER_NAME_LBL;
//            userNameLbl.textAlignment = NSTextAlignmentLeft;
//            userNameLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:17];
//            userNameLbl.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
//            userNameLbl.shadowColor = [UIColor grayColor];
//            userNameLbl.shadowOffset = CGSizeMake(1.0, 1.0);
//            userNameLbl.backgroundColor = [UIColor clearColor];
//            [userNameLbl setUserInteractionEnabled:NO];
//            
//            [cell.contentView addSubview:userNameLbl];
//            
//        }//close if
//        
//        else
//        {   //retrieve the properties
//            userNameTF = (UITextField *)[cell.contentView viewWithTag:USER_NAME_TF];
//            userNameLbl = (UILabel *)[cell.contentView viewWithTag:USER_NAME_LBL];
//        }
//        
//        if (([_displayArray count] >= 1 && _user) || ([_displayArray count] >= 1 && _fileExists)) {// was just([_dataSource count] >= 1 && _user) {
//            
//            //Construct keys for iteration
//            NSArray *userKeys = @[@"Initials", @"Name", @"Email", @"Staff ID"];
//            
//            //if selected add extra items to array in expand method
//            if (_isSelected && _isExpanded) {
//                
//                //_dataSource has the appropreiate _userArray containing the 3 fields of each user
//                [userNameTF setText:[NSString stringWithFormat:@"%@", [[_displayArray objectAtIndex:indexPath.section]    objectAtIndex:indexPath.row]]];
//                [userNameLbl setText:[NSString stringWithFormat:@"%@", [userKeys objectAtIndex:indexPath.row]]];
//                
//            }//close if
//            
//            else //not expanded and not selected so just show 1 entry -> the initials
//            {
//                //Added this -> if file exists display its data
//                //            if (_fileExists && _isWritten) {
//                //                DLog(@"Enter fileExists if in else");
//                //test new approach
//                [userNameTF setText:[NSString stringWithFormat:@"%@", [[_displayArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];//0
//                //set UILabel name, should be uniform
//                [userNameLbl setText:[NSString stringWithFormat:@"%@", [userKeys objectAtIndex:indexPath.row]]];
//                //            }
//                //            else
//                //            {
//                //                //set UITextField Initials
//                //                [userNameTF setText:[NSString stringWithFormat:@"%@", [[_displayArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]]];//yes
//                //                //set UILabel name
//                ////                [userNameLbl setText:@"Initials"];//was this -> so far so good
//                //                [userNameLbl setText:[NSString stringWithFormat:@"%@", [userKeys objectAtIndex:indexPath.row]]];
//                //                //maybe save to file here also
//                //            }
//                
//            }//close else
//            
//        }//close if
//        
//        if ([_displayArray count] >= 1) {//was _dataSource
//            
//            if (indexPath.row == 0) {
//                cell.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0];//light white
//                cell.imageView.image = [UIImage imageNamed:@"rightArrow.png"];//add resource
//                
//            }
//            else
//            {
//                cell.backgroundColor = [UIColor whiteColor];
//                cell.imageView.image = nil;
//            }
//        }//close if
//        
//        return cell;
//        
//    }
    
    
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        //remove and write to file -> works but using reloadData instead of deleteRowsAtIndex with anim
//        //        if ([_userTV numberOfRowsInSection:indexPath.section] == 1) {
//        //remove entire entry
//        //            [_displayArray removeObjectAtIndex:indexPath.section];
//        
//        //remove data from storedArray also
//        //            [_storedArray removeObjectAtIndex:indexPath.section];
//        //            [_storedArray writeToFile:fullPath atomically:YES];
//        
//        //reload data into _storedArray from file
//        //            _storedArray = [NSMutableArray arrayWithContentsOfFile:fullPath];
//        //            [_userTV reloadData];//works no smooth anim though
//        //        }//close if
//        
//        
//        DLog(@"_storedArray before deletion>>: %@", _storedArray);
//        
//        //works correctly with smooth animation
//        if ([_userTV numberOfRowsInSection:indexPath.section] == 1)
//        {
//            [[_displayArray objectAtIndex:indexPath.section]removeObjectAtIndex:indexPath.row];//perfect
//            DLog(@"_displayArray after deletion>>: %@", _displayArray);
//            //remove the data from our counterpart storedArray object
//            [_storedArray removeObjectAtIndex:indexPath.section];//except remove whole entry
//            
//            [_userTV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }
//        //write to file
//        [_storedArray writeToFile:fullPath atomically:YES];
//        //reload data into _storedArray from file
//        _storedArray = [NSMutableArray arrayWithContentsOfFile:fullPath];
//        DLog(@"_storedArray after deletion>>: %@", _storedArray);//correct count _displayArray wrong count
//        
//        //radical change
//        //        [_displayArray removeAllObjects];
//        //        DLog(@"Test _displayArray: %@", _displayArray);
//        //        //Construct an array to populate the headers with initials
//        //        for (int i = 0; i < [_storedArray count]; i++) {
//        //            NSMutableArray *initArray = [NSMutableArray array];
//        //            [initArray addObject:[[_storedArray objectAtIndex:i]objectAtIndex:0]];//extract the new user initials
//        //            [_displayArray insertObject:initArray atIndex:i];
//        //        }
//        //        [_userTV reloadData];//works
//        
//    }//close editingStyle if


    
//    - (void)textFieldDidEndEditing:(UITextField *)textField {
//        //retrieve the cell for which the textField was entered
//        UITableViewCell *cell = (UITableViewCell *)[textField.superview superview];
//        NSIndexPath *indexPath = [_loginTV indexPathForCell:cell];
//        UITextField *nextTF;
//        
//        //ADMIN ONLY
//        if (indexPath.section == 0) {
//            DLog(@"Administrator section");
//            //set spinner
//            //[loginBtn setEnabled:NO];
//            if (![textField.text isEqualToString:@""] && [textField.text length] > 3) {
//                
//                //assign to _password
//                _password = textField.text;
//                
//                //set spinner
//                [loginBtn setEnabled:YES];//should be YES
//                //            [loginSpinner setHidden:NO];
//                //            [loginSpinner setAlpha:1.0];
//                
//                _adminValid = YES;
//                
//                [textField resignFirstResponder];
//                
//                
//                //            //iterate through _users collection to check for a valid user
//                //            for (NSDictionary *dict in _admins) {
//                //                NSDictionary *aAdmin = dict[textField.text];
//                //                if ([aAdmin[@"Password"] isEqualToString:textField.text]) {
//                //                    //add to packagedUsers collection
//                //                    [_packagedAdmins setObject:aAdmin forKey:@(1)];//now NSNumbers
//                //                    DLog(@"_packagedAdmins: %@", _packagedAdmins);
//                //                    _adminValid = YES;//aAdmin[@"Passsword"];
//                //                }//close if
//                //
//                //            }//close for
//                //
//                //            //if valid administrator
//                //            if (_adminValid) {
//                //
//                //                //set spinner
//                //                [loginBtn setEnabled:YES];
//                //                [loginSpinner setHidden:YES];
//                //                [loginSpinner setAlpha:0.0];
//                //
//                //                //ToDo create admin package
//                //                [self dismissViewControllerAnimated:YES completion:^{
//                //                    [textField resignFirstResponder];
//                //                    //different custom delegate method call
//                //                    if ([self.delegate respondsToSelector:@selector(dismissLoginVC: isAdmin:)]) {
//                //                        //dismissLoginVC
//                //                        [self.delegate performSelector:@selector(dismissLoginVC: isAdmin:) withObject:_packagedAdmins withObject:@(YES)];
//                //                        DLog(@"New delgate protocol implemented");
//                //                    }
//                //                }];
//                //            }//close if
//                
//            }//close if
//            else
//            {
//                [textField becomeFirstResponder];
//                //if blank display an error message
//            }
//            
//        }//USER 1
//        else if (indexPath.section == 1) {
//            DLog(@"Control User:1 section");
//            if (![textField.text isEqualToString:@""] && [textField.text length] > 3) {
//                
//                //assign to _password
//                _userOne = textField.text;
//                
//                //set spinner
//                [loginBtn setEnabled:YES];
//                _userOneValid = YES;
//                
//                //get next TextField
//                nextTF = [self returnNextTextField:textField];
//                [nextTF becomeFirstResponder];
//                
//                //                //iterate through _users collection to check for a valid user
//                //                for (NSDictionary *dict in _users) {
//                //                    NSDictionary *aUser = dict[textField.text];
//                //                    //if a reg user exists for the textField entry perform some operation
//                //                    if ([aUser[@"Staff ID"] isEqualToString:textField.text]) { // -> User => StaffID
//                //                        //aUser is the specified user via Login textField add to collection
//                //                        [_packagedUsers setObject:aUser forKey:@(1)];//number now associated with a user
//                //                        DLog(@"_packagedUsers: %@", _packagedUsers);
//                //                        _userOneValid = YES;
//                //                    }//close if
//                //
//                //                }//close for
//                //
//                //            //if valid user
//                //            if (_userOneValid) {
//                //                //get next TextField
//                //                nextTF = [self returnNextTextField:textField];
//                //                [nextTF becomeFirstResponder];
//                //            }
//                
//            }//close if
//            else
//            {
//                [textField becomeFirstResponder];
//                //if blank display an error message
//            }
//            
//        }
//        else//USER 2
//        {
//            DLog(@"Control User:2 section");
//            if (![textField.text isEqualToString:@""] && [textField.text length] > 3) {
//                
//                //assign to _password
//                _userTwo = textField.text;
//                
//                //set spinner
//                [loginBtn setEnabled:YES];
//                _userTwoValid = YES;
//                //last textField so resign TextField as its also valid
//                [textField resignFirstResponder];
//                
//                //iterate through _users collection to check for a valid user
//                //                for (NSDictionary *dict in _users) {
//                //                    NSDictionary *aUser = dict[textField.text];
//                //                    if ([aUser[@"Staff ID"] isEqualToString:textField.text]) {
//                //                        //add to packagedUsers collection
//                //                        [_packagedUsers setObject:aUser forKey:@(2)];//now NSNumbers
//                //                        DLog(@"_packagedUsers: %@", _packagedUsers);
//                //                        _userTwoValid = YES;
//                //                    }//close if
//                //
//                //                }//close for
//                //
//                //            //if valid user
//                //            if (_userTwoValid) {
//                //                
//                //                //set spinner
//                //                [loginBtn setEnabled:YES];
//                //                [loginSpinner setHidden:YES];
//                //                [loginSpinner setAlpha:0.0];
//                //                
//                //                //last textField so resign TextField as its also valid
//                //                [textField resignFirstResponder];
//                //
//                //                if ([_packagedUsers count] == 2) {//set to 2
//                //                    //we have two reg logged in users so set a BOOL and dismiss modal
//                //                    
//                //                    [self dismissViewControllerAnimated:YES completion:^{
//                //                        //custom delegate method call
//                //                        if ([self.delegate respondsToSelector:@selector(dismissLoginVC: isAdmin:)]) {
//                //                            //dismissLoginVC
//                //                            [self.delegate performSelector:@selector(dismissLoginVC: isAdmin:) withObject:_packagedUsers withObject:@(NO)];
//                //                            DLog(@"New delegate protocol implemented");
//                //                        }
//                //                    }];
//                //                    
//                //                }//close if
//                //            }
//                
//            }//close if
//            else
//            {
//                [textField becomeFirstResponder];
//                //if blank display an error message
//            }
//            
//        }
//        
//    }
    
    
    //        [UIView animateWithDuration:duration animations:^{
    ////            _registerTV.contentInset =  UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);//keyboardSize.height
    //
    //            [_registerTV setContentOffset:scrollPoint animated:YES];
    //        }];

    
    
    //            //iterate through _users collection to check for a valid user
    //            for (NSDictionary *dict in _admins) {
    //                NSDictionary *aAdmin = dict[textField.text];
    //                if ([aAdmin[@"Password"] isEqualToString:textField.text]) {
    //                    //add to packagedUsers collection
    //                    [_packagedAdmins setObject:aAdmin forKey:@(1)];//now NSNumbers
    //                    DLog(@"_packagedAdmins: %@", _packagedAdmins);
    //                    _adminValid = YES;//aAdmin[@"Passsword"];
    //                }//close if
    //
    //            }//close for
    //
    //            //if valid administrator
    //            if (_adminValid) {
    //
    //                //set spinner
    //                [loginBtn setEnabled:YES];
    //                [loginSpinner setHidden:YES];
    //                [loginSpinner setAlpha:0.0];
    //
    //                //ToDo create admin package
    //                [self dismissViewControllerAnimated:YES completion:^{
    //                    [textField resignFirstResponder];
    //                    //different custom delegate method call
    //                    if ([self.delegate respondsToSelector:@selector(dismissLoginVC: isAdmin:)]) {
    //                        //dismissLoginVC
    //                        [self.delegate performSelector:@selector(dismissLoginVC: isAdmin:) withObject:_packagedAdmins withObject:@(YES)];
    //                        DLog(@"New delgate protocol implemented");
    //                    }
    //                }];
    //            }//close if

    
    
//    - (void)createUserFactory {
//        //Auto set here that they are ADMINs because of context they are in i.e. Admins settings
//        
//        User *user = [[User alloc]initWithName:_name eMail:_eMail
//                                       staffID:_staffID Initials:_initials
//                                       isAdmin:YES withPassword:_adminPassword];
//        
//        
//        //ToDo implement this later -> with write to file and add to an array
//        NSDictionary *adminsDict = [user adminDict];//administrator with password
//        DLog(@"adminsDict: %@", adminsDict);
//        
//        
//        //Create a local array
//        NSMutableArray *localUserArray = [NSMutableArray array];
//        [localUserArray addObject:[user userName]];
//        [localUserArray addObject:[user userEMail]];
//        [localUserArray addObject:[user userStaffID]];
//        [localUserArray addObject:[user userPassword]];
//        
//        //in editing mode
//        if (_allowEdit) {
//            //need to allow overwriting of data for admins here
//            if ([_adminArray count] == 1) { //but no admins or only one setup
//                
//                //add each object to its particular collection at index 1
//                [_administratorArray insertObject:adminsDict atIndex:1];
//                
//                //Add to the overAll collection
//                [_adminArray insertObject:localUserArray atIndex:1];
//            }
//            
//        }
//        //not in editing mode but no admins or only one setup
//        else if (!_allowEdit && [_adminArray count] < 2) {
//            
//            
//        }
//        
//        
//        
//        [_administratorArray addObject:adminsDict];
//        //write to file here also
//        [_administratorArray writeToFile:adminsPath atomically:YES];
//        DLog(@"_administratorArray: %@", _administratorArray);
//        
//        
//        //Create a local array
//        NSMutableArray *localUserArray = [NSMutableArray array];
//        [localUserArray addObject:[user userName]];
//        [localUserArray addObject:[user userEMail]];
//        [localUserArray addObject:[user userStaffID]];
//        [localUserArray addObject:[user userPassword]];
//        //Add to the overAll collection
//        [_adminArray addObject:localUserArray];
//        DLog(@"_adminArray__: %@ with Count: %i ", _adminArray, [_adminArray count]);
//        //write to file
//        [_adminArray writeToFile:filePath atomically:YES];
//        _isWritten = YES;
//        
//    }
    
//    - (NSString *)convertMyCollectionFromCollection:(NSMutableArray *)deposits {
//        
//        
//        NSString *__block parsedString = [[NSMutableString alloc]init];
//        
//        //Sent as an attachment -> Note: this is all the data we need to send pertaining to a lodgement
//        //    NSMutableArray *adminArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];//NOW admin
//        
//        DLog(@"_depositsArray contains: %@", _depositsCollection);// --> actual bag deposit details
//        //extract the required fields for attachment
//        NSMutableArray *depositArray = [NSMutableArray array];
//        DLog(@"depositArray: %@", depositArray);
//        
//        for (id object in _depositsCollection) {
//            Deposit *deposit = (Deposit *)object;
//            NSMutableArray *array = [NSMutableArray array];
//            //        [array addObject:[deposit timeStamp]];//actual time
//            [array addObject:@([deposit bagAmount])];//each bag amount
//            [array addObject:[deposit bagNumber]];//Unique bag number -> now Process
//            [array addObject:[deposit bagBarcode]];//Unigue bag number
//            //add to depositArray
//            [depositArray addObject:array];//crash
//        }
//        //add the total amount and count at the end
//        //    [depositArray addObject:@([Deposit totalBagsAmount])];
//        //    [depositArray addObject:@([Deposit totalBagCount])];
//        
//        
//        
//        double bagAmount;
//        NSString *uniqueBagNo;
//        //now format the array with required fields for CSV attachment
//        for (NSArray *array in depositArray) {
//            for (int i = 0; i < [array count]; i++) {
//                
//                NSString *bagBarcode;
//                NSString *appendedString;
//                //retrieve each element and format
//                if (i == 0) {
//                    bagAmount = [array[i]doubleValue];
//                }
//                else if (i == 1) {
//                    uniqueBagNo = array[i];
//                }
//                else if (i == 2 && bagAmount && uniqueBagNo) {
//                    bagBarcode = array[i];
//                    appendedString = [NSString stringWithFormat:@"€%.2f,%@,%@,\n", bagAmount, uniqueBagNo, bagBarcode];
//                    DLog(@"appendedString: %@", appendedString);
//                    parsedString = [parsedString stringByAppendingString:appendedString];//452.130000,A Coin Only Dropsafe,19005349, --> Dont forget newLine escape seq
//                }
//                
//            }//close inner for
//            
//        }//close outer for
//        
//        DLog(@"parsedString>>>>>>>>>>>>>: %@", parsedString);
//        return parsedString;// --> use excel xml format and create headers
//        
//    }

    
    //        NSMutableDictionary *appData = [[NSMutableDictionary alloc]init];
    //        NSData *attachData = [NSPropertyListSerialization dataFromPropertyList:appData format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    
    //        [mailController addAttachmentData:csvData
    //                                 mimeType:@"text/csv" //@"application/pdf" or text/plain or @"mime"
    //                                 fileName:@"usersCollection.plist"];//@"CSVFile.csv" -> works as plist fileName

    
    
    //        SuccessPopupVC *successVC = [[SuccessPopupVC alloc]initWithNibName:@"SuccessPopupVC" bundle:nil];
    //        DLog(@"SuccessPopupVC: %@", successVC);
    //        [successVC showOnView:self.view];//test
    
    
    //        //Log the user out and reset --> moved to SuccessPopup
    //        if ([self.delegate respondsToSelector:@selector(resetDataAndPresentLogInVC)]) {
    //            [self.delegate performSelector:@selector(resetDataAndPresentLogInVC)];
    //        }
    
    //add delay to view message
    //        double delayInSeconds = 2.0;//wont need
    //        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    //        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    //            //return to HomeVC
    //            [self.navigationController popToRootViewControllerAnimated:YES];
    //        });
    
    
    
//    -(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//        
//        DLog(@"selectedIP in numOfSects: %@", selectedIndexPath);
//        
//        //item has been removed and its the selected item section
//        //    if (_valueRemoved && selectedIndexPath.section == section) {
//        //        return 0;
//        //    }
//        //    else
//        //    {
//        //        return 1;
//        //    }
//        
//        return 1;//should always be one
//    }


    
}

@end
