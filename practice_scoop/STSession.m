//
//  STSession.m
//  Stadium Times
//
//  Created by William L. Schreiber on 10/30/13.
//  Copyright (c) 2013 Stadium Stock Exchange. All rights reserved.
//

#import "STSession.h"

static STSession* thisSession = nil;

@implementation STSession

@synthesize deviceTokenString;
@synthesize loggedInUser;

//constructor
-(id) init
{
   if (thisSession) {
      return thisSession;
   }
   self = [super init];
   [self setVariables];
   return self;
}


//singleton instance
+(STSession*) thisSession
{
   if (!thisSession) {
      thisSession = [[super allocWithZone:NULL] init];
   }
   return thisSession;
}


//prevent creation of additional instances
+(id)allocWithZone:(NSZone *)zone
{
   return [self thisSession];
}


-(void) setVariables
{
   NSLog(@"Setting Singleton Variables");
   
   [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(saveMyData:)
    name:UIApplicationWillResignActiveNotification
    object:nil];
   
   
   NSString* dataFilePath = [self userFileInDocumentsDirectory];
   
   // Check if the file already exists
   
   if ([[self fileManager] fileExistsAtPath: dataFilePath])
   {
      self.loggedInUser = [NSKeyedUnarchiver unarchiveObjectWithFile:dataFilePath];
      NSLog(@"GOT USER: %@", self.loggedInUser);
   } else {
      self.loggedInUser = nil;
   }
   
}


- (void) saveMyData:(NSNotification*)notification
{
   NSLog(@"SAVING DATA");
   [NSKeyedArchiver archiveRootObject:self.loggedInUser toFile:[self userFileInDocumentsDirectory]];
}


//Saving / Archiving

//
- (NSFileManager*) fileManager
{
   return [NSFileManager defaultManager];
}

// Returns the URL to the application's Documents directory.
- (NSString *)applicationDocumentsDirectory
{
   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
   return basePath;
}

- (NSString *) userFileInDocumentsDirectory
{
   return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"user.archive"];
}



// METHODS

- (BOOL) isLoggedIn
{
   if (self.loggedInUser) {
      return YES;
   } else {
      return NO;
   }
}


- (UIColor*) greenColor
{
   return [UIColor colorWithRed:0.498 green:.690 blue:.255 alpha:1];
}

- (UIColor*) greenColorTrans
{
   return [UIColor colorWithRed:0.498 green:.690 blue:.255 alpha:0.7];
}

- (UIColor*) redColor
{
   return [UIColor colorWithRed:.804 green:.267 blue:.267 alpha:1];
}

- (UIColor*) offwhiteColor
{
   return [UIColor colorWithRed:.929 green:.925 blue:.910 alpha:1];
}

- (UIColor*) softBlackColor
{
   return [UIColor colorWithRed:.216 green:.216 blue:.216 alpha:1];
}

- (UIColor*) softerBlackColor
{
   return [UIColor colorWithRed:.137 green:.137 blue:.137 alpha:1];
}

- (UIColor*) goldColor
{
   return [UIColor colorWithRed:.894 green:.718 blue:.286 alpha:1];
}



- (NSString*) toMoney:(NSNumber *)number
{
   // Init and configure formatter
   NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
   [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
   [formatter setMaximumFractionDigits:2];
   NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"us_US"];
   [formatter setLocale:locale];
   [formatter setGroupingSize:3];
   [formatter setUsesGroupingSeparator:YES];
   [formatter setGroupingSeparator:@","];
   [formatter setAllowsFloats:YES];
   // Get a formatted string using the local currency formatter and then get a double
   // vice-versa
   return [formatter stringFromNumber:number];
}

- (UIFont*) montserratFont
{
   return [UIFont fontWithName:@"Montserrat-Regular" size:14.0f];
}

- (void) logFontNames
{
   // List all fonts on iPhone
   NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
   NSArray *fontNames;
   NSInteger indFamily, indFont;
   for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
   {
      NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
      fontNames = [[NSArray alloc] initWithArray:
                   [UIFont fontNamesForFamilyName:
                    [familyNames objectAtIndex:indFamily]]];
      for (indFont=0; indFont<[fontNames count]; ++indFont)
      {
         NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
      }
   }
}

-(NSString *)getRootDomain:(NSString *)domain
{
   NSURL* url = [NSURL URLWithString:domain];
   NSString *host = [NSString stringWithFormat:
                           @"%@",
                           //url.scheme,
                           url.host//,
                           //[url.pathComponents objectAtIndex:1]];
           ];
   return [host stringByReplacingOccurrencesOfString:@"www." withString:@""];
}

@end
