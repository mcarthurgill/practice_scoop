//
//  SCGroupShowTableViewController.h
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/20/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadURLJson.h"
#import "MBProgressHUD.h"

@interface SCGroupShowTableViewController : UITableViewController <LoadJsonDelegate, MBProgressHUDDelegate>
{
    LoadURLJson* loadJson;
    MBProgressHUD* HUD; 
}

@end
