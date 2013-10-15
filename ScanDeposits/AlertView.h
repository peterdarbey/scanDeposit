//
//  AlertView.h


#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#import "Deposit.h"

@protocol ResumeScanMode <NSObject>

- (void)startScanning;
- (void)presentDepositsViewController:(NSMutableArray *)array;

@end

@interface AlertView : UIView <UITextFieldDelegate>

-(void)showOnView:(UIView*)view;

+(AlertView*)loadFromNibNamed:(NSString*)nibName;

@property (strong, nonatomic) IBOutlet UITextField *inputAmountTF;

@property (weak, nonatomic) IBOutlet UIView *zoneBackground;
@property (weak, nonatomic) IBOutlet UILabel *barcodeString;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imagePlaceHolder;

//Delegate ivar
@property (weak, nonatomic) id <ResumeScanMode> delegate;

@end
