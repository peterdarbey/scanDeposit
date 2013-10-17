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
@property (strong, nonatomic) NSString *barcode;
@property (strong, nonatomic) NSString *branchNSC;

@property (strong, nonatomic) NSString *device;// -> TDR
@property (strong, nonatomic) NSString *ID;// blank

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
    
    if ([key isEqualToString:@"Barcode"]) {
        [self setValue:value forKey:@"barcode"];//property ivar contains all data?
    } else if ([key isEqualToString:@"BranchNSC"]) {
        [self setValue:value forKey:@"branchNSC"];
    } else if ([key isEqualToString:@"Device"]) {
        [self setValue:value forKey:@"device"];//property ivar
    } else if ([key isEqualToString:@"ID"]) {
        [self setValue:value forKey:@"ID"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (self.barcode) {
        [dictionary setObject:self.barcode forKey:@"barcode"];
    }
    if (self.branchNSC) {
        [dictionary setObject:self.branchNSC forKey:@"branchNSC"];
    }
    if (self.device) {
        [dictionary setObject:self.device forKey:@"device"];
    }
    if (self.ID) {
        [dictionary setObject:self.ID forKey:@"ID"];
    }
    
    return dictionary;
}

- (NSString *)branchNSC {
    
    return _branchNSC;
}

- (NSString *)barcodeData {
    
    return _barcode;
}
- (NSString *)device {
    
    return _device;
}
- (NSString *)getID {
    return _ID;
}

@end
