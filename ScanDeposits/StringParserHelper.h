//
//  StringParserHelper.h
//  ScanDeposits
//
//  Created by Peter Darbey on 18/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringParserHelper : NSObject

+ (NSString *)getFilePathForName:(NSString *)fileName;

+ (NSDictionary *)parseQRBarcodeFromString:(NSString *)barcodeString;
+ (NSDictionary *)parseILBarcodeFromString:(NSString *)barcodeString withBarcodeType:(NSString *)barcodeType;

+ (NSString *)parseMyCollection:(NSMutableArray *)array;

@end
