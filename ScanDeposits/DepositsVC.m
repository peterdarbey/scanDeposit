//
//  DepositsVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 15/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//


#import "HomeVC.h"

//Popup
#import "SuccessPopup.h"
#import "DepositsVC.h"

//Models
#import "Deposit.h"
#import "QRBarcode.h"
#import "EightBarcode.h"
#import "StringParserHelper.h"

@interface DepositsVC ()
{
    SuccessPopup *successPopup;
    UIBarButtonItem *editBBtn, *doneBtn;
}

@property double editedBagAmount;
@property int editedBagCount;

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
    
    //Add editable code for fields
    editBBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPressed:)];
    
    [self.navigationItem setRightBarButtonItem:editBBtn];
    
    //init our email array
    _dataArray = [NSMutableArray array];
    
    _valueRemoved = NO;
    
    
//    //Moved here from viewWillAppear
//    //if we can email enable the proceed button
//    if([MFMailComposeViewController canSendMail]) {
//        
//        [proceedBtn setEnabled:YES];
//    }
    
}

#pragma mark - custom popup xibs

- (void)showSuccessPopupWithTitle:(NSString *)title andMessage:(NSString *)message
                       forBarcode:(NSString *)barcodeString {
    
//    //Create a custom SuccessPopup.xib
//    //Now gobal which resolved the issue
    successPopup = [SuccessPopup loadFromNibNamed:@"SuccessPopup"];
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[HomeVC class]]) {
            HomeVC *homeVC = (HomeVC *)viewController;
            [successPopup setDelegate:homeVC];//sets here
        }
    }
    
    //test this delegate method
    [successPopup setNotDelegate:self];
    
    //set text
    successPopup.titleLbl.text = title;
    successPopup.messageLbl.text = message;
   
    //ToDo add whatever setup code required here
    [successPopup showOnView:self.view];
    
}

- (void)editPressed:(UIButton *)sender {
    
    DLog(@"Edit presssed");//works
    
    _allowEdit = YES;
    [_depositsTV reloadData];
    
    doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressed:)];
    //set the done button as the current barButton
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
}

- (void)doneBtnPressed:(UIButton *)sender {
    
    DLog(@"DoneBtnPressed");
    
    [_depositsTV reloadData];
    
    //set the edit button as the current barButton
    [self.navigationItem setRightBarButtonItem:editBBtn];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        DLog(@"Remove item at index here");
        //set this first to update the conditional in numberOfSections
        _valueRemoved = YES;
        [_depositsTV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //extract the bagAmount and bagtotal in order to subtract from total amount ect..
        Deposit *tempDeposit = [_depositsCollection objectAtIndex:indexPath.section];
        _editedBagCount = (int)[tempDeposit bagCount];
        _editedBagAmount = (double)[tempDeposit bagAmount];
        
        //remove the data from our deposits collection
        [_depositsCollection removeObjectAtIndex:indexPath.section];//works
        //Once removed here the proceed button will iterate this collection so up to date data intact
        //ToDo
        //Update the total bag count and amount in view
        [_depositsTV reloadData];//this causes a problem, as no sections after update viewForFooter disappears
       
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //if we can email enable the proceed button
    if([MFMailComposeViewController canSendMail]) {
        
        [proceedBtn setEnabled:YES];
    }
    
    _allowEdit = NO;
}

#pragma mark - Custom delegate method
//make a delegate method
- (void)DismissUnderlyingVC {

        //dismiss the viewController and wipe data
       [self.navigationController popToRootViewControllerAnimated:YES];
    
        //Reset all barcode data, logged in users and the recorded deposits
        [self wipeAndResetData];
}

- (void)wipeAndResetData {
    
    DLog(@"DepositsCollection: %@", _depositsCollection);
    //wipe recorded deposits
    _depositsCollection = nil;
    
    DLog(@"_barcodeArray: %@", _barcodeArray);
    DLog(@"_usersDict: %@", _usersDict);
    //wipe recorded QR and ITF barcode data
    _barcodeArray = nil;
    //wipe recorded logged in users of the app
    _usersDict = nil;
    
    //reset bag data types also
    _totalDepositAmount = 0.0;
    _bagCount = 0;
}


- (NSString *)getFilePath
{
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectoryPath stringByAppendingPathComponent:@"adminsCollection.plist"];
    
    return fullPath;
}

//should be a helper object

- (NSMutableArray *)collectMyData {
    
    //Test
//    NSString *header = [NSString stringWithFormat:@"Date/Time,Branch NSC,Process Type,Safe ID,Sequence No,Unique No,Bag Count,Total Bag Count,Bag Amount,Control User 1:Name,Control User 1:Email,Control User 2:Name, Control User 2:Email,Administrator"];
    
        //extract barcode data
        if (_barcodeArray) {
    
            //extract the barcode objects required values
            for (id object in _barcodeArray) {
                if ([object isKindOfClass:[QRBarcode class]]) {
                    QRBarcode *qrBarcode = (QRBarcode *)object;
//                    [_dataArray addObject:header];// --> leave out for now
                    //Add elements to the array
                    [_dataArray addObject:[qrBarcode barcodeBranch]];
                    [_dataArray addObject:[qrBarcode barcodeProcess]];
                    [_dataArray addObject:@([qrBarcode barcodeSafeID])];//Device
                }
            }//close for
        }
    
    //extract all the deposit data
    if (_depositsCollection) {
        
        for (id object in _depositsCollection) {
            if ([object isKindOfClass:[Deposit class]]) {
                Deposit *deposit = (Deposit *)object;
                //added last 6digits --> Sequence Number
                [_dataArray addObject:[[deposit bagBarcode]substringFromIndex:6]];
                [_dataArray addObject:[deposit bagBarcode]];//has ITF --> barcodeUniqueBagNumber
                [_dataArray addObject:@([deposit bagCount])];//int
                [_dataArray addObject:@([deposit bagAmount])];//double
                [_dataArray addObject:[deposit timeStamp]];//add date/time
            }
        }//close for
        //dont forget static methods ie count and amount total
        [_dataArray addObject:@([Deposit totalBagCount])];//should be right
        [_dataArray addObject:@([Deposit totalBagsAmount])];
        
    }

        //retrieves each LOGGED IN users name and email
        if (_usersDict) {
        
            //userOne
            NSDictionary *userOneDict = _usersDict[@1];
            [_dataArray addObject:userOneDict[@"Name"]];
            [_dataArray addObject:userOneDict[@"Email"]];
            //userTwo
            NSDictionary *userTwoDict = _usersDict[@2];
            [_dataArray addObject:userTwoDict[@"Name"]];
            [_dataArray addObject:userTwoDict[@"Email"]];
        
        }//close userDict

    
    //Also need Administrators after --> use the adminsCollection.plist for this data
    NSMutableArray *adminArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
//    DLog(@"adminArray: %@", adminArray);

        if (adminArray) {
            for (int i = 0; i < [adminArray count]; i++) {
                NSString *adminName = [[adminArray objectAtIndex:i]objectAtIndex:0];//name
                [_dataArray addObject:adminName];
            }
        }//close if
    
    DLog(@"<<<<<<<< _dataArray contents >>>>>>>>>>: %@", _dataArray);
    
    return _dataArray;
}


// https://github.com/jetseven/skpsmtpmessage rather than using MFMailController

- (void)proceedPressed:(UIButton *)sender {

//        NSMutableDictionary *appData = [[NSMutableDictionary alloc]init];
//        NSData *attachData = [NSPropertyListSerialization dataFromPropertyList:appData format:NSPropertyListXMLFormat_v1_0 errorDescription:nil];
    

    
    
        //returns a string with as a csv format
        _dataArray = [self collectMyData];
        //Now need to parse my new data collection
        NSString *finalString = [StringParserHelper parseMyCollection:_dataArray];
//        finalString = [NSString stringWithFormat:@"%@,,,,,,,,,,", finalString];//correct
        
        //serialize and convert to data for webservice
        NSData *dataString = [finalString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
//    //Create our recipients -> Note this will come from file later
//    NSArray *emailRecipArray = @[@"peterdarbey@gmail.com", @"david.h.roberts@aib.ie", @"eimear.e.ferguson@aib.ie", @"gavin.e.bennett@aib.ie"];
    
        //TEMP email assignees
        NSArray *emailRecipArray = @[@"peterdarbey@gmail.com"];//, @"fintan.a.killoran@aib.ie"];
    
        //send email to all the users stored on the device for now
        NSMutableArray *adminArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
        //Create our default recipients from file for all emails
        NSMutableArray *emailRecipientsArray = [NSMutableArray array];
        //iterate through collection to retrieve the recipients
        DLog(@"adminArray: %@", adminArray);
        for (int i = 0; i < [adminArray count]; i++) {
            NSString *recipient = [[adminArray objectAtIndex:i]objectAtIndex:1];//now email
            [emailRecipientsArray addObject:recipient];
        }
    
        //data returned a dict for each user associated with the lodgement via log in
        //For message body
        NSDictionary *userOne = _usersDict[@1];
        NSDictionary *userTwo = _usersDict[@2];
        NSString *userOneName = userOne[@"Name"];
        NSString *userTwoName = userTwo[@"Name"];

        //construct the mailVC and set its necessary parameters
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
        [mailController setTitle:@"Please find the attached documents."];
        [mailController setSubject:NSLocalizedString(@"Device Manager Report + Date/time ->Process", @"Device Manager Report")];
        [mailController setCcRecipients:emailRecipArray];
        [mailController setToRecipients:emailRecipArray];//currently me will be --> emailRecipientsArray
        [mailController setMailComposeDelegate:self];
    
        //Email container settings
//        NSArray *contentArray = @[@"<number of bags>", @"<value of bags>"];
        NSArray *contentArray = @[@([Deposit totalBagCount]), @([Deposit totalBagsAmount])];
    
        //disclaimer content
        NSString *disclaimerString = @"IMPORTANT - IF THE ABOVE CONFIRMATION IS IN ANY WAY INACCURATE, YOU SHOULD IMMEDIATELY ADVISE YOUR BRANCH MANAGER / HRQMO. OTHERWISE, YOU ARE CONFIRMING THAT YOU WERE A CONTROL USER AS DESCRIBED ABOVE AND THAT THE CONTENTS OF THIS CONFIRMING MAIL ARE ACCURATE.";
        //for message body
        QRBarcode *qrBarcode;
        if ([_barcodeArray[0] isKindOfClass:[QRBarcode class]]) {
            qrBarcode = _barcodeArray[0];
        }
    
        //Inline with draft
        [mailController setMessageBody:[NSString stringWithFormat:@"This mail is your copy of the record that you\n <Control User 1: %@> and <Control User 2: %@> together opened and record the following contents of the <process: %@> taken from <Safe ID: %i> on <date><time: %@>.\n\nContent Summary\n%@\n\n\n\n%@", userOneName, userTwoName, [qrBarcode barcodeProcess], [qrBarcode barcodeSafeID], [NSDate date],contentArray, disclaimerString] isHTML:NO];
    
        //add attachment to email
        [mailController addAttachmentData:dataString mimeType:@"text/csv" fileName:@"mailData.csv"];//text/xml for plist content
        //present the mail composer
        [self presentViewController:mailController animated:YES completion:nil];
    
}



#pragma mark - MFMailCompose delegate callbacks
- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result) {

        //disable the send email button on succces
        [proceedBtn setEnabled:NO];
        
        //dismiss mailComposer
        [self dismissViewControllerAnimated:YES completion:nil];
        
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            //custom Success Popup may add a pause here
            [self showSuccessPopupWithTitle:@"Success email sent" andMessage:@"Email successfully sent to recipients" forBarcode:nil];//put in completion block above
        });
                
    }//close if
    
    else if (error) {
        
        [self dismissViewControllerAnimated:YES completion:^{
             //custom Warning Popup
            [self showWarningPopupWithTitle:@"Error: Unable to send email" andMessage:@"Unable to send email, please check your signal" forBarcode:nil];
            //ToDo decide where to go from here if it fails can we send again
            [proceedBtn setEnabled:YES];//maybe
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
        [bagLbl setUserInteractionEnabled:NO];
//        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i",[Deposit totalBagCount]]];
        
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
//        [bagAmountLbl setText:[NSString stringWithFormat:@"€%.2f", [Deposit totalBagsAmount]]];
        
        DLog(@"BEORE BAG COUNT: %i", [Deposit totalBagCount]);
        
        DLog(@"BEFORE valueChanged: %f", [Deposit totalBagsAmount]);
        
        if (_valueRemoved) {//damn
            //ToDo change the deposit total and bag total
            [bagAmountLbl setText:[NSString stringWithFormat:@"€%.2f", [Deposit totalBagsAmount] - _editedBagAmount]];
            [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i",[Deposit totalBagCount] - _editedBagCount]];
            
        }
        else
        {
            //retrieve the total bag amount from the class method here
            [bagAmountLbl setText:[NSString stringWithFormat:@"€%.2f", [Deposit totalBagsAmount]]];
            [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i",[Deposit totalBagCount]]];
        }
       
        DLog(@"AFTER valueChanged: %f", [Deposit totalBagsAmount]);
        DLog(@"AFTER BAG COUNT: %i", [Deposit totalBagCount]);
        
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
    DLog(@"count in sections: %i", [_depositsCollection count]);//1 before update
    return [_depositsCollection count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        //crash because model doesnt have a count method
//        return [[_depositsCollection objectAtIndex:section]count];//will always be one except on deletion
    
    //before _valueRemoved was put first it was calling numOfSects twice as it thought 2 rows so 2 calls to numbOfS
    if (_valueRemoved) {
        return 0;
    }
    else
    {
         return 1;//will always be one
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedIndexPath = indexPath;
    [_depositsTV deselectRowAtIndexPath:indexPath animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"depositCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
//    UILabel *bagAmountLbl;
    UITextField *bagAmountTF;
    UILabel *bagNumberLbl;
    
    //1st time thru cell doesnt exist so create else dequeue
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        
        //Construct another label for amount
        bagAmountTF = [[UITextField alloc]initWithFrame:CGRectMake(210, cell.bounds.size.height/4, 80 , 25)];
        bagAmountTF.tag = BAG_AMOUNT;
        bagAmountTF.textAlignment = NSTextAlignmentRight;
        bagAmountTF.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        bagAmountTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
//        bagAmountTF.shadowColor = [UIColor grayColor];
//        bagAmountTF.shadowOffset = CGSizeMake(1.0, 1.0);
        bagAmountTF.backgroundColor = [UIColor clearColor];
        [bagAmountTF setUserInteractionEnabled:NO];
        [bagAmountTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        //set delegate
        [bagAmountTF setDelegate:self];
        //add to view
        [cell.contentView addSubview:bagAmountTF];
        
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
        bagAmountTF = (UITextField *)[cell.contentView viewWithTag:BAG_AMOUNT];
        bagNumberLbl = (UILabel *)[cell.contentView viewWithTag:BAG_NO_LBL];
    }
    
        Deposit *deposit = [_depositsCollection objectAtIndex:indexPath.section];
    
        DLog(@"_totalDepositAmount>>>: %f", _totalDepositAmount);
        DLog(@"_depositsCollection contains: %@", _depositsCollection);//1
        //need getter here for these private ivars
        DLog(@"countOfBagAmount: %f", [deposit bagAmount]);
    
        bagAmountTF.text = [NSString stringWithFormat:@"€%.2f", [deposit bagAmount]];
    
        bagNumberLbl.text = [NSString stringWithFormat:@"Bag No: %@", [deposit bagBarcode]];//unique bag number
    
    if (_allowEdit) {
        DLog(@"Allow editing here");
        [bagAmountTF setUserInteractionEnabled:YES];//test
        
        
        
    }
    
    
        return cell;
}
#pragma mark - UITextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    UITableViewCell *cell = (UITableViewCell *)[textField.superview superview];
    NSIndexPath *indexPath = [_depositsTV indexPathForCell:cell];
    
    if (_allowEdit && [textField.text length] > 0) {
        
        //retrieve the deposit model for the TF index
        Deposit *deposit = [_depositsCollection objectAtIndex:indexPath.section];
        
        double newAmount = textField.text.doubleValue;
        DLog(@"newAmount: %f", newAmount);
//        [deposit setBagAmount:newAmount];//not working says undeclared variable
        
        DLog(@"deposit current amount: %f", deposit.bagAmount);
        //resign the 1st responder
        [textField resignFirstResponder];
        //reset the editing values
        [self doneBtnPressed:nil];
    }
    
    
    
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
