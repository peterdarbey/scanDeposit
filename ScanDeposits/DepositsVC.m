//
//  DepositsVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "DepositsVC.h"

@interface DepositsVC ()

@end

@implementation DepositsVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //register for callbacks
    [_depositsTV setDelegate:self];
    [_depositsTV setDataSource:self];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //Refresh data when required
//    [_depositsTV reloadData];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10;
//}

#pragma Format date specifier
-(NSString *)formatMyDateString:(NSString *)ticket
{
    // Format the date and time
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    
    NSDate *dateFromString = [myDateFormatter dateFromString:ticket];
    NSString *formattedDate = [NSDateFormatter localizedStringFromDate: dateFromString dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    
    return formattedDate;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"depositCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    UITextField *bagAmountTF;
    UILabel *bagNumberLbl;
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        //Construct textField
        bagAmountTF = [[UITextField alloc]initWithFrame:CGRectMake(75,cell.bounds.size.height/4, 150, 25)];
        bagAmountTF.tag = BAG_AMOUNT_TF;
        bagAmountTF.textAlignment = NSTextAlignmentRight;
        bagAmountTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        bagAmountTF.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        bagAmountTF.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        
        //Construct Label
        bagNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 100 , 25)];
        
        
    }
    else
    {
        
    }
        bagAmountTF.text = @"Test for now";
    
        return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if( indexPath.row == 0 ) {
//        if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
//            cell.backgroundView = [appDelegate styleTableCell:@"singleCell"];
//            cell.selectedBackgroundView = [appDelegate styleTableCell:@"singleCellSelected"];
//            
//        }
//        else
//        {
//            cell.backgroundView = [appDelegate styleTableCell:@"top"];
//            cell.selectedBackgroundView = [appDelegate styleTableCell:@"top"];
//        }
//    }
//    else if (indexPath.row == [self.tableView numberOfRowsInSection:0] -1 ) {
//        cell.backgroundView = [appDelegate styleTableCell:@"bottom"];
//        cell.selectedBackgroundView = [appDelegate styleTableCell:@"bottom"];
//    }
//    else {
//        cell.backgroundView = [appDelegate styleTableCell:@"middle"];
//        cell.selectedBackgroundView = [appDelegate styleTableCell:@"middle"];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
