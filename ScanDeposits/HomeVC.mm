//
//  HomeVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 09/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "HomeVC.h"


@interface HomeVC ()

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

#pragma mark Scandit SDK - delegate methods
- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didScanBarcode:(NSDictionary *)barcodeResult {
    
    NSDictionary *barcodeDict = barcodeResult;
    
    //create our custom model object
    Barcode *barcodeObject = [Barcode instanceFromDictionary:barcodeResult];
    DLog(@"didScanBarcode with <<<<barcodeObject>>>>: %@", barcodeObject);
    
    //retrieve the barcode string from the barcode recognition engine
    NSString *barcodeString = barcodeDict[@"barcode"];
    DLog(@"didScanBarcode with barcodeString: %@", barcodeString);
    
    NSString *barcodeSymbology = barcodeDict[@"symbology"];
    DLog(@"didScanBarcode with barcodeSymbology: %@", barcodeSymbology);
    
}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController
                didCancelWithStatus:(NSDictionary *)status {
    DLog(@"didCancel");
}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController
                    didManualSearch:(NSString *)input {
    DLog(@"didManualSearch");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    DLog(@"viewDidLoad");
    
    ScanditSDKBarcodePicker *picker =
    [[ScanditSDKBarcodePicker alloc] initWithAppKey:kScanditSDKAppKey];
    picker.overlayController.delegate = self;
    [picker startScanning];
//    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
    
    [self presentViewController:picker animated:YES completion:^{
    [picker setModalPresentationStyle:UIModalPresentationPageSheet];
    [picker setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
