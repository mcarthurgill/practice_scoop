//
//  SCUserGroupsViewController.h
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/19/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadURLJson.h"
#import "MBProgressHUD.h"

@interface SCUserGroupsViewController : UIViewController <LoadJsonDelegate, MBProgressHUDDelegate>
{
    LoadURLJson* loadJson;
    MBProgressHUD* HUD; 
}

@property (strong, nonatomic) IBOutlet UITextField *user_id;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *findGroupsButton;

- (IBAction)findGroupsAction:(id)sender;

@end
