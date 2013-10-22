//
//  PopupTV.h
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpTV : UITableView  <UITableViewDataSource, UITableViewDelegate>
{
    NSIndexPath *selectedIP;
}


@end

