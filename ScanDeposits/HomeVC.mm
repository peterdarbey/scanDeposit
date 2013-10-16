//
//  HomeVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 09/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "HomeVC.h"


@interface HomeVC ()
{
    ScanditSDKBarcodePicker *picker;
}

@end

@implementation HomeVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)buttonTapped:(UIButton *)sender
{
    picker =
    [[ScanditSDKBarcodePicker alloc] initWithAppKey:kScanditSDKAppKey];
    picker.overlayController.delegate = self;
    [picker.overlayController showSearchBar:YES];
    [picker.overlayController showToolBar:YES];
    [picker.overlayController setToolBarButtonCaption:@"Cancel"];
    
    [picker.overlayController setTextForInitializingCamera:@"Please Wait"];
    [picker startScanning];
    //set the keyboard type
    [picker.overlayController setSearchBarKeyboardType:UIKeyboardTypeNamePhonePad];//lose keybopard toolbar
    
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _barcodeArray = [NSMutableArray array];
    
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.title = NSLocalizedString(@"Home Screen", @"Home Screen");
    
    //Construct a imageView
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
    [self.view addSubview:imgView];
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonStyle:scanBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Scan Barcode"];
    

//    scanBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    scanBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    
//    [scanBtn setFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height/2, 180, 44)];
    [scanBtn setFrame:CGRectMake(20, self.view.frame.size.height/2, 280, 44)];
    [scanBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    
    UIButton *moneyBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonStyle:moneyBagBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"MoneyBag"];
    [moneyBagBtn setFrame:CGRectMake(20, self.view.frame.size.height/3, 280, 44)];
    [moneyBagBtn addTarget:self action:@selector(moneyBagTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:moneyBagBtn];
    
}
-(void)moneyBagTapped:(UIButton *)sender
{
    //Create a custom Alert -> AlertView.xib
    AlertView *popup = [AlertView loadFromNibNamed:@"InputFundsView"];
    [popup showOnView:self.view];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}


#pragma mark - Custom delegate method
- (void)presentDepositsViewController:(NSMutableArray *)array {
    
    
    //TEST
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
    DepositsVC *depositsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DepositsVC"];
    depositsVC.title = NSLocalizedString(@"Deposits", @"Deposits View");
//    depositsVC.depositAmount = [[depositsArray objectAtIndex:0]doubleValue];//should be Bag model or NSdict//pass the barcodeData collection to our new view
//    depositsVC.depositCount = [[depositsArray objectAtIndex:1]intValue];//should be Bag model or NSdict
    
    depositsVC.depositsArray = array;
    [self.navigationController pushViewController:depositsVC animated:YES];
    DLog(@"Push to viewController delegate method called");
}

-(void)startScanning {
    
    [picker startScanning];
    DLog(@"Start scanning delegate");
}

#pragma mark Scandit SDK - delegate methods
- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didScanBarcode:(NSDictionary *)barcodeResult {
    
    //Parse barcode string first before init model obj
    NSString *parseString = barcodeResult[@"barcode"];
    
    NSMutableArray *filteredArray = (NSMutableArray *)[parseString componentsSeparatedByCharactersInSet:
        [NSCharacterSet characterSetWithCharactersInString:@" "]];
     DLog(@"filteredArray>>>>>>>>>>>>>>>: %@ %i", filteredArray, filteredArray.count);//27
    
//    NSArray *wordsArr = [parseString componentsSeparatedByString:@" "];
//    int count = 0;
//    for (NSString *word in wordsArr) {
//        if ([word hasPrefix:@"\"\""]) {
//            count++;
//            NSLog(@"%dth match: %@", count, word);
//        }
//    }
 
    DLog(@"parseString: %@", parseString);
    
//    NSString *filteredString = [parseString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"Device"]];
//    DLog(@"filteredString: %@", filteredString);
    
    
    //create our custom model object with the barcode data from the retrieved barcode recognition engine
    Barcode *barcodeObject = [Barcode instanceFromDictionary:barcodeResult];//will need custom initWith method
    //Add to collection
    [_barcodeArray addObject:barcodeObject];
    
    DLog(@"barcode from model object>>>>>>>>: %@", barcodeObject.barcode);
    
    //present alertView and temp stop scanning
    [picker stopScanning];

    /*********ToDO will need some variation on the barcode scanning process to deter the scan owner ie safe or bag
    will be a value within the scan data to determine the type of scan owner then on if check for that
    and displayv accordingly
    differ alertView perhaps
    **********/
    
    
    
    //Create a custom Alert -> AlertView.xib
    AlertView *popup = [AlertView loadFromNibNamed:@"AlertView"];
    //Add custom delegate method here to restart picker scanning
    [popup setDelegate:self];
    //set the barcode text
    popup.barcodeString.text = [NSString stringWithFormat:@"%@", barcodeObject.barcode];
    [popup showOnView:picker.view];
}

//-(void)showPopup {
//    //Create a custom Alert -> AlertView.xib
//    AlertView *popup = [AlertView loadFromNibNamed:@"AlertView"];
//    //Add custom delegate method here to restart picker scanning
//    [popup setDelegate:self];
//    //set the barcode text
//    popup.barcodeString.text = [NSString stringWithFormat:@"%@", barcodeObject.barcode];
//    [popup showOnView:picker.view];
//}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didCancelWithStatus:(NSDictionary *)status {
    
    DLog(@"status dictionary: %@", status);
//    [picker.overlayController searchBarTextDidEndEditing:picker.overlayController];
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [picker stopScanning];//why cancel
    }];
}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didManualSearch:(NSString *)input {
    
    NSDictionary *manualDict = @{@"barcode" : input, @"symbology" : @"None defined"};
    DLog(@"manualDict is: %@", manualDict);
    
    //Create our custom model object
    Barcode *barcodeObject = [Barcode instanceFromDictionary:manualDict];
    [_barcodeArray addObject:barcodeObject];
    
    //Create a custom Alert -> AlertView.xib
    AlertView *popup = [AlertView loadFromNibNamed:@"AlertView"];
    //Add custom delegate method here to restart picker scanning
    [popup setDelegate:self];
    //set the barcode text
    popup.barcodeString.text = [NSString stringWithFormat:@"%@", barcodeObject.barcode];
    [popup showOnView:picker.view];
    
    DLog(@"didManualSearch with Inputed from barcodeObject: %@", barcodeObject.barcode);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
