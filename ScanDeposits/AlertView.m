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
        // Initialization code
    }
    
    return self;
}

-(void)setupView {
    //Create semi-transparent background
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    
    //Button styling
    [self buttonStyle:_cancelBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButton.png" withTitle:@"Cancel"];
    [self buttonStyle:_saveBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButton.png" withTitle:@"Confirm"];
    
}

+(AlertView*)loadFromNibNamed:(NSString*)nibName {
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    AlertView *view = [xib objectAtIndex:0];
    return view;
}


- (IBAction)dismiss:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(startScanning)]) {
            [self.delegate performSelector:@selector(startScanning)];
            DLog(@"Delgate performSelector");
        }
    }];
    
}

- (IBAction)yesPressed:(id)sender {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
        //Resume scanning
        if ([self.delegate respondsToSelector:@selector(startScanning)]) {
            [self.delegate performSelector:@selector(startScanning)];
            DLog(@"Delgate performSelector");
        }
    }];
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
