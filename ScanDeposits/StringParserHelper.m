//
//  StringParserHelper.m
//  ScanDeposits
//
//  Created by Peter Darbey on 18/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "StringParserHelper.h"

@implementation StringParserHelper
{
    
}


+ (NSString *)getFilePathForName:(NSString *)fileName
{
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectoryPath stringByAppendingPathComponent:fileName];
    
    return fullPath;
}


+ (NSString *)convertMyCollection {
    
    
    NSString *__block parsedString = [[NSMutableString alloc]init];
    NSString *__block newString = [[NSMutableString alloc]init];
    
    
    //sent inline with subject body -> need to get this working
    NSMutableArray *userArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePathForName:@"usersCollection.plist"]];
    
    //ToDo add comma separated pairs to collection
    [userArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        for (NSArray *array in userArray) {
            for (int i = 0; i < [array count]; i++) {
                //retrieve each element
                obj = [array objectAtIndex:i];
                //cast and format
                NSString *stringObj = (NSString *) [NSString stringWithFormat:@"%@,", obj];//@"\"%@\","
                //add to collection
                parsedString = [parsedString stringByAppendingString:stringObj];
                newString = [parsedString stringByAppendingString:stringObj];
            }
        }
        
        DLog(@"newString: %@", newString);
    }];
    
    DLog(@"parsedString >>>>>: %@", parsedString);
    
    NSString *tabString = [NSString stringWithFormat:@"%@\t\t\t\t", newString];
    DLog(@"tabString: %@", tabString);
    return tabString; //newString
    
}

//parses the QR barcode string for external device and creates a dictionary
+ (NSDictionary *)parseQRBarcodeFromString:(NSString *)barcodeString {
    
    //parse functionality
    //construct an array with the substrings separated by commas -> 3 entries
    NSArray *array = [barcodeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];//create a dictionary from data in string
    
    //create objects for iteration operations
    NSMutableString *stringEntry = [NSMutableString string];
    NSMutableArray *elementArray = [NSMutableArray array];
    
    //iterate each comma separated string in the array
    for (NSString *string in array) {
        //retrieve each string of K / V pairs
        stringEntry = (NSMutableString *)string;
        //construct another array by separating ":"
        NSArray *valueArray = [stringEntry componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        [elementArray addObject:valueArray];
    }//close for
    
    //create objects for iteration operations
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *kvPairsArray = [NSMutableArray array];
    
    //iterate
    for (NSMutableArray *valueArray in elementArray) {
        //iterate through each Key / Value pair in valuesArray
        for (int i = 0; i < [valueArray count]; i++) {
            NSString *entryString = [valueArray objectAtIndex:i];
            //removes the white space if any and replaces in the source array
            NSString *keyString = [entryString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            //replace string in collection
            [valueArray replaceObjectAtIndex:i withObject:keyString];
            //if index:1 remove the backslash
            if (i == 1) {
                keyString = [keyString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
                [dict setObject:keyString forKey:[valueArray objectAtIndex:0]];//works but probably a better way
            }
            //add to collection
            [kvPairsArray addObject:keyString];
        }//close inner for
        
    }//close outer for
    
    //        DLog(@"kvPairsArray: %@", kvPairsArray);//nice
    
    return dict;
}

//parse method for parsing the 2/5 interleaved barcode string
+ (NSDictionary *)parseILBarcodeFromString:(NSString *)barcodeString withBarcodeType:(NSString *)barcodeType {
    
    //190053495691 --> current bag barcode string
    //Process Type comes from 1st 3 digits of barcode
    NSString *processString = [barcodeString substringToIndex:3];//correct -> 190 first 3 digits
    DLog(@"processString: %@", processString); //barcodeResult[@"symbology"];
    
    //assigned by conditional
    NSString *processType;
    
    //if processString isEq to 291 then its "A Coin Only Dropsafe"
    if ([processString isEqualToString:@"291"]) {
        DLog(@"Process Type: %@", processString);
        
        processType = @"A Coin Only Dropsafe";
        //if not a valid barcode then dont allow user to proceed
        //display warning message again
        //ToDo record the digits in an array to check the bag scanned is never the same again -> see sdk didScan
        
        
    }//close if
    
    //else its not a recognised barcode --> tin of beans
    else
    {
        processType = @"Not a valid barcode";
    }
    
    //construct a dict for 2/5 interleaved model
    NSDictionary *dict = @{@"Symbology" : barcodeType, @"Process Type" : processType, @"Unique Bag Number" : barcodeString};
    
    return dict;
}



@end
