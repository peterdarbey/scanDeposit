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
    NSMutableDictionary *xmlDataDict;
}


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
    
    if ([_depositsTV numberOfSections] <= 0) {
        [editBBtn setEnabled:NO];
    }
    
    
//    //Moved here from viewWillAppear
//    //if we can email enable the proceed button
//    if([MFMailComposeViewController canSendMail]) {
//        
//        [proceedBtn setEnabled:YES];
//    }
    
    //test here
    xmlDataDict = [NSMutableDictionary dictionary];
    
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
//    successPopup.titleLbl.text = title;//the whole property is nil ???
//    successPopup.messageLbl.text = message; //nil too even with string ???
   
    //ToDo add whatever setup code required here
//    [successPopup showOnView:self.view];
    //updated and set in class
    [successPopup showOnView:self.view withTitle:title andMessage:message];//nope
    
}

- (void)editPressed:(UIButton *)sender {
    //edit pressed disable proceedBtn
    [proceedBtn setEnabled:NO];
    
//    [_depositsTV setEditing:YES animated:YES];//test
    _allowEdit = YES;
    [_depositsTV reloadData];
    
    doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressed:)];
    //set the done button as the current barButton
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
}

- (void)doneBtnPressed:(UIButton *)sender {
    
    //done pressed re-enable proccedBtn
    [proceedBtn setEnabled:YES];
    
    //    [_depositsTV endEditing:YES];//test
    
    _allowEdit = NO;
    
    [_depositsTV reloadData];
    
    //set the edit button as the current barButton
    [self.navigationItem setRightBarButtonItem:editBBtn];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //assign here
    selectedIndexPath = indexPath;
    DLog(@"selectedIP in commit: %@", selectedIndexPath);
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //extract the bagAmount and bagtotal in order to subtract from total amount etc...
        Deposit *tempDeposit = [_depositsCollection objectAtIndex:indexPath.section];

        //retrieve the total bag count and then decrement by 1 and set
        [Deposit setTotalbagCount:[Deposit totalBagCount] - 1];
        
        //retrieve the deposit cash amount and subtract from the class total and then add the new edited amount
        double oldTotalAmount = [Deposit totalBagsAmount];
        double newTotalAmount = oldTotalAmount - [tempDeposit bagAmount];
        //update class state for total amount
        [Deposit setTotalBagsAmount:newTotalAmount];
        
        
        //set this first to update the conditional in numberOfSections
        _valueRemoved = YES;
        
        //this is the update
      //[_depositsTV deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
         //remove the data from our deposits collection and update the total amopunt/count
         [_depositsCollection removeObjectAtIndex:indexPath.section];//always 1st ->doesnt call any tblView delegate
        
        [_depositsTV deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];//change to fade --> but works lovely
        
        
        //if not the last section refresh data --> as it auto refreshes the viewInfooter
//        if (indexPath.section != [_depositsTV numberOfSections]-1) {
            double delayInSeconds = 0.3;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [_depositsTV reloadData];//tricky
            });
//        }//close if

    }//close if
    
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

        //Reset all barcode data, logged in users and the recorded deposits
        [self wipeAndResetData];
    
        //dismiss the viewController and wipe data --> pops to HomeVC
       [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}

- (void)wipeAndResetData {
    
    //wipe recorded deposits
    [_depositsCollection removeAllObjects];
    
    DLog(@"_barcodeArray: %@", _barcodeArray);
    DLog(@"_usersDict: %@", _usersDict);
    //wipe recorded QR and ITF barcode data
    [_barcodeArray removeAllObjects];//dont nil just remove entries --> nil
    
    //wipe recorded logged in users of the app
    _usersDict = nil;
    
    //reset the class Deposit static methods
    [Deposit setTotalBagsAmount:0.0];
    [Deposit setTotalbagCount:0];
    
    //reset bag data types also
//    _totalDepositAmount = 0.0;//what are these
    _bagCount = 0;
    
    //Note wipe the uniqueBagArray containing barcodes that prexist
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[HomeVC class]]) {
            HomeVC *homeVC = (HomeVC *)vc;
            [homeVC.uniqueBagArray removeAllObjects];
            DLog(@" <<< homeVC.uniqueBagArray >>>: %@", homeVC.uniqueBagArray);
            [homeVC.depositsArray removeAllObjects];//was passing values to DepositsVC
        }
    }
    
}


- (NSString *)getFilePath
{
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectoryPath stringByAppendingPathComponent:@"adminsCollection.plist"];
    
    return fullPath;
}


//Note: removed createXMLSSFromCollection method to the class helper


//should be a helper object
- (NSMutableArray *)collectMyData {
    
//    xmlDataDict = [NSMutableDictionary dictionary];
    
        //extract barcode data
        if (_barcodeArray) {
    
            //extract the barcode objects required values
            for (id object in _barcodeArray) {
                if ([object isKindOfClass:[QRBarcode class]]) {
                    QRBarcode *qrBarcode = (QRBarcode *)object;
                    //Add elements to the array
                    [_dataArray addObject:[qrBarcode barcodeBranch]];
                    [_dataArray addObject:[qrBarcode barcodeProcess]];
                    [_dataArray addObject:@([qrBarcode barcodeSafeID])];//Safe
                }
            }//close for
        }
    
    //extract all the deposit data
    if (_depositsCollection) {
        
        for (id object in _depositsCollection) {
            if ([object isKindOfClass:[Deposit class]]) {
                Deposit *deposit = (Deposit *)object;
                //added last 6digits --> Sequence Number
                [_dataArray addObject:[[deposit bagBarcode]substringFromIndex:6]];//Device Type
                [_dataArray addObject:[[deposit bagBarcode]substringFromIndex:3]];//Sequence No ->not intergrate yet
                [_dataArray addObject:[deposit bagBarcode]];//has ITF --> barcodeUniqueBagNumber
                [_dataArray addObject:@([deposit bagCount])];//int
                [_dataArray addObject:@([deposit bagAmount])];//double
                [_dataArray addObject:[deposit timeStamp]];//add date/time --> Break after here
               
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

    
    //each Administrator associated with device --> use the adminsCollection.plist for this data
    NSMutableArray *adminArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];

        if (adminArray) {
            for (int i = 0; i < [adminArray count]; i++) {
                NSString *adminName = [[adminArray objectAtIndex:i]objectAtIndex:0];//name
                [_dataArray addObject:adminName];
            }
        }//close if
    
    DLog(@"<<<<<<<< _dataArray contents >>>>>>>>>>: %@", _dataArray);//23 at moment
//    DLog(@"<< xmlDataDict contents >>: %@", xmlDataDict);//crash 29 values verses 34 keys
    
    return _dataArray;
}


// https://github.com/jetseven/skpsmtpmessage rather than using MFMailController

- (void)proceedPressed:(UIButton *)sender {

        //returns the complete ordered app data required for the XML structure
        _dataArray = [self collectMyData];
    
        //convert collection into an excel XMLSS format
        NSMutableArray *xmlArray;
//        if ([xmlDataDict count] > 0) {
//            xmlArray = [StringParserHelper createXMLSSFromArray:_dataArray andDictionary:xmlDataDict];
//        }
        //new test method
        xmlArray = [StringParserHelper createXMLSSFromCollection:_dataArray];
        DLog(@"xmlArray is: %@", xmlArray);//break after date and time key
    
        //then parse into an appended string --> non csv format
        NSString *xmlString = [StringParserHelper parseMyCollection:xmlArray];
        //serialize and convert to data for webservice XMLSS format xls
        NSData *xmlDataString = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    
        //parse into appended string with commas separated values for CSV format
        NSString *finalString = [StringParserHelper parseMyCollectionWithCommas:_dataArray];
        //serialize and convert to data for webservice as CSV format
        NSData *dataString = [finalString dataUsingEncoding:NSUTF8StringEncoding];
    
    
//    //Create our recipients -> Note this will come from file later
//    NSArray *emailRecipArray = @[@"peterdarbey@gmail.com", @"david.h.roberts@aib.ie", @"eimear.e.ferguson@aib.ie", @"gavin.e.bennett@aib.ie"];
    
        //TEMP email assignees
        NSArray *emailRecipArray = @[@"peterdarbey@gmail.com", @"fintan.a.killoran@aib.ie"];
    
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
        //need to remove from here when deleted and edited
        NSArray *contentArray = @[@([Deposit totalBagCount]), @([Deposit totalBagsAmount])];
    
        //disclaimer content
        NSString *disclaimerString = @"IMPORTANT - IF THE ABOVE CONFIRMATION IS IN ANY WAY INACCURATE, YOU SHOULD IMMEDIATELY ADVISE YOUR BRANCH MANAGER / HRQMO. OTHERWISE, YOU ARE CONFIRMING THAT YOU WERE A CONTROL USER AS DESCRIBED ABOVE AND THAT THE CONTENTS OF THIS CONFIRMING MAIL ARE ACCURATE.";
        //for message body
        QRBarcode *qrBarcode;
        if ([_barcodeArray[0] isKindOfClass:[QRBarcode class]]) {
            qrBarcode = _barcodeArray[0];
        }
    
        //Inline with draft
        [mailController setMessageBody:[NSString stringWithFormat:@"This mail is your copy of the record that you\n <Control User 1: %@> and <Control User 2: %@> together opened and record the following contents of the <process: %@> taken from <Safe ID: %i> on <date><time: %@>.\n\nContent Summary\n%@\n\n\n\n%@", userOneName, userTwoName, [qrBarcode barcodeProcess], [qrBarcode barcodeSafeID], [NSDate date],contentArray, disclaimerString] isHTML:NO];//current date
    
        //add attachment to email as CSV format
        [mailController addAttachmentData:dataString mimeType:@"text/csv" fileName:@"mailData.csv"];

        //add attachment to email as Excel SpreadSheet xls format
        [mailController addAttachmentData:xmlDataString mimeType:@"application/vnd.ms-excel" fileName:@"mailData.xls"];
    
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
            [self showWarningPopupWithTitle:@"Error: Unable to send email" andMessage:@"Please check you have coverage" forBarcode:nil];
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
        
        DLog(@"BEORE BAG COUNT: %i", [Deposit totalBagCount]);
        
        DLog(@"BEFORE valueChanged: %f", [Deposit totalBagsAmount]);
        
        //retrieve the total bag amount from the class method here
        [bagAmountLbl setText:[NSString stringWithFormat:@"€%.2f", [Deposit totalBagsAmount]]];//should be always right cause using class method
        
        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i",[Deposit totalBagCount]]];
        
//        if (_valueRemoved) {
//            //reset to NO
//            _valueEdited = NO;
//        }
       
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
        return 145.0;
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
    
    DLog(@"count in sections: %i", [_depositsCollection count]);//[2,0]
    return [_depositsCollection count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return 1;//should always be one
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        
        //Construct another label for amount
        bagAmountTF = [[UITextField alloc]initWithFrame:CGRectMake(210, cell.bounds.size.height/4, 80 , 25)];
        bagAmountTF.tag = BAG_AMOUNT;
        bagAmountTF.textAlignment = NSTextAlignmentRight;
        bagAmountTF.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        bagAmountTF.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        bagAmountTF.backgroundColor = [UIColor clearColor];
        [bagAmountTF setUserInteractionEnabled:NO];
        [bagAmountTF setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];//center
        [bagAmountTF setClearsOnBeginEditing:YES];
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
    
        //populate the cell text
        bagAmountTF.text = [NSString stringWithFormat:@"€%.2f", [deposit bagAmount]];
        bagNumberLbl.text = [NSString stringWithFormat:@"Bag No: %@", [deposit bagBarcode]];//unique bag number
    
    //enable user editing
    if (_allowEdit) {
        DLog(@"Allow editing here");
        [bagAmountTF setUserInteractionEnabled:YES];
    }
    else
    {
        [bagAmountTF setUserInteractionEnabled:NO];
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
        
        _valueEdited = YES;
        
        double newAmount = textField.text.doubleValue;
        
        
        //retrieve the deposit model for the TF index
        Deposit *deposit = [_depositsCollection objectAtIndex:indexPath.section];
        
        //retrieve the deposit cash amount and subtract from the class total and then add the new edited amount
        double oldTotalAmount = [Deposit totalBagsAmount];
        double newTotalAmount = oldTotalAmount - [deposit bagAmount];
        //update class state for total amount
        [Deposit setTotalBagsAmount:newTotalAmount + newAmount];
        
       [deposit setBagAmount:newAmount];//ivar not property
        //then replace the retrieved deposit with the edited deposit in the collection
        [_depositsCollection replaceObjectAtIndex:indexPath.section withObject:deposit];
        
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
