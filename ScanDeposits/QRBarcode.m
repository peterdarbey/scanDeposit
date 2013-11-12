//
//  QRBarcode.m
//  ScanDeposits
//
//  Created by Peter Darbey on 12/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "QRBarcode.h"

@interface QRBarcode ()
{
    
}

//private members
@property (strong, nonatomic) NSString *branchNSC;//Branch NSC
@property (strong, nonatomic) NSString *process;//Process
@property int safeID;//Safe ID
@property (strong, nonatomic) NSString *device;// -> TDR
//internal representation
@property (strong, nonatomic) NSDictionary *internalDict;

@end


@implementation QRBarcode

- (void)commonInit:(NSDictionary *)dict {
    
    _symbology = dict[@"Symbology"];
    _branchNSC = dict[@"Branch NSC"];
    _process = dict[@"Process"];
    _safeID = [dict[@"Safe ID"]intValue];//retrieve int value
    _device = dict[@"Device"];
    
    _internalDict = dict;
    
}

- (id)initBarcodeWithType:(NSString *)symbology branch:(NSString *)branchNSC
                  process:(NSString *)processType
                safeID:(int)safeType andDevice:(NSString *)device {
    
    self = [super init];
    if (self) {
        
        NSDictionary *dict = @{@"Symbology" : symbology, @"Branch NSC" : branchNSC, @"Process" : processType, @"Safe ID" : @(safeType), @"Device" : device};//adding to a collection
        
        
        [self commonInit:dict];
    }
    
    return self;
}

//getters
- (NSString *)barcodeSymbology {
    
    return _symbology;
}
- (NSString *)barcodeBranch {
    
    return _branchNSC;
}
- (NSString *)barcodeProcess {
    
    return _process;
}
- (int)barcodeSafeID {
    
    return _safeID;
}
- (NSString *)barcodeDevice {
    
    return _device;
}





@end
