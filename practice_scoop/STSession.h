//
//  STSession.h
//  Stadium Times
//
//  Created by William L. Schreiber on 10/30/13.
//  Copyright (c) 2013 Stadium Stock Exchange. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCUserShowViewController.h"
#import "SCAllUnseenPostsViewController.h"
#import "SCUserGroupsViewController.h"
#import "SCSignUpViewController.h"
#import "SCUpdateUserViewController.h"

@interface STSession : NSObject


+(STSession*) thisSession;
-(void) setVariables;


@property (strong, nonatomic) NSString* deviceTokenString;

@property (strong, nonatomic) NSDictionary* loggedInUser;

- (NSString *)applicationDocumentsDirectory;


//METHODS

- (BOOL) isLoggedIn;

- (UIColor*) greenColor;
- (UIColor*) greenColorTrans;
- (UIColor*) redColor;
- (UIColor*) offwhiteColor;
- (UIColor*) softBlackColor;
- (UIColor*) softerBlackColor;
- (UIColor*) goldColor;

- (NSString*) toMoney:(NSNumber*)number;

- (UIFont*) montserratFont;

- (void) logFontNames;

- (NSString *)getRootDomain:(NSString *)domain;

@end
