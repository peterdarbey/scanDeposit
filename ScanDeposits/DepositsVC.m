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
    double newAmount;
    UIBarButtonItem *barBtnFinished;
    NSString *xlsStringImg;
    //HTTP request
    NSMutableData *responseData;
    UIActivityIndicatorView *requestSpinner;
    
    //Mobile Iron workaround
    UIBarButtonItem *attachButton;
    NSData *xmlDataString;
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
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    //register for callbacks
    [_depositsTV setDelegate:self];
    [_depositsTV setDataSource:self];
    [_depositsTV setBackgroundColor:[UIColor clearColor]];
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
    
    //test here
    xmlDataDict = [NSMutableDictionary dictionary];
    
    //Mobile Iron workaround
//    attachButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(uploadData)];
//    [self addToolBarMobileIron:attachButton];
    
    
}

//mobile iron test
-(void)writeToLibraryWithData:(NSData *)data {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);//NSPicturesDirectory
    NSString *libraryDirectory = [paths objectAtIndex:0];

    NSString *xmlPath = [libraryDirectory stringByAppendingPathComponent:@"xlsData.xls"];
    [data writeToFile:xmlPath atomically:YES];
    DLog(@"%@ written to file: %@", xmlDataString, xmlPath);// /var/mobile/Applications/9F6B4DA6-C826-4D56-A8AB-0E7A653A8549/Library/xlsData.xls
    
    
    //to convert NSData to PDF --> Mobile_Iron workaround
//    CFDataRef myPDFData        = (__bridge CFDataRef)data;
//    DLog(@"myPData: %@", myPDFData);//has data
//    
//    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
//    DLog(@"provider: %@", provider);//valid
//    
//    CGPDFDocumentRef pdf = CGPDFDocumentCreateWithProvider(provider);
//    DLog(@"pdf: %@", pdf);//nil --> failed to find PDF header: `%PDF' not found.
//    CGDataProviderRelease(provider);
//    
//    UIImage *pdfImage = [UIImage imageWithData:(__bridge NSData *)(pdf)];//nil
    
    
//    UIImage *pdfImage = [UIImage imageWithData:data];//nil -> wont work has to be image data
    //Works
//    UIImage *localRes = [UIImage imageNamed:@"tablet-header-icon-less-flash.png"];
//    UIImageWriteToSavedPhotosAlbum(localRes, nil, nil, nil);//works
//    DLog(@"localRes: %@", localRes);
    
//    UIImageWriteToSavedPhotosAlbum(pdfImage, nil, nil, nil);
//    DLog(@"pdfImage saved to file: %@", pdfImage);
    
    //WORKS as PDF
//    UIGraphicsBeginPDFContextToFile(xmlPath, CGRectZero, nil);
//    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, 612, 792), nil);
////    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width), nil);
//    //watch scaling
//    [xlsStringImg drawInRect:CGRectMake(5, 50, 320, 500) withFont:[UIFont systemFontOfSize: 16.0]];//was 48.0
//    UIGraphicsEndPDFContext();
//    
//    NSURL* url = [NSURL fileURLWithPath: xmlPath];
//    
//    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL ((__bridge CFURLRef) url);
//    
////    UIGraphicsBeginImageContext(CGSizeMake(596,842));
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    CGContextRef currentContext = UIGraphicsGetCurrentContext();
//    
//    CGContextTranslateCTM(currentContext, 0, 842);
//    CGContextScaleCTM(currentContext, 1.0, -1.0); // make sure the page is the right way up
//    
//    CGPDFPageRef page = CGPDFDocumentGetPage(document, 1); // first page of PDF is page 1 (not zero)
//    CGContextDrawPDFPage (currentContext, page);  // draws the page in the graphics context
//    
//    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
////    NSString* imagePath = [localDocuments stringByAppendingPathComponent: @"test.png"];
//    [UIImagePNGRepresentation(image) writeToFile: xmlPath atomically:YES];//test this also
//    
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//    DLog(@"pdfImage saved to file: %@", image);
    
}


#pragma mark - custom popup xibs
- (void)showSuccessPopupWithTitle:(NSString *)title andMessage:(NSString *)message
                       forBarcode:(NSString *)barcodeString {
    

    //Now gobal which resolved the issue
    successPopup = [SuccessPopup loadFromNibNamed:@"SuccessPopup"];
    
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[HomeVC class]]) {
            HomeVC *homeVC = (HomeVC *)viewController;
            [successPopup setDelegate:homeVC];//sets here
        }
    }
    
    //test this delegate method
    [successPopup setNotDelegate:self];
    
    //updated and set in class
    [successPopup showOnView:self.view withTitle:title andMessage:message];//nil
    
}

- (void)callMyWebserviceWithData:(NSString *)appData {
//- (void)callMyWebserviceWithData:(NSMutableArray *)appData {
    
    NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:kURLNOEL] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:30.0];

    //request the server response as JSON
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    
    //call createPayloadWithData instead with xmlArray of data in xml format instead a collection
    [self createPayloadWithData:appData forRequest:theRequest];
    
}

- (void)createPayloadWithData:(NSString *)appData forRequest:(NSMutableURLRequest *)request {
//- (void)createPayloadWithData:(NSMutableArray *)appData forRequest:(NSMutableURLRequest *)request {

    //Create our recipients -> Note this will come from file later
//    NSArray *emailRecipArray = @[@"peterdarbey@gmail.com", @"david.h.roberts@aib.ie", @"eimear.e.ferguson@aib.ie", @"gavin.e.bennett@aib.ie"];
    
    //send email to all the users stored on the device for now
    NSMutableArray *adminArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];
    //Create our default recipients from file for all emails
    NSMutableArray *emailRecipients = [NSMutableArray array];
    
    //iterate through collection to retrieve the recipients
    DLog(@"adminArray: %@", adminArray);
    for (int i = 0; i < [adminArray count]; i++) {
        NSString *recipient = [[adminArray objectAtIndex:i]objectAtIndex:1];//now email field
        [emailRecipients addObject:recipient];
    }
    
//    //data returned a dict for each user associated with the lodgement via log in
//    //For message body
//    NSDictionary *userOne = _usersDict[@1];
//    NSDictionary *userTwo = _usersDict[@2];
//    NSString *userOneName = userOne[@"Name"];
//    NSString *userTwoName = userTwo[@"Name"];
    
    //Pass the 2 Administrator's associated with device
    NSDictionary *payload = @{@"payload" : appData, @"recipients" : @[emailRecipients[0], emailRecipients[1]]};
    
    NSError *parseError;
    NSData *jsonData;
    
    //if valid json convert/serialize and package in payload
    if ([NSJSONSerialization isValidJSONObject:payload]) {
        DLog(@"is VALID JSON");
        jsonData = [NSJSONSerialization dataWithJSONObject:payload options:NSJSONWritingPrettyPrinted error:&parseError];
        //set the request values
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request setHTTPShouldHandleCookies:NO];
    }
    
    
    //create visual feedback via a UIActivity spinner
    requestSpinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [proceedBtn setEnabled:NO];
    [requestSpinner setHidesWhenStopped:YES];
    CGPoint spinnerPoint = CGPointMake(252.5, 22);
    [requestSpinner setCenter:spinnerPoint];
    
    //add to proceed button view
    [proceedBtn addSubview:requestSpinner];
    [requestSpinner startAnimating];
    

   //create connection outside of dispatch queue
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
    
    //dispatch a request on a background thread
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
//        //just create standard for now
//        [connection start];
//    });
    
}

#pragma mark - NSURLConnection Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //init data for response
    responseData = [[NSMutableData alloc]init];
    
    //cast and query Status Code
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = httpResponse.statusCode;
    
    if (statusCode == 200) {
        NSLog(@"HTTP status is: %i, good to go", statusCode);
//        [self sentMailWithSuccess:YES];//nah dont need here only when finished receiving data
    }
    else if (statusCode == 400 || statusCode == 401 || statusCode == 404)
    {
        //capture the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [requestSpinner stopAnimating];
            [proceedBtn setEnabled:YES];
            //show error popup
            //via this method
//            [self sentMailWithError:YES];
            [self showWarningPopupWithTitle:[NSString stringWithFormat:@"Error: %i", statusCode] andMessage:@"Did not receive a valid response" forBarcode:nil];
        });
        
    }
    else if (statusCode == 500) {
        //display custom error popup
        [self sentMailWithError:YES];
        
    }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [responseData appendData:data];
//    DLog(@"receiving data: %@", data);
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)data;
    DLog(@"response allHeaderFields: %@", response);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSError *parseError;
    NSDictionary *dict;
    
    //if we have a response parse it
    if (responseData) {
        //the responseData is not JSON but string
        id responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:&parseError];//was 0
        //for test display only
        NSMutableString *responseString = [[NSMutableString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        DLog(@"responseString: %@", responseString);//CoinDrop Servlet is processing your data ...
        
        if (parseError) { //we are receiving a parse error with returned response not json
            DLog(@"error parsing the response: %@ probably not configured for json yet", parseError);
            return;
        }
        else
        {
            if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
                dict = (NSDictionary *)responseObject;
                DLog(@"dict: %@", dict);
                if (dict) {
                    DLog(@"Success");
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [requestSpinner stopAnimating];
//                      [proceedBtn setEnabled:YES];//we dont want to allow user to send again
                        [self sentMailWithSuccess:YES];//display success on screen
                    });

                }
            }
        }
        
    }//close outer if
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
        DLog(@"Error with response: %@", [error localizedDescription]);
    
    //retrieve the main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [requestSpinner stopAnimating];
        [proceedBtn setEnabled:YES];
        //show error popup
        [self showWarningPopupWithTitle:@"Error" andMessage:@"Failed to connect to server" forBarcode:nil];
//        [self sentMailWithSuccess:YES];//for now test
    });
}

- (void)editPressed:(UIButton *)sender {
    //edit pressed disable proceedBtn
    [proceedBtn setEnabled:NO];
    
    _allowEdit = YES;
    [_depositsTV reloadData];
    
    doneBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnPressed:)];
    //Dont enable till the user enters a value in textField
    [doneBtn setEnabled:NO];
    
    //set the done button as the current barButton
    [self.navigationItem setRightBarButtonItem:doneBtn];
    
}

- (void)doneBtnPressed:(UIButton *)sender {
    
    //done pressed re-enable proccedBtn
    [proceedBtn setEnabled:YES];
    
    [_depositsTV reloadData];
    _allowEdit = NO;
    
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
                    [_depositsTV reloadData];
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
    if ([_barcodeArray count] > 0) {
        [_barcodeArray removeAllObjects];//dont nil just remove entries
    }
    
    //wipe recorded logged in users of the app
    _usersDict = nil;
    
    //reset the class Deposit static methods
    [Deposit setTotalBagsAmount:0.0];
    [Deposit setTotalbagCount:0];
    
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


//should be a helper object
- (NSMutableArray *)collectMyData {
    
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
                //Device Type: --> creates a string from 0 to the specified range (3) (Process Type)
                [_dataArray addObject:[[deposit bagBarcode]substringToIndex:3]];
                //Sequence No --> creates a string from specified range (3) to end of string
                [_dataArray addObject:[[deposit bagBarcode]substringFromIndex:3]];
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
    
        }

    
    //each Administrator associated with device --> use the adminsCollection.plist for this data
    NSMutableArray *adminArray = [NSMutableArray arrayWithContentsOfFile:[self getFilePath]];

        if (adminArray) {
            for (int i = 0; i < [adminArray count]; i++) {
                NSString *adminName = [[adminArray objectAtIndex:i]objectAtIndex:0];//name
                [_dataArray addObject:adminName];
            }
        }//close if
    
    DLog(@"<<<<<<<< _dataArray contents >>>>>>>>>>: %@", _dataArray);
    
    return _dataArray;
}

- (NSString *)getFilePathForName:(NSString *)name {
    
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,
                                                                            NSUserDomainMask, YES ) objectAtIndex:0];
    NSString *fullFilePath = [documentsDirectoryPath stringByAppendingPathComponent:name];//@"users.plist"
    
    return fullFilePath;
}

-(void)saveMyDoc:(NSData *)xmlsFile {
    
    
    NSString *xmlPath = [self getFilePathForName:@"xlsData.plist"];
    
    [xmlsFile writeToFile:@"xlsData.plist" atomically:YES];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    [fileManager copyItemAtPath:xmlPath toPath:@"" error:&error];
    
}


// https://github.com/jetseven/skpsmtpmessage rather than using MFMailController

- (void)proceedPressedWithRequest:(UIButton *)sender {
    
    //returns the complete ordered app data required for the XML structure
    _dataArray = [self collectMyData];
    
    //convert collection into an excel XMLSS format
    NSMutableArray *xmlArray;
    //new method breaks after date/time key --> offset correct
    xmlArray = [StringParserHelper createXMLFromCollectionFin:_dataArray andDeposits:_depositsCollection];//add _depositsArray
    DLog(@"xmlArray is: %@", xmlArray);
    
    //then parse into an appended string --> non csv format
    NSString *xmlString = [StringParserHelper parseMyCollection:xmlArray];
    DLog(@"xmlString sent to Noel: %@", xmlString);
    
    //serialize and convert to data for webservice XMLSS format xls
    xmlDataString = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    
    //Adding new functionality to save an image to camera roll -> Mobile Iron
    [self writeToLibraryWithData:xmlDataString];//write to NSLibraryDirectory
    
    //call the request code
        [self callMyWebserviceWithData:xmlString];
//    [self callMyWebserviceWithData:xmlArray];//_dataArray
    
}

- (void)proceedPressed:(UIButton *)sender {

        //returns the complete ordered app data required for the XML structure
        _dataArray = [self collectMyData];
    
        //convert collection into an excel XMLSS format
        NSMutableArray *xmlArray;
        //new method breaks after date/time key --> offset correct
        xmlArray = [StringParserHelper createXMLFromCollectionFin:_dataArray andDeposits:_depositsCollection];//add _depositsArray
        DLog(@"xmlArray is: %@", xmlArray);
    
        //then parse into an appended string --> non csv format
        NSString *xmlString = [StringParserHelper parseMyCollection:xmlArray];
//        xlsStringImg = xmlString;
        //serialize and convert to data for webservice XMLSS format xls
        xmlDataString = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    
        //parse into appended string with commas separated values for CSV format
        NSString *finalString = [StringParserHelper parseMyCollectionWithCommas:_dataArray];
        //mobile iron workaround
        xlsStringImg = finalString;//not using anymore
        //serialize and convert to data for webservice as CSV format
        NSData *dataString = [finalString dataUsingEncoding:NSUTF8StringEncoding];
    
        //Adding new functionality to save an image to camera roll -> Mobile Iron
        //call a new method
        [self writeToLibraryWithData:xmlDataString];//write to NSLibraryDirectory
    
    
    //Create our recipients -> Note this will come from file later
    NSArray *emailRecipArray = @[@"peterdarbey@gmail.com", @"david.h.roberts@aib.ie", @"eimear.e.ferguson@aib.ie", @"gavin.e.bennett@aib.ie"];
    
        //TEMP email assignees
//        NSArray *emailRecipArray = @[@"peterdarbey@gmail.com"];
    
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
//        [mailController setEditing:NO];
        [mailController setEditing:NO animated:NO];
        mailController.editing = NO;
        [mailController.view setUserInteractionEnabled:NO];//nope
    
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
        [mailController addAttachmentData:xmlDataString mimeType:@"application/vnd.ms-excel" fileName:@"ProcessReport.xls"];
        
        //call the request code
//        [self callMyWebserviceWithData:xmlDataString];
//        [self callMyWebserviceWithData:xmlArray];//_dataArray -> changed to NSString from NSMutableArray
    
    
        //if mail isnt setup return
        if (mailController == nil)
        return;
        //else present the mail composer
        else
            [self presentViewController:mailController animated:YES completion:nil];
    
}

-(void)addToolBarMobileIron:(UIBarButtonItem *)button {
    
    NSArray *barBtnArray = [NSArray arrayWithObjects:button, nil];
    UIToolbar *customTB = [[UIToolbar alloc]initWithFrame:CGRectMake(0 , self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    
    [customTB setBarStyle:UIBarStyleBlackTranslucent];
    customTB.items = barBtnArray;
    [self.view addSubview:customTB];
}

- (void)sentMailWithSuccess:(BOOL)sent {
    
    //disable the send email button on succces
    [proceedBtn setEnabled:NO];
    
    //dismiss mailComposer
    [self dismissViewControllerAnimated:YES completion:nil];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //custom Success Popup may add a pause here
        [self showSuccessPopupWithTitle:@"Success deposit sent" andMessage:@"Deposit data successfully sent to recipients" forBarcode:nil];//put in completion block above
    });
}
- (void)sentMailWithError:(BOOL)failed {
    
    [self dismissViewControllerAnimated:YES completion:^{
        //custom Warning Popup
        [self showWarningPopupWithTitle:@"Error: Unable to send email" andMessage:@"Please check you have coverage" forBarcode:nil];
        //ToDo decide where to go from here if it fails can we send again
        [proceedBtn setEnabled:YES];
    }];
}

#pragma mark - MFMailCompose delegate callbacks
- (void)mailComposeController:(MFMailComposeViewController*)mailController didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [mailController setEditing:NO];
    switch (result) {
        case MFMailComposeResultCancelled:
            [self dismissViewControllerAnimated:YES completion:^{
                //ToDo perhaps Pop to rootViewConroller and Logout
                DLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            }];
            break;
        case MFMailComposeResultSaved:
            //ToDo -> NO dont save
            [self dismissViewControllerAnimated:YES completion:nil];
            DLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            [self sentMailWithSuccess:YES];
            DLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            [self sentMailWithError:YES];
            DLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
    }
    
    if (error) {
        DLog(@"Failed with error: %@", [error localizedDescription]);
        [self sentMailWithError:YES];//perhaps pop to rootViewController and Logout
    }
    
//    if (result) {
//
//        //disable the send email button on succces
//        [proceedBtn setEnabled:NO];
//        
//        //dismiss mailComposer
//        [self dismissViewControllerAnimated:YES completion:nil];
//        
//        double delayInSeconds = 1.0;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
//            //custom Success Popup may add a pause here
//            [self showSuccessPopupWithTitle:@"Success email sent" andMessage:@"Email successfully sent to recipients" forBarcode:nil];//put in completion block above
//        });
//        
//    }//close if
    
//    else if (error) {
//        
//        [self dismissViewControllerAnimated:YES completion:^{
//             //custom Warning Popup
//            [self showWarningPopupWithTitle:@"Error: Unable to send email" andMessage:@"Please check you have coverage" forBarcode:nil];
//            //ToDo decide where to go from here if it fails can we send again
//            [proceedBtn setEnabled:YES];//maybe
//        }];
//    }
    
}

#pragma mark - custom popup xibs

- (void)showWarningPopupWithTitle:(NSString *)title andMessage:(NSString *)message
                       forBarcode:(NSString *)barcodeString {
    
    //Create a custom WarningPopup.xib
    WarningPopup *warningPopup = [WarningPopup loadFromNibNamed:@"WarningPopup"];
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
        [proceedBtn addTarget:self action:@selector(proceedPressedWithRequest:) forControlEvents:UIControlEventTouchUpInside];
        //Hide for now
//        [proceedBtn addTarget:self action:@selector(proceedPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self buttonStyle:proceedBtn WithImgName:@"blueButton.png" imgSelectedName:@"blueButtonSelected.png" withTitle:@"SEND EMAIL"];
        //add to parent view
        [aView addSubview:proceedBtn];
        
        
        //construct a UILabel for text
        UILabel *bagLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 25)];
        [bagLbl setBackgroundColor:[UIColor clearColor]];
        [bagLbl setFont:[UIFont fontWithName:@"Arial-BoldMT" size:15]];
        bagLbl.textAlignment = NSTextAlignmentLeft;
        
        bagLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        //remove shadows
//        bagLbl.shadowColor = [UIColor grayColor];
//        bagLbl.shadowOffset = CGSizeMake(1.0, 1.0);
        [bagLbl setUserInteractionEnabled:NO];
        
        [innerView addSubview:bagLbl];
        
        //Construct another label for amount
        UILabel *bagAmountLbl = [[UILabel alloc]initWithFrame:CGRectMake(210, 10, 80 , 25)];
        bagAmountLbl.textAlignment = NSTextAlignmentRight;
        bagAmountLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        bagAmountLbl.textColor = [UIColor colorWithRed:0.0/255.0 green:145.0/255.0 blue:210.0/255.0 alpha:1.0];//blue
        //remove shadows
//        bagAmountLbl.shadowColor = [UIColor grayColor];
//        bagAmountLbl.shadowOffset = CGSizeMake(1.0, 1.0);//shame
        bagAmountLbl.backgroundColor = [UIColor clearColor];
        [bagAmountLbl setUserInteractionEnabled:NO];
        
        DLog(@"BEORE BAG COUNT: %i", [Deposit totalBagCount]);
        
        DLog(@"BEFORE valueChanged: %f", [Deposit totalBagsAmount]);
        
        //retrieve the total bag amount from the class method here
        [bagAmountLbl setText:[NSString stringWithFormat:@"€%.2f", [Deposit totalBagsAmount]]];//should be always right cause using class method
        
        [bagLbl setText:[NSString stringWithFormat:@"Total bags: %i",[Deposit totalBagCount]]];
        
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
        //set textField Keyboard setting
        [bagAmountTF setKeyboardType:UIKeyboardTypeNumberPad];
        [bagAmountTF setInputAccessoryView:[self createCustomKBView]];//add toolbar to keyboard
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
        //remove shadows
//        bagNumberLbl.shadowColor = [UIColor grayColor];
//        bagNumberLbl.shadowOffset = CGSizeMake(1.0, 1.0);
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

//doesnt update amount ??
- (void)doneKBPressed:(UIButton *)sender {
    
    DLog(@"DoneKB Pressed");
    //done pressed re-enable proccedBtn
    [proceedBtn setEnabled:YES];
    
    [_depositsTV reloadData];
    _allowEdit = NO;
    
    //set the edit button as the current barButton
    [self.navigationItem setRightBarButtonItem:editBBtn];
    
}

- (void)cancelKBPressed:(UIButton *)sender {
    
    DLog(@"Cancel Pressed");
}

- (UIToolbar *)createCustomKBView {
    
    //construct barButtonItems
    UIBarButtonItem *barBtnCancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelKBPressed:)];
    [barBtnCancel setTintColor:[UIColor blackColor]];
    
    barBtnFinished = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneKBPressed:)];
    [barBtnFinished setTintColor:[UIColor blueColor]];
    barBtnFinished.enabled = NO;
    
    //Add a divider for the toolBar barButtonItems
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *barBtnArray = [NSArray arrayWithObjects:barBtnCancel, flexible, barBtnFinished, nil];
    
    UIToolbar *customTB = [[UIToolbar alloc]initWithFrame:CGRectMake(0 , 0, 50, 44)];
    
    [customTB setBarStyle:UIBarStyleBlackTranslucent];
    customTB.items = barBtnArray;
    return customTB;
    
}

#pragma mark - UITextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString* s = [NSMutableString stringWithString:textField.text];
    NSLog(@"s length = %i", s.length);
    if(range.location + range.length > textField.text.length) {
        [s appendString:string];
    }
    else {
        [s replaceCharactersInRange:range withString:string];
    }
    NSString* t = [s  stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    long v = [t integerValue];
    long n = v / 100;
    long d = v % 100;
    
    if(v >= 100000) {
        return NO;
    }
    
    if(v > 0) { //only executes in edit mode
        //enable done + return key
        doneBtn.enabled = YES;
        barBtnFinished.enabled = YES;
    }
    else {
        //disable here
        doneBtn.enabled = NO;
        barBtnFinished.enabled = NO;
    }
    textField.text = [NSString stringWithFormat:@"%03ld.%02ld", n, d];
    newAmount = (double)textField.text.doubleValue;//assign to iVar here not in didEndEditing
    DLog(@"newAmount: %f", newAmount);
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    UITableViewCell *cell = (UITableViewCell *)[textField.superview superview];
    while(![cell isKindOfClass:[UITableViewCell class]]) cell = (UITableViewCell *)[cell superview]; // iOS 7 fix
    NSIndexPath *indexPath = [_depositsTV indexPathForCell:cell];
    
    if (_allowEdit && [textField.text length] > 0 && [textField.text length] <= 6) {
        
        _valueEdited = YES;
    
        DLog(@"newAmount in didEndEd: %f", newAmount);
        
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
    
}

@end
