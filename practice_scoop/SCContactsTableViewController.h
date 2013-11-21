//
//  SCContactsTableViewController.h
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/21/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "SCContactsTableViewCell.h"

@interface SCContactsTableViewController : UITableViewController <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic) NSInteger contactCount;
@property (strong, nonatomic) IBOutlet NSMutableDictionary *contacts;
@property (strong, nonatomic) IBOutlet NSDictionary *alphabet; 

@end
