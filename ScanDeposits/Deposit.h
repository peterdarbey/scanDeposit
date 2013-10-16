//
//  CoinBag.h
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bag.h"

@interface Deposit : NSObject
{
    
}

@property int totalBagCount;

////should be private
//@property (strong, nonatomic) NSString *bagNumber;
//@property int bagCount;
//@property double bagAmount;
//@property (strong, nonatomic) NSString *bagBarcode;
//@property (strong, nonatomic) NSString *timeStamp;

//setter/getter
//+(void)setTotalNumberOfBags:(NSInteger)count;

+(NSInteger)totalNumberOfBags;

- (id)initWithBagNumber:(NSString *)bagNumber bagBarcode:(NSString *)barcode
              bagAmount:(double)amount bagCount:(int)count timeStamp:(NSString *)time;

- (double)countOfBagAmount;
- (int)countOfBagCount;

@end
