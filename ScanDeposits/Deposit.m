//
//  CoinBag.m
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "Deposit.h"

@interface Deposit ()
{
   
}


//Private members
@property (strong, nonatomic) NSString *bagNumber;
@property int bagCount;
@property double bagAmount;
@property (strong, nonatomic) NSString *bagBarcode;
@property (strong, nonatomic) NSString *timeStamp;

@property (strong, nonatomic) NSDictionary *internalDict;

@end

NSInteger totalBagCount = 0;

@implementation Deposit
{
    
}

static NSInteger _totalBagCount;
static double _totalBagsAmount;

-(void) commonInit:(NSDictionary *)dict {
    
    _bagNumber = dict[@"BagNumber"];//string
    _bagBarcode = dict[@"Barcode"];//process a coin bag
    _bagAmount = (double)[dict[@"BagAmount"]doubleValue];
    _bagCount = [dict[@"BagCount"]intValue];
    _timeStamp = dict[@"Time"];//string
    _internalDict = dict;

}
//make class method +  instead of -
- (id)initWithBagNumber:(NSString *)bagNumber bagBarcode:(NSString *)barcode
              bagAmount:(double)amount bagCount:(int)count timeStamp:(NSString *)time {
    
    self = [super init];
    if (self) {
        NSDictionary *dict = @{@"BagNumber": bagNumber, @"Barcode" : barcode, @"BagAmount" : [NSNumber numberWithDouble:amount], @"BagCount" : [NSNumber numberWithInt:count], @"Time" : time};
        DLog(@"init dict has: %@", dict);
        
        //In constructor increment bag count
        _totalBagCount++;
        DLog(@"_totalBagCount********: %i", _totalBagCount);
        _totalBagsAmount += [dict[@"BagAmount"]doubleValue];//retreive the instance amount and Add to total
       
        
        [self commonInit:dict];
    }
    
    return self;
}

//public getters members
+ (NSInteger)getTotalBagCount {
    
    return _totalBagCount;
}
+ (double)totalBagsAmount {
    
    return _totalBagsAmount;
}

- (double)countOfBagAmount {
    return _bagAmount;
}
- (int)countOfBagCount {
    return _bagCount;
}
- (NSString *)getBagNumber {
    return _bagNumber;
}


@end
