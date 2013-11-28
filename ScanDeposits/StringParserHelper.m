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

+ (NSMutableArray *)createXMLSSFromCollection:(NSMutableArray *)array {
    
    //Test construction of excel xml structure --> xmlss format
    //DTD import
    NSString *xmlDTD = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
    NSString *xmlWBOpen = @"<Workbook";
    //schemas
    NSString *xmlSchemas = @" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\">";
    
    NSString *xmlWBClose = @"</Workbook>";
    NSString *xmlWSOpen = @"<ss:Worksheet ss:Name=\"AppData\">";
    NSString *xmlWSClose = @"</ss:Worksheet>";
    NSString *xmlTblOpen = @"<ss:Table>";
    NSString *xmlTblClose = @"</ss:Table>";
    NSString *xmlColumn = @"<ss:Column ss:Width=\"80\"/>";
    NSString *xmlColumnSpan = @"<Column ss:Span=\"15\" ss:Width=\"80\"/>";
    //styles
    NSString *xmlStyles = @"<Styles><Style ss:ID=\"s1\"><Interior ss:Color=\"#800008\" ss:Pattern=\"Solid\"/></Style></Styles>";
    
    //row contruction
    NSString *xmlRowOpen = @"<ss:Row>";
    NSString *xmlRowClose = @"</ss:Row>";
    NSString *xmlCellOpen = @"<ss:Cell>";
    NSString *xmlCellClose = @"</ss:Cell>";
    
    //Bold style
    NSString *xmlBoldStyle = @"<Row ss:Index=\"1\" ss:Height=\"14\"><Cell><ss:Data xmlns=\"http://www.w3.org/TR/REC-html40\" ss:Type=\"String\">Branch NSC <Font html:Color=\"#ff0000\"><I><U>UnderLine</U></I></Font> askd<B>Bold</B>This is working</ss:Data></Cell><Cell ss:StyleID=\"s1\"><Data ss:Type=\"String\">Process No</Data></Cell></Row>";
    
    //array construct for new xml collection
    NSMutableArray *__block xmlArray = [NSMutableArray array];
    //construct the header and various imports with view hierarchy structure
    //add the necessary headers and DTD metaData to the collection first
    [xmlArray addObject:xmlDTD];//docType
    [xmlArray addObject:xmlWBOpen];//WorkBook
    [xmlArray addObject:xmlSchemas];//add all necessary schemas
    [xmlArray addObject:xmlStyles];//style rules
    [xmlArray addObject:xmlWSOpen];//WorkSheet
    [xmlArray addObject:xmlTblOpen];//Table
    [xmlArray addObject:xmlColumn];//Column test
    [xmlArray addObject:xmlColumnSpan];//add the span
    [xmlArray addObject:xmlBoldStyle];//test this entry
    //add the first row
    [xmlArray addObject:xmlRowOpen];
    
    //key construct for xml creation method
    NSArray *keysArray = @[@"Branch NSC", @"Process No", @"Safe ID", @"Device Type", @"Sequence No:"
                           , @"Unique Bag No:", @"Bag Count", @"Bag Value", @"Date/Time", @"Total Count", @"Total Value", @"User:1 Name", @"User:1 Email", @"User:2 Name", @"User:2 Email", @"Administrator:1", @"Administrator:2"];
    
    //enumerate and add to the xmlArray all the heading --> all 16
    [keysArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            //construct the heading first with titles
            NSString *string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", obj];
            [xmlArray addObject:xmlCellOpen];
            [xmlArray addObject:string];
            [xmlArray addObject:xmlCellClose];
        }
    }];
    //close the first row
    [xmlArray addObject:xmlRowClose];
    
    //add the first row
    [xmlArray addObject:xmlRowOpen];
    //Need to add array aka _dataArray with matching count of keysArray
    
    //new data structure for xml spreadsheet intergration
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithObjects:array forKeys:keysArray];
    DLog(@"dataDict for xml construct*******: %@", dataDict);
    
    //enumerate the collection and add xml structure and content
    [dataDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyStr = (NSString *)key;
        
        //dont need conditionals as Im only taking the values now so 1 iteration
        xmlArray = [StringParserHelper parseValue:obj forKey: keyStr addToCollection:xmlArray];
        
    }];
    
    //close the first row
    [xmlArray addObject:xmlRowClose];
    //then add the closing format types
    [xmlArray addObject:xmlTblClose];//Table Close
    [xmlArray addObject:xmlWSClose];//WorkSheet Close
    [xmlArray addObject:xmlWBClose];//WorkBook Close
    
    
    DLog(@"xmlArray -------->: %@", xmlArray);
    
    return xmlArray;
}


+ (NSMutableArray *)parseValue:(id)obj forKey:(NSString *)key addToCollection:(NSMutableArray *)array  {
    
    //row contruction
//    NSString *xmlRowOpen = @"<ss:Row>";
//    NSString *xmlRowClose = @"</ss:Row>";
    NSString *xmlCellOpen = @"<ss:Cell>";
    NSString *xmlCellClose = @"</ss:Cell>";
    NSString *string;
    
    //if NSString
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *objString = (NSString *)obj;
        string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", objString];
        
        //if its the 1st item add a row and a cell
        if ([key isEqualToString:@"Branch NSC"]) {
//            [array addObject:xmlRowOpen];
            [array addObject:xmlCellOpen];
            [array addObject:string];
            [array addObject:xmlCellClose];
        }
        //else if its the last close the row tag
        else if ([key isEqualToString:@"Administrator:2"]) {
            [array addObject:xmlCellOpen];
            [array addObject:string];
            [array addObject:xmlCellClose];
//            [array addObject:xmlRowClose];
        }
        //else its just a regular entry
        else
        {   //actually only need these
            [array addObject:xmlCellOpen];
            [array addObject:string];
            [array addObject:xmlCellClose];
        }
    }//close if
    //else if NSNumber
    else if ([obj isKindOfClass:[NSNumber class]]) {
        //int
        if ((strcmp([obj objCType], @encode(int)) == 0)) {
            int valueInt = (int)[obj intValue];
            string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"Number\">%i</ss:Data>",valueInt];
        }
        //double
        else if ((strcmp([obj objCType], @encode(double)) == 0)) {
            double valueDouble = (double)[obj doubleValue];
            string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"Number\">%.2f</ss:Data>", valueDouble];//€%.2f
        }
            [array addObject:xmlCellOpen];
            [array addObject:string];
            [array addObject:xmlCellClose];
    }//close else if
    
    DLog(@"ARRAY: %@", array);
    return array;
    
}
//creates comma serparate pairs
+ (NSString *)parseMyCollectionWithCommas:(NSMutableArray *)array {
    
    //        NSMutableDictionary *appData = [[NSMutableDictionary alloc]init];
    //        NSData *attachData = [NSPropertyListSerialization dataFromPropertyList:appData format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    
    
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
        
    }
    return finalString;
}
+ (NSString *)parseMyCollection:(NSMutableArray *)array {
    
    NSMutableString *parsingString = [[NSMutableString alloc]init];
    NSString *finalString;
    
    if (array) { //temp remove commas
        
        for (int i = 0; i < [array count]; i++) {
            NSString *string;
            //string
            if ([array[i] isKindOfClass:[NSString class]]) {
                string = [NSString stringWithFormat:@"%@", array[i]];//@"%@,"
                parsingString = (NSMutableString *)[parsingString stringByAppendingString:string];
            }
            else if ([array[i] isKindOfClass:[NSNumber class]]) {
                //double
                if ((strcmp([array[i] objCType], @encode(double)) == 0)) {
                    string = [NSString stringWithFormat:@"%.2f", [array[i]doubleValue]];//@"€%.2f,"
                    parsingString = (NSMutableString *)[parsingString stringByAppendingString:string];
                }
                //integer
                else if ((strcmp([array[i] objCType], @encode(int)) == 0)) {
                    string = [NSString stringWithFormat:@"%i", [array[i]intValue]];//@"%i,"
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
