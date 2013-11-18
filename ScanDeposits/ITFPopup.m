//

//

#import "ITFPopup.h"

#import "Deposit.h"

#import "QRBarcode.h"
#import "EightBarcode.h"

@interface ITFPopup ()
{
    
}
//Private
@property(nonatomic,strong) UIView *backgroundView;
@property double bagAmount;
@property int bagCount;

@end

@implementation ITFPopup

@synthesize zoneBackground = _zoneBackground;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //init here
        _bagAmount = 000.00;
        _bagCount = 0;
    }
    
    return self;
}
- (void)cancelKBPressed:(UIButton *)sender {

    [_inputAmountTF resignFirstResponder];
}
- (void)doneKBPressed:(UIButton *)sender {
   
    [_inputAmountTF resignFirstResponder];
    
}
- (UIToolbar *)createCustomKBView {
    
    //construct barButtonItems
    UIBarButtonItem *barBtnCancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelKBPressed:)];
    [barBtnCancel setTintColor:[UIColor blackColor]];
    
    UIBarButtonItem *barBtnFinished = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneKBPressed:)];
    [barBtnFinished setTintColor:[UIColor blueColor]];
    
    //Add a divider for the toolBar barButtonItems
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *barBtnArray = [NSArray arrayWithObjects:barBtnCancel, flexible, barBtnFinished, nil];
    
    UIToolbar *customTB = [[UIToolbar alloc]initWithFrame:CGRectMake(0 , 0, 50, 44)];
    
    [customTB setBarStyle:UIBarStyleBlackTranslucent];
    customTB.items = barBtnArray;
    return customTB;

}
-(void)setupView {
    //Create semi-transparent background
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    //init string array
    stringArray = [NSMutableArray array];
    
    //init our barcodeArray -> wait its passed to us
    
    [_inputAmountTF setKeyboardType:UIKeyboardTypeNumberPad];
    
    //construct a keyBoard view to sit on KB
    [_inputAmountTF setInputAccessoryView:[self createCustomKBView]];
    
    
    //Button styling
    [self buttonStyle:_cancelBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"Cancel"];
    [_cancelBtn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self buttonStyle:_saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"Confirm"];
    [_saveBtn addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    //Not convince that this is the best place to set delegate 
    [self.inputAmountTF setDelegate:self];
    
}
#pragma delegate methods for textField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField.text length] > 5) {
        DLog(@"greater than 5 characters disable textField");
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField.text length] > 1) {
        //enable the button only if the chars dont exceed 5 without decimal
        //user can only enter 5 numbers without . and 3 on left with .
        //option: 1 could remove the decmial equation by changing the KB
        //option: 2 condtionals in shouldChange method
        
        //leave this as is
        _saveBtn.enabled = YES;
   
        _bagAmount = (double)textField.text.doubleValue;
        _bagCount += 1;
        DLog(@"_bagAmount: %f", _bagAmount);
        
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
    
    NSString *previousValue = [[[textField.text stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] stringByReplacingOccurrencesOfString:@"." withString:@""] stringByReplacingOccurrencesOfString:@"," withString:@""];
    DLog(@"previousValue>>>>>: %@", previousValue);//all without the decimal 1st entery not here until 2nd entered then all entries
    string = [string stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
    DLog(@"string>>>>>: %@", string);//single current char
    NSString *modifiedValue = [NSString stringWithFormat:@"%@%@", previousValue, string];
    DLog(@"modifiedValue>>>>>: %@", modifiedValue);//adds together
    if ([modifiedValue length] == 1) {
        
        modifiedValue = [NSString stringWithFormat:@"0.0%@", string];
        
    }
    
    else if ([modifiedValue length] == 2) {
        
        modifiedValue = [NSString stringWithFormat:@"0.%@%@", previousValue, string];
        
    }
    
    else if ([modifiedValue length] > 2) {
        
        modifiedValue = [NSString stringWithFormat:@"%@.%@",[modifiedValue substringToIndex: modifiedValue.length-2],[modifiedValue substringFromIndex:modifiedValue.length-2]];
        
    }
    
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSDecimalNumber *decimal = [NSDecimalNumber decimalNumberWithString:modifiedValue];
    modifiedValue = [formatter stringFromNumber:decimal];

    if ([string isEqualToString:@"0"] && modifiedValue.length < 5) {
        DLog(@"Allow 0 entry");//goes in but not allowed by decimal
        textField.text = modifiedValue;
    }
    else if (![string isEqualToString:@"0"] && modifiedValue.length <= 6) {
        textField.text = modifiedValue;
        DLog(@"Do not allow 0 entry");
    }
    
//    if (modifiedValue.length > 7) {
//        DLog(@"Sorry value to big");
//        //NOTE: problem with the 0 entry
//        //show alert here
//    }
//    else
//    {
//        textField.text = modifiedValue;
//    }
//    textField.text = modifiedValue;
    
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
-(void)dismissPopupAndResumeScanning {
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        
        //only executed if user presses confirm
        if (_confirmed) {
            
            //Init custom model object and add to collection before passing to delegate
            Deposit *deposit = [self createDepositModelObject];
            //call this delegate method from HomeVC if _confirmPressed
            if ([self.delegate respondsToSelector:@selector(passScannedData:)]) {
                [self.delegate performSelector:@selector(passScannedData:) withObject:deposit];
            }
            
        }//close if
        
        //dismissed popup and resume scanning mode and save barcode data if applicable
        if ([self.delegate respondsToSelector:@selector(startScanning)]) {
            [self.delegate performSelector:@selector(startScanning)];
            DLog(@"Delgate performSelector");
        }
    }];

}
-(void)cancelPressed:(UIButton *)sender {
    //Cancel does NOT create a deposit model object just dismisses picker 
    [self dismissPopupAndResumeScanning];
    
}
//_saveBtn
-(void)confirmPressed:(UIButton *)sender {
    
    _confirmed = YES;
    [self dismissPopupAndResumeScanning];
    
}

#pragma factory method
- (Deposit *)createDepositModelObject {
    
    DLog(@"_barcodeArray: %@", _barcodeArray);
    
    QRBarcode *qrBarcode;
    EightBarcode *eightBarcode;
    
    if ([[_barcodeArray objectAtIndex:0] isKindOfClass:[QRBarcode class]]) {
        qrBarcode = [_barcodeArray objectAtIndex:0];
    }
    
    
    if ([[_barcodeArray lastObject] isKindOfClass:[EightBarcode class]]) {
         eightBarcode = [_barcodeArray lastObject];//always the last object as QR is first and its an ordered collection
    }
    
    DLog(@"eightBarcode barcodeUniqueBagNumber: %@", [eightBarcode barcodeUniqueBagNumber]);
    
    //Init custom model object have to pass the unique bag number here plus maybe the QR branch or something?
    Deposit *deposit = [[Deposit alloc]initWithBagNumber:[qrBarcode barcodeProcess]// --> think thats right
                                              bagBarcode:[eightBarcode barcodeUniqueBagNumber] bagAmount: _bagAmount bagCount:_bagCount timeStamp:_timeString];
    
    return deposit;
}

+(ITFPopup *)loadFromNibNamed:(NSString*)nibName {
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    ITFPopup *view = [xib objectAtIndex:0];
    return view;
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
    CGPoint offset = CGPointMake(view.center.x, view.center.y -30);
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
