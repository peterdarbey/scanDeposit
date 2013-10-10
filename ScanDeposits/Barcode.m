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
        [self setValue:value forKey:@"barcode"];//property ivar
    } else if ([key isEqualToString:@"Symbology"]) {
        [self setValue:value forKey:@"symbology"];//property ivar
    } else {
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
    
    return dictionary;
}

@end
