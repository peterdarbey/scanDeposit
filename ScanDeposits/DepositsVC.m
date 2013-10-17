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
    Deposit *deposit;
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
- (void)proceedPressed:(UIButton *)sender {
    
    DLog(@"Proceed pressed");
}

-(void)buttonStyle:(UIButton *)button WithImgName:(NSString *)imgName imgSelectedName:(NSString *)selectedName withTitle:(NSString *)title
{
    //button parameters
    UIImage *stretchButon = [[UIImage imageNamed:imgName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button setBackgroundImage:stretchButon forState:UIControlStateNormal];
    UIImage *stretchSelectedButton = [[UIImage imageNamed:selectedName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [button setBackgroundImage:stretchSelectedButton forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == [_depositsTV numberOfSections]-1) {
        
    
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 145)];//85
        [aView setBackgroundColor:[UIColor clearColor]];
        //construct an innerView to hole placeHolders
        UIView *innerView = [[UIView alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width -20, 45)];
        [innerView setBackgroundColor:[UIColor whiteColor]];
        innerView.layer.cornerRadius = 5.0;
        
        //construct a button to proceed
        UIButton *proceedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [proceedBtn setFrame:CGRectMake(10, aView.frame.size.height -60, 300, 44)];
        [proceedBtn setUserInteractionEnabled:YES];
        [proceedBtn addTarget:self action:@selector(proceedPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self buttonStyle:proceedBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"PROCEED"];
        
        //add to parent view
        [aView addSubview:proceedBtn];
        
        
        //construct a UILabel for text
        UILabel *bagLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 25)];
        [bagLbl setBackgroundColor:[UIColor clearColor]];
        [bagLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        bagLbl.textAlignment = NSTextAlignmentLeft;
        bagLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        bagLbl.shadowColor = [UIColor grayColor];
        bagLbl.shadowOffset = CGSizeMake(1.0, 1.0);
//        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i", _bagCount]];//[Deposit totalNumberOfBags]
        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i", [Deposit totalNumberOfBags]]];
        DLog(@"BAG COUNT: %i", [Deposit totalNumberOfBags]);
        [bagLbl setUserInteractionEnabled:NO];
        //add to view
        [innerView addSubview:bagLbl];
        
//        [aView addSubview:bagLbl];
        
        
        //construct a UILabel for total amount
        UITextField *amountTF = [[UITextField alloc]initWithFrame:CGRectMake(130, 10, 160, 25)];
        [amountTF setBackgroundColor:[UIColor clearColor]];
        [amountTF setFont:[UIFont systemFontOfSize:17]];
        amountTF.textAlignment = NSTextAlignmentLeft;
        amountTF.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        [amountTF setUserInteractionEnabled:NO];
        [amountTF setText:[NSString stringWithFormat:@"Total: €%.2f", _totalDepositAmount]];
        //add to view
        [innerView addSubview:amountTF];
        [aView addSubview:innerView];

        return aView;
    }//close if
    else
    {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section== [_depositsTV numberOfSections]-1) {
        return 145.0;//was 85.0 which was correct but now need a button
    }
    else
    {
        return 10.0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 64;
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
        bagAmountTF = [[UITextField alloc]initWithFrame:CGRectMake(130, cell.bounds.size.height/4, 160, 25)];
        bagAmountTF.tag = BAG_AMOUNT_TF;
        bagAmountTF.textAlignment = NSTextAlignmentLeft;
        bagAmountTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        bagAmountTF.font = [UIFont systemFontOfSize:17];
        bagAmountTF.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        [bagAmountTF setUserInteractionEnabled:NO];
//        NSAttributedString *attString;
//        NSShadow* shadow = [[NSShadow alloc] init];
//        shadow.shadowColor = [UIColor whiteColor];
//        shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
//        [attString addAttribute:NSShadowAttributeName value:shadow range:range];
//        bagAmountTF.attributedText = attString;
        
        bagAmountTF.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bagAmountTF];
        
        
        //Construct Label
        bagNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 120 , 25)];
        bagNumberLbl.tag = BAG_NO_LBL;
        bagNumberLbl.textAlignment = NSTextAlignmentLeft;
        bagNumberLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        bagNumberLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        bagNumberLbl.shadowColor = [UIColor grayColor];
        bagNumberLbl.shadowOffset = CGSizeMake(1.0, 1.0);//better
        bagNumberLbl.backgroundColor = [UIColor clearColor];
        [bagNumberLbl setUserInteractionEnabled:NO];
        [cell.contentView addSubview:bagNumberLbl];
        
    }
    else
    {
        bagAmountTF = (UITextField *)[cell.contentView viewWithTag:BAG_AMOUNT_TF];
        bagNumberLbl = (UILabel *)[cell.contentView viewWithTag:BAG_NO_LBL];
    }
//        double amount = 000.00;//should add the 0s when a value there
    
    
//        Deposit *deposit = [_depositsArray lastObject];//wasnt same model object?
        deposit = [_depositsCollection objectAtIndex:indexPath.section];//correct
        _totalDepositAmount += [deposit countOfBagAmount];
        DLog(@"_totalDepositAmount>>>: %f", _totalDepositAmount);
        DLog(@"_depositsCollection contains: %@", _depositsCollection);
        //need getter here for these private ivars
        bagAmountTF.text = [NSString stringWithFormat:@"Amount is: €%.2f", [deposit countOfBagAmount]];//@"€%.2f"
        DLog(@"countOfBagAmount: %f", [deposit countOfBagAmount]);
    
        //set this locally for number but then static/gobal ivar
        int numberOfBags = [deposit countOfBagCount];
        bagNumberLbl.text = [NSString stringWithFormat:@"Bag number: %i", numberOfBags];
    
//    if (indexPath.section == [_depositsTV numberOfSections]-1) {
//        bagNumberLbl.text = [NSString stringWithFormat:@"Total Bags: %i", totalBags];
//        DLog(@"in IF statement");
//    }
    
    
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
