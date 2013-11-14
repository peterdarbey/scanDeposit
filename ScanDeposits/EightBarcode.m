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
@property (strong, nonatomic) NSDictionary *barcodeDict;


@end


@implementation EightBarcode
{
    
}

- (void)commonInit:(NSDictionary *)dict {
    
    _symbology = dict[@"Symbology"];
    _processType = dict[@"Process Type"];//coin only
    _uniqueBagNumber = dict[@"Unique Bag Number"];//12 digit code with 1st 3 deter processType 
    
    if (_symbology) {
        //create a dict with a barcodeType identifier
        _barcodeDict = @{_symbology : dict};
        DLog(@"_barcodeDict in commonInit: %@", _barcodeDict);
    }
    
    _internalDict = dict;//3 entries
    
}
                                                //processType:Coin only
//NOTE: uniqueBagNumber and more passed to Deposit model objects constructor
- (id)initBarcodeWithSymbology:(NSString *)symbology processType:(NSString *)process
                                          uniqueBagNumber:(NSString *)uniqueNumber { //uniqune is 12 digit
    
    self = [super init];
    if (self) {
        
        NSDictionary *dict = @{@"Symbology" : symbology, @"Process Type" : process,
                               @"Unique Bag Number" : uniqueNumber};//dont think we need time here
        
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
//returns a dictionary containing the barcode model with its symbology as a key
- (NSDictionary *)barcodeDictionaryWithSymbology {
    
    return _barcodeDict;
}




@end


