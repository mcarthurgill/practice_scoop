//
//  SCUserShowViewController.h
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/19/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadURLJson.h"
#import "MBProgressHUD.h"

@interface SCUserShowViewController : UIViewController <LoadJsonDelegate, MBProgressHUDDelegate>
{
    LoadURLJson* loadJson;
    MBProgressHUD* HUD;
}

@property (strong, nonatomic) IBOutlet UIButton *showUserButton;

- (IBAction)showUserAction:(id)sender;
@end
