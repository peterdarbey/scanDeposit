//
//  DepositsVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "DepositsVC.h"

@interface DepositsVC ()
{
    
}
//private collection member
//@property (strong, nonatomic) NSMutableArray *depositsArray;

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
    
    [_depositsTV setBackgroundColor:[UIColor lightGrayColor]];//right
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    int numberOfBags = 5;
    return  numberOfBags;//bag count
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;//should always be 1
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    [_depositsTV deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"depositCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    UITextField *bagAmountTF;
    UILabel *bagNumberLbl;
    
    //1st time thru cell doesnt exist so create else dequeue
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        //Construct textField
        bagAmountTF = [[UITextField alloc]initWithFrame:CGRectMake(130, cell.bounds.size.height/4, 180, 25)];
        bagAmountTF.tag = BAG_AMOUNT_TF;
        bagAmountTF.textAlignment = NSTextAlignmentLeft;
        bagAmountTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        bagAmountTF.font = [UIFont systemFontOfSize:17];
        bagAmountTF.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        bagAmountTF.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bagAmountTF];
        
        
        //Construct Label
        bagNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 120 , 25)];
        bagNumberLbl.tag = BAG_NO_LBL;
        bagNumberLbl.textAlignment = NSTextAlignmentLeft;
        bagNumberLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        bagNumberLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        bagNumberLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bagNumberLbl];
        
    }
    else
    {
        bagAmountTF = (UITextField *)[cell.contentView viewWithTag:BAG_AMOUNT_TF];
        bagNumberLbl = (UILabel *)[cell.contentView viewWithTag:BAG_NO_LBL];
    }
//        double amount = 000.00;//should add the 0s when a value there
    
        Deposit *deposit = [[Deposit alloc]init];
    
        bagAmountTF.text = [NSString stringWithFormat:@"Amount is: €%.2f", deposit.bagAmount];//@"€%.2f"
        //set this locally for number but then static/gobal ivar
        int numberOfBags = deposit.bagCount;
        bagNumberLbl.text = [NSString stringWithFormat:@"No of Bags: %i", numberOfBags];
    
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
