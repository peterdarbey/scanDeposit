//
//  LogInVC.h
//  ScanDeposits
//
//  Created by Peter Darbey on 06/11/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTFIELD_TAG 100
#define LABEL_TAG 200

@interface LogInVC : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    
    UIBarButtonItem *doneBtn;
    NSFileManager *fileManager;
}

@property (strong, nonatomic) IBOutlet UITableView *loginTV;

@property (strong, nonatomic) NSMutableArray *users;

@end
