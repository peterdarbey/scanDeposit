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








//    //NOTE: may need to add user to NSUserDefaults
//    //if Administrator (filled in password so admin) go to RegistrationVC / Administrator Settings
//    if (_isAdmin) { //&& !_isUser
////        DLog(@"User is ADMIN");
////        RegistrationVC *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationVC"];
////        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:registerVC];
////        [navController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
////
////        //Add delay to presentation of LoginVC until HomeVC has appeared first
////        double delayInSeconds = 0.3;
////        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
////        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////
////            //NOTE: dont need the dispatch delay for RegistrationVC as admin ???
////            //Delay added has resolved the issue with the unbalanced calls to navController
////            [self presentViewController:navController animated:YES completion:^{
////                [registerVC setModalPresentationStyle:UIModalPresentationFullScreen];
////                [registerVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
////                [registerVC setTitle:NSLocalizedString(@"Admin Settings", @"Adminstrator Settings")];
////            }];
////
////        });//close dispatch block
//
//    }
//    //not administrator or a reg user
//    else if (!_isAdmin && !_isUser) { //correct behaviour now
//
////        LogInVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
////
////        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginVC];
////
////        //Add delay to presentation of LoginVC until HomeVC has appeared first
////        double delayInSeconds = 0.3;//0.25
////        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
////        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////
////            //HomeVC been by another NavController when we dismiss the LoginVC? -> solved
////            [self presentViewController:navController animated:YES completion:^{
////                //ToDo add some functionality here
////                [loginVC setModalPresentationStyle:UIModalPresentationFullScreen];
////                [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
////                [loginVC setTitle:NSLocalizedString(@"Log In", @"Log In")];
////                //set the HomeVC as the delegate for the LoginVC dismissLoginVCWithValidation
////                [loginVC setDelegate:self];
////            }];
////
////        });//close dispatch block
//
//
//    }
//    else
//    {
//        DLog(@"is user scan away");//temp remove condition later
//    }



//    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *docDir = [arrayPaths objectAtIndex:0];
//    NSString *Path = [docDir stringByAppendingString:@"/CSVFile.csv"];
//    NSData *csvData = [NSData dataWithContentsOfFile:Path];


//if (_isSetup) {
//    
//    //        //Once setup complete Always present LogInVC for all users/admins if not already logged in
//    //        [self presentLogInVC];
//    
//    //is admin via login and not user
//    if (_isAdmin && !_isUser) {
//        //admin has Logged in so now dismiss LogInVC
//        DLog(@"Admin delegate protocol did dismiss LogInVC");
//        //and present Administration settings/RegisrationVC
//        [self presentRegistrationVC];
//        
//    }
//    //setup is complete and NOT administrator but _isUser = YES
//    else if (!_isAdmin && _isUser) {
//        
//        //user has Logged in so now dismiss LogInVC
//        DLog(@"User delegate protocol did dismiss LogInVC");
//        //and present HomeVC to allow scanning by user
//        DLog(@"Proceed and scan away");
//    }
//    else
//    {
//        //Once setup complete Always present LogInVC for all users/admins if not already LOGGED IN
//        [self presentLogInVC];
//    }
//    
//    
//}//close if

//        +(void)showAlertFromNibName:(NSString*)nibName OnView:(UIView*)view {
//            [[AlertTableView loadFromNibNamed:nibName] showOnView:view];
//        }


//defaultCenter = [NSNotificationCenter defaultCenter];
////register for notifications and call this selector
////    [defaultCenter addObserver:self selector:@selector(notifiyViewControllerWithNotification:) name:@"okPressed" object:nil];//okPressed
//
////setup notification params
////    [self dispatchEventOnTouch];
//}
//
//- (void)notifiyViewControllerWithNotification:(NSNotification *)notification {
//    
//    if ([self.notDelegate respondsToSelector:@selector(NotificationOfButtonPressed:)]) {
//        [self.notDelegate performSelector:@selector(NotificationOfButtonPressed:) withObject:notification];//works
//        
//    }
//    
//}
//-(void)dispatchEventOnTouch
//{
//    
//    //register the control object and associated key with a notification
//    //userInfo = @{@"okPressed" : @(_buttonPressed)};
//    userInfo = @{@"okPressed" : _okayBtn};//nil currently
//    [defaultCenter postNotificationName: @"okPressed" object:nil userInfo:userInfo];//was nil
//    DLog(@"EVENT DISPATCHED");
//}




//- (NSMutableArray *)createXMLSSFromCollection:(NSMutableArray *)array {
//
//    //Test construction of excel xml structure --> xmlss format
//    //DTD import
//    NSString *xmlDTD = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
////    NSString *xmlWBOpen = @"<ss:Workbook xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\">";
//    NSString *xmlWBOpen = @"<Workbook>";
//    //schemas
//    NSString *xmlSchemas = @"xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\" xmlns:x=\"urn:schemas-microsoft-com:office:excel\">";
//
//    NSString *xmlWBClose = @"</ss:Workbook>";
//    NSString *xmlWSOpen = @"<ss:Worksheet ss:Name=\"AppData\">";
//    NSString *xmlWSClose = @"</ss:Worksheet>";
//    NSString *xmlTblOpen = @"<ss:Table>";
//    NSString *xmlTblClose = @"</ss:Table>";
//    NSString *xmlColumn = @"<ss:Column ss:Width=\"80\"/>";
//    NSString *xmlColumnSpan = @"<Column ss:Span=\"15\" ss:Width=\"80\"/>";
//    //styles
//    NSString *xmlStyles = @"<Styles><Style ss:ID=\"s1\"><Interior ss:Color=\"#800008\" ss:Pattern=\"Solid\"/></Style></Styles>";
//
//    //row contruction
//    NSString *xmlRowOpen = @"<ss:Row>";
//    NSString *xmlRowClose = @"</ss:Row>";
//    NSString *xmlCellOpen = @"<ss:Cell>";
//    NSString *xmlCellClose = @"</ss:Cell>";
//
//    //Bold style
//    NSString *xmlBoldStyle = @"<Row ss:Index=\"1\" ss:Height=\"14\"><Cell><ss:Data xmlns=\"http://www.w3.org/TR/REC-html40\" ss:Type=\"String\">Branch NSC <Font html:Color=\"#ff0000\"><I><U>UnderLine</U></I></Font> askd<B>Bold</B>This is working</ss:Data></Cell><Cell ss:StyleID=\"s1\"><Data ss:Type=\"String\">Process No</Data></Cell></Row>";
//
//    //array construct for new xml collection
//    NSMutableArray *__block xmlArray = [NSMutableArray array];
//
//    //add the necessary headers and DTD metaData to the collection first
//    [xmlArray addObject:xmlDTD];//docType
//    [xmlArray addObject:xmlWBOpen];//WorkBook
//    [xmlArray addObject:xmlSchemas];//add all necessary schemas
//    [xmlArray addObject:xmlStyles];
//    [xmlArray addObject:xmlWSOpen];//WorkSheet
//    [xmlArray addObject:xmlTblOpen];//Table
//
////    [xmlArray addObject:xmlRowOpen];//Row Open and Close after each entry -> 1
//
//    [xmlArray addObject:xmlColumn];//Column test
//    [xmlArray addObject:xmlColumnSpan];//add the span
//    [xmlArray addObject:xmlBoldStyle];//test this entry
////    //add the first row
////    [xmlArray addObject:xmlRowOpen];
//
//    //key construct for xml creation method
//    NSArray *keysArray = @[@"Branch NSC", @"Process No", @"Safe ID", @"Device Type", @"Sequence No:"
//                           , @"Unique Bag No:", @"Bag Count", @"Bag Value", @"Date/Time", @"Total Count", @"Total Value", @"User:1 Name", @"User:1 Email", @"User:2 Name", @"User:2 Email", @"Administrator:1", @"Administrator:2"];
//
//    //enumerate and add to the xmlArray all the heading --> all 16
//    [keysArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        if ([obj isKindOfClass:[NSString class]]) {
//            //construct the heading first with titles
//            NSString *string = [NSString stringWithFormat:@"<ss:Data ss:Type=\"String\">%@</ss:Data>", obj];
//            [xmlArray addObject:xmlCellOpen];
//            [xmlArray addObject:string];
//            [xmlArray addObject:xmlCellClose];
//        }
//    }];
////    //close the first row
////    [xmlArray addObject:xmlRowClose];
//
//    //add the first row
//    [xmlArray addObject:xmlRowOpen];
//    //Need to add array aka _dataArray with matching count of keysArray
//
//    //new data structure for xml spreadsheet intergration
//    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithObjects:array forKeys:keysArray];
//    DLog(@"dataDict for xml construct*******: %@", dataDict);
//
//    //enumerate the collection and add xml structure and content
//    [dataDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        NSString *keyStr = (NSString *)key;
//
//            //dont need conditionals as Im only taking the values now so 1 iteration
//            xmlArray = [StringParserHelper parseValue:obj forKey: keyStr addToCollection:xmlArray];
//            DLog(@"xmlArray: %@", xmlArray);//should work correctly
//
//    }];
//
//    //close the first row
//    [xmlArray addObject:xmlRowClose];
//
//    //then add the closing format types
//    [xmlArray addObject:xmlTblClose];//Table Close
//    [xmlArray addObject:xmlWSClose];//WorkSheet Close
//    [xmlArray addObject:xmlWBClose];//WorkBook Close
//
//
//    DLog(@"xmlArray -------->: %@", xmlArray);
//
//    return xmlArray;
//}





//- (NSMutableArray *)collectMyData {
//    
//    //    xmlDataDict = [NSMutableDictionary dictionary];
//    
//    //extract barcode data
//    if (_barcodeArray) {
//        
//        //extract the barcode objects required values
//        for (id object in _barcodeArray) {
//            if ([object isKindOfClass:[QRBarcode class]]) {
//                QRBarcode *qrBarcode = (QRBarcode *)object;
//                
//                //Add elements to the array
//                [_dataArray addObject:[qrBarcode barcodeBranch]];
//                //                    [xmlDataDict setValue:[qrBarcode barcodeBranch] forKey:@"Branch NSC"];
//                [_dataArray addObject:[qrBarcode barcodeProcess]];
//                //                    [xmlDataDict setValue:[qrBarcode barcodeProcess] forKey:@"Process No"];
//                [_dataArray addObject:@([qrBarcode barcodeSafeID])];//Safe
//                //                    [xmlDataDict setValue:@([qrBarcode barcodeSafeID]) forKey:@"Safe ID"];
//            }
//        }//close for
//    }
//    
//    //extract all the deposit data
//    if (_depositsCollection) {
//        
//        for (id object in _depositsCollection) {
//            if ([object isKindOfClass:[Deposit class]]) {
//                Deposit *deposit = (Deposit *)object;
//                //added last 6digits --> Sequence Number
//                [_dataArray addObject:[[deposit bagBarcode]substringFromIndex:6]];//Device Type
//                //                [xmlDataDict setValue:[[deposit bagBarcode]substringFromIndex:6] forKey:@"Device Type"];
//                [_dataArray addObject:[[deposit bagBarcode]substringFromIndex:3]];//Sequence No ->not intergrate yet
//                //                [xmlDataDict setValue:[[deposit bagBarcode]substringFromIndex:3] forKey:@"Sequence No:"];
//                [_dataArray addObject:[deposit bagBarcode]];//has ITF --> barcodeUniqueBagNumber
//                //                [xmlDataDict setValue:[deposit bagBarcode] forKey:@"Unique Bag No:"];
//                [_dataArray addObject:@([deposit bagCount])];//int
//                //                [xmlDataDict setValue:@([deposit bagCount]) forKey:@"Bag Count"];
//                [_dataArray addObject:@([deposit bagAmount])];//double
//                //                [xmlDataDict setValue:@([deposit bagAmount]) forKey:@"Bag Value"];
//                [_dataArray addObject:[deposit timeStamp]];//add date/time
//                //                [xmlDataDict setValue:[deposit timeStamp] forKey:@"Date/Time"];
//                
//                //test dict is overwriting values in here
//                
//            }
//        }//close for
//        //dont forget static methods ie count and amount total
//        [_dataArray addObject:@([Deposit totalBagCount])];//should be right
//        //        [xmlDataDict setValue:@([Deposit totalBagCount]) forKey:@"Total Count"];
//        [_dataArray addObject:@([Deposit totalBagsAmount])];
//        //        [xmlDataDict setValue:@([Deposit totalBagsAmount]) forKey:@"Total Value"];
//        
//    }
//    
//    //retrieves each LOGGED IN users name and email
//    if (_usersDict) {
//        
//        //userOne
//        NSDictionary *userOneDict = _usersDict[@1];//--> yeah didnt work
//        [_dataArray addObject:userOneDict[@"Name"]];
//        //            [xmlDataDict setValue:userOneDict[@"Name"] forKey:@"User:1 Name"];//these may overwrite each other
//        [_dataArray addObject:userOneDict[@"Email"]];
//        //            [xmlDataDict setValue:userOneDict[@"Email"] forKey:@"User:1 Email"];//these may overwrite each other
//        //userTwo
//        NSDictionary *userTwoDict = _usersDict[@2];
//        [_dataArray addObject:userTwoDict[@"Name"]];
//        //            [xmlDataDict setValue:userOneDict[@"Name"] forKey:@"User:2 Name"];//these may overwrite each other
//        [_dataArray addObject:userTwoDict[@"Email"]];
//        //            [xmlDataDict setValue:userOneDict[@"Email"] forKey:@"User:2 Email"];//these may overwrite each other
//        
//    }//close userDict
//    
//    
//    //each Administrator associated with device --> use the adminsCollection.plist for this data
//    NSMutableArray *adminArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
//    
//    if (adminArray) {
//        for (int i = 0; i < [adminArray count]; i++) {
//            NSString *adminName = [[adminArray objectAtIndex:i]objectAtIndex:0];//name
//            [_dataArray addObject:adminName];
//            //                [xmlDataDict setValue:adminName forKey:[NSString stringWithFormat:@"Administrator:%i", i+1]];
//        }
//    }//close if
//    
//    DLog(@"<<<<<<<< _dataArray contents >>>>>>>>>>: %@", _dataArray);//23 at moment
//    //    DLog(@"<< xmlDataDict contents >>: %@", xmlDataDict);//crash 29 values verses 34 keys
//    
//    return _dataArray;
//}




@end
