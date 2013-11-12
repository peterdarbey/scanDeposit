//
//  HomeVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 09/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "HomeVC.h"

#import "Barcode.h"
#import "DepositsVC.h"
#import "Deposit.h"
#import "RegistrationVC.h"

#import "UserVC.h"


@interface HomeVC ()
{
    ScanditSDKBarcodePicker *picker;
}
@property (strong, nonatomic) NSMutableDictionary *validUsersDict;
@property (strong, nonatomic) NSMutableDictionary *validAdminsDict;

@end

@implementation HomeVC

#pragma mark - Custom delegate method for LoginVC
- (void)dismissLoginVC:(NSMutableDictionary *)users isAdmin:(NSNumber *)admin {
    
    DLog(@"admin passed by dimissLoginVC method: %d", admin.boolValue);
    _isAdmin = admin.boolValue;//set by object returned -> NO for users
    
    //NOTE: Logout button required?
    if (_isAdmin) {//because NSNumber wasnt used and dismissVCWithCompletion block
        
        //if admin not a user
        _isUser = NO;
        //will need for packaging off to email with other data
        _validAdminsDict = users;//pass to deposits
    }
    else
    {
        DLog(@"is USERS: %@", users);//is dictionary
        _isUser = YES;
        //will need for packaging off to email with other data
        _validUsersDict = users;//pass to deposits
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

//Note: 128 barcode
- (void)cancelScanPressed:(UIButton *)sender {

   
//    [picker stopScanning];
//     [self dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:^{
        //Stop the picker scanning
        [picker stopScanning];
        //cancelled scanning device QR barcode
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
            //scanned device QR barcode, now set to 128 barcode
            _scanModeIsDevice = NO;
        }];

        
    }//close if
    
    else //128 barcode
    {
        DLog(@"Scanning functionality for 128 barcode");
        
        [picker dismissViewControllerAnimated:YES completion:^{
            //stop picker scanning
            [picker stopScanning];
            //needs the deposits data from the AlertView
            //now pass the deposits data to DepositsVC to pop its tblView
            DepositsVC *depositsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DepositsVC"];
            depositsVC.title = NSLocalizedString(@"Deposits", @"Deposits View");
            depositsVC.depositsCollection = _depositsArray;//bag data
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
            DLog(@"Push to viewController delegate method called");
            
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
    
    
    
    //hardcode NO
    _scanModeIsDevice = NO;
    
    //if scan QR barcode
    if (_scanModeIsDevice) {
        [self.view addSubview:scanBagBtn];
        //Add other behaviour here
        
        [helpTV setText:@"How to use this app\n\nPlease scan the barcode on the external device (ATM)..."];
        
        [self.view addSubview:helpTV];
        
    }
    else //else 128 barcode
    {
        [self.view addSubview:scanDeviceBtn];
        
        //Add other behaviour here
        [helpTV setText:@"Now scan the bag barcode and enter the amount for each deposit.\n\nFinally press proceed to send email"];
        [self.view addSubview:helpTV];
        
    }

    
    UIImage *aibImg = [UIImage imageNamed:@"logo_80_121.png"];//not great resolution
    UIImageView *aibImgV = [[UIImageView alloc]initWithImage:aibImg];
    [aibImgV setFrame:CGRectMake(10, 54, aibImg.size.width, aibImg.size.height)];
    
    [self.view addSubview:aibImgV];
    
}

- (void)viewWillAppear:(BOOL)animated {
    

//    _isAdmin = YES; //HARD CODE here for implementation of Administrator functionality
    DLog(@"_isAdmin: %d", _isAdmin);
    
    //NOTE: may need to add user to NSUserDefaults 
    //if Administrator (filled in password so admin) go to RegistrationVC / Administrator Settings
    if (_isAdmin) { //&& !_isUser 
        DLog(@"User is ADMIN");
        RegistrationVC *registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationVC"];
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:registerVC];
        [navController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
        
        //Add delay to presentation of LoginVC until HomeVC has appeared first
        double delayInSeconds = 0.3;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
            //NOTE: dont need the dispatch delay for RegistrationVC as admin ???
            //Delay added has resolved the issue with the unbalanced calls to navController
            [self presentViewController:navController animated:YES completion:^{
                [registerVC setModalPresentationStyle:UIModalPresentationFullScreen];
                [registerVC setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
                [registerVC setTitle:NSLocalizedString(@"Admin Settings", @"Adminstrator Settings")];
            }];
            
        });//close dispatch block
        
    }
    //not administrator or a reg user
    else if (!_isAdmin && !_isUser) { //correct behaviour now
        
        LogInVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LogInVC"];
        
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:loginVC];
        
        //Add delay to presentation of LoginVC until HomeVC has appeared first
        double delayInSeconds = 0.3;//0.25
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
    else
    {
        DLog(@"is user scan away");//temp remove condition later
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
    NSDictionary *userInfo = @{@"scanDeviceBtnTapped" : scanDeviceBtn};
    [notificationCenter postNotificationName: @"scanDeviceBtnTapped" object:nil userInfo:userInfo];
    DLog(@"EVENT DISPATCHED");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //Only subscribe when the view is on screen
    notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(xibDismissed:)
                               name:@"scanDeviceBtnTapped"
                             object:nil];//not interested in who posted notification just event
    
}
- (void)xibDismissed:(NSNotification *)notification {
    
    
    NSDictionary *userInfo = notification.userInfo;
    DLog(@"userInfo: %@", userInfo.description);
    
    DLog(@"Test this notification: %@", notification.name);
    if ([notification.name isEqualToString:@"scanDeviceBtnTapped"]) {
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
    if (_scanModeIsDevice) {
       
            
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
    DLog(@"Start scanning delegate");
}

- (NSDictionary *)parseBarcodeFromString:(NSString *)barcodeString {
    
    //NOTE: parse first
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
    for (NSArray *valueArray in elementArray) {
        for (int i = 0; i < [valueArray count]; i++) {
            NSString *entryString = [valueArray objectAtIndex:i];
            //remove the white space
            NSString *keyString = [entryString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];//removes any white sapace if any there
            //if index:1 remove the back slash
            if (i == 1) {
                keyString = [keyString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
                [dict setObject:keyString forKey:[[valueArray objectAtIndex:0]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];//works fine but probably a better way
            }
            //add to collection
            [kvPairsArray addObject:keyString];
        }//close inner for
        
    }//close outer for
    
//        DLog(@"kvPairsArray: %@", kvPairsArray);//works
        DLog(@"*** dict ***: %@", dict);//works
    
    return dict;
}

#pragma mark Scandit SDK - delegate methods
- (void)scanditSDKOverlayController:
(ScanditSDKOverlayController *)scanditSDKOverlayController didScanBarcode:(NSDictionary *)barcodeResult {
    
    //Capture Time stamp here -> when bag scanned when date/time is created
    dateString = [self formatMyDateString];
    DLog(@"<< dateString >>: %@", dateString);//current 24 Hr format: 12/11/2013 11:46
    
    DLog(@"barcodeResult*****: %@", barcodeResult);
    
    //its a NSString so cant use objectForKey
     NSString *barcodeString = barcodeResult[@"barcode"];
    DLog(@"barcodeString: %@", barcodeString);
    
    //extract the Symbology to determine the relevant data model and construct appropriately
    NSString *barcodeType = (NSString *)barcodeResult[@"symbology"];
    
    
    //conditionals to extract/process the type of barcode scanned i.e. QR or 128
    //if scan QR barcode
    //Hard code YES here
    _scanModeIsDevice = YES;
    if (_scanModeIsDevice && [barcodeType isEqualToString:@"QR"]) {
        
        DLog(@"barcodeType: %@", barcodeType);//QR - correct
        
        //parses a barcode string and creates a dictionary
        NSDictionary *barcodeDict = [self parseBarcodeFromString:barcodeString];
        DLog(@"barcodeDict: %@", barcodeDict);
        
        
        
        //Proceed with the QRBarcode model
//        Barcode *barcodeObject = [Barcode instanceFromDictionary:barcodeResult];//need custom initWith method
    
        
    }
    //else scan 128 barcode
    else if (_scanModeIsDevice && [barcodeType isEqualToString:@"128"])
    {
        DLog(@"barcodeType: %@", barcodeType);//128 - correct
        
        
    }
    
    

    //NOTE: Model not correct yet needs to be parsed 1st
    //create our custom model object with the barcode data
    Barcode *barcodeObject = [Barcode instanceFromDictionary:barcodeResult];//will need custom initWith method
    //Add to collection
    [_barcodeArray addObject:barcodeObject];
    
    DLog(@"barcode from model>>>>>>>>: %@", [barcodeObject barcodeData]);
    
    NSDictionary *dictBarcode = [barcodeObject dictionaryRepresentation];
    DLog(@"dictBarcode: %@", dictBarcode);//needs to be parsed first??
    
    
    //present alertView and temp stop scanning
    [picker stopScanning];

    //Create a custom Alert -> AlertView.xib
    [self showPopup:[barcodeObject barcodeData]];
}

-(void)showPopup:(NSString *)barcode {
    //Create a custom Alert -> AlertView.xib
    AlertView *popup = [AlertView loadFromNibNamed:@"AlertView"];
    //Add custom delegate method here to restart picker scanning
    [popup setDelegate:self];
    //pass the time
    popup.timeString = dateString;//not very OO
    //set the barcode text
    popup.barcodeString.text = [NSString stringWithFormat:@"%@", barcode];
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
    [self showPopup:[barcodeObject barcodeData]];
    
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
