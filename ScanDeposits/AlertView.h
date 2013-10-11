//
//  AlertView.h


#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@protocol ResumeScanMode <NSObject>

-(void)startScanning;

@end

@interface AlertView : UIView

-(void)showOnView:(UIView*)view;

- (IBAction)dismiss:(id)sender;
- (IBAction)yesPressed:(id)sender;

+(AlertView*)loadFromNibNamed:(NSString*)nibName;

@property (weak, nonatomic) IBOutlet UIView *zoneBackground;
@property (weak, nonatomic) IBOutlet UILabel *barcodeString;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imagePlaceHolder;
//Delegate ivar
@property (weak, nonatomic) id <ResumeScanMode> delegate;

@end
