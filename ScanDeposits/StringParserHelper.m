//
//  StringParserHelper.m
//  ScanDeposits
//
//  Created by Peter Darbey on 18/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "StringParserHelper.h"
#import "Deposit.h"

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
//iterate through the collection and add new keySets when applicable with _dataArray passed in
+ (NSMutableDictionary *)iterateWithKeySetsFromCollection:(NSArray *)array {
    
    //key construct for xml creation method
    NSArray *keysArray = @[@"Branch NSC", @"Process No", @"Safe ID", @"Device Type", @"Sequence No:"
                           , @"Unique Bag No:", @"Bag Count", @"Bag Value", @"Date/Time", @"Total Count", @"Total Value", @"User:1 Name", @"User:1 Email", @"User:2 Name", @"User:2 Email", @"Administrator:1", @"Administrator:2"];
    //make a mutable copy
    NSMutableArray *keysMArray = (NSMutableArray *)[keysArray mutableCopy];
    
    NSArray *keysSet = @[@"Device Type", @"Sequence No:", @"Unique Bag No:", @"Bag Count", @"Bag Value", @"Date/Time", @"Total Count", @"Total Value", @"User:1 Name", @"User:1 Email", @"User:2 Name", @"User:2 Email", @"Administrator:1", @"Administrator:2"];
    
    //for entries in the _dataArray that exceed on entry add the keys again
    //need right conditional for this
    for (int i = 0; i < [array count]; i++) {
        
        [keysMArray addObject:keysSet];//all keys
    }
    //finally add _dataArray with all extra count keys and construct the dicitionary
    NSMutableDictionary *xmlDict = [NSMutableDictionary dictionaryWithObjects:array forKeys:keysMArray];
    
    
    return xmlDict;
}

+ (NSMutableArray *)createXMLSSFromArray:(NSMutableArray *)array andDictionary:(NSMutableDictionary *)dict {
//    DLog(@"ARRAY -> _dataArray contents: %@", array);//_dataArray contents
    
    //Construction of excel xmlss structure --> xls format
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
    NSString *xmlBoldStyle = @"<ss:Row ss:Index=\"1\" ss:Height=\"14\"><Cell><ss:Data xmlns=\"http://www.w3.org/TR/REC-html40\" ss:Type=\"String\">Branch NSC <Font html:Color=\"#ff0000\"><I><U>UnderLine</U></I></Font> askd<B>Bold</B>This is working</ss:Data></Cell><Cell ss:StyleID=\"s1\"><Data ss:Type=\"String\">Process No</Data></Cell></ss:Row>";
    
    //array construct for new xml collection
    NSMutableArray *__block xmlArray = [NSMutableArray array];
    //construct the header and various imports with view hierarchy structure including metaData
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
            //construct the heading first with titles/Keys
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
   
    //new data structure for xml spreadsheet intergration -> keysArray and _dataArray count need to match
    NSMutableDictionary *xmlDict = [self iterateWithKeySetsFromCollection:array];//StringParserHelper method
    DLog(@"<< xmlDict construct >>: %@", xmlDict);
    
    
    //OLD
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithObjects:array forKeys:keysArray];
    DLog(@"dataDict construct: %@", dataDict);//old
    
    //enumerate the collection and add xml structure and content
    [dataDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *keyStr = (NSString *)key;
        
        //dont need conditionals as Im only taking the values now so 1 iteration
        xmlArray = [StringParserHelper parseValue:obj forKey:keyStr addToCollection:xmlArray];
        
    }];
    
    //enumerate and add to the xmlArray all the heading --> all 16
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            //construct the heading first with titles/Keys
            NSString *string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", obj];
            [xmlArray addObject:xmlCellOpen];
            [xmlArray addObject:string];
            [xmlArray addObject:xmlCellClose];
        }
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
//new method for enumerating and adding xml
+ (NSMutableArray *)parseValue:(id)obj addToCollection:(NSMutableArray *)array {
    
    NSString *xmlCellOpen = @"<ss:Cell>";
    NSString *xmlCellClose = @"</ss:Cell>";
    NSString *string;
    //I dont need key once heading are in place
    
    //if NSString
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *objString = (NSString *)obj;
        string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", objString];
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
    }//close else if
    
    //actually only need these
    [array addObject:xmlCellOpen];
    [array addObject:string];
    [array addObject:xmlCellClose];
    
    DLog(@"ARRAY: %@", array);
    
    return array;
    
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

//Test this new approach
+ (NSMutableArray *)createXMLSSFromCollection:(NSMutableArray *)array {

    //Construction of excel xmlss structure --> xls format
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
    //construct the header and various imports with view hierarchy structure including metaData
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
                           , @"Unique Bag No:", @"Bag Count", @"Bag Value", @"Date/Time", @"Total Count", @"Total Value", @"User:1 Name", @"User:1 Email", @"User:2 Name", @"User:2 Email", @"Administrator:1", @"Administrator:2"];//17items --> [keysArray count] -> 16
    
    //enumerate and add to the xmlArray all the heading --> all 16
    [keysArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            //construct the heading first with titles/Keys
            NSString *string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", obj];
            [xmlArray addObject:xmlCellOpen];
            [xmlArray addObject:string];
            [xmlArray addObject:xmlCellClose];
        }
    }];
    
    //close the Heading row
    [xmlArray addObject:xmlRowClose];
    
    //add the first row of the deposit entries
    //insert an empty row here
    [xmlArray addObject:xmlRowOpen];
    
    //enumerate _dataArray and add to the xmlArray all entries
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //construct the values now
        NSString *string;
            //if NSString
            if ([obj isKindOfClass:[NSString class]]) {
                NSString *objString = (NSString *)obj;
                string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", objString];
            }
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
                
            }//close else if
        
        //if the _dataArray has more than one entry of deposit data inject new row rules
        if ([array count] > 16) { //--> is _dataArray object

            //if the index is equal to the last index in the keysArray close the cell and row
            if (idx == [keysArray count] -1) {
                [xmlArray addObject:xmlCellOpen];
                [xmlArray addObject:string];
                [xmlArray addObject:xmlCellClose];
                [xmlArray addObject:xmlRowClose];
            }
            else if (idx == ([keysArray count] +1)) { //index 17
                //may not need this value
                [xmlArray addObject:xmlRowOpen];
            }
            else
            {
                [xmlArray addObject:xmlCellOpen];
                [xmlArray addObject:string];
                [xmlArray addObject:xmlCellClose];
            }
            
        }//close if
        else //keep adding cells
        {
            [xmlArray addObject:xmlCellOpen];
            [xmlArray addObject:string];
            [xmlArray addObject:xmlCellClose];
        }
        
        //dont need conditionals as Im only taking the values now so 1 iteration
//        xmlArray = [StringParserHelper parseValue:obj addToCollection:xmlArray];
    }];//close enumeration
    
    //close the first row
    [xmlArray addObject:xmlRowClose];
    //then add the closing format types
    [xmlArray addObject:xmlTblClose];//Table Close
    [xmlArray addObject:xmlWSClose];//WorkSheet Close
    [xmlArray addObject:xmlWBClose];//WorkBook Close
    
    
    DLog(@"xmlArray -------->: %@", xmlArray);
    
    return xmlArray;

}

+ (NSMutableArray *)createXMLFromCollectionFin:(NSMutableArray *)array andDeposits:(NSMutableArray *)deposits {
    
    
    //Construction of excel xmlss structure --> xls format
    //DTD import
    NSString *xmlDTD = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
    NSString *xmlWBOpen = @"<Workbook";
    //schemas
    NSString *xmlSchemas = @" xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\">";
    
    NSString *xmlWBClose = @"</Workbook>";
    NSString *xmlWSOpen = @"<ss:Worksheet ss:Name=\"ProcessReport\">";
    NSString *xmlWSClose = @"</ss:Worksheet>";
    NSString *xmlTblOpen = @"<ss:Table>";
    NSString *xmlTblClose = @"</ss:Table>";
    NSString *xmlColumn = @"<ss:Column ss:Width=\"80\"/>";
    NSString *xmlColumnSpan = @"<Column ss:Span=\"16\" ss:Width=\"80\"/>";
    //styles
    NSString *xmlStyles = @"<Styles><Style ss:ID=\"s1\"><Interior ss:Color=\"#800008\" ss:Pattern=\"Solid\"/></Style></Styles>";
    //row contruction
    NSString *xmlRowOpen = @"<ss:Row>";
    NSString *xmlRowClose = @"</ss:Row>";
    NSString *xmlCellOpen = @"<ss:Cell>";
    NSString *xmlCellOpenWithIndex = @"<ss:Cell ss:Index=\"INDEX\">";
    NSString *xmlCellClose = @"</ss:Cell>";
    //New row style
    NSString *xmlHeadingStyleRowOpen = @"<ss:Row ss:Index=\"2\" ss:Height=\"18\" ss:StyleID=\"s1\">";
    
    //Bold style
//    NSString *xmlBoldStyle = @"<ss:Row ss:Index=\"1\" ss:Height=\"18\"><ss:Cell><ss:Data xmlns=\"http://www.w3.org/TR/REC-html40\" ss:Type=\"String\">Branch NSC<Font html:Color=\"#ff0000\"><I></I></Font><B><I>Bold Branch NSC</I></B>This is working</ss:Data></ss:Cell><ss:Cell ss:StyleID=\"s1\"><ss:Data ss:Type=\"String\">Process No</ss:Data></ss:Cell></ss:Row>";//correct
    
//    NSString *xmlFontStyle = @"<ss:Row ss:Index=\"1\" ss:Height=\"18\"><ss:Cell><ss:Data xmlns=\"http://www.w3.org/TR/REC-html40\" ss:Type=\"String\">Branch NSC<Font html:Color=\"#ff0000\"></Font><B>Bold Branch NSC</B>This is working</ss:Data></ss:Cell><ss:Cell ss:StyleID=\"s1\"><ss:Data ss:Type=\"String\">Process No</ss:Data></ss:Cell></ss:Row>";//correct
    
    //array construct for new xml collection
    NSMutableArray *__block xmlArray = [NSMutableArray array];
    //construct the header and various imports with view hierarchy structure including metaData
    [xmlArray addObject:xmlDTD];//docType
    [xmlArray addObject:xmlWBOpen];//WorkBook
    [xmlArray addObject:xmlSchemas];//add all necessary schemas
    [xmlArray addObject:xmlStyles];//style rules
    [xmlArray addObject:xmlWSOpen];//WorkSheet
    [xmlArray addObject:xmlTblOpen];//Table
    [xmlArray addObject:xmlColumn];//Column test
    [xmlArray addObject:xmlColumnSpan];//add the span
//    [xmlArray addObject:xmlBoldStyle];//test this entry
    //add the first row
    [xmlArray addObject:xmlHeadingStyleRowOpen];//was xmlRowOpen
    
    //key construct for xml creation method
    NSArray *keysArray = @[@"Branch NSC", @"Process No", @"Safe ID", @"Device Type", @"Sequence No:"
                           , @"Unique Bag No:", @"Bag Count", @"Bag Value", @"Date/Time", @"Total Count", @"Total Value", @"User:1 Name", @"User:1 Email", @"User:2 Name", @"User:2 Email", @"Administrator:1", @"Administrator:2"];
  
    __block int row = 0;
    __block int column = 0;
    __block int rowCount = ([array count] - 3 - 8) / 6;
    
    [keysArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //key
        NSString *objString = (NSString *)obj;
        //construct the keys
        NSString *string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", objString];
		[xmlArray addObject:xmlCellOpen];
		[xmlArray addObject:string];
		[xmlArray addObject:xmlCellClose];
	}];
    //close the Heading
    [xmlArray addObject:xmlRowClose];
    //Create a new row
    [xmlArray addObject:xmlRowOpen];
    
    //construct a variable to hold bag Values and increment
    double __block totals = 0.0;
    NSInteger __block bagIdx = 7;
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        //construct the values now
        NSString *string;
        //if NSString
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *objString = (NSString *)obj;
            string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", objString];
        }
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
		}//close else if
        
		if(idx < 3 || idx > 6 * rowCount + 2) {
            
			if(idx < 3) {
				[xmlArray addObject:[xmlCellOpenWithIndex stringByReplacingOccurrencesOfString:@"INDEX" withString:[NSString stringWithFormat:@"%i", idx + 1]]];
				[xmlArray addObject:string];
				[xmlArray addObject:xmlCellClose];
			}            
			return;
		}
        
        
		[xmlArray addObject:[xmlCellOpenWithIndex stringByReplacingOccurrencesOfString:@"INDEX" withString:[NSString stringWithFormat:@"%i", column + 4]]];
		[xmlArray addObject:string];
		[xmlArray addObject:xmlCellClose];
        
        //totals section
        if(!((column + 1) % 6)) {
			[xmlArray addObject:xmlCellOpen];
			[xmlArray addObject:[NSString stringWithFormat:@"<ss:Data ss:Type=\"Number\">%i</ss:Data>", row]];
			[xmlArray addObject:xmlCellClose];
			[xmlArray addObject:xmlCellOpen];
            
            //bagIdx starts at 6
            totals += [array [bagIdx]doubleValue];//assign to totals
            DLog(@"<< totals >>: %f", totals);//correct
            //[Deposit totalBagsAmount] -> class method
            [xmlArray addObject:[NSString stringWithFormat:@"<ss:Data ss:Type=\"Number\">%.2f</ss:Data>", totals]];
			[xmlArray addObject:xmlCellClose];
            //incremnet bagIdx by 6
            bagIdx +=6;
            
            if(row == 0) {
				int i;
				for(i = 0; i < 6; i++) {
					string = [array objectAtIndex:i + 2 + 3 + rowCount * 6];
					[xmlArray addObject:xmlCellOpen];
					[xmlArray addObject:[NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", string]];
					[xmlArray addObject:xmlCellClose];
				}
			}
            
    		[xmlArray addObject:xmlRowClose];
    		[xmlArray addObject:xmlRowOpen];
            
            row++;
			column = 0;
        }
		else
			column++;
        
    }];//close enumeration
    
    //close the first row
    [xmlArray addObject:xmlRowClose];
    //then add the closing format types
    [xmlArray addObject:xmlTblClose];//Table Close
    [xmlArray addObject:xmlWSClose];//WorkSheet Close
    [xmlArray addObject:xmlWBClose];//WorkBook Close
    
    NSLog(@"%@", xmlArray);
    
    return xmlArray;
    
}

@end
