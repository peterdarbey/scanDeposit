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

//- (NSMutableArray *)collectMyData {
//    
//    //_barcodeArray --> QR + ITF barcode data
//    DLog(@"barcodeArray: %@", _barcodeArray);
//    
//    if (_barcodeArray) {
//        
//        //extract the barcode objects required values
//        for (id object in _barcodeArray) {
//            
//            if ([object isKindOfClass:[QRBarcode class]]) {
//                QRBarcode *qrBarcode = (QRBarcode *)object;
//                //Add elements to the array
//                [_dataArray addObject:[qrBarcode barcodeBranch]];
//                [_dataArray addObject:[qrBarcode barcodeProcess]];
//                [_dataArray addObject:@([qrBarcode barcodeSafeID])];//Device
//            }
//            //                else if ([object isKindOfClass:[EightBarcode class]]) {
//            //                    EightBarcode *ITFBarcode = (EightBarcode *) object;
//            //                    //added last 6digits --> Sequence Number
//            //                    [_dataArray addObject:[[ITFBarcode barcodeUniqueBagNumber]substringFromIndex:6]];
//            //                    [_dataArray addObject:[ITFBarcode barcodeUniqueBagNumber]];//dont need
//            //                }
//            
//        }//close for
//    }
//    
//    DLog(@"depositsCollection: %@", _depositsCollection);
//    if (_depositsCollection) {
//        
//        for (id object in _depositsCollection) {
//            if ([object isKindOfClass:[Deposit class]]) {
//                Deposit *deposit = (Deposit *)object;
//                //                [_dataArray addObject:[deposit bagNumber]];// is QR Process instead
//                //added last 6digits --> Sequence Number
//                [_dataArray addObject:[[deposit bagBarcode]substringFromIndex:6]];//has ITF
//                [_dataArray addObject:[deposit bagBarcode]];//has ITF --> barcodeUniqueBagNumber
//                [_dataArray addObject:@([deposit bagCount])];//int
//                [_dataArray addObject:@([deposit bagAmount])];//double
//                [_dataArray addObject:[deposit timeStamp]];//add date/time
//            }
//        }//close for
//        //dont forget static methods ie count and amount total
//        [_dataArray addObject:@([Deposit totalBagCount])];//should be right
//        [_dataArray addObject:@([Deposit totalBagsAmount])];
//        
//    }
//    
//    DLog(@"_usersDict: %@", _usersDict);
//    //extract the logged in users details
//    if (_usersDict) { // --> a dict with 2 k / v pairs
//        
//        
//        //extract the users Name and Email details for logged in users
//        //userOne
//        NSDictionary *userOneDict = _usersDict[@1];
//        [_dataArray addObject:userOneDict[@"Name"]];
//        [_dataArray addObject:userOneDict[@"Email"]];
//        //userTwo
//        NSDictionary *userTwoDict = _usersDict[@2];
//        [_dataArray addObject:userTwoDict[@"Name"]];
//        [_dataArray addObject:userTwoDict[@"Email"]];
//        
//    }//close userDict
//    
//    //Also need Administrators after --> use the adminsCollection.plist for this data
//    NSMutableArray *adminArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];//NOW admin
//    DLog(@"adminArray: %@", adminArray);
//    
//    //    if (adminArray) {
//    //
//    //        for (id object in adminArray) {
//    //            if ([object isKindOfClass:[NSArray class]]) {
//    //                NSArray *adminArray = (NSArray *)object;
//    //            }
//    //        }
//    //    }
//    
//    DLog(@"<<<<<<<< _dataArray contents >>>>>>>>>>: %@", _dataArray);
//    
//    
//    return _dataArray;
//}


+ (NSString *)parseMyCollection:(NSMutableArray *)array {
    
    NSMutableString *parsingString = [[NSMutableString alloc]init];
    NSString *finalString;
    
    if (array) {
        
        for (int i = 0; i < [array count]; i++) {
            NSString *string;
            //string
            if ([array[i] isKindOfClass:[NSString class]]) {
                string = [NSString stringWithFormat:@"%@,", array[i]];
                parsingString = (NSMutableString *)[parsingString stringByAppendingString:string];
            }
            else if ([array[i] isKindOfClass:[NSNumber class]]) {
                //double
                if ((strcmp([array[i] objCType], @encode(double)) == 0)) {
                    string = [NSString stringWithFormat:@"€%.2f,", [array[i]doubleValue]];
                    parsingString = (NSMutableString *)[parsingString stringByAppendingString:string];
                }
                //integer
                else if ((strcmp([array[i] objCType], @encode(int)) == 0)) {
                    string = [NSString stringWithFormat:@"%i,", [array[i]intValue]];
                    parsingString = (NSMutableString *)[parsingString stringByAppendingString:string];
                }
            }//else if close
            
            finalString = parsingString;
        }
        
        DLog(@"finalString: %@", finalString);//correct
        
        //test building xml for csv file
        //        NSString *XML= [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">\n<en-note>%@",finalString];
        
        
    }
    return finalString;
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
