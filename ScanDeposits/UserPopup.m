//
//  UserPopup.m
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "UserPopup.h"

#import "PopupTV.h"

@interface UserPopup ()
{
    
}
//Private
@property(nonatomic,strong) UIView *backgroundView;

@end


@implementation UserPopup

@synthesize zoneBackground = _zoneBackground;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init here
        
    }
    
    return self;
}

//- (UIToolbar *)createCustomKBView {
//    
//    //construct barButtonItems
//    UIBarButtonItem *barBtnCancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelKBPressed:)];
//    [barBtnCancel setTintColor:[UIColor blackColor]];
//    
//    UIBarButtonItem *barBtnFinished = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneKBPressed:)];
//    [barBtnFinished setTintColor:[UIColor blueColor]];
//    
//    //Add a divider for the toolBar barButtonItems
//    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    NSArray *barBtnArray = [NSArray arrayWithObjects:barBtnCancel, flexible, barBtnFinished, nil];
//    
//    UIToolbar *customTB = [[UIToolbar alloc]initWithFrame:CGRectMake(0 , 0, 50, 44)];
//    
//    [customTB setBarStyle:UIBarStyleBlackTranslucent];
//    customTB.items = barBtnArray;
//    return customTB;
//    
//}

-(void)setupView {
    //Create semi-transparent background
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    //init string array
    stringArray = [NSMutableArray array];
    
    
//    //construct a keyBoard view to sit on KB
//    [_inputAmountTF setInputAccessoryView:[self createCustomKBView]];
    
    _popupTV = [[PopUpTV alloc]initWithFrame:CGRectMake(0, 0, _popupView.frame.size.width, _popupView.frame.size.height) style:UITableViewStyleGrouped];
    //_popupTV has the delegate property so have to set from there
//    [_popupTV setUserDelegate:self];
    [self.popupView addSubview:_popupTV];//works
    
    
    //Button styling
    [self buttonStyle:_cancelBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"Cancel"];
    [_cancelBtn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self buttonStyle:_confirmBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"Confirm"];
    [_confirmBtn addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    //Not convince that this is the best place to set delegate
//    [self.inputAmountTF setDelegate:self];
    
}

#pragma delegate methods for textField
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField.text length] > 1) {
        //enable the button only if the chars dont exceed 5 without decimal
        //user can only enter 5 numbers without . and 3 on left with .
        //option: 1 could remove the decmial equation by changing the KB
        //option: 2 condtionals in shouldChange method
        
        //leave this as is
        _confirmBtn.enabled = YES;
        
    }
    
    [textField resignFirstResponder];
    
}

- (NSString *)validateStringFromUserInput:(NSString *)inputText {
    
    NSMutableArray *editStrArray = (NSMutableArray *)[inputText componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
    DLog(@"arrayOfStringComponents>>>>>: %@", editStrArray);
    [stringArray addObject:[editStrArray lastObject]];
    NSString *newString = [editStrArray objectAtIndex:0];
    DLog(@"newString: %@", newString);
    DLog(@"stringArray: %@", stringArray);
    
    return newString;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if([[string stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]]
        isEqualToString:@""])
        return YES;
    
   
    
    return NO;
    
}

//better approach
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    //replace what the user entered with this string
//
//    //if entered text is > 5 lets check its content
//    if ([string isEqualToString:@"."]) {
//        DLog(@"Less than 4");
//
//        [self validateStringFromUserInput:textField.text];
////        NSMutableArray *editStrArray = (NSMutableArray *)[textField.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"."]];
////        DLog(@"arrayOfStringComponents>>>>>: %@", editStrArray);
////        [stringArray addObject:[editStrArray lastObject]];
////        NSString *newString = [editStrArray objectAtIndex:0];
////        DLog(@"newString: %@", newString);
////        DLog(@"stringArray: %@", stringArray);
//    }
//
//
//    //Check the 4th character entered
//    if ([[textField.text stringByReplacingCharactersInRange:range withString:string] length] == 4) {
//        DLog(@"STRING: %@", string);//really a char //current value -> value just entered
//        //4th character entered check if its a @"."
//        if (![string isEqualToString:@"."]) {
//            DLog(@"Right the string has a 4th 0 so too big: %@", string);//hits here
//            // so remove last entry
////            NSString *edString = [textField.text stringByDeletingLastPathComponent];//might work
////            NSString *removeString = string;
//            NSString *edString = [textField.text stringByReplacingCharactersInRange:range withString:@"."];
//            DLog(@"edString: %@", edString);//321. worked now tell user
//            textField.text = edString;
////            textField.placeholder = edString;
//        }
//
//    }//close outter if
//
//
//        return YES;//should be replaced
//}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}
-(void)dismissPopup {
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        
    }];
    
}
-(void)cancelPressed:(UIButton *)sender {
    //Cancel does NOT create a deposit model object just dismisses picker
    [self dismissPopup];
    
}
//_saveBtn
-(void)confirmPressed:(UIButton *)sender {
    
    DLog(@"_popupTV.staffID: %@", _popupTV.staffID);//null why
    
    if (_popupTV.name && _popupTV.eMail && _popupTV.staffID && _popupTV.initials) {
        DLog(@"Enter create User model conditional");
        //Not right place for User model init
        
        //NOTE users admin property set to = NO
        //NOTE: could check user key isAdmin and determine here if admin as user and allow login auto for user
        //if I did that though they couldnt use app 
        //create user model set NO as default for isAdmin and pass back to the UserVC
        User *user = [[User alloc]initWithName:_popupTV.name eMail:_popupTV.eMail
                                       staffID:_popupTV.staffID Initials:_popupTV.initials isAdmin:NO withPassword:@"Not Authorized"];//was nil -> fixed
        
        //NOTE never Admin when this method is called from the PopupTV class
        DLog(@"User>>>>>: %@", user);
        //create a delegate method
        //Test
        if ([self.userDelegate respondsToSelector:@selector(returnUserModel:)]) {
            [self.userDelegate performSelector:@selector(returnUserModel:) withObject:user];
            DLog(@"Custom User Delegate preformed");
            //need another delegate method to refresh the tblView
        }
        if ([self.userDelegate respondsToSelector:@selector(refreshView)]) {
            [self.userDelegate performSelector:@selector(refreshView)];//called works
        }
    }
    [self dismissPopup];
    
}

#pragma factory method
//- (User *)createDepositModelObject {
//    
//    //    NSMutableArray *array = [NSMutableArray array];
//    
//    //Init custom model object
//    User *user = [[Deposit alloc]initWithBagNumber:@"987565-4646" bagBarcode:@"987565-4646"
//                                               bagAmount: _bagAmount bagCount:_bagCount timeStamp:_timeString];
//    
//    //Add to collection before passing to delegate
//    //    [array addObject:deposit];
//    return user;
//}

+(UserPopup *)loadFromNibNamed:(NSString*)nibName {
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    UserPopup *userPopup = [xib objectAtIndex:0];
    return userPopup;
}

//Button styling
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

-(void)showOnView:(UIView*)view {
    [self setupView];
    
    self.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    CGPoint offset = CGPointMake(view.center.x, view.center.y -15);
    //    self.center = view.center;//pass picker.view.center to view
    self.center = offset;
    self.layer.cornerRadius = 5.0;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    
    [view addSubview:_backgroundView];
    [_backgroundView addSubview:self];//Need to add self to background
    
    [UIView animateWithDuration:0.2
                     animations:^{
                         [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
                         self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.1 animations:^{
                             self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                         }];
                     }];
}


@end
