//

//

#import "AlertView.h"

@interface AlertView ()
{
    
}
//Private
@property(nonatomic,strong) UIView *backgroundView;
@property double bagAmount;
@property int bagCount;

@end

@implementation AlertView

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


-(void)setupView {
    //Create semi-transparent background
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    
    //Button styling
    [self buttonStyle:_cancelBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButton.png" withTitle:@"Cancel"];
    [_cancelBtn addTarget:self action:@selector(cancelPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self buttonStyle:_saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButton.png" withTitle:@"Confirm"];
    [_saveBtn addTarget:self action:@selector(confirmPressed:) forControlEvents:UIControlEventTouchUpInside];
    //Not convince that this is the best place to set delegate 
    [self.inputAmountTF setDelegate:self];
    
}
#pragma delegate methods for textField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
//    _bagAmount = (double)[NSString stringWithFormat:@"%f", textField.text.doubleValue];
    _bagAmount = (double)textField.text.doubleValue;
    _bagCount += 1;
    
    [textField resignFirstResponder];
    
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
            NSMutableArray *modelArray = [self createDepositModelObject];
            //call this delegate method from HomeVC if _confirmPressed
            if ([self.delegate respondsToSelector:@selector(passScannedData:)]) {
                [self.delegate performSelector:@selector(passScannedData:) withObject:modelArray];
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
- (NSMutableArray *)createDepositModelObject {
    
    NSMutableArray *array = [NSMutableArray array];
    
    //Init custom model object
    Deposit *deposit = [[Deposit alloc]initWithBagNumber:@"987565-4646" bagBarcode:@"987565-4646"
                                               bagAmount: _bagAmount bagCount:_bagCount timeStamp:_timeString];
    
    //Add to collection before passing to delegate
    [array addObject:deposit];
    return array;
}

+(AlertView*)loadFromNibNamed:(NSString*)nibName {
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    AlertView *view = [xib objectAtIndex:0];
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
    
    self.center = view.center;//pass picker.view.center to view
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
