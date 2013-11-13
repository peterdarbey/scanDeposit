//
//  EightBarcode.h
//  ScanDeposits
//
//  Created by Peter Darbey on 13/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EightBarcode : NSObject


@property (strong, nonatomic) NSString *symbology;


- (void)commonInit:(NSDictionary *)dict;

- (id)initBarcodeWithSymbology:(NSString *)symbology processType:(NSString *)process
        uniqueBagNumber:(NSString *)uniqueNumber;


//getters
- (NSString *)barcodeSymbology;
- (NSString *)barcodeProcess;
- (NSString *)barcodeUniqueBagNumber;

- (NSDictionary *)barcodeDictionaryWithSymbology;

@end
