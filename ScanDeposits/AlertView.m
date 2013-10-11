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
    _backgroundView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_backgroundView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];//semi trans
    
//    UIImage *stretch = [[UIImage imageNamed:@"alertViewBg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
//    UIImageView *bgStretchView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
//    bgStretchView.image = stretch;
//    [self insertSubview:bgStretchView atIndex:0];
    
    UIImage *stretchButon = [[UIImage imageNamed:@"blueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
    [self.cancelBtn setBackgroundImage:stretchButon forState:UIControlStateNormal];
    UIImage *stretchSelectedButton = [[UIImage imageNamed:@"blueButtonSelected.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.cancelBtn setBackgroundImage:stretchSelectedButton forState:UIControlStateHighlighted];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    stretchButon = [[UIImage imageNamed:@"blueButton.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10,10,10,10)];
    [self.saveBtn setBackgroundImage:stretchButon forState:UIControlStateNormal];
    stretchSelectedButton = [[UIImage imageNamed:@"blueButtonSelected.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.saveBtn setBackgroundImage:stretchSelectedButton forState:UIControlStateHighlighted];
    [self.saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

+(AlertView*)loadFromNibNamed:(NSString*)nibName {
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
    AlertView *view = [xib objectAtIndex:0];
    return view;
}

+(void)showAlertFromNibName:(NSString*)nibName OnView:(UIView*)view {
    [[AlertView loadFromNibNamed:nibName] showOnView:view];
}

- (IBAction)dismiss:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
    }];
    
}

- (IBAction)yesPressed:(id)sender {

    
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.alpha = 0.0;
//        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//        UINavigationController *navController = (UINavigationController *) appDelegate.window.rootViewController;
        
            } completion:^(BOOL finished) {
        [_backgroundView removeFromSuperview];
    }];
}


-(void)showOnView:(UIView*)view {
    [self setupView];
    
    
    self.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
    
    self.center = view.center;
    
    [view addSubview:_backgroundView];
    [_backgroundView addSubview:self];
    
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
