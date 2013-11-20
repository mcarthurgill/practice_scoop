//
//  SCShowOneGroupViewController.m
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/20/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import "SCShowOneGroupViewController.h"
#import "NSString+URLEncoding.h"
#import "STSession.h"

@interface SCShowOneGroupViewController ()

@end

@implementation SCShowOneGroupViewController

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
    loadJson = [LoadURLJson download:[NSString stringWithFormat:@"/users.json?user[name]=mcarthur&user[phone]=3343994374&user[password]=snickers"] withDelegate:self withMethod:@"POST" withParameters:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showOneGroupAction:(id)sender {
    //this is hard coded for the first group
    loadJson = [LoadURLJson download:[NSString stringWithFormat:@"/groups/1.json?user[password]=%@", [[[STSession thisSession] loggedInUser] objectForKey:@"password"]] withDelegate:self withMethod:@"GET" withParameters:nil];
}


- (void)downloadFinished
{
    NSData *data = [[NSData alloc] initWithData:loadJson.receivedData];
    
    NSError *error = nil;
    NSDictionary *resp = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"download Finished: %@",resp);
    
    [self analyzeResponse:resp];
    
}

- (void) analyzeResponse:(NSDictionary*)response
{
    [self hideHUD];
    if ([response objectForKey:@"user"]) {
        [[STSession thisSession] setLoggedInUser:[response objectForKey:@"user"]];
    }
    NSLog(@"response: %@", response);
}



//HUD

- (void) showHUD
{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
    }
    HUD.delegate = self;
    HUD.labelText = @"Hang tight...";
    [self.view addSubview:HUD];
    [HUD show:YES];
}

- (void) hideHUD
{
    [HUD show:NO];
    [HUD removeFromSuperview];
}



@end
