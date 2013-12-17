//
//  HomeVC.m
//  ScanDeposits
//
//  Created by Peter Darbey on 09/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "HomeVC.h"
//#import "DepositsVC.h"

//models
#import "Deposit.h"
#import "UserVC.h"
//barcode models
#import "QRBarcode.h"
#import "EightBarcode.h"
//helper object for parsing
#import "StringParserHelper.h"


#import "Barcode.h"//--> keep for now



@interface HomeVC ()
{
    ScanditSDKBarcodePicker *picker;
//    NSMutableArray *uniqueBagArray;
    UITextView *helpTV;
}


@property (strong, nonatomic) NSMutableDictionary *validUsersDict;
@property (strong, nonatomic) NSMutableDictionary *validAdminsDict;

//QR barcode model
@property (strong, nonatomic) QRBarcode *qrBarcode;
//2/5 interleaved barcode model
@property (strong, nonatomic) EightBarcode *eightBarcode;

@end

@implementation HomeVC

#pragma mark - Custom delegate method for DepositsVC
- (void)resetDataAndPresentWithFlag:(NSNumber *)shouldDismiss {
    
    DLog(@"Delegate method called to reset and present LoginVC");//called
    
    //ToDo:1 reset all deposit data on app --> except usersCollection.plist/adminsCollection.plist
    
    //QR required first before scanning bags commences
    _scanModeIsQR = YES;
    //reset isAdmin
    _isAdmin = NO;
    _isUser = NO;
    
    //test
    _shouldDismiss = shouldDismiss.boolValue;
    
    //set the picker into scan mode again
    [picker startScanning];//not yet
}

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

- (void)cancelScanPressed:(UIButton *)sender {
    /* 
     NOTE 1:Proceed on QRPopup auto dismisses the picker so cancelScan can only be pressed before QR is captured, resulting in no valid QR -> _scanModeIsQR is set to YES, as only set to NO in didScan delegate method once QR condition is met NOTE 2:If cancelScan is pressed its when _scanModeIsQR = NO (ITF mode enabled)
    */
    
    //set here
    _didCancelScan = YES;
    //cancelled ITF scan means QR already scanned so set to NO
    _scanModeIsQR = NO;
    
    //picker dismissVC
    [self dismissViewControllerAnimated:YES completion:^{
        [picker stopScanning];
        
        //called if when _confirmPressed of _cancelPressed ITF Popup then user presses cancelScan
        if (_didCancelScan) {
//            _scanModeIsQR = YES;//could be reset here if the external device is damaged
            
            //User pressed cancelScans so wipe all data concerning barocodes barcodeArray,history including scanned Deposits
            if (_uniqueBagArray && _barcodeArray) {
                [_uniqueBagArray removeAllObjects];//cancelScan means reset all data in history
        
                //note: no deposit required here as only constructed on Proceed Press ITF Popup
                
                [_barcodeArray removeLastObject];//removes the EightBarcode but leaves QR inside
//                [_barcodeArray removeAllObjects];//actually remove all items
            }
            //we are assuming that the user wants to remove all scanned Deposits as they are canceling scans
            if ([_depositsArray count] > 0) {
                [_depositsArray removeAllObjects];//remove all Deposit instances
            }
            
            //reset the class Deposit static methods
            [Deposit setTotalBagsAmount:0.0];
            [Deposit setTotalbagCount:0];
        }
    }];
    
}

//set conditions for appropriate behaviours
- (void)finishedScanPressed:(UIButton *)sender {
   
    //QR barcode
    if (_scanModeIsQR) {
        
        DLog(@"Scanning functionality for QR barcode");
        [picker dismissViewControllerAnimated:YES completion:^{
            [picker stopScanning];
            //scanned device QR barcode, now set to 2/5 interleaved barcode
            _scanModeIsQR = NO;//correct
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
            depositsVC.title = NSLocalizedString(@"Contents List", @"Contents Listing");
//            //should only delete when the user presses cancelScans
//            if (_didCancelScan) {
//                DLog(@"DepositsArray: %@", _depositsArray);
//                if ([_depositsArray count] > 0) {
//                    [_depositsArray removeLastObject];
//                }
//            }//close if
            
            depositsVC.depositsCollection = _depositsArray;//bag/deposit data
            depositsVC.barcodeArray = _barcodeArray;//pass all barcode data to deposits
            //set delegate here
//            [depositsVC setDelegate:self];
            
            DLog(@"_depositsArray in picker dismiss: %@", _depositsArray);//empty
            
            //package off logged in users/admins data
            if (_validUsersDict) {
                depositsVC.usersDict = _validUsersDict;
                DLog(@"_validUsersDict: %@", _validUsersDict);//one should have value
            }
            else if (_validAdminsDict)
            {
                depositsVC.adminsDict = _validAdminsDict;
                DLog(@"_validAdminsDict: %@", _validAdminsDict);//dont need this for email
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
    
    if ([_depositsArray count] > 0) {
        [barBtnFinished setEnabled:YES];
    }
    else
    {
        [barBtnFinished setEnabled:NO];
    }
   
    
    //disable finishedScans button if depositsArray has no data inside
    
    
    //Add a divider for the toolBar barButtonItems
    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *barBtnArray = [NSArray arrayWithObjects:barBtnCancel, flexible, barBtnFinished, nil];
    UIToolbar *customTB = [[UIToolbar alloc]initWithFrame:CGRectMake(0 , self.view.frame.size.height - 44, self.view.frame.size.width, 44)];
    
    [customTB setBarStyle:UIBarStyleBlackTranslucent];
    customTB.items = barBtnArray;
    [picker.view addSubview:customTB];
    
    [picker.overlayController setTextForInitializingCamera:@"Please Wait"];

    [self.navigationController presentViewController:picker animated:YES completion:nil];
    [picker startScanning];
    //Dont need Observer currently
//    [self dispatchEventOnTouch];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    _barcodeArray = [NSMutableArray array];
    
    _depositsArray = [NSMutableArray array];
    
    _uniqueBagArray = [NSMutableArray array];
    
    
    
    //How to use the app wording to be revised
    helpTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 160, self.view.frame.size.width -20, 250)];
//    [helpTV setText:@"How to use this app\nPlease scan the external device (ATM) barcode.\n\nThen scan the bag barcode and enter the amount for each deposit.\n\nFinally press proceed to confirm email"];
    
    [helpTV setBackgroundColor:[UIColor clearColor]];
    [helpTV setFont:[UIFont systemFontOfSize:21]];
    //    [helpTV setTextColor:[UIColor colorWithRed:172.0/255.0 green:74.0/255.0 blue:0.0/255.0 alpha:1.0]];//orange
    [helpTV setTextColor:[UIColor whiteColor]];
    [helpTV setFont:[UIFont fontWithName:@"Arial-BoldMT" size:21.0]];
//    [helpTV setShadowColor:[UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0]];//darkGray
    [helpTV setEditable:NO];
    [helpTV setUserInteractionEnabled:NO];
    [helpTV setTextAlignment:NSTextAlignmentCenter];
    
//    [self.view addSubview:helpTV];
    
    
    
    
//    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.title = NSLocalizedString(@"Home", @"Home Screen");
    
    //Construct a imageView
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
    [self.view addSubview:imgView];
    
    //construct the scanBtn for DEVICE -> QR
    scanDeviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonStyle:scanDeviceBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected.png" withTitle:@"Scan Device Barcode"];
//    scanBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    scanDeviceBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [scanDeviceBtn setFrame:CGRectMake(20, self.view.frame.size.height -124, 280, 44)];
    [scanDeviceBtn addTarget:self action:@selector(scanBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //see condition below
//    [self.view addSubview:scanDeviceBtn];
    
    //Construct new scan device button for BAG -> 128
    scanBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonStyle:scanBagBtn WithImgName:@"blueButton.png" imgSelectedName:@"bluebuttonSelected.png" withTitle:@"Scan Bag Barcode"];
    scanBagBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [scanBagBtn setFrame:CGRectMake(20, self.view.frame.size.height -124, 280, 44)];
    [scanBagBtn addTarget:self action:@selector(scanBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //construct a logOut button
    logOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self buttonStyle:logOutBtn WithImgName:@"greenButton.png" imgSelectedName:@"greenbuttonSelected.png" withTitle:@"LOGOUT"];
    logOutBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [logOutBtn setFrame:CGRectMake(20, self.view.frame.size.height -60, 280, 44)];
    [logOutBtn addTarget:self action:@selector(logOutPressed:) forControlEvents:UIControlEventTouchUpInside];
    //add to viewHierarchy
    [self.view addSubview:logOutBtn];
    
    /*if the admin setup is completed then RegisrationVC (Users not included in that BOOL) has 
     occurred so only show the RegisrationVC when admin has logged in so always show LogInVC
     */
    
    
    //Set to YES on app launch as first time will always be QR external device barcode
    _scanModeIsQR = YES;//hardcode YES here
    
    
    
    
    UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_80_121.png"]];
    logo.frame = CGRectMake(20, 64, 40, 60);
    
    UILabel *logoName = [[UILabel alloc]initWithFrame:CGRectMake(65, 81.5, 120, 25)];
    [logoName setBackgroundColor:[UIColor clearColor]];
    [logoName setText:@"AIB eRegister"];
    [logoName setTextColor:[UIColor whiteColor]];
    [logoName setFont:[UIFont fontWithName:@"Arial-BoldMT" size:18.0]];
    [logoName setShadowColor:[UIColor colorWithRed:60.0/255.0 green:80.0/255.0 blue:95.0/255.0 alpha:1.0]];//darkGray
    [logoName setShadowOffset:CGSizeMake(1.0, 1.0)];
    [logoName setUserInteractionEnabled:NO];
    [self.view addSubview:logoName];
    
    
    
//    UIImage *aibImg = [UIImage imageNamed:@"logo_80_121.png"];
//    UIImageView *aibImgV = [[UIImageView alloc]initWithImage:aibImg];
//    [aibImgV setFrame:CGRectMake(10, 54, aibImg.size.width, aibImg.size.height)];
    
    [self.view addSubview:logo];//aibImgV
    
}
//test
- (void)logOutPressed:(UIButton *)sender {
    
    _isLoggedOut = YES;
    _isAdmin = NO;
    _isUser = NO;
    _scanModeIsQR = YES;
    //why dont I wipe data here
    if ([_uniqueBagArray count] > 0) {
        DLog(@"uniqueBagArray before: %@", _uniqueBagArray);
        [_uniqueBagArray removeAllObjects];//correct
        DLog(@"uniqueBagArray after: %@", _uniqueBagArray);//what about depositsCollection
    }
    
    DLog(@"DepositsArray: %@", _depositsArray);
    if ([_depositsArray count] > 0) {
        [_depositsArray removeAllObjects];
    }
    
    if ([_barcodeArray count] > 0) {
        [_barcodeArray removeAllObjects];
    }
    
    //reset the class Deposit static methods
    [Deposit setTotalBagsAmount:0.0];
    [Deposit setTotalbagCount:0];
    
    //present LogInVC as viewWillAppear is not called here on button press
    [self presentLogInVC];//test
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
    //moved here because wipeData sets to nil and not created again as in viewDidLoad
//     _depositsArray = [NSMutableArray array];
    DLog(@"<< _scanModeIsQR >>: %d", _scanModeIsQR);// --> NO correct
    
    //NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //retrieve the app state for use case app flow
    //    _isAdmin = [[userDefaults objectForKey:@"Is Administrator"]boolValue];
    _isSetup = [[userDefaults objectForKey:@"Is Setup"]boolValue];
    
    
    //if scan QR barcode
    if (_scanModeIsQR) {
        
        //if first time using app dont show txt and buttons on HomeVC
        if (_isSetup) {
            
            [self.view addSubview:scanDeviceBtn];//correct
            //Add other behaviour here
            [helpTV setText:@"How to use this app\n\nPlease scan the barcode on the Device/Process..."];
            [self.view addSubview:helpTV];
        }
//        [self.view addSubview:scanDeviceBtn];//correct
//        //Add other behaviour here
//        [self.view addSubview:helpTV];
        
    }
    else //else 2/5 interleaved barcode
    {
        if (_isSetup) {
            
            [self.view addSubview:scanBagBtn];//correct
            
            //Add other behaviour here 
            [helpTV setText:@"Now scan the barcode on each bag and enter a € value for each bag.\n\nNB - Any bag barcode can only be scanned once during a session"];
            [self.view addSubview:helpTV];
        }
        
    }

    
    //NOTE: when setup has occurred then the app flow is LogInVC for both users
    if (_isSetup) {
        
        //setup is complete and NOT administrator but _isUser = YES
        if (!_isAdmin && _isUser) {
            
            //user has Logged in so now dismiss LogInVC
//            DLog(@"User delegate protocol did dismiss LogInVC");
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
        //only occurs when the successPopup is dismissed by user on email success
        else if (_shouldDismiss) {
            //reset to NO
            _shouldDismiss = NO;
            [self presentLogInVC];
        }

        else
        {
            //Once setup complete Always present LogInVC for all users/admins if not already LOGGED IN
            //Added delay to presentation of LogInVC in method below until HomeVC has appeared first
            
            //disable scanBtn
            [scanDeviceBtn setEnabled:NO];
            
            double delayInSeconds = 0.75;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //added additional delay here as its required by dismissal event on Logout press but dont want in method below
                [self presentLogInVC];//needs this duration
                
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
- (void)resetBarcodeHistoryWithStatus:(NSNumber *)didCancel {
    _didCancelDeposit = didCancel.boolValue;
    
    //if user cancelled scan of ITF --> if cancelPressed on ITF Popup
    if (_didCancelDeposit) {
        //cancelled ITF scan means QR already scanned so set to NO and wipe last ITF barcode from barcodesArray
        //and history
        _scanModeIsQR = NO;
        
        //ToDO wipe barcodeArray for stored history of scans so we can scan the bag again
        if ([_uniqueBagArray count] > 0 && [_barcodeArray count] > 0) {
            //Dont need to check if it contains the barcodeString as its an ordered collection
            //So remove lastObject will work fine
            [_uniqueBagArray removeLastObject];//correct just last object as possible user wants to change bag
            DLog(@"UniqueBagArray after removal: %@", _uniqueBagArray);//removed
            //remember no deposit here as we cancelled
            //remove the EightBarcode object from the barcodeArray
            [_barcodeArray removeLastObject];// correct i think
            DLog(@"_barcodeArray after removal: %@", _barcodeArray);//just QR inside
            
            //disable finishedScans button if depositsArray has no data inside
            //need minimum of 1  2/5 interleaved to be scanned + a Deposit model created via (Proceed pressed)
            if ([_depositsArray count] > 0) {
                [barBtnFinished setEnabled:YES];//correct
            }
            else
            {
                [barBtnFinished setEnabled:NO];
            }
            
        }//close if
//         [picker dismissViewControllerAnimated:YES completion:nil];//test
    }
    
}
- (void)passScannedData:(Deposit *)deposit {
    
    //could set _scanModeIsQR = NO; here but set in delegate didScan condition
    
    //Pass the deposits data back to self and add to collection
    [_depositsArray addObject:deposit];
     DLog(@"_depositsArray in delegate: %@", _depositsArray);//correct
    
    //need minimum of 1  2/5 interleaved to be scanned + a Deposit model created via (Proceed pressed)
    //enable finishedScans button now as a scanned deposit
    barBtnFinished.enabled = YES;
    
}

- (void)presentDepositsViewController:(NSMutableArray *)array {
    
}

#pragma mark - custom delegate method for WarningPopup
//should not need 3 delegate protocols here
- (void)resumeScanning {
    
    [picker startScanning];
    //not sure what mode we are in yet??
//    _scanModeIsQR = ;// -> NO as called in differ instances
    
}

#pragma mark - custom delegate method for ITFPopup
-(void)startScanning {
    
    [picker startScanning];
}

#pragma mark - custom delegate method for QRPopup 
//QRPopup is only called from a successful QR scan in if statement
- (void)startScanningWithScanMode:(NSNumber *)mode {

    //if the mode is NO set the scanMode to 2/5 interleaved
    if (!mode.boolValue) { //NO
    
        //set _scanModel to bag barcode now as we have a successful QR scan
       _scanModeIsQR = mode.boolValue;//is always NO -> correct
        
        //NOTE: we dont have to dismiss the picker we can just start scanning again dismiss picker so that we can change the UI
        [picker dismissViewControllerAnimated:YES completion:nil];
        //or start scan process again
//     [picker startScanning];
    }
    
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
    DLog(@"barcodeString: %@", barcodeString);//190053495691 --> 12 digits
    
    //extract the Symbology to determine the relevant data model and construct appropriately
    NSString *barcodeType = (NSString *)barcodeResult[@"symbology"];
    
    //declare the dictionary to hold the parsed dict model object
    NSDictionary *__block barcode;
    
    int minCount = 12;
    //no point in continuing if the barcode is only partially scanned --> works
    if ([barcodeString length] < minCount) {
        
        NSString *title = @"Warning: Unrecognised barcode!";
        NSString *message = @"Only partially scanned try again";
        [self showWarningPopupWithTitle:title andMessage:message forBarcode:barcodeString];
        [picker stopScanning];
    }
    else
    {
    //if in QR scan mode, its a QR and a valid bank QR code
    if (_scanModeIsQR && [barcodeType isEqualToString:@"QR"] && [barcodeString hasPrefix:@"Branch NSC"]) {
        
        DLog(@"barcodeType: %@", barcodeType);//QR - correct if execution enters here we have a valid QR for app
        //dont actually need here as custom delegate (startsScanningWithScanMode:) sets to NO on return
        _scanModeIsQR = NO; // --> NOTE flag to say scanned QR already
        
        //parses a barcode string and creates a dictionary
        barcode = [StringParserHelper parseQRBarcodeFromString:barcodeString];// --> changed to class Helper method
        DLog(@"barcodeDict: %@", barcode);
        
        //Now parsed correctly proceed with the new QRBarcode model constructor
        _qrBarcode = [[QRBarcode alloc]initBarcodeWithSymbology:barcodeType branch:barcode[@"Branch NSC"] process:barcode[@"Process"] safeID:[barcode[@"Safe ID"]intValue] andDevice:@"UnKnown"];
            //Add to barcodeArray collection as once I have this barcode is overwritten on 2/5 interleaved scan
            [_barcodeArray addObject:_qrBarcode];
        
         [picker stopScanning];
        
        //present the QR popup
        [self showQRPopup:barcodeString];
        
    }
    //else if in QR scan mode, its an ITF with valid bank bag details, but we have not scanned QR first
    else if (_scanModeIsQR && [barcodeType isEqualToString:@"ITF"] && [barcodeString hasPrefix:@"190"])//291
    {
        //Construct custom warning popup
        [picker stopScanning];
        //Display warning popup and dont allow scanning
        NSString *title = @"Warning: No QR code scanned yet!";
        NSString *message = @"To continue please scan the Device / Process first";
        [self showWarningPopupWithTitle:title andMessage:message forBarcode:barcodeString];
    }
    //enter else if in 2/5 interleaved scan mode, its an ITF and its a valid bank bag                    @"291"
    else if (!_scanModeIsQR && [barcodeType isEqualToString:@"ITF"] && [barcodeString hasPrefix:@"190"])//prefix may change
    {
        DLog(@"barcodeType: %@", barcodeType);// 2/5 interleaved correct --> 190053495691
        //stop scanning
        [picker stopScanning];
        
        //NOTE: Make sure that the barcode for the bag has been fully scanned all digits not just 8
        NSString *uniqueSubString = [barcodeString substringFromIndex:7];//correct is last five digits 95691
        DLog(@"uniqueString >>>>>>>>>>>>>>>>: %@", uniqueSubString);
        //if barcodeString length < 12 dont allow display a warning message insufficient barcode data
        
        //if the collection already has that barcode subString then it has already been scanned
        if ([_uniqueBagArray containsObject:uniqueSubString]) { //note -> not stored on device so valid but launch
            //add conditional for the logout button ie --> _shouldDismiss BOOL
            //Display warning popup and dont allow scanning
            NSString *title = @"Warning this bag has already been scanned";
            NSString *message = @"Please scan a different bag to continue";
            [self showWarningPopupWithTitle:title andMessage:message forBarcode:barcodeString];
        }
        //else its has never been scanned before so proceed and construct model etc..
        else //-> Note dont need gobal ivar as never reaches Deposits class withoput this else ITFPopup
        {
            //need to addObj after 1st check
            [_uniqueBagArray addObject:uniqueSubString];//possibly from file as may save
            
            //Note: replaced by helper
//            barcode = [self parseILBarcodeFromString:barcodeString withBarcodeType:barcodeResult[@"symbology"]];
            
            //Note: need to parse the 2/5 interleaved barcode before constructing dictionary
            barcode = [StringParserHelper parseILBarcodeFromString:barcodeString
                                                   withBarcodeType:barcodeResult[@"symbology"]];//--> changed to class Helper method
            
            //construct custom 2/5 interleaved barcode model
            _eightBarcode = [[EightBarcode alloc]initBarcodeWithSymbology:barcode[@"Symbology"] processType:barcode[@"Process Type"] uniqueBagNumber:barcode[@"Unique Bag Number"]];
            DLog(@"_eightBarcode: %@", _eightBarcode);
            //Add to collection -> we have a key value pair here to ID the type of barcode object so add to same array as QRBarcode
            //leave this wrong place for didResetBarcode bool
            [_barcodeArray addObject:_eightBarcode];
        
            //Construct custom popup here for 2/5 interleaved barcode
            //present the 2/5 interleaved popup
            [self showITFPopup:barcodeString];//pass relevant custom model or dictionary
        }//close else
        
    }//close else if
    
    else if (!_scanModeIsQR && [barcodeType isEqualToString:@"QR"] && [barcodeString hasPrefix:@"Branch NSC"])
    {
        //Construct custom warning popup
        [picker stopScanning];
        //Display warning popup and dont allow scanning
        NSString *title = @"Warning: QR code already scanned!";
        NSString *message = @"To continue please scan a bag barcode!";
        [self showWarningPopupWithTitle:title andMessage:message forBarcode:barcodeString];
    }

    //need this else here for displaying a Non QR / 2/5 interleaved type
    else
    {
        //Construct custom warning popup
        [picker stopScanning];
        //Display warning popup and dont allow scanning
        NSString *title = @"Warning: this is not a valid bank type";
        NSString *message = @"Please scan another item";
        [self showWarningPopupWithTitle:title andMessage:message forBarcode:barcodeString];
    }
        
    }//close outer barcode length check

}

#pragma mark - custom popup xibs

- (void)showWarningPopupWithTitle:(NSString *)title andMessage:(NSString *)message
                       forBarcode:(NSString *)barcodeString {
    
    //Create a custom WarningPopup.xib
    WarningPopup *warningPopup = [WarningPopup loadFromNibNamed:@"WarningPopup"];
    //set delegate
    [warningPopup setDelegate:self];
    //set text
    warningPopup.titleLbl.text = title;
    warningPopup.messageLbl.text = message;
    
    
    //ToDo add whatever setup code required here
    [warningPopup showOnView:picker.view];
    
}

- (void)showQRPopup:(NSString *)barcodeString {
    
    //Create a custom QRPopup.xib
    QRPopup *qrPopup = [QRPopup loadFromNibNamed:@"QRPopup"];
    //Add custom delegate method here to restart picker scanning
    [qrPopup setDelegate:self];
    //ToDo add whatever setup code required here
    
    if ([barcodeString hasPrefix:@"Branch NSC"]) { //cant test for barcodeType as Its a custom QR
        
        //populate the QR barcode popup
        qrPopup.branchLbl.text = [NSString stringWithFormat:@"Branch: %@", [_qrBarcode barcodeBranch]];
        qrPopup.processLbl.text = [NSString stringWithFormat:@"Process: %@", [_qrBarcode barcodeProcess]];
        qrPopup.safeIDLbl.text = [NSString stringWithFormat:@"Safe ID: %2i", [_qrBarcode barcodeSafeID]];
        
    }
    
    [qrPopup showOnView:picker.view];
}

//this will be the2/5 interleave
-(void)showITFPopup:(NSString *)barcodeString {
    
    //Create a custom AlertView.xib
    ITFPopup *itfPopup = [ITFPopup loadFromNibNamed:@"ITFPopup"];
    //Add custom delegate method here to restart picker scanning
    [itfPopup setDelegate:self];
    //pass the time
    itfPopup.timeString = dateString;//not very OO -> passing to the Deposit model via the popup xib
    //pass the barcode data
    itfPopup.barcodeArray = _barcodeArray;//we dont know at this point if user wants to cancel so leave as is
    
    //Add another Prefix test from the 2/5 interleaved barcode
    if ([barcodeString hasPrefix:@"190"]) {//change to 291 or 292
        
        //populate the 2/5 interleave barcode popup 
        itfPopup.branchLbl.text = [NSString stringWithFormat:@"Unique Bag Number:%@", [_eightBarcode barcodeUniqueBagNumber]];
        itfPopup.processLbl.text = [NSString stringWithFormat:@"Process: %@", [_eightBarcode barcodeProcess]];
        //with relevant popup instantsiated in each conditional
        
    }
    
    [itfPopup showOnView:picker.view];
    
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
