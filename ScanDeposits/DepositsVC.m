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
    //self.view setBackgroundColor:[UIColor clearColor]];
    [_depositsTV setBackgroundColor:[UIColor clearColor]];//right
    [_depositsTV setBackgroundView:[[UIImageView alloc]initWithImage:
                                                 [UIImage imageNamed:@"Default-568h.png"]]];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //Refresh data when required
//    [_depositsTV reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 54;
    }
    else
    {
        return 10;
    }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return  numberOfBags;//bag count
    return [_depositsCollection count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;//will always be one
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
        bagAmountTF = [[UITextField alloc]initWithFrame:CGRectMake(135, cell.bounds.size.height/4, 155, 25)];
        bagAmountTF.tag = BAG_AMOUNT_TF;
        bagAmountTF.textAlignment = NSTextAlignmentLeft;
        bagAmountTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        bagAmountTF.font = [UIFont systemFontOfSize:17];
        bagAmountTF.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
    
//        NSAttributedString *attString;
//        NSShadow* shadow = [[NSShadow alloc] init];
//        shadow.shadowColor = [UIColor whiteColor];
//        shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
//        [attString addAttribute:NSShadowAttributeName value:shadow range:range];
//        bagAmountTF.attributedText = attString;

        bagAmountTF.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bagAmountTF];
        
        
        //Construct Label
        bagNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 125 , 25)];
        bagNumberLbl.tag = BAG_NO_LBL;
        bagNumberLbl.textAlignment = NSTextAlignmentLeft;
        bagNumberLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        bagNumberLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        bagNumberLbl.shadowColor = [UIColor grayColor];
        bagNumberLbl.shadowOffset = CGSizeMake(1.0, 1.0);//better
        bagNumberLbl.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bagNumberLbl];
        
    }
    else
    {
        bagAmountTF = (UITextField *)[cell.contentView viewWithTag:BAG_AMOUNT_TF];
        bagNumberLbl = (UILabel *)[cell.contentView viewWithTag:BAG_NO_LBL];
    }
//        double amount = 000.00;//should add the 0s when a value there
    
    
//        Deposit *deposit = [_depositsArray lastObject];//wasnt same model object?
        Deposit *deposit = [_depositsCollection objectAtIndex:indexPath.section];//correct
        DLog(@"_depositsCollection contains>>>>>>>>>>>>>>>>>>: %@", _depositsCollection);
        //need getter here for these private ivars
        bagAmountTF.text = [NSString stringWithFormat:@"Amount is: €%.2f", [deposit countOfBagAmount]];//@"€%.2f"
        DLog(@"countOfBagAmount: %f", [deposit countOfBagAmount]);
    
        //set this locally for number but then static/gobal ivar
        int numberOfBags = [deposit countOfBagCount];
        int totalBags = 5;
        bagNumberLbl.text = [NSString stringWithFormat:@"Bag number: %i", numberOfBags];
    
    if (indexPath.section == [_depositsTV numberOfSections]-1) {
        bagNumberLbl.text = [NSString stringWithFormat:@"Total Bags: %i", totalBags];
        DLog(@"in IF statement");
    }
    
    
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
