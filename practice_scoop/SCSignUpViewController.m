//
//  SCSignUpViewController.m
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/18/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import "SCSignUpViewController.h"
#import "NSString+URLEncoding.h"
#import "STSession.h"


@interface SCSignUpViewController ()

@end

@implementation SCSignUpViewController

@synthesize name;
@synthesize phone;
@synthesize password;
@synthesize submitButton;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonAction:(id)sender {
    [self showHUD];
    loadJson = [LoadURLJson download:[NSString stringWithFormat:@"/users.json?user[name]=%@&user[phone]=%@&user[password]=%@", [self.name.text urlEncodeUsingEncoding:NSUTF8StringEncoding], [self.phone.text urlEncodeUsingEncoding:NSUTF8StringEncoding], [self.password.text urlEncodeUsingEncoding:NSUTF8StringEncoding]] withDelegate:self withMethod:@"POST" withParameters:nil];
    NSLog(@"Request Made");
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
    NSLog(@"response: %@", [[STSession thisSession] loggedInUser]);
    
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
