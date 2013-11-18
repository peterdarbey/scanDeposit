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

//should be a helper object
- (NSString *)convertMyCollectionFromCollection:(NSMutableArray *)deposits {
    
    
    NSString *__block parsedString = [[NSMutableString alloc]init];
    
    //Sent as an attachment -> Note: this is all the data we need to send pertaining to a lodgement
//    NSMutableArray *userArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];//NOT this anymore
    
    DLog(@"_depositsArray contains: %@", _depositsCollection);// --> actual bag deposit details
    //extract the required fields for attachment
    NSMutableArray *depositArray = [NSMutableArray array];
    DLog(@"depositArray: %@", depositArray);
    
    for (id object in _depositsCollection) {
        Deposit *deposit = (Deposit *)object;
        NSMutableArray *array = [NSMutableArray array];
//        [array addObject:[deposit timeStamp]];//actual time
        [array addObject:@([deposit bagAmount])];//each bag amount
        [array addObject:[deposit bagNumber]];//Unique bag number -> now Process
        [array addObject:[deposit bagBarcode]];//Unigue bag number
        //add to depositArray
        [depositArray addObject:array];//crash
    }
    //add the total amount and count at the end
//    [depositArray addObject:@([Deposit totalBagsAmount])];
//    [depositArray addObject:@([Deposit totalBagCount])];
    
    DLog(@"<< depositArray >>: %@", depositArray);
    
    double bagAmount;
    NSString *uniqueBagNo;
    //now format the array with required fields for CSV attachment
    for (NSArray *array in depositArray) {
        for (int i = 0; i < [array count]; i++) {
            
            NSString *bagBarcode;
            NSString *appendedString;
            //retrieve each element and format
            if (i == 0) {
                bagAmount = [array[i]doubleValue];
            }
            else if (i == 1) {
                uniqueBagNo = array[i];
            }
            else if (i == 2 && bagAmount && uniqueBagNo) {
                bagBarcode = array[i];
                appendedString = [NSString stringWithFormat:@"€%.2f,%@,%@,\n", bagAmount, uniqueBagNo, bagBarcode];
                DLog(@"appendedString: %@", appendedString);
                parsedString = [parsedString stringByAppendingString:appendedString];//452.130000,A Coin Only Dropsafe,19005349, --> Dont forget newLine escape seq
            }
           
        }//close inner for
        
    }//close outer for
    
        DLog(@"parsedString>>>>>>>>>>>>>: %@", parsedString);
        NSString *tabString = [NSString stringWithFormat:@"%@,,,,,,,,,,", parsedString];//correct
        return tabString;// --> use excel xml format and create headers
    
}

// https://github.com/jetseven/skpsmtpmessage rather than using MFMailController
- (void)proceedPressed:(UIButton *)sender {

//        NSMutableDictionary *appData = [[NSMutableDictionary alloc]init];
//        NSData *attachData = [NSPropertyListSerialization dataFromPropertyList:appData format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];

    
    
    
//    //Create our recipients -> Note this will come from file later
//    NSArray *emailRecipArray = @[@"peterdarbey@gmail.com", @"david.h.roberts@aib.ie", @"gavin.e.bennett@aib.ie"];
    
        //TEMP email assignees
        NSArray *emailRecipArray = @[@"peterdarbey@gmail.com"];//, @"fintan.a.killoran@aib.ie"];
    
    
        //send email to all the users stored on the device for now
        NSMutableArray *userArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
        //Create our default recipients from file for all emails
        NSMutableArray *emailRecipientsArray = [NSMutableArray array];
        //iterate through collection to retrieve the recipients
        for (int i = 0; i < [userArray count]; i++) {
            NSString *recipient = [[userArray objectAtIndex:i]objectAtIndex:2];
            [emailRecipientsArray addObject:recipient];
        }
        DLog(@"emailRecipientsArray: %@", emailRecipientsArray);
    
    
    
        //Populate the mail data with the logged in users also
        DLog(@"Logged in usersDict passed: %@", _usersDict);
        //returns a dict for each user associated with the lodgement via log in
        NSDictionary *userOne = _usersDict[@1];//correct
        NSDictionary *userTwo = _usersDict[@2];
        DLog(@"userOne: %@ and UserTwo: %@", userOne, userTwo);
        
        //retrieves each logged in users name --> may need users emails also
        NSString *userOneName = userOne[@"Name"];
        NSString *userOneEMail = userOne[@"Email"];
        NSString *userTwoName = userTwo[@"Name"];
        NSString *userTwoEMail = userTwo[@"Email"];
    
    
        NSArray *contentArray = @[@"<number of bags>", @"<value of bags>"];
    
        NSString *newUserString = [self convertMyCollectionFromCollection:_depositsCollection];
        //serialize and convert to data for webservice
        NSData *dataString = [newUserString dataUsingEncoding:NSUTF8StringEncoding];
    
    
        //construct the mailVC and set its necessary parameters
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        
        [mailController setTitle:@"Please find the attached documents."];
        [mailController setSubject:NSLocalizedString(@"Device Manager Report + Date/time ->Process", @"Device Manager Report")];
        [mailController setCcRecipients:emailRecipArray];
        [mailController setToRecipients:emailRecipArray];//to me for now
        [mailController setMailComposeDelegate:self];

    
    
        //disclaimer content
        NSString *disclaimerString = @"IMPORTANT - IF THE ABOVE CONFIRMATION IS IN ANY WAY INACCURATE, YOU SHOULD IMMEDIATELY ADVISE YOUR BRANCH MANAGER / HRQMO. OTHERWISE, YOU ARE CONFIRMING THAT YOU WERE A CONTROL USER AS DESCRIBED ABOVE AND THAT THE CONTENTS OF THIS CONFIRMING MAIL ARE ACCURATE.";
    
        //Inline with draft
        [mailController setMessageBody:[NSString stringWithFormat:@"This mail is your copy of the record that you\n <Control User 1: %@> and <Control User 2: %@> together opened and record the following contents of the <process> taken from <Safe ID> on <date><time>.\n\nContent Summary\n%@\n\n\n\n%@", userOneName, userTwoName, contentArray, disclaimerString] isHTML:NO];
    
        [mailController addAttachmentData:dataString mimeType:@"text/csv" fileName:@"testData.csv"];//text/xml for plist content
    
        //present the mail composer
        [self presentViewController:mailController animated:YES completion:nil];
    
    
    
//        [mailController addAttachmentData:csvData
//                                 mimeType:@"text/csv" //@"application/pdf" or text/plain or @"mime"
//                                 fileName:@"usersCollection.plist"];//@"CSVFile.csv" -> works as plist fileName
   
}

#pragma mark - MFMailCompose delegate callbacks
- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result) {
        //ToDo popup with message saying email sent successfully
//        [self becomeFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
            //ToDo add code here --> add custom popup here green for go and reset all the deposit data
            
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Email sent" message:@"Email successfully sent to recipients" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];//change for xib later
            [self.navigationController popToRootViewControllerAnimated:YES];//returning to HomeVC
            //Log the user out also******
            
            //ToDo reset app and clear data -> clear some data on device except usersCollection.plist
        }];
    }
    else if (error) {
        //ToDo error sending email
        
        [self dismissViewControllerAnimated:YES completion:^{
             //ToDo add code here --> Warning popup here - Red
            [self showWarningPopupWithTitle:@"Error: Unable to send email" andMessage:@"Unable to send email, please check your signal" forBarcode:nil];
        }];
    }
    
}

#pragma mark - custom popup xibs

- (void)showWarningPopupWithTitle:(NSString *)title andMessage:(NSString *)message
                       forBarcode:(NSString *)barcodeString {
    
    //Create a custom WarningPopup.xib
    WarningPopup *warningPopup = [WarningPopup loadFromNibNamed:@"WarningPopup"];
    //set delegate
//    [warningPopup setDelegate:self];
    
    //set text
    warningPopup.titleLbl.text = title;
    warningPopup.messageLbl.text = message;
    
    
    //ToDo add whatever setup code required here
    [warningPopup showOnView:self.view];
    
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
        [self buttonStyle:proceedBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"SEND EMAIL"];
        
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
        DLog(@"BAG COUNT: %i", [Deposit totalBagCount]);//appDelegate.totalBagCount
        //TEST
//        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i",appDelegate.totalBagCount]];
        
        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i",[Deposit totalBagCount]]];
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
        [amountTF setText:[NSString stringWithFormat:@"Total:"]];

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
    
    UILabel *bagAmountLbl;
    UILabel *bagNumberLbl;
    
    //assign here but not dependent on instance state here so also displayed in view so dont need the specified index
//        _totalDepositAmount = [Deposit totalBagsAmount];
   
    
    //1st time thru cell doesnt exist so create else dequeue
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        //Construct textField
//        bagAmountTF = [[UITextField alloc]initWithFrame:CGRectMake(130, cell.bounds.size.height/4, 160, 25)];
//        bagAmountTF.tag = BAG_AMOUNT_TF;
//        bagAmountTF.textAlignment = NSTextAlignmentLeft;
////        bagAmountTF.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        bagAmountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        bagAmountTF.font = [UIFont systemFontOfSize:17];
//        bagAmountTF.textColor = [UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0];//darkGray
//        [bagAmountTF setUserInteractionEnabled:NO];
//        
//        bagAmountTF.backgroundColor = [UIColor redColor];

        
        
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
        bagNumberLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, cell.bounds.size.height/4, 190 , 25)];
        bagNumberLbl.tag = BAG_NO_LBL;
        bagNumberLbl.textAlignment = NSTextAlignmentLeft;
        bagNumberLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];//17
        bagNumberLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        bagNumberLbl.shadowColor = [UIColor grayColor];
        bagNumberLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        bagNumberLbl.backgroundColor = [UIColor clearColor];
        [bagNumberLbl setUserInteractionEnabled:NO];
        [cell.contentView addSubview:bagNumberLbl];
        
    }
    else
    {
        bagAmountLbl = (UILabel *)[cell.contentView viewWithTag:BAG_AMOUNT];
        bagNumberLbl = (UILabel *)[cell.contentView viewWithTag:BAG_NO_LBL];
    }
    
        Deposit *deposit = [_depositsCollection objectAtIndex:indexPath.section];
    
        DLog(@"_totalDepositAmount>>>: %f", _totalDepositAmount);
        DLog(@"_depositsCollection contains: %@", _depositsCollection);
        //need getter here for these private ivars
        DLog(@"countOfBagAmount: %f", [deposit bagAmount]);
    
        bagAmountLbl.text = [NSString stringWithFormat:@"€%.2f", [deposit bagAmount]];
    
        bagNumberLbl.text = [NSString stringWithFormat:@"Bag No: %@", [deposit bagBarcode]];//unique bag number
    
        return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.row == 0 ) {
        if ([tableView numberOfRowsInSection:indexPath.section] == 1) {
            cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singleCell.png"]];
            cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singleCellSelected.png"]];
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
