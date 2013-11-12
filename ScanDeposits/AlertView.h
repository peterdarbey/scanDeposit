//
//  AlertView.h


#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@class Deposit;

@protocol ResumeScanMode <NSObject>

- (void)startScanning;
- (void)presentDepositsViewController:(NSMutableArray *)array;
- (void)passScannedData:(NSMutableArray *)dataArray;

@end

@interface AlertView : UIView <UITextFieldDelegate>
{
    NSMutableArray *stringArray;
}

-(void)showOnView:(UIView*)view;

+(AlertView*)loadFromNibNamed:(NSString*)nibName;

@property (strong, nonatomic) IBOutlet UITextField *inputAmountTF;

//temp time ivar
@property (strong, nonatomic) NSString *timeString;
//conditional test for init custom deposit model object
@property BOOL confirmed;//ivar so is NO by default

@property (weak, nonatomic) IBOutlet UIView *zoneBackground;
//@property (weak, nonatomic) IBOutlet UILabel *barcodeString;

@property (strong, nonatomic) IBOutlet UILabel *symbologyLbl;
@property (strong, nonatomic) IBOutlet UILabel *branchLbl;

@property (strong, nonatomic) IBOutlet UILabel *processLbl;
@property (strong, nonatomic) IBOutlet UILabel *safeIDLbl;


@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imagePlaceHolder;

//Delegate ivar
@property (weak, nonatomic) id <ResumeScanMode> delegate;

@end
