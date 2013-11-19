//
//  SCGroupsCreateViewController.h
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/19/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "LoadURLJson.h"

@interface SCGroupsCreateViewController : UIViewController <LoadJsonDelegate, MBProgressHUDDelegate>
{
    LoadURLJson* loadJson;
    MBProgressHUD* HUD;
}
@property (strong, nonatomic) IBOutlet UITextField *groupName;
@property (strong, nonatomic) IBOutlet UITextField *groupAvatarUrl;
@property (strong, nonatomic) IBOutlet UIButton *createGroupButton;

- (IBAction)createGroupAction:(id)sender;
@end
