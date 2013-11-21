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
@synthesize sortedKeys;

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
    contacts = [[NSMutableArray alloc] init];
    alphabet = [[NSMutableDictionary alloc] init];
    sortedKeys = [[NSArray alloc] init];
    NSArray *alphaLetters = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"ZZ_OTHER", nil];
    
    for (int i = 0; i < 27; i++) {
        NSMutableArray *empty = [[NSMutableArray alloc] init];
        [alphabet setValue:empty forKey:[alphaLetters objectAtIndex:i]];
    }

    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
    contactCount = (NSInteger)ABAddressBookGetPersonCount( addressBook );
    NSString *name;
    NSString *firstName;
    NSString *lastName;
    NSString *phone;
    NSString *firstLetter;
    
    for ( int i = 0; i < contactCount; i++ )
    {
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
        firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        lastName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        name = (__bridge NSString *)(ABRecordCopyCompositeName(person));

        
        if ([alphaLetters containsObject:[[lastName substringToIndex:1] uppercaseString]]) {
            firstLetter = [[lastName substringToIndex:1] uppercaseString];
        }else if ([alphaLetters containsObject:[[firstName substringToIndex:1] uppercaseString]]){
            firstLetter = [[firstName substringToIndex:1] uppercaseString];
        }else {
            firstLetter = @"ZZ_OTHER";
        }
        
        if (ABMultiValueGetCount(multi)){
            phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
            if ([alphabet objectForKey:firstLetter]) {
                NSArray *values = [[NSArray alloc] initWithObjects:name, firstName, lastName, phone, nil];
                NSArray *keys = [[NSArray alloc] initWithObjects:@"name", @"firstName", @"lastName", @"phone", nil];
                NSDictionary *contact = [[NSDictionary alloc] initWithObjects:values forKeys:keys];
                [self addDictionary:contact toSortedArray:[alphabet objectForKey:firstLetter]];
            }
        }
    }
    
    NSArray *keysForNullValues = [alphabet allKeysForObject:[[NSMutableArray alloc] init]];
    [alphabet removeObjectsForKeys:keysForNullValues];
     
    sortedKeys = [[alphabet allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    contacts = [[NSMutableArray alloc] initWithArray:nil];
    for (int i = 0; i < sortedKeys.count; ++i) {
        [contacts addObject:[alphabet objectForKey:[sortedKeys objectAtIndex:i]]];
    }


//    NSLog(@"alphabet = %lu", [alphabet count]);
//    NSLog(@"alphabet = %@", alphabet);
    NSLog(@"contacts = %@", contacts);

}

-(NSMutableArray *)addDictionary:(NSDictionary *)contact toSortedArray:(NSMutableArray *)array
{
    if ([array count] == 0) {
        [array addObject:contact];
        return array;
    }
    for(int i = 0; i < [array count]; i++)
    {
        for(int j = i+1; j <= [array count]; j++)
        {
            NSString *recordOne = [[[array objectAtIndex:i] valueForKey:@"lastName"] lowercaseString];
            NSString *recordTwo = [[contact valueForKey:@"lastName"] lowercaseString];
            NSComparisonResult result = [recordOne compare:recordTwo];
            if(result == NSOrderedDescending) {
                [array insertObject:contact atIndex:i];
            }
            else {
                return array;
            }
        }
    }
    return array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return contacts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[contacts objectAtIndex:section] count];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [sortedKeys objectAtIndex:section];
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
