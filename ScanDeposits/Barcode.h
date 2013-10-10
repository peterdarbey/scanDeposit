//
//  Barcode.h
//  ScanDeposits
//
//  Created by Peter Darbey on 10/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Barcode : NSObject

@property (strong, nonatomic) NSString *barcode;
@property (strong, nonatomic) NSString *symbology;

+ (Barcode *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionaryRepresentation;


@end
