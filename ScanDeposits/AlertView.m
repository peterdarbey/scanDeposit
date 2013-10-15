//

//

#import "AlertView.h"

@interface AlertView ()

@property(nonatomic,strong) UIView *backgroundView;

@end

@implementation AlertView

@synthesize zoneBackground = _zoneBackground;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
    [_saveBtn addTarget:self action:@selector(savePressed:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)dismissPopupAndResumeScanning {
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        //dismissed popup and resume scanning mode and save barcode data if applicable
        if ([self.delegate respondsToSelector:@selector(startScanning)]) {
            [self.delegate performSelector:@selector(startScanning)];
            DLog(@"Delgate performSelector");
        }
    }];

}
-(void)cancelPressed:(UIButton *)sender {
    
    [self dismissPopupAndResumeScanning];
    
}

-(void)savePressed:(UIButton *)sender {
    
    //Note if behaviour doesnt change encapsulate in a seperate method
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [_backgroundView removeFromSuperview];
                         //call another delegate method
                         if ([self.delegate respondsToSelector:@selector(presentDepositsViewController)]) {
                             [self.delegate performSelector:@selector(presentDepositsViewController)];
                         }
                     }];
    
    
//    [self dismissPopupAndResumeScanning];
    //ToDo ->Add data persistence if required here
    
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
