//
//  PersistenceManager.h
//  ScanDeposits
//
//  Created by Peter Darbey on 31/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersistenceManager : NSObject

//- (id) init;

+ (NSString *)getFilePath;
- (void)writeToCollection:(NSMutableArray *)array withPath:(NSString *)path;

@end
