//

//

#import "ITFPopup.h"

#import "Deposit.h"

#import "QRBarcode.h"
#import "EightBarcode.h"

@interface ITFPopup ()
{
    UIBarButtonItem *barBtnFinished;
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

    //_bagAmount = 000.00;
    [_inputAmountTF resignFirstResponder];
}
- (void)doneKBPressed:(UIButton *)sender {
   
    [_inputAmountTF resignFirstResponder];
    
}
- (UIToolbar *)createCustomKBView {
    
    //construct barButtonItems
    UIBarButtonItem *barBtnCancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelKBPressed:)];
    [barBtnCancel setTintColor:[UIColor blackColor]];
    
    barBtnFinished = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneKBPressed:)];
    [barBtnFinished setTintColor:[UIColor blueColor]];
    barBtnFinished.enabled = NO;
    
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField.text length]) {// > 1 && [textField.text length] <= 6) {
        //leave this as is
        _saveBtn.enabled = YES;
   
//        _bagAmount = (double)textField.text.doubleValue;
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
    
    NSMutableString* s = [NSMutableString stringWithString:textField.text];
    
    if(range.location + range.length > textField.text.length) {
        [s appendString:string];
    }
    else {
        [s replaceCharactersInRange:range withString:string];
    }

    NSString* t = [s  stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    long v = [t integerValue];
    long n = v / 100;
    long d = v % 100;
    
    if(v >= 100000) {
       // barBtnFinished.enabled = NO;
        return NO;
    }
    
    if(v > 0) {
        barBtnFinished.enabled = YES;
    }
    else {
        barBtnFinished.enabled = NO;
    }
    textField.text = [NSString stringWithFormat:@"%03ld.%02ld", n, d];
    _bagAmount = (double)textField.text.doubleValue;//assign to iVar here not in didEndEditing
//    _bagCount += 1;
    return NO;
    
}

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
        //else cancel was pressed on ITFPopup
        else
        {
            //ToDo allow rescanning of the scanned bag again
            if ([self.delegate respondsToSelector:@selector(resetBarcodeHistoryWithStatus:)]) {
                [self.delegate performSelector:@selector(resetBarcodeHistoryWithStatus:) withObject:@(YES)];
            }
        }
        
        //dismissed popup and resume scanning mode and save barcode data if applicable
        if ([self.delegate respondsToSelector:@selector(startScanning)]) {
            [self.delegate performSelector:@selector(startScanning)];
            DLog(@"Delgate performSelector");
        }
    }];

}
-(void)cancelPressed:(UIButton *)sender {
    
    _confirmed = NO;//explictly set to NO
    
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
