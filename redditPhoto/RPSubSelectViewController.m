//
//  RPSubSelectViewController.m
//  redditPhoto
//
//  Created by Caleb Freed on 12/7/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "RPSubSelectViewController.h"

@interface RPSubSelectViewController ()

@end

@implementation RPSubSelectViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;

    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Subreddits";
    _subredditList = [[NSMutableArray alloc] initWithObjects:@"pics",@"funny",@"adviceanimals",@"yogapants", @"bikinis", @"nsfw", @"wtf", @"ass+titties", @"ass", @"tightdresses", nil];
    _pages = [[NSMutableDictionary alloc]init];
    NSNumber *zero = [NSNumber numberWithInt:0];
    for( id sub in _subredditList)
    {
        [_pages setObject:zero forKey:sub];
    }
    NSLog(@"%@",_subredditList);
    returnedNum = 0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_subredditList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [_subredditList objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toPics" sender:self];
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

- (void)RPViewControllerDidFinish:(RPViewController*)controller
{
    NSLog(@"ViewReturned page: %@", _pages);
    NSNumber *page = [NSNumber numberWithInt:controller.numPage];
    [_pages setValue:page forKey:controller.subReddit];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString: @"toPics"])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDelegate: self];
        [[segue destinationViewController] setSubReddit:[_subredditList objectAtIndex:selectedRowIndex.row]];
        [[segue destinationViewController] setNumPage:[[_pages valueForKey:[_subredditList objectAtIndex:selectedRowIndex.row]]intValue]];
    }
}

@end
