//
//  PopupTV.m
//  ScanDeposits
//
//  Created by Peter Darbey on 22/10/2013.
//  Copyright (c) 2013 AIB. All rights reserved.
//

#import "PopupTV.h"

@implementation PopUpTV

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
//        [self setRowHeight:44];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIView *view = [[UIView alloc]init];
        view.frame = self.bounds;
        view.backgroundColor = [UIColor clearColor];
        self.backgroundView = view;//works
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topWhiteDropCell.png"]];//waiting for a cell for this
//        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topWhiteDropCellSelected.png"]];
//    }
//    else if (indexPath.row == [self numberOfRowsInSection:0] -1) {
//        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottomWhiteDropCell.png"]];
//        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottomWhiteDropCellSelected.png"]];
//    }
//    else {
//        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"midWhiteDropCell.png"]];
//        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"midWhiteDropCellSelected.png"]];
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//always minimum 1
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"popCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIP = indexPath;
    
    //deselect
    [self deselectRowAtIndexPath:indexPath animated:YES];
}


@end
