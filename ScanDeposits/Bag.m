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

    
}

@end
