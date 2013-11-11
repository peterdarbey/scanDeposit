//
//  LogInVC.h
//  ScanDeposits
//
//  Created by Peter Darbey on 06/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@class LogInVC;

@protocol DismissLoginWithValidationDelegate <NSObject>

- (void)dismissLoginVC:(NSMutableDictionary *)users isAdmin:(NSNumber *)admin;

@end


#define TEXTFIELD_TAG 100
#define LABEL_TAG 200

@interface LogInVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    
    UIBarButtonItem *doneBtn;
    NSFileManager *fileManager;
    NSIndexPath *selectedIndex;
}

@property (strong, nonatomic) IBOutlet UITableView *loginTV;
//control user
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) NSMutableDictionary *packagedUsers;//was NSArray
//administrator
@property (strong, nonatomic) NSMutableArray *admins;
@property (strong, nonatomic) NSMutableDictionary *packagedAdmins;

@property (weak, nonatomic) id <DismissLoginWithValidationDelegate> delegate;

@property BOOL adminFieldValid;
@property BOOL userOneFieldValid;
@property BOOL userTwoFieldValid;


@end
