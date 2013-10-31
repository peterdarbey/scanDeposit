//
//  PersistenceManager.m
//  ScanDeposits
//
//  Created by Peter Darbey on 31/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "PersistenceManager.h"

@interface PersistenceManager ()
{
    
}


@end


@implementation PersistenceManager


//- (id)init
//{
//    
//    if (self = [super init]) {
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        NSString *fullPath = [PersistenceManager getFilePath];
//        
//        //Check if file exists
//        if ([fileManager fileExistsAtPath:fullPath])
//        {
//            NSArray *currentItems = [NSArray arrayWithContentsOfFile:fullPath];
////            _allItems = [[NSMutableArray alloc] initWithArray:currentItems];
//            
//        } else {
////            _allItems = [[NSMutableArray alloc] init];
//        }
//    }
//    return self;
//    
//}


+ (NSString *)getFilePath
{
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectoryPath stringByAppendingPathComponent:@"usersCollection.plist"];
    
    return fullPath;
}


//read/write to file on device
- (void)writeToCollection:(NSMutableArray *)array withPath:(NSString *)path
{
    
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectoryPath stringByAppendingPathComponent:path];
    [array writeToFile:fullPath atomically:YES];
    
}


@end
