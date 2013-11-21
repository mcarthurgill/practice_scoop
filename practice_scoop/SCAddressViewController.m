//
//  SCAddressViewController.m
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/20/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import "SCAddressViewController.h"

@interface SCAddressViewController ()

@end

@implementation SCAddressViewController

@synthesize contactsButton;
@synthesize nameLabel;
@synthesize phoneLabel;
@synthesize contacts; 


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	contacts = [[NSMutableDictionary alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contactsButtonAction:(id)sender {
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
    
    ABPersonViewController *pvc = [[ABPersonViewController alloc] init];
    [pvc setHighlightedItemForProperty:kABPersonPhoneProperty withIdentifier:0];
    
    NSString *phone;
    NSString *name;
    
    if (ABMultiValueGetCount(multi)){
        phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
        name = (__bridge NSString *)(ABRecordCopyCompositeName(person));
    }

    NSLog(@"name = %@", name);
    NSLog(@"phone = %@", phone);
    
    NSMutableDictionary *second = [[NSMutableDictionary alloc] init];
    
    [second setObject:name forKey:@"name"];
    [second setObject:phone forKey:@"phone"];
    
    if ([contacts objectForKey:phone]) {
        [contacts removeObjectForKey:phone];
    }else{
        [contacts setObject:second forKey:phone];
    }
    
    NSLog(@"tmp = %@", contacts);
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}



@end
