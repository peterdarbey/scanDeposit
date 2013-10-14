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
//    [picker.overlayController setTextForInitializingCamera:@"Please Wait"];
    [picker startScanning];
    //set the keyboard type
//    [picker.overlayController setSearchBarKeyboardType:UIKeyboardTypeNamePhonePad];
    
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
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonStyle:scanBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected" withTitle:@"Scan Barcode"];
    

//    scanBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    scanBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    
//    [scanBtn setFrame:CGRectMake(self.view.frame.size.width/4, self.view.frame.size.height/2, 180, 44)];
    [scanBtn setFrame:CGRectMake(20, self.view.frame.size.height/2, 280, 44)];
    [scanBtn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}


#pragma mark - Custom delegate method
-(void)startScanning {
    
    [picker startScanning];
    DLog(@"Start scanning delegate");
}

#pragma mark Scandit SDK - delegate methods
- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didScanBarcode:(NSDictionary *)barcodeResult {
    
    //Parse barcode string first before init model obj
    NSString *parseString = barcodeResult[@"barcode"];

    
//    NSPredicate *predicateFilter = [NSPredicate predicateWithFormat:@"code CONTAINS[cd] %@", device];
//    NSArray *filteredArray = [array filteredArrayUsingPredicate:predicateFilter];
    
    NSMutableArray *filteredArray = (NSMutableArray *)[parseString componentsSeparatedByCharactersInSet:
        [NSCharacterSet characterSetWithCharactersInString:@" "]];
     DLog(@"filteredArray>>>>>>>>>>>>>>>: %@ %i", filteredArray, filteredArray.count);//27
    
//     NSMutableArray *childArray = [NSMutableArray arrayWithCapacity:[filteredArray count]];
   
    
   
//    NSArray *wordsArr = [parseString componentsSeparatedByString:@" "];
//    int count = 0;
//    for (NSString *word in wordsArr) {
//        if ([word hasPrefix:@"\"\""]) {
//            count++;
//            NSLog(@"%dth match: %@", count, word);
//        }
//    }
    
    
//    for (int i = 0; i < [filteredArray count]; i++) {
//        if ([[filteredArray objectAtIndex:i] isEqualToString:@"\"/"]) {
//            [filteredArray removeLastObject];
////        NSString *subString = [NSString stringWithFormat:@"%@,",[filteredArray objectAtIndex:i]];
////        [childArray addObject:subString];
////            DLog(@"subString: %@", subString);
//        }
//        
//    }
           DLog(@"parsed filteredArray: %@", filteredArray);
    DLog(@"New count: %i", filteredArray.count);//21
   
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
