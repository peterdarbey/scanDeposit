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
//@property int bagNumber;
//@property int bagCount;
//@property double bagAmount;
//@property (strong, nonatomic) NSString *bagBarcode;

@property (strong, nonatomic) NSDictionary *internalDict;

@end


@implementation Deposit
{
    
}

-(void) commonInit:(NSDictionary *)dict {
    
    //ToDo add timeStamp
    _bagNumber = dict[@"BagNumber"];//string
    _bagBarcode = dict[@"Barcode"];
    _bagAmount = (double)[dict[@"BagAmount"]doubleValue];
    _bagCount = [dict[@"BagCount"]intValue];
    _internalDict = dict;

}

- (id)initWithBagNumber:(NSString *)bagNumber bagBarcode:(NSString *)barcode
              bagAmount:(double)amount bagCount:(int)count {
    
    self = [super init];
    if (self) {
        NSDictionary *dict = @{@"BagNumber": bagNumber, @"Barcode" : barcode, @"BagAmount" : [NSNumber numberWithDouble:amount], @"BagCount" : [NSNumber numberWithInt:count]};
        DLog(@"init dict has: %@", dict);
        [self commonInit:dict];
    }
    
    return self;
}

//public members
+(void)setTotalNumberOfBags:(NSInteger)count {
    
//    _bagCount = count;
}

+(int)totalNumberOfBags {
    
//    return _bagCount;
    return 5;
}



@end
