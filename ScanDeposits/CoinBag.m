//
//  CoinBag.m
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "CoinBag.h"

@interface CoinBag ()
{
   
}
//Private members
@property int *number;
@property double total;
@property (strong, nonatomic) NSString *barcode;

@end


@implementation CoinBag
{
    
}

//public members
+(void)totalNumberOfBags:(NSInteger)count {
    
//    _totalBagCount = count;
}
+(int)totalNumberOfBags {
//    return _totalBagCount;
    return 5;
}

@end
