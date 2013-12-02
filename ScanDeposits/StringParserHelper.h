//
//  StringParserHelper.h
//  ScanDeposits
//
//  Created by Peter Darbey on 18/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Deposit;

@interface StringParserHelper : NSObject

+ (NSString *)getFilePathForName:(NSString *)fileName;

+ (NSDictionary *)parseQRBarcodeFromString:(NSString *)barcodeString;
+ (NSDictionary *)parseILBarcodeFromString:(NSString *)barcodeString withBarcodeType:(NSString *)barcodeType;

+ (NSMutableDictionary *)iterateWithKeySetsFromCollection:(NSArray *)keysArray;

//parse by appending string and adding commas
+ (NSString *)parseMyCollectionWithCommas:(NSMutableArray *)array;
//parse by appending string
+ (NSString *)parseMyCollection:(NSMutableArray *)array;

//test
+ (NSMutableArray *)createXMLSSFromCollection:(NSMutableArray *)array;

//Fintan
+ (NSMutableArray *)createXMLFromCollectionFin:(NSMutableArray *)array andDeposits:(NSMutableArray *)deposits;

//new
+ (NSMutableArray *)createXMLSSFromArray:(NSMutableArray *)array andDictionary:(NSMutableDictionary *)dict;
+ (NSMutableArray *)parseValue:(id)obj forKey:(NSString *)key addToCollection:(NSMutableArray *)array;

//new test
+ (NSMutableArray *)parseValue:(id)obj addToCollection:(NSMutableArray *)array;

@end
