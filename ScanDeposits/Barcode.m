//
//  Barcode.m
//  ScanDeposits
//
//  Created by Peter Darbey on 10/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "Barcode.h"

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
    } else if ([key isEqualToString:@"Symbology"]) {
        [self setValue:value forKey:@"symbology"];
    } else if ([key isEqualToString:@"Device"]) {
        [self setValue:value forKey:@"device"];//property ivar
    } else if ([key isEqualToString:@"ID"]) {
        [self setValue:value forKey:@"iD"];
    } else if ([key isEqualToString:@"LodgementType"]) {
        [self setValue:value forKey:@"lodgementType"];//this may be incorrect
    }
    else {
        [super setValue:value forUndefinedKey:key];
    }
    
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (self.barcode) {
        [dictionary setObject:self.barcode forKey:@"barcode"];
    }
    if (self.symbology) {
        [dictionary setObject:self.symbology forKey:@"symbology"];
    }
    if (self.device) {
        [dictionary setObject:self.device forKey:@"device"];
    }
    if (self.iD) {
        [dictionary setObject:self.iD forKey:@"ID"];
    }
    if (self.lodgementType) {
        [dictionary setObject:self.lodgementType forKey:@"lodgementType"];
    }
    
    return dictionary;
}

@end
