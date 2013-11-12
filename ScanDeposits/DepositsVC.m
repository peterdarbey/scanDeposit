//
//  DepositsVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "DepositsVC.h"

#import "Deposit.h"

@interface DepositsVC ()
{
//    Deposit *deposit;
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
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //register for callbacks
    [_depositsTV setDelegate:self];
    [_depositsTV setDataSource:self];
    //self.view setBackgroundColor:[UIColor clearColor]];
    [_depositsTV setBackgroundColor:[UIColor clearColor]];//right
    [_depositsTV setBackgroundView:[[UIImageView alloc]initWithImage:
                                                 [UIImage imageNamed:@"Default-568h.png"]]];
    
    //TODO
    //Add editable code for fields
    UIBarButtonItem *editBBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    
    [self.navigationController.navigationItem setRightBarButtonItem:editBBtn];
    
}
- (void)editPressed:(UIButton *)sender {
    
    DLog(@"Edit presssed");
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //Refresh data when required
//    [_depositsTV reloadData];
    
    //if we can email enable the proceed button
    if([MFMailComposeViewController canSendMail]) {
        
        [proceedBtn setEnabled:YES];
    }
    
}
- (NSString *)getFilePath
{
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectoryPath stringByAppendingPathComponent:@"usersCollection.plist"];
    
    return fullPath;
}

- (NSString *)convertMyCollection {
    
//     NSMutableArray * __block parsedArray = [NSMutableArray array];
    
    NSString *__block parsedString = [[NSMutableString alloc]init];
    NSString *__block newString = [[NSMutableString alloc]init];
    
    
    //sent inline with subject body -> need to get this working
    NSMutableArray *userArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
    //ToDo add comma separated pairs to collection
    [userArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        for (NSArray *array in userArray) {
            for (int i = 0; i < [array count]; i++) {
                //retrieve each element
                obj = [array objectAtIndex:i];
                //cast and format
                NSString *stringObj = (NSString *) [NSString stringWithFormat:@"%@,", obj];//@"\"%@\","
                //add to collection
                parsedString = [parsedString stringByAppendingString:stringObj];
               newString = [parsedString stringByAppendingString:stringObj];
            }
        }
        
        DLog(@"newString: %@", newString);
    }];
    
         DLog(@"parsedString >>>>>: %@", parsedString);
    
    NSString *tabString = [NSString stringWithFormat:@"%@\t\t\t\t", newString];
    DLog(@"tabString: %@", tabString);
    return tabString; //newString
    
}

//email button
- (void)proceedPressed:(UIButton *)sender {
    
    
//    NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    NSString *docDir = [arrayPaths objectAtIndex:0];
//    NSString *Path = [docDir stringByAppendingString:@"/CSVFile.csv"];
//    NSData *csvData = [NSData dataWithContentsOfFile:Path];

    

    //ToDo package data up to fire off to webservice
//    //Create our recipients -> Note this will come from file later
    NSArray *emailRecipArray = @[@"peterdarbey@gmail.com", @"david.h.roberts@aib.ie", @"gavin.e.bennett@aib.ie"]; //@"fintan.a.killoran@aib.ie"];
    
    
        NSString *disclaimerString = @"IMPORTANT - IF THE ABOVE CONFIRMATION IS IN ANY WAY INACCURATE, YOU SHOULD IMMEDIATELY ADVISE YOUR BRANCH MANAGER / HRQMO. OTHERWISE, YOU ARE CONFIRMING THAT YOU WERE A CONTROL USER AS DESCRIBED ABOVE AND THAT THE CONTENTS OF THIS CONFIRMING MAIL ARE ACCURATE.";
   
    
    
        // https://github.com/jetseven/skpsmtpmessage rather than using MFMailController
    
//        NSMutableDictionary *appData = [[NSMutableDictionary alloc]init];
//        NSData *attachData = [NSPropertyListSerialization dataFromPropertyList:appData format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    
        //sent inline with subject body
        NSMutableArray *userArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
    
        //Create our recipients -> Note this will come from file later
        NSMutableArray *emailRecipientsArray = [NSMutableArray array];
        //iterate through collection to retrieve the recipients
        for (int i = 0; i < [userArray count]; i++) {
            NSString *recipient = [[userArray objectAtIndex:i]objectAtIndex:2];
            [emailRecipientsArray addObject:recipient];
        }
    
        DLog(@"emailRecipientsArray: %@", emailRecipientsArray);//works but need to receive myself as no aib.ie acc
    
        NSArray *contentArray = @[@"<number of bags>", @"<value of bags>"];
    
        NSString *newUserString = [self convertMyCollection];
        //serialize and convert to data for webservice
        NSData *dataString = [newUserString dataUsingEncoding:NSUTF8StringEncoding];
    
    
        //construct the mailVC and set its necessary parameters
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        
        [mailController setTitle:@"Please find the attached documents."];
        [mailController setSubject:NSLocalizedString(@"Device Manager Report + Date/time ->Process", @"Device Manager Report")];
        [mailController setCcRecipients:emailRecipArray];
        [mailController setToRecipients:emailRecipArray];//to me for now
        [mailController setMailComposeDelegate:self];
//        [mailController setMessageBody:[NSString stringWithFormat:@"Please find the attached documents: \n%@", userArray] isHTML:NO];
    
        //ToDo alot of parsing -> Temp code ***
        NSString *userName1 = [[userArray objectAtIndex:0]objectAtIndex:1];//hardCoded will need data from barcode too i.e. -> Process, SafeID and Date/Time
         NSString *userName2 = [[userArray objectAtIndex:1]objectAtIndex:1];//hardCoded
        //Inline with draft
        [mailController setMessageBody:[NSString stringWithFormat:@"This mail is your copy of the record that you\n (<Control User 1: %@>) and (<Control User 2: %@>) together opened and record the following contents of the <process> taken from <Safe ID> on <date><time>.\n\nContent Summary\n%@\n\n\n\n%@", userName1, userName2, contentArray, disclaimerString] isHTML:NO];//add disclaimer at end also
    
        [mailController addAttachmentData:dataString mimeType:@"text/csv" fileName:@"testData.csv"];//text/xml for plist content
    
//        [mailController addAttachmentData:csvData
//                                 mimeType:@"text/csv" //@"application/pdf" or text/plain or @"mime"
//                                 fileName:@"usersCollection.plist"];//@"CSVFile.csv" -> works as plist fileName
    
        [self presentViewController:mailController animated:YES completion:nil];
   
}

#pragma mark - MFMailCompose delegate callbacks
- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result) {
        //ToDo popup with message saying email sent successfully
//        [self becomeFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
            //ToDo add code here
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Email sent" message:@"Email successfully sent to recipients" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];//change for xib later
            [self.navigationController popToRootViewControllerAnimated:YES];//returning to HomeVC
            //ToDo reset app and clear data -> clear some data on device except usersCollection.plist
        }];
    }
    else if (error) {
        //ToDo error sending email
        
        [self dismissViewControllerAnimated:YES completion:^{
            //ToDo add code here
//            UIAlertView *alertView = [UIAlertView alloc]initWithTitle:@"Email sent" message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        }];
    }
    
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
//        [innerView setBackgroundColor:[UIColor lightGrayColor]];//was whiteColor
        [innerView setBackgroundColor:[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:1.0]];
        innerView.layer.cornerRadius = 5.0;
        
        //construct a button to proceed
        proceedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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

//        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i", [Deposit totalNumberOfBags]]];
        DLog(@"BAG COUNT: %i", [Deposit getTotalBagCount]);//appDelegate.totalBagCount
        //TEST
//        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i",appDelegate.totalBagCount]];
        
        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i",[Deposit getTotalBagCount]]];
//        DLog(@"BAG COUNT: %i", appDelegate.totalBagCount);
        
        [bagLbl setUserInteractionEnabled:NO];
        //add to view
        [innerView addSubview:bagLbl];
        

        //Construct another label for amount
        UILabel *bagAmountLbl = [[UILabel alloc]initWithFrame:CGRectMake(210, 10, 80 , 25)];
        bagAmountLbl.textAlignment = NSTextAlignmentRight;
        bagAmountLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        bagAmountLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        bagAmountLbl.shadowColor = [UIColor grayColor];
        bagAmountLbl.shadowOffset = CGSizeMake(1.0, 1.0);//better
        bagAmountLbl.backgroundColor = [UIColor clearColor];
        [bagAmountLbl setUserInteractionEnabled:NO];
        //retrieve the total bag amount from the class method here
        [bagAmountLbl setText:[NSString stringWithFormat:@"€%.2f", [Deposit totalBagsAmount]]];
        //add to innerView
        [innerView addSubview:bagAmountLbl];

        
        
        //construct a UILabel for total amount
        UITextField *amountTF = [[UITextField alloc]initWithFrame:CGRectMake(130, 10, 160, 25)];
        [amountTF setBackgroundColor:[UIColor clearColor]];
        [amountTF setFont:[UIFont systemFontOfSize:17]];
        amountTF.textAlignment = NSTextAlignmentLeft;
        amountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        amountTF.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        [amountTF setUserInteractionEnabled:NO];
        
//        [amountTF setText:[NSString stringWithFormat:@"Total: €%.2f", _totalDepositAmount]];
        [amountTF setText:[NSString stringWithFormat:@"Total deposit:"]];

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
    UILabel *bagAmountLbl;
    UILabel *bagNumberLbl;
    
    //assign here but not dependent on instance state here so also displayed in view so dont need the specified index
//        _totalDepositAmount = [Deposit totalBagsAmount];
   
    
    //1st time thru cell doesnt exist so create else dequeue
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        //Construct textField
        bagAmountTF = [[UITextField alloc]initWithFrame:CGRectMake(130, cell.bounds.size.height/4, 160, 25)];
        bagAmountTF.tag = BAG_AMOUNT_TF;
        bagAmountTF.textAlignment = NSTextAlignmentLeft;
//        bagAmountTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        bagAmountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        bagAmountTF.font = [UIFont systemFontOfSize:17];
        bagAmountTF.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
        [bagAmountTF setUserInteractionEnabled:NO];
        
        bagAmountTF.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:bagAmountTF];
        
        
        //Construct another label for amount
        bagAmountLbl = [[UILabel alloc]initWithFrame:CGRectMake(210, cell.bounds.size.height/4, 80 , 25)];
        bagAmountLbl.tag = BAG_AMOUNT;
        bagAmountLbl.textAlignment = NSTextAlignmentRight;
        bagAmountLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        bagAmountLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        bagAmountLbl.shadowColor = [UIColor grayColor];
        bagAmountLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        bagAmountLbl.backgroundColor = [UIColor clearColor];
        [bagAmountLbl setUserInteractionEnabled:NO];
        [cell.contentView addSubview:bagAmountLbl];
        
        //Construct Label
        bagNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 120 , 25)];
        bagNumberLbl.tag = BAG_NO_LBL;
        bagNumberLbl.textAlignment = NSTextAlignmentLeft;
        bagNumberLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];//17
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
        bagAmountLbl = (UILabel *)[cell.contentView viewWithTag:BAG_AMOUNT];//new property
        bagNumberLbl = (UILabel *)[cell.contentView viewWithTag:BAG_NO_LBL];
    }
    
        Deposit *deposit = [_depositsCollection objectAtIndex:indexPath.section];
    
        DLog(@"_totalDepositAmount>>>: %f", _totalDepositAmount);
        DLog(@"_depositsCollection contains: %@", _depositsCollection);
        //need getter here for these private ivars
        bagAmountTF.text = [NSString stringWithFormat:@"Amount is:"];//@"€%.2f"
        DLog(@"countOfBagAmount: %f", [deposit countOfBagAmount]);
    
        bagAmountLbl.text = [NSString stringWithFormat:@"€%.2f", [deposit countOfBagAmount]];//@"€%.2f"
    
    
        //get the indiviual bag number from indexPath and add one
        NSInteger bagRow = indexPath.section;
        bagNumberLbl.text = [NSString stringWithFormat:@"Bag number: %i", bagRow +1];
    
        return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 0 ) {
        if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singleCell"]];
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singleCellSelected"]];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
