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
        // Custom initialization
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

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        DLog(@"Cancel button pressed");//correct
        //start picker again
    }
    else
    {
         DLog(@"Save button pressed");
        //Perhaps add data persistence here
        //Save and start picker again
    }
        //UIAlertView has been dismissed so resume scanning mode
         [picker startScanning];
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


#pragma mark Scandit SDK - delegate methods
- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didScanBarcode:(NSDictionary *)barcodeResult {
    
    //create our custom model object
    Barcode *barcodeObject = [Barcode instanceFromDictionary:barcodeResult];
    //Add to collection
    [_barcodeArray addObject:barcodeObject];
    //retrieve the barcode string from the barcode recognition engine
    DLog(@"barcode from model object>>>>>>>>: %@", barcodeObject.barcode);
    DLog(@"barcode symbology: %@", barcodeObject.symbology);
    
    //present alertView and temp stop scanning
    [picker stopScanning];
    
    //ToDo: Create a custom Alert -> PopupView.xib
//    PopupView *popup = [[PopupView alloc]initWithFrame:CGRectMake(100, 100, 240, 160)];
//    [self.view addSubview:popup];
    
    PopupAV *popup = [[PopupAV alloc]initWithNibName:@"PopupAV" bundle:Nil];
    popup.barcodeString.text = [NSString stringWithFormat:@"Barcode is: %@", barcodeObject.barcode];
    [popup showOnView:picker.view];//works
    DLog(@"picker.view.center: %f and Y: %f", picker.view.center.x, picker.view.center.y);//(160, 294)
    
//    [self.view addSubview:popup];
    
    
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Scanned Successfully" message:[NSString stringWithFormat:@"Barcode is %@", barcodeObject.barcode] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
//    [alertView show];
    
}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didCancelWithStatus:(NSDictionary *)status {
    
    DLog(@"status dictionary: %@", status);
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [picker stopScanning];
    }];
}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didManualSearch:(NSString *)input {
    
    DLog(@"didManualSearch with Input: %@", input);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
