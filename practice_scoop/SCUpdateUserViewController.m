//
//  SCUpdateUserViewController.m
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/18/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import "SCUpdateUserViewController.h"
#import "NSString+URLEncoding.h"


@interface SCUpdateUserViewController ()

@end

@implementation SCUpdateUserViewController

@synthesize name;
@synthesize password;
@synthesize phone;
@synthesize updateButton;

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

- (IBAction)updateButtonAction:(id)sender {
    [self showHUD];
    
    //you need to change the ID here to the SCSession object's user's ID
    loadJson = [LoadURLJson download:[NSString stringWithFormat:@"/users/%s.json?user[name]=%@&user[phone]=%@&user[password]=%@", "2", [self.name.text urlEncodeUsingEncoding:NSUTF8StringEncoding], [self.phone.text urlEncodeUsingEncoding:NSUTF8StringEncoding], [self.password.text urlEncodeUsingEncoding:NSUTF8StringEncoding]] withDelegate:self withMethod:@"PUT" withParameters:nil];
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
