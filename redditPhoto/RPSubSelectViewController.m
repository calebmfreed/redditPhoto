//
//  RPSubSelectViewController.m
//  redditPhoto
//
//  Created by Caleb Freed on 12/7/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "RPSubSelectViewController.h"
#import "addSubViewController.h"
#import "RPAppDelegate.h"

@interface RPSubSelectViewController ()

@end

@implementation RPSubSelectViewController
@synthesize managedObjectContext, thing;


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
    
    _subredditList = [[NSMutableArray alloc] init];

    self.navigationController.navigationBarHidden = NO;

    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = @"Subreddits";
    
    
    id delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [delegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Subreddits" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    thing = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    NSLog(@"thing array: %@", thing );

    //NSLog(@"thing: %@", [[thing valueForKey:@"name"] objectAtIndex:0] );
    //Puts add button for adding new subreddit
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self action:@selector(addButtonPressed)];
    self.navigationItem.leftBarButtonItem = addButton;
    //Adds edit button to delete subreddits
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                              style:self.editButtonItem.style
                                                                             target:self
                                                                             action:@selector(editButtonPressed)];
    
    //Loads the subreddit list with objects from the core database
    for(int i = 0; i < [[thing valueForKey:@"name"] count]; i++)
    {
        [_subredditList addObject:[[thing valueForKey:@"name"] objectAtIndex:i]];

    }
    //self.title = @"Failed Banks";
    //_subredditList = [managedObjectContext executeFetchRequest:fetchRequest error:&error];

    //[_subredditList addObject:[[thing valueForKey:@"name"] objectAtIndex:0]];
    
    //_subredditList = [[NSMutableArray alloc] initWithObjects:@"pics",@"funny",@"adviceanimals",@"yogapants", @"bikinis", @"nsfw", @"wtf", @"ass+titties", @"ass", @"tightdresses", nil];
    _pages = [[NSMutableDictionary alloc]init];
    NSNumber *zero = [NSNumber numberWithInt:0];
    for( id sub in _subredditList)
    {
        [_pages setObject:zero forKey:sub];
    }
    NSLog(@"Sub List: %@",_subredditList);
    returnedNum = 0;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
}

- (void) editButtonPressed
{
    self.tableView.editing = !self.tableView.editing;

}

- (void) addButtonPressed
{
    [self performSegueWithIdentifier:@"add" sender:nil];
    
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //    1
        [tableView beginUpdates];
        // Delete the row from the data source
        
        [_subredditList removeObjectAtIndex:indexPath.row];

        //    2
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

        //    3
        [self.managedObjectContext deleteObject:[self.thing objectAtIndex:indexPath.row]];
        NSError *error;

        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        //    4
        RPAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.thing = [appDelegate fetchNames];
        //    5
        [tableView endUpdates];
        if([_subredditList count] == 0)
        {
            [self editButtonPressed];
        }
    }
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

- (void)AddViewControllerDidFinish:(addSubViewController*)controller;
{
    if(![controller.passSub isEqualToString:@""] && ![_subredditList containsObject:controller.passSub])
    {
        NSManagedObjectContext *context = [self managedObjectContext];
        NSManagedObject *sub = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"Subreddits"
                                           inManagedObjectContext:context];
        [sub setValue:controller.passSub forKey:@"name"];
        NSLog(@"Done adding%@", controller.passSub);
        NSNumber *zero = [NSNumber numberWithInt:0];
        [_pages setObject:zero forKey:controller.passSub];
        [_subredditList addObject:controller.passSub];
        NSError *error;

        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"Subreddits" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        //NSLog(@"%@",[fetchedObjects objectAtIndex:2]);
        //[context deleteObject:[fetchedObjects objectAtIndex:0]];
        for (NSManagedObject *info in fetchedObjects) {
            NSLog(@"Name: %@", [info valueForKey:@"name"]);
            
        }
        RPAppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
        self.thing = [appDelegate fetchNames];
        [self.tableView reloadData];
    }
    else{
        NSLog(@"No sub added");
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}


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
    
    if([segue.identifier isEqualToString: @"add"])
    {
        [[segue destinationViewController] setDelegate: self];
    }
}

@end
