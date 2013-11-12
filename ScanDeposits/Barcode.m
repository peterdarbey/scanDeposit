//
//  Barcode.m
//  ScanDeposits
//
//  Created by Peter Darbey on 10/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "Barcode.h"

@interface Barcode ()
{
    
}

//private members
@property (strong, nonatomic) NSString *process;//Process
@property (strong, nonatomic) NSString *barcode;//barcode containing all relevant data
@property (strong, nonatomic) NSString *branchNSC;//Branch NSC
@property (strong, nonatomic) NSString *device;// -> TDR
@property (strong, nonatomic) NSString *safeID;//Safe ID

@end



@implementation Barcode

+ (Barcode *)instanceFromDictionary:(NSDictionary *)aDictionary {
    
    Barcode *instance = [[Barcode alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;
    
}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {
    
    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    [self setValuesForKeysWithDictionary:aDictionary];
    
}

- (void)setValue:(id)value forKey:(NSString *)key {
    
    [super setValue:value forKey:key];
    
//    if ([key isEqualToString:@"Barcode"]) {
//        
//        if ([value isKindOfClass:[NSDictionary class]]) {
//            self.barcode = [Barcode instanceFromDictionary:value];
//        }
//        
//    } else {
//        [super setValue:value forKey:key];
//    }
    
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
    //this method sets the properties and values from a dictionary
    if ([key isEqualToString:@"Barcode"]) {
        [self setValue:value forKey:@"barcode"];//property ivar contains all data?
    } else if ([key isEqualToString:@"Symbology"]) {
        [self setValue:value forKey:@"symbology"];
    }else if ([key isEqualToString:@"Process"]) {
        [self setValue:value forKey:@"process"];
    } else if ([key isEqualToString:@"Branch NSC"]) {
        [self setValue:value forKey:@"branchNSC"];
    } else if ([key isEqualToString:@"Device"]) {
        [self setValue:value forKey:@"device"];
    } else if ([key isEqualToString:@"Safe ID"]) {
        [self setValue:value forKey:@"safeID"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (self.barcode) {
        [dictionary setObject:self.barcode forKey:@"Barcode"];
    }
    if (self.symbology) {
        [dictionary setObject:self.symbology forKey:@"Symbology"];
    }if (self.process) {
        [dictionary setObject:self.process forKey:@"Process"];
    }
    if (self.branchNSC) {
        [dictionary setObject:self.branchNSC forKey:@"Branch NSC"];
    }
    if (self.device) {
        [dictionary setObject:self.device forKey:@"Device"];
    }
    if (self.safeID) {
        [dictionary setObject:self.safeID forKey:@"Safe ID"];
    }
    
    return dictionary;
}

//getters
- (NSString *)branchNSC {
    
    return _branchNSC;
}
- (NSString *)getSymbology {
    
    return _symbology;
}
- (NSString *)process {
    
    return _process;
}

- (NSString *)barcodeData {
    
    return _barcode;
}
- (NSString *)device {
    
    return _device;
}
- (NSString *)getID {
    return _safeID;
}

@end
