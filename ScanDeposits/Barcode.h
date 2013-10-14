//
//  Barcode.h
//  ScanDeposits
//
//  Created by Peter Darbey on 10/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Barcode : NSObject

@property (strong, nonatomic, readonly) NSString *barcode;
@property (strong, nonatomic) NSString *symbology;
//New attributes
@property (strong, nonatomic, readonly) NSString *device;// -> TDR
@property (strong, nonatomic, readonly) NSString *iD;// blank
@property (strong, nonatomic, readonly) NSString *lodgementType;// -> 932388 003

//@property (strong, nonatomic) NSDate *currentDate;//already captured


+ (Barcode *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;
- (NSDictionary *)dictionaryRepresentation;


@end
