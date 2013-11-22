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
@synthesize searchBar;
@synthesize contactsArrayDict;
@synthesize keysArrayDict;
@synthesize selectedContacts;

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
   
   
   
   [self initializeVariables];
   
   [self getAddressBook];
   
   CFErrorRef  error;
   ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL,&error);
   
   ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
      //        accessGranted = granted;
      if (granted) {
         if ([contacts count] == 0) {
            [self getAddressBook];
         }
      }
   });
   
   

}

- (void) initializeVariables
{
   contactsArrayDict = [[NSMutableDictionary alloc] init];
   keysArrayDict = [[NSMutableDictionary alloc] init];
   contacts = [[NSMutableArray alloc] init];
   alphabet = [[NSMutableDictionary alloc] init];
   sortedKeys = [[NSMutableArray alloc] init];
   selectedContacts = [[NSMutableDictionary alloc] init];
}

- (void) getAddressBook
{
   
   
   NSArray *alphaLetters = [[NSArray alloc] initWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"ZZ_OTHER", nil];
   
   for (int i = 0; i < 27; i++) {
      NSMutableArray *empty = [[NSMutableArray alloc] init];
      [alphabet setValue:empty forKey:[alphaLetters objectAtIndex:i]];
   }
   
   ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
   CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
   contactCount = (NSInteger)ABAddressBookGetPersonCount( addressBook );
   NSLog(@"CONTACT COUNT: %ld", (long)contactCount);
   NSString *name;
   NSString *firstName;
   NSString *lastName;
   NSString *phone;
   NSString *firstLetter;
   
   int count = 0;
   int foundFirstLetter = 0;
   
   for ( int i = 0; i < contactCount; i++ )
   {
      ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
      ABMultiValueRef multi = ABRecordCopyValue(person, kABPersonPhoneProperty);
      firstName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
      lastName = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
      name = (__bridge NSString *)(ABRecordCopyCompositeName(person));
      
      NSString* nameToCompare;
      if (!lastName) {
         nameToCompare = name;
      } else {
         nameToCompare = lastName;
      }
      
      if ([nameToCompare length] > 0) {
         firstLetter = [[nameToCompare substringToIndex:1] uppercaseString];
      } else {
         firstLetter = @"ZZ_OTHER";
      }
      
      if (ABMultiValueGetCount(multi)){
         ++count;
         phone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(multi, 0);
         if ([alphabet objectForKey:[firstLetter uppercaseString]]) {
            ++foundFirstLetter;
            NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
            if (name) {
               [contact setObject:name forKey:@"name"];
            }
            if (firstName) {
               [contact setObject:firstName forKey:@"firstName"];
            }
            if (lastName) {
               [contact setObject:lastName forKey:@"lastName"];
            }
            if (phone) {
               [contact setObject:phone forKey:@"phone"];
            }
            [self addDictionary:contact toSortedArray:[alphabet objectForKey:firstLetter]];
         }
      }
   }
   
   NSLog(@"COUNT: %i", count);
   NSLog(@"FOUND FIRST LETTER: %i", foundFirstLetter);
   
   NSArray *keysForNullValues = [alphabet allKeysForObject:[[NSMutableArray alloc] init]];
   [alphabet removeObjectsForKeys:keysForNullValues];
   
   sortedKeys = [[NSMutableArray alloc] initWithArray:[[alphabet allKeys] sortedArrayUsingSelector:@selector(compare:)]];
   
   contacts = [[NSMutableArray alloc] initWithArray:nil];
   for (int i = 0; i < sortedKeys.count; ++i) {
      [contacts addObject:[alphabet objectForKey:[sortedKeys objectAtIndex:i]]];
   }
   
   
   //    NSLog(@"alphabet = %lu", [alphabet count]);
   //    NSLog(@"alphabet = %@", alphabet);
   //NSLog(@"contacts = %@", contacts);
   

   [self setContacts:contacts andKeys:sortedKeys forKey:@"-"];
   [self reloadContacts];
   
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
           NSString* nameToCompare;
           if (!([[[array objectAtIndex:i] valueForKey:@"lastName"] length] > 0)) {
              nameToCompare = @"lastName";
           } else {
              nameToCompare = @"name";
           }
            NSString *recordOne = [[[array objectAtIndex:i] valueForKey:nameToCompare] lowercaseString];
            NSString *recordTwo = [[contact valueForKey:nameToCompare] lowercaseString];
           if ([recordOne isEqualToString:recordTwo]) {
              recordOne = [[[array objectAtIndex:i] valueForKey:@"firstName"] lowercaseString];
              recordTwo = [[contact valueForKey:@"firstName"] lowercaseString];
           }
            NSComparisonResult result = [recordOne compare:recordTwo];
            if(result == NSOrderedDescending) {
                [array insertObject:contact atIndex:i];
               return array;
            }
        }
    }
    [array addObject:contact];
    return array;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void) setOriginalContactsAndKeys
{
   [self setContacts:[contactsArrayDict objectForKey:@"-"] andKeys:[keysArrayDict objectForKey:@"-"]];
   [self reloadContacts];
}


- (void) setContacts:(NSMutableArray *)c andKeys:(NSMutableArray*)k forKey:(NSString*)key
{
   [self setContacts:c andKeys:k];
   [self.keysArrayDict setObject:k forKey:key];
   [self.contactsArrayDict setObject:c forKey:key];
   [self reloadContacts];
}

- (void) setContacts:(NSMutableArray *)c andKeys:(NSMutableArray*)k
{
   contacts = [[NSMutableArray alloc] initWithArray:c];
   sortedKeys = [[NSMutableArray alloc] initWithArray:k];
}

- (void) createAndPushNewContactsForSearch:(NSString*)search
{
   NSMutableArray* newContacts;
   NSMutableArray* newKeys;
   search = [search lowercaseString];
   
   if (search.length > 1 && [self.contactsArrayDict objectForKey:[search substringToIndex:(search.length-2)]]) {
      newContacts = [[NSMutableArray alloc] initWithArray:[self.contactsArrayDict objectForKey:[search substringToIndex:(search.length-2)]]];
      newKeys = [[NSMutableArray alloc] initWithArray:[self.keysArrayDict objectForKey:[search substringToIndex:(search.length-2)]]];
   } else {
      newContacts = [[NSMutableArray alloc] initWithArray:[self contactsToWorkWith]];
      newKeys = [[NSMutableArray alloc] initWithArray:[self sortedKeysToWorkWith]];
   }
   
   NSLog(@"Dictionary COUNT: %i", contactsArrayDict.allValues.count);
   
   if (newContacts && newKeys) {
      
      for (int sectionsIndex = 0; sectionsIndex < newContacts.count; sectionsIndex) {
         
         NSMutableArray* newRows = [[NSMutableArray alloc] initWithArray:[newContacts objectAtIndex:sectionsIndex]];
         
         for (int rowsIndex = 0; rowsIndex < newRows.count; rowsIndex) {
            
            if ([[[[newRows objectAtIndex:rowsIndex] objectForKey:@"name"] lowercaseString] rangeOfString:search].location == NSNotFound) {
               //REMOVE CONTACT
               [newRows removeObjectAtIndex:rowsIndex];
            } else {
               ++rowsIndex;
            }
            
         }
         
         if (newRows.count == 0) {
            //REMOVE SECTION
            [newContacts removeObjectAtIndex:sectionsIndex];
            [newKeys removeObjectAtIndex:sectionsIndex];
         } else {
            [newContacts setObject:newRows atIndexedSubscript:sectionsIndex];
            ++sectionsIndex;
         }
         
      }
      
   }
   
   [self setContacts:newContacts andKeys:newKeys forKey:search];
   
}

- (void) reloadContacts
{
    NSLog(@"reloading contacts");
   [self.tableView reloadData];
}



#pragma mark - Table view data source

- (NSMutableArray*) contactsToWorkWith
{
   return contacts;
}

- (NSMutableArray*) sortedKeysToWorkWith
{
   return sortedKeys;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self contactsToWorkWith] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [(NSMutableArray*)[[self contactsToWorkWith] objectAtIndex:section] count];
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   if ([[self sortedKeysToWorkWith] count] > 0) {
      if ([[[self sortedKeysToWorkWith] objectAtIndex:section] isEqualToString:@"ZZ_OTHER"]) {
         return @"#";
      } else {
         return [[self sortedKeysToWorkWith] objectAtIndex:section];
      }
   }
   return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSLog(@"NUMBER SELECTED: %i", selectedContacts.count);
   
    static NSString *CellIdentifier = @"SCContactsTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellSelectionStyleNone reuseIdentifier:@"SCContactsTableViewCell"];
//    }
    
   UILabel* contactName = (UILabel*) [cell.contentView viewWithTag:1];
   
   NSDictionary* contact = [[[self contactsToWorkWith] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
//   NSString *boldFontName = [[UIFont boldSystemFontOfSize:12] fontName];
//   NSString *yourString = [contact objectForKey:@"name"];
//   NSRange boldedRange = NSMakeRange([[contact objectForKey:@"firstName"] length], [[contact objectForKey:@"lastName"] length]);
//   NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:yourString];
//   [attrString beginEditing];
//   [attrString addAttribute:NSFontAttributeName
//                      value:boldFontName
//                      range:boldedRange];
//   [attrString endEditing];
//   
//   [contactName setAttributedText:attrString];

   
   [contactName setText:[contact objectForKey:@"name"]];
   
   
   if ([selectedContacts objectForKey:[contact objectForKey:@"phone"]]) {
      [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
   }
   
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
   NSDictionary* c = [[contacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
   
   NSLog(@"ADD TO SELECTED CONTACTS");
   [self addContactToSelected:c];
   [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
   
}


- (void) tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
   NSDictionary* c = [[contacts objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
   
   NSLog(@"REMOVE FROM SELECTED CONTACTS");
   [self removeContactFromSelected:c];
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}


//=== SEARCH BAR DELEGATE

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   searchText = [searchText lowercaseString];
   
   if (searchText.length == 0) {
      [self setOriginalContactsAndKeys];
   } else {
      
      if ([self.contactsArrayDict objectForKey:searchText]) {
         NSLog(@"FOUND DICT");
         [self setContacts:[self.contactsArrayDict objectForKey:searchText] andKeys:[self.keysArrayDict objectForKey:searchText]];
         [self reloadContacts];
      } else {
         NSLog(@"CREATING NEW DICT");
         [self createAndPushNewContactsForSearch:searchText];
      }
      
   }
   
   NSLog(@"%@", searchText);
   
}


- (void) addContactToSelected:(NSDictionary*)c
{
   if (![selectedContacts objectForKey:[c objectForKey:@"phone"]]) {
      [selectedContacts setObject:c forKey:[c objectForKey:@"phone"]];
   }
}

- (void) removeContactFromSelected:(NSDictionary*)c
{
   [selectedContacts removeObjectForKey:[c objectForKey:@"phone"]];
}



@end
