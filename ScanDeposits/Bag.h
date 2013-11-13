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


@end
