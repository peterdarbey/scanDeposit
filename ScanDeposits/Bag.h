//
//  Bag.h
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bag : NSObject
{
//    static int totalBagNumber;
}

@property int totalBagCount;

//+(int)numberOfBags;




//- (NSDictionary *)parseBarcodeFromString:(NSString *)barcodeString {
//    
//    //NOTE: parse first
//    //construct an array with the substrings separated by commas -> 3 entries
//    NSArray *array = [barcodeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];//create a dictionary from data in string
//    
//    //create objects for iteration operations
//    NSMutableString *stringEntry = [NSMutableString string];
//    NSMutableArray *elementArray = [NSMutableArray array];
//    
//    //iterate each comma separated string in the array
//    for (NSString *string in array) {
//        //retrieve each string of K / V pairs
//        stringEntry = (NSMutableString *)string;
//        //construct another array by separating ":"
//        NSArray *valueArray = [stringEntry componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
//        [elementArray addObject:valueArray];
//    }//close for
//    
//    //create objects for iteration operations
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    NSMutableArray *kvPairsArray = [NSMutableArray array];
//    
//    //iterate
//    for (NSMutableArray *valueArray in elementArray) {
//        for (int i = 0; i < [valueArray count]; i++) {
//            NSString *entryString = [valueArray objectAtIndex:i];
//            //removes the white space if any and replaces in the source array
//            NSString *keyString = [entryString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            //replace string in collection
//            [valueArray replaceObjectAtIndex:i withObject:keyString];
//            //if index:1 remove the backslash
//            if (i == 1) {
//                keyString = [keyString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
//                [dict setObject:keyString forKey:[valueArray objectAtIndex:0]];//stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];//works fine but probably a better way
//            }
//            //add to collection
//            [kvPairsArray addObject:keyString];
//        }//close inner for
//        
//    }//close outer for
//    
//    //        DLog(@"kvPairsArray: %@", kvPairsArray);//works
//    DLog(@"*** dict ***: %@", dict);//works
//    
//    return dict;
//}



@end
