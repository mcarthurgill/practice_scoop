//
//  SCAddressViewController.h
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/20/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SCAddressViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIButton *contactsButton;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet NSMutableDictionary *contacts;

- (IBAction)contactsButtonAction:(id)sender;

@end
