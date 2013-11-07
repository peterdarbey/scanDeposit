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

- (void)dismissLoginVC:(NSMutableDictionary *)users;

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

@property (strong, nonatomic) NSMutableArray *users;

//@property (strong, nonatomic) NSMutableArray *packagedUsers;//make dictionary
@property (strong, nonatomic) NSMutableDictionary *packagedUsers;//make dictionary
//@property (strong, nonatomic) User *user;

@property (weak, nonatomic) id <DismissLoginWithValidationDelegate> delegate;

@end
