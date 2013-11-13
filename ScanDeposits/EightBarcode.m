//
//  EightBarcode.m
//  ScanDeposits
//
//  Created by Peter Darbey on 13/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "EightBarcode.h"

@interface EightBarcode ()
{
    
}
//private properties
@property (strong, nonatomic) NSString *processType;
@property (strong, nonatomic) NSString *uniqueBagNumber;
//@property (strong, nonatomic) NSString *timeStamp;

@property (strong, nonatomic) NSDictionary *internalDict;


@end


@implementation EightBarcode
{
    
}

- (void)commonInit:(NSDictionary *)dict {
    
    _symbology = dict[@"Symbology"];
    _processType = dict[@"ProcessType"];
    _uniqueBagNumber = dict[@"UniqueNumber"];
    
    _internalDict = dict;//3 entries
    
    
}

//NOTE: uniqueBagNumber and more passed to Deposit model objects constructor
- (id)initBarcodeWithType:(NSString *)symbology processType:(NSString *)process
                                          uniqueBagNumber:(NSString *)uniqueNumber {
    
    self = [super init];
    if (self) {
        
        NSDictionary *dict = @{@"Symbology" : symbology, @"ProcessType" : process,
                               @"UniqueNumber" : uniqueNumber};//dont think we need time here
        
        [self commonInit:dict];
    }
    
    return self;
    
}

//getters
- (NSString *)barcodeSymbology {
    
    return _symbology;
}

- (NSString *)barcodeProcess {
    
    return _processType;
}

- (NSString *)barcodeUniqueBagNumber {
    
    return _uniqueBagNumber;
}




@end


