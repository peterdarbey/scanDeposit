//
//  HomeVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 09/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "HomeVC.h"

#import "Barcode.h"//old
#import "QRBarcode.h"
#import "EightBarcode.h"//new

#import "DepositsVC.h"
#import "Deposit.h"
//#import "RegistrationVC.h"

#import "UserVC.h"


@interface HomeVC ()
{
    ScanditSDKBarcodePicker *picker;
}
@property (strong, nonatomic) NSMutableDictionary *validUsersDict;
@property (strong, nonatomic) NSMutableDictionary *validAdminsDict;
//QR barcode model
@property (strong, nonatomic) QRBarcode *qrBarcode;
//2/5 interleaved barcode model
@property (strong, nonatomic) EightBarcode *eightBarcode;

@end

@implementation HomeVC

#pragma mark - Custom delegate method for LoginVC
- (void)dismissLoginVC:(NSMutableDictionary *)users isAdmin:(NSNumber *)admin {
    
    DLog(@"admin passed by dimissLoginVC method: %d", admin.boolValue);
    _isAdmin = admin.boolValue;//set by object returned -> NO for users
    
    //NOTE: Logout button required?
    if (_isAdmin) {
        
        //if admin not a user
        _isUser = NO;
        //will need for packaging off to email with other data
        _validAdminsDict = users;
    }
    else
    {
        DLog(@"is USERS: %@", users);//is dictionary
        _isUser = YES;
        //Note: _isAdmin is NO if execution enters here
        
        //will need for packaging off to email with other data
        _validUsersDict = users;
    }
    
    //disable scanBtn
    [scanDeviceBtn setEnabled:YES];
    
}

#pragma mark - Custom delegate method for RegistrationVC
- (void)logoutAdministrator:(NSNumber *)admin {
    
    DLog(@"admin in logoutAdministrator method: %d", admin.boolValue);
    
    _isLoggedOut = admin.boolValue;
    
    if (_isLoggedOut) {
        
        //sets the admin to no as logged out before the viewWillAppear is called
        _isAdmin = NO;//should really be logged out BOOL not _isAdmin -> goes here
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

//Note: 2/5 interleaved barcode
- (void)cancelScanPressed:(UIButton *)sender {

   
//    [picker stopScanning];
//     [self dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //Stop the picker scanning
        [picker stopScanning];
        //cancelled scanning device QR barcode so set to YES again
        _scanModeIsDevice = YES;//this may vary
    }];
    
}

//set conditions for appropriate behaviours
- (void)finishedScanPressed:(UIButton *)sender {
   
    //QR barcode
    if (_scanModeIsDevice) {
        
        DLog(@"Scanning functionality for QR barcode");
        [picker dismissViewControllerAnimated:YES completion:^{
            [picker stopScanning];
            //scanned device QR barcode, now set to 2/5 interleaved barcode
            _scanModeIsDevice = NO;//correct
        }];

        
    }//close if
    
    else //2/5 interleaved barcode
    {
        DLog(@"Scanning functionality for 2/5 interleaved barcode");
        
        [picker dismissViewControllerAnimated:YES completion:^{
            //stop picker scanning
            [picker stopScanning];
            //needs the deposits data from the AlertView
            //now pass the deposits data to DepositsVC to pop its tblView
            DepositsVC *depositsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DepositsVC"];
            depositsVC.title = NSLocalizedString(@"Deposits", @"Deposits View");
            depositsVC.depositsCollection = _depositsArray;//bag data
            depositsVC.QRArray = _barcodeArray; //may need a condition here before adding check -> can add all barcode models to this and id by key @"Symbology"
            
            
            //package off logged in users/admins data
            if (_validUsersDict) {
                depositsVC.usersDict = _validUsersDict;
                DLog(@"_validUsersDict: %@", _validUsersDict);//one should have value
            }
            else if (_validAdminsDict)
            {
                depositsVC.adminsDict = _validAdminsDict;
                DLog(@"_validAdminsDict: %@", _validAdminsDict);
            }
            
            [self.navigationController pushViewController:depositsVC animated:YES];
            
            //careful though as user may want to scan more
//            _scanModeIsDevice = YES;//reset to scan QR barcode as viewDidLoad is Not called unless app is quit
            
        }];

        
    }//close else
    
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

//setup the barcode engine
- (void)scanBtnPressed:(UIButton *)sender {
    

    //make sure only ONE instance
    picker = [[ScanditSDKBarcodePicker alloc] initWithAppKey:kScanditSDKAppKey];
    picker.overlayController.delegate = self;
    [picker.overlayController showSearchBar:NO];
    
    //construct barButtonItems
    UIBarButtonItem *barBtnCancel = [[UIBarButtonItem alloc]initWithTitle:@"CancelScan" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelScanPressed:)];
    [barBtnCancel setTintColor:[UIColor blackColor]];
    
    barBtnFinished = [[UIBarButtonItem alloc]initWithTitle:@"FinishedScan" style:UIBarButtonItemStyleBordered target:self action:@selector(finishedScanPressed:)];
    [barBtnFinished setTintColor:[UIColor blackColor]];
    
    //Add a divider for the toolBar barButtonItems
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *barBtnArray = [NSArray arrayWithObjects:barBtnCancel, flexible, barBtnFinished, nil];
    UIToolbar *customTB = [[UIToolbar alloc]initWithFrame:CGRectMake(0 , self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    
    [customTB setBarStyle:UIBarStyleBlackTranslucent];
    customTB.items = barBtnArray;
    [picker.view addSubview:customTB];
    
    [picker.overlayController setTextForInitializingCamera:@"Please Wait"];
    [picker startScanning];
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
    //Dont need Observer currently
//    [self dispatchEventOnTouch];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _barcodeArray = [NSMutableArray array];
    
    _depositsArray = [NSMutableArray array];
    
    barBtnFinished.enabled = NO;
    
    
    
    //How to use the app wording to be revised
    UITextView *helpTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 175, self.view.frame.size.width -20, 250)];
//    [helpTV setText:@"How to use this app\nPlease scan the external device (ATM) barcode.\n\nThen scan the bag barcode and enter the amount for each deposit.\n\nFinally press proceed to confirm email"];
    
    [helpTV setBackgroundColor:[UIColor clearColor]];
    [helpTV setFont:[UIFont systemFontOfSize:21]];
    //    [helpTV setTextColor:[UIColor colorWithRed:172.0/255.0 green:74.0/255.0 blue:0.0/255.0 alpha:1.0]];//orange
    [helpTV setTextColor:[UIColor whiteColor]];
    [helpTV setEditable:NO];
    [helpTV setUserInteractionEnabled:NO];
    [helpTV setTextAlignment:NSTextAlignmentCenter];
    
//    [self.view addSubview:helpTV];
    
    
    
    
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.title = NSLocalizedString(@"Home Screen", @"Home Screen");
    
    //Construct a imageView
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
    [self.view addSubview:imgView];
    
    //construct the scanBtn for DEVICE -> QR
    scanDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonStyle:scanDeviceBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected.png" withTitle:@"Scan Device Barcode"];
//    scanBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    scanDeviceBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [scanDeviceBtn setFrame:CGRectMake(20, self.view.frame.size.height -60, 280, 44)];
    [scanDeviceBtn addTarget:self action:@selector(scanBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //see condition below
//    [self.view addSubview:scanDeviceBtn];
    
    //Construct new scan device button for BAG -> 128
    scanBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonStyle:scanBagBtn WithImgName:@"greenButton.png" imgSelectedName:@"greenbuttonSelected.png" withTitle:@"Scan Bag Barcode"];
    scanBagBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [scanBagBtn setFrame:CGRectMake(20, self.view.frame.size.height -60, 280, 44)];
    [scanBagBtn addTarget:self action:@selector(scanBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    /*if the admin setup is completed then RegisrationVC (Users not included in that BOOL) has 
     occurred so only show the RegisrationVC when admin has logged in so always show LogInVC
     */
    
    
    //Set to YES on app launch as first time will always be QR external device barcode
    _scanModeIsDevice = YES;//hardcode YES here
    
    //if scan QR barcode
    if (_scanModeIsDevice) {
        
        [self.view addSubview:scanDeviceBtn];//correct
        //Add other behaviour here
        
        [helpTV setText:@"How to use this app\n\nPlease scan the barcode on the Device/Process..."];
        
        [self.view addSubview:helpTV];
        
    }
    else //else 2/5 interleaved barcode
    {
        [self.view addSubview:scanBagBtn];//correct
        
        //Add other behaviour here
        [helpTV setText:@"Now scan the bag barcode and enter the amount for each deposit.\n\nFinally press proceed to send email"];
        [self.view addSubview:helpTV];
        
    }

    
    UIImage *aibImg = [UIImage imageNamed:@"logo_80_121.png"];//not great resolution
    UIImageView *aibImgV = [[UIImageView alloc]initWithImage:aibImg];
    [aibImgV setFrame:CGRectMake(10, 54, aibImg.size.width, aibImg.size.height)];
    
    [self.view addSubview:aibImgV];
    
}

- (void)presentLogInVC {
    
    //Once setup complete Always present LogInVC for all users/admins
    LogInVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
    //
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginVC];
    
    //Add delay to presentation of LoginVC until HomeVC has appeared first
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        //HomeVC been by another NavController when we dismiss the LoginVC? -> solved
        [self presentViewController:navController animated:YES completion:^{
            //ToDo add some functionality here
            [loginVC setModalPresentationStyle:UIModalPresentationFullScreen];
            [loginVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [loginVC setTitle:NSLocalizedString(@"Log In", @"Log In")];
            //set the HomeVC as the delegate for the LoginVC dismissLoginVCWithValidation
            [loginVC setDelegate:self];
        }];
        
    });//close dispatch block
    
}

- (void)presentRegistrationVC {
    
    DLog(@"Presenting RegistrationVC");
    
    RegistrationVC *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationVC"];
    //Attempt to present on some other navController whilst pres in progress
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:registerVC];
    [navController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    
    //Add delay to presentation of LoginVC until HomeVC has appeared first
    double delayInSeconds = 1.0;//works -> gives the LogInVC time to dismiss and allow presentation of regVC
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
        //NOTE: dont need the dispatch delay for RegistrationVC as admin ???
        //Delay added has resolved the issue with the unbalanced calls to navController
        [self presentViewController:navController animated:YES completion:^{ //returns here after 1.3 
            [registerVC setModalPresentationStyle:UIModalPresentationFullScreen];
            [registerVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            [registerVC setTitle:NSLocalizedString(@"Admin Settings", @"Adminstrator Settings")];
            //new delegate method
            [registerVC setDelegate:self];
        }];
    });//close dispatch block
}

- (void)viewWillAppear:(BOOL)animated {
    

    //NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    //retrieve the app state for use case app flow
    //    _isAdmin = [[userDefaults objectForKey:@"Is Administrator"]boolValue];
    _isSetup = [[userDefaults objectForKey:@"Is Setup"]boolValue];
    
    //NOTE: when setup has occurred then the app flow is LogInVC for both users
    if (_isSetup) {
        
        //setup is complete and NOT administrator but _isUser = YES
        if (!_isAdmin && _isUser) {
            
            //user has Logged in so now dismiss LogInVC
            DLog(@"User delegate protocol did dismiss LogInVC");
            //and present HomeVC to allow scanning by user
            DLog(@"Proceed and scan away");
        }
        //is admin via login and not user
        else if (_isAdmin && !_isUser) {
            //admin has Logged in so now dismiss LogInVC
            //and present Administration settings/RegisrationVC
            
            //Added 1.0 delay to presentation of RegistrationVC in method below
                [self presentRegistrationVC];//correct
            
        }//close else if

        else
        {
            //Once setup complete Always present LogInVC for all users/admins if not already LOGGED IN
            //Added delay to presentation of LogInVC in method below until HomeVC has appeared first
            
            double delayInSeconds = 0.75;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //added additional delay here as its required by dismissal event on Logout press but dont want in method below
                [self presentLogInVC];//needs this duration
                //disable scanBtn
                [scanDeviceBtn setEnabled:NO];
            });
        }
        
        
    }//close if
    
    //else setup has not yet occurred -> _isSetup = NO; -> FIRST TIME LAUNCH
    else
    {
        //FIRST TIME LAUNCH: -> present Administration settings/RegisrationVC
        [self presentRegistrationVC];
    }

}

//Unregister for notifications
- (void)viewDidDisappear:(BOOL)animated{
    
    [notificationCenter removeObserver:self];
    [super viewDidDisappear:YES];
}
-(void)dispatchEventOnTouch
{
    //register the control object and associated key with a notification 
    NSDictionary *userInfo = @{@"scanBtnPressed" : scanDeviceBtn};
    [notificationCenter postNotificationName: @"scanBtnPressed" object:nil userInfo:userInfo];
    DLog(@"EVENT DISPATCHED");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //Only subscribe when the view is on screen
    notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(xibDismissed:)
                               name:@"scanBtnPressed"
                             object:nil];//not interested in who posted notification just event
    
}
- (void)xibDismissed:(NSNotification *)notification {
    
    
    NSDictionary *userInfo = notification.userInfo;
    DLog(@"userInfo: %@", userInfo.description);
    
    DLog(@"Test this notification: %@", notification.name);
    if ([notification.name isEqualToString:@"scanBtnPressed"]) {
        DLog(@"Notified");//works
    }
    
}


#pragma Format date specifier
-(NSString *)formatMyDateString
{
    //Capture Time stamp here
    NSDate *currentDate = [NSDate date];
    
    NSString *formattedDate = [NSDateFormatter localizedStringFromDate: currentDate dateStyle:                          NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];//may need secs

    return formattedDate;
}


#pragma mark - Custom delegate method
- (void)passScannedData:(Deposit *)deposit {
    
    DLog(@"dataArray: %@", deposit);
    //NOTE: data structure may be different here
    if (_scanModeIsDevice) {//dont think we need this
       
            
    }
    else
    {
        
    }
    
    //Pass the deposits data back to self
//    _depositsArray = dataArray;
//    _depositsArray = [NSMutableArray array];
    
    [_depositsArray addObject:deposit];
    
    //enable finishedScans button now as we have at least 1 scanned deposit
    barBtnFinished.enabled = YES;
    
}

- (void)presentDepositsViewController:(NSMutableArray *)array {
    
}

-(void)startScanning {
    
    [picker startScanning];
}

- (NSDictionary *)parseQRBarcodeFromString:(NSString *)barcodeString {
    
    //parse functionality
    //construct an array with the substrings separated by commas -> 3 entries
    NSArray *array = [barcodeString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];//create a dictionary from data in string
    
    //create objects for iteration operations
    NSMutableString *stringEntry = [NSMutableString string];
    NSMutableArray *elementArray = [NSMutableArray array];
    
    //iterate each comma separated string in the array
    for (NSString *string in array) {
        //retrieve each string of K / V pairs
        stringEntry = (NSMutableString *)string;
        //construct another array by separating ":"
        NSArray *valueArray = [stringEntry componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":"]];
        [elementArray addObject:valueArray];
    }//close for
    
    //create objects for iteration operations
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSMutableArray *kvPairsArray = [NSMutableArray array];
    
    //iterate
    for (NSMutableArray *valueArray in elementArray) {
        //iterate through each Key / Value pair in valuesArray
        for (int i = 0; i < [valueArray count]; i++) {
            NSString *entryString = [valueArray objectAtIndex:i];
            //removes the white space if any and replaces in the source array
            NSString *keyString = [entryString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            //replace string in collection
            [valueArray replaceObjectAtIndex:i withObject:keyString];
            //if index:1 remove the backslash
            if (i == 1) {
                keyString = [keyString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
                [dict setObject:keyString forKey:[valueArray objectAtIndex:0]];//works but probably a better way
            }
            //add to collection
            [kvPairsArray addObject:keyString];
        }//close inner for
        
    }//close outer for
    
//        DLog(@"kvPairsArray: %@", kvPairsArray);//nice
    
    return dict;
}

#pragma mark Scandit SDK - delegate methods
- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didScanBarcode:(NSDictionary *)barcodeResult {
    
    //Capture Time stamp here -> when bag scanned when date/time is created
    dateString = [self formatMyDateString];
    DLog(@"<< dateString >>: %@", dateString);//current 24 Hr format: 12/11/2013 11:46
    
    //see whats inside before parsing
    DLog(@"barcodeResult returned by scan engine: %@", barcodeResult);
    
    //its a NSString so cant use objectForKey
     NSString *barcodeString = barcodeResult[@"barcode"];
    DLog(@"barcodeString: %@", barcodeString);//190053495691
    
    //extract the Symbology to determine the relevant data model and construct appropriately
    NSString *barcodeType = (NSString *)barcodeResult[@"symbology"];
    //declare the dictionary to hold the parsed dict model object
    NSDictionary *barcode;
    //conditionals to extract/process the type of barcode scanned i.e. QR or 128
    
    
    //if scan QR barcode and stops regular QR code from entering
    if (_scanModeIsDevice && [barcodeType isEqualToString:@"QR"] && [barcodeString hasPrefix:@"Branch NSC"]) {
        
        DLog(@"barcodeType: %@", barcodeType);//QR - correct
        
        //parses a barcode string and creates a dictionary
        barcode = [self parseQRBarcodeFromString:barcodeString];
        DLog(@"barcodeDict: %@", barcode);
        
        //Now parsed correctly proceed with the new QRBarcode model constructor
        _qrBarcode = [[QRBarcode alloc]initBarcodeWithSymbology:barcodeType branch:barcode[@"Branch NSC"] process:barcode[@"Process"] safeID:[barcode[@"Safe ID"]intValue] andDevice:@"UnKnown"];//the Safe ID rounds off int
            //Add to barcodeArray collection as once I have this barcode is overwritten on 2/5 interleaved scan
            [_barcodeArray addObject:_qrBarcode];
        
        //present the appropriate popup -> AlertView.xib and temp stop scanning
        [picker stopScanning];
        //NOTE: different popup for QR
        [self showPopup:barcodeString];//pass relevant custom model or dictionary
        
        //set _scanModel to bag barcode now as we have a successful QR scan
        _scanModeIsDevice = NO;
        
        //Dismiss Picker once this has been scanned
        
        
    }
    //else scan 2/5 interleaved barcode --> will be different Prefix for 2/5 interleaved not 128
    else if (!_scanModeIsDevice && [barcodeType isEqualToString:@"ITF"] && [barcodeString hasPrefix:@"190"])
    {
        DLog(@"barcodeType: %@", barcodeType);// 2/5 interleaved correct --> 190053495691
    
        //Note: need to parse the 2/5 interleaved barcode before constructing dictionary
        barcode = [self parseILBarcodeFromString:barcodeString withBarcodeType:barcodeResult[@"symbology"]];
        
            //construct custom 128Barcode model
            _eightBarcode = [[EightBarcode alloc]initBarcodeWithSymbology:barcode[@"Symbology"] processType:barcode[@"Process Type"] uniqueBagNumber:barcode[@"Barcode"]];//barcodeResult[@"Unique Bag Number"];
        
            DLog(@"eightBarcode: %@", _eightBarcode);
            //Add to collection
//          [_barcodeArray addObject:eightBarcode];
            
        
        //Construct custom popup here for 128
        //present the appropriate popup -> AlertView.xib and temp stop scanning
        [picker stopScanning];
        [self showPopup:barcodeString];//pass relevant custom model or dictionary
        
    }//close else if
    
    
}
//parse method for parsing the 2/5 interleaved barcode string
- (NSDictionary *)parseILBarcodeFromString:(NSString *)barcodeString withBarcodeType:(NSString *)barcodeType {
    
    //190053495691 --> current bag barcode string
    //Process Type comes from 1st 3 digits of barcode
    NSString *processString = [barcodeString substringToIndex:3];//correct -> 190 first 3 digits
    DLog(@"processString: %@", processString); //barcodeResult[@"symbology"];
    
    //assigned by conditional
    NSString *processType;
    
    //if processString isEq to 291 then its "A Coin Only Dropsafe"
    if ([processString isEqualToString:@"291"]) {
        DLog(@"Process Type: %@", processString);
        
        processType = @"A Coin Only Dropsafe";
        
    }//close if
    
    //else its not a recognised barcode --> tin of beans
    else
    {
        processType = @"Not a valid barcode";
    }
    
    //construct a dict for 2/5 interleaved model
     NSDictionary *dict = @{@"Symbology" : barcodeType, @"Process Type" : processType, @"Barcode" : barcodeString};
  
    return dict;
}

-(void)showPopup:(NSString *)barcodeString {
    //Create a custom AlertView.xib
    AlertView *popup = [AlertView loadFromNibNamed:@"AlertView"];
    //Add custom delegate method here to restart picker scanning
    [popup setDelegate:self];
    //pass the time
    popup.timeString = dateString;//not very OO -> passing to the Deposit model via the popup xib
    
    if ([barcodeString hasPrefix:@"Branch NSC"]) { //cant test for barcodeType as Its a custom QR
        
        //populate the QR barcode popup
        popup.symbologyLbl.text = [NSString stringWithFormat:@"Symbology: %@", [_qrBarcode barcodeSymbology]];
        popup.branchLbl.text = [NSString stringWithFormat:@"Branch: %@", [_qrBarcode barcodeBranch]];
        popup.processLbl.text = [NSString stringWithFormat:@"Process: %@", [_qrBarcode barcodeProcess]];
        popup.safeIDLbl.text = [NSString stringWithFormat:@"Safe ID: %2i", [_qrBarcode barcodeSafeID]];
        
    }
    //Add another Prefix test from the 2/5 interleaved barcode
    else if ([barcodeString hasPrefix:@"Branch NSC"]) {
        
        //populate the 2/5 interleave barcode popup 
        popup.symbologyLbl.text = [NSString stringWithFormat:@"Symbology: %@", [_eightBarcode barcodeSymbology]];
        popup.branchLbl.text = [NSString stringWithFormat:@"Unique Bag Number:%@", [_eightBarcode barcodeUniqueBagNumber]];
        popup.processLbl.text = [NSString stringWithFormat:@"Process: %@", [_eightBarcode barcodeProcess]];
        popup.safeIDLbl.text = [NSString stringWithFormat:@"Safe ID: Not Applicable"];
        //with relevant popup instantsiated in each conditional
        
    }
    else
    {
        //populate the QR barcode popup
        popup.symbologyLbl.text = [NSString stringWithFormat:@"Symbology: Not available"];
        popup.branchLbl.text = [NSString stringWithFormat:@"Branch: Not available"];
        popup.processLbl.text = [NSString stringWithFormat:@"Process: Not available"];
        popup.safeIDLbl.text = [NSString stringWithFormat:@"Safe ID: Not available"];
    }
    
    [popup showOnView:picker.view];
}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didCancelWithStatus:(NSDictionary *)status {
    
    DLog(@"status dictionary: %@", status);
//    [picker.overlayController searchBarTextDidEndEditing:picker.overlayController];
    [self dismissViewControllerAnimated:YES completion:^{
        [picker stopScanning];
    }];
}

- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didManualSearch:(NSString *)input {
    
    NSDictionary *manualDict = @{@"barcode" : input, @"symbology" : @"None defined"};
    DLog(@"manualDict is: %@", manualDict);
    
    //Create our custom model object
    Barcode *barcodeObject = [Barcode instanceFromDictionary:manualDict];
    [_barcodeArray addObject:barcodeObject];
    
    //Create a custom Alert -> AlertView.xib
//    [self showPopup:manualDict];//TEMP
    
    
//    //Create a custom Alert -> AlertView.xib
//    AlertView *popup = [AlertView loadFromNibNamed:@"AlertView"];
//    //Add custom delegate method here to restart picker scanning
//    [popup setDelegate:self];
//    //set the barcode text
//    popup.barcodeString.text = [NSString stringWithFormat:@"%@", barcodeObject.barcode];
//    [popup showOnView:picker.view];
    
    DLog(@"didManualSearch with Inputed from barcodeObject: %@", [barcodeObject barcodeData]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
