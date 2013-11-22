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

@interface SCContactsTableViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic) NSInteger contactCount;
@property (strong, nonatomic) NSMutableArray *contacts;
@property (strong, nonatomic) NSMutableDictionary *alphabet;
@property (strong, nonatomic) NSMutableArray *sortedKeys;

@property (strong, nonatomic) NSMutableDictionary* contactsArrayDict;
@property (strong, nonatomic) NSMutableDictionary* keysArrayDict;
@property (strong, nonatomic) NSMutableDictionary* selectedContacts;

@end
