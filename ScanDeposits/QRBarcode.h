//
//  QRBarcode.h
//  ScanDeposits
//
//  Created by Peter Darbey on 12/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRBarcode : NSObject

//public
@property (strong, nonatomic) NSString *symbology;


- (void)commonInit:(NSDictionary *)dict;

- (id)initBarcodeWithType:(NSString *)symbology branch:(NSString *)branchNSC
                  process:(NSString *)processType
                   safeID:(int)safeType
                andDevice:(NSString *)device;

//getters
- (NSString *)barcodeSymbology;
- (NSString *)barcodeBranch;
- (NSString *)barcodeProcess;
- (int)barcodeSafeID;
- (NSString *)barcodeDevice;

@end
