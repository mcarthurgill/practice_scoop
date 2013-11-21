//
//  SCContactsTableViewController.m
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/21/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import "SCContactsTableViewController.h"

@interface SCContactsTableViewController ()

@end

@implementation SCContactsTableViewController

@synthesize contactCount;
@synthesize contacts;
@synthesize alphabet;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    contacts = [[NSMutableDictionary alloc] init];
    alphabet = [[NSMutableDictionary alloc] init];
    NSArray *alphaLetters = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"ZZ_OTHER", nil];
    
    for (int i = 0; i < 27; i++) {
        NSMutableArray *empty = [[NSMutableArray alloc] init];
        [alphabet setValue:empty forKey:[alphaLetters objectAtIndex:i]];
    }
    
    NSString *firstLetter = @"";
    

    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    contactCount = (NSInteger)ABAddressBookGetPersonCount( addressBook );
    NSString *name;
    NSString *firstName;
    NSString *lastName;
    NSString *phone;
    for ( int i = 0; i < contactCount; i++ )
    {
        ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
        ABMultiValueRef multi = ABRecordCopyValue(ref, kABPersonPhoneProperty);
        firstName = (__bridge NSString*)ABRecordCopyValue(ref, kABPersonFirstNameProperty);
        lastName = (__bridge NSString*)ABRecordCopyValue(ref, kABPersonLastNameProperty);
        name = (__bridge NSString *)(ABRecordCopyCompositeName(ref));
        
        if (lastName) {
            firstLetter = [lastName substringToIndex:1];
        }else if (firstName){
            firstLetter = [firstName substringToIndex:1];
        }else {
            firstLetter = @"zz_other";
        }
        
        NSLog(@"firstLetter = %@", firstLetter);

//        if (ABMultiValueGetCount(multi)){
//            phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
//        }
//
//        NSMutableDictionary *second = [[NSMutableDictionary alloc] init];
//        
//        [second setObject:name forKey:@"name"];
//        [second setObject:phone forKey:@"phone"];
//        
//        if ([contacts objectForKey:phone]) {
//            [contacts removeObjectForKey:phone];
//        }else{
//            [contacts setObject:second forKey:phone];
//        }
//        NSLog(@"name=%@", name);

    }
//
//   // NSLog(@"contacts = %@", contacts);


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"num rows = %d", contactCount); 
    return contactCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SCContactsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    return cell;
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
//    
//    if ([contacts objectForKey:phone]) {
//        [contacts removeObjectForKey:phone];
//    }else{
//        [contacts setObject:second forKey:phone];
//    }
//    
//    NSLog(@"tmp = %@", contacts);
    
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
