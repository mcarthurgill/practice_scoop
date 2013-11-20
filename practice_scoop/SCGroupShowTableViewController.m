//
//  SCGroupShowTableViewController.m
//  practice_scoop
//
//  Created by Joseph McArthur Gill on 11/20/13.
//  Copyright (c) 2013 Joseph McArthur Gill. All rights reserved.
//

#import "SCGroupShowTableViewController.h"
#import "SCGroupShowTableViewCell.h"
#import "STSession.h"

@interface SCGroupShowTableViewController ()

@end

@implementation SCGroupShowTableViewController

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
    loadJson = [LoadURLJson download:[NSString stringWithFormat:@"/users.json?user[name]=mcarthur&user[phone]=3343994374&user[password]=snickers"] withDelegate:self withMethod:@"POST" withParameters:nil];
    NSLog(@"****** VIEW DID LOAD");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        NSLog(@"****** SECTIONS");
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        NSLog(@"****** ROWS");
    NSLog(@"****COUNT = %lu", (unsigned long)[[[STSession thisSession] groups] count]);
    return [[[STSession thisSession] groups] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        NSLog(@"****** CELL FOR ROW");
    static NSString *CellIdentifier = @"SCGroupShowTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[SCGroupShowTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[[[STSession thisSession] groups] objectAtIndex:[indexPath row]] objectForKey:@"group_name"];
    
    return cell;
}



- (void)downloadFinished
{
        NSLog(@"****** DOWNLOAD FINISHED");
    NSData *data = [[NSData alloc] initWithData:loadJson.receivedData];
    
    NSError *error = nil;
    NSDictionary *resp = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error:&error];
    
    NSLog(@"download Finished: %@",resp);
    
    [self analyzeResponse:resp];
    
}

- (void) analyzeResponse:(NSDictionary*)response
{
        NSLog(@"****** ANALYZE RESPONSE");
    [self hideHUD];
    if ([response objectForKey:@"user"]) {
        [[STSession thisSession] setLoggedInUser:[response objectForKey:@"user"]];
        loadJson = [LoadURLJson download:[NSString stringWithFormat:@"/users/%@/groups.json?user[password]=%@", [[[STSession thisSession] loggedInUser] objectForKey:@"id"], [[[STSession thisSession] loggedInUser] objectForKey:@"password"]] withDelegate:self withMethod:@"GET" withParameters:nil];
        NSLog(@"Request Made");
    }
    
    if ([response objectForKey:@"groups"]) {
        NSMutableArray *arr;
        for (NSString *key in response) {
            for (int i = 0; i < [[response objectForKey:@"groups"] count]; i++) {
                [arr addObject:[[response objectForKey:key] objectAtIndex:i]];
            }
        }
        [[[STSession thisSession] groups] initWithArray:arr];
    }
    //NSLog(@"response: %@", response);
    
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



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
