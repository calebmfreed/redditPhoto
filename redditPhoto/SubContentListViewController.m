//
//  SubContentListViewController.m
//  redditPhoto
//
//  Created by Caleb Freed on 12/25/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

static NSString *const BaseURLString = @"http://www.reddit.com";

#define FONT_SIZE 12.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

#import "SubContentListViewController.h"

@interface SubContentListViewController ()

@end

@implementation SubContentListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated{
    [[self delegate] SubContentListDone:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    loaded = NO;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _wheels.hidesWhenStopped = YES;
    [_wheels startAnimating];
    self.navigationItem.title = _subReddit;
    NSString *subUrl = [NSString stringWithFormat:@"%@/r/%@/.json?limit=100&", BaseURLString, _subReddit];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:subUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary * tempDict = (NSDictionary *)responseObject;
        _response = tempDict[@"data"];
        //NSLog(@"single reponse, %@", [[[_response objectForKey:@"data"]objectForKey:@"children"]objectAtIndex:0]);
        //NSLog(@"again single reponse, %@", tempDict[@"data"][@"children"][0][@"data"]);
        //[self.commentsButton setTitle:[NSString stringWithFormat:@"Comments: %@", _response[@"children"][numPage][@"data"][@"num_comments"]] forState:UIControlStateNormal];
        loaded = YES;
        [_wheels stopAnimating];
        [self.tableView reloadData];

        //[self loadPicture:numPage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
    return [_response[@"children"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    // Get the text so we can measure it
    NSString *text = _response[@"children"][indexPath.row][@"data"][@"title"];
    NSLog(@"CellText: %@", text);
    // Get a CGSize for the width and, effectively, unlimited height
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    // Get the size of the text given the CGSize we just made as a constraint
    CGSize size = [text sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    // Get the height of our measurement, with a minimum of 44 (standard cell size)
    CGFloat height = MAX(size.height, 15.0f);
    // return the height, with a bit of extra padding in
    return height + (CELL_CONTENT_MARGIN * 2);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _numPage = (int)indexPath.row;
    [self performSegueWithIdentifier:@"toPics" sender:self];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"postTitles";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(loaded == YES)
    {
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:FONT_SIZE];
        cell.textLabel.numberOfLines = 10;
        cell.textLabel.text = _response[@"children"][indexPath.row][@"data"][@"title"];
        //NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Helvetica Neue"]);
                      //fontNamesForFamilyName:@"Helvetica Neue"]

    }
    // Configure the cell...
    
    return cell;
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


#pragma mark - Navigation
- (void)RPViewControllerDidFinish:(RPViewController*)controller
{
    //NSNumber *page = [NSNumber numberWithInt:controller.numPage];
    //[_pages setValue:page forKey:controller.subReddit];
    _numPage = controller.numPage;
    NSIndexPath *moveTo = [NSIndexPath indexPathForRow:_numPage inSection:0];
    [self.tableView selectRowAtIndexPath:moveTo
                           animated:NO
                     scrollPosition:UITableViewScrollPositionMiddle];
}


// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString: @"toPics"])
    {
        [[segue destinationViewController] setDelegate: self];
        //[[segue destinationViewController] setSubReddit:[_subredditList objectAtIndex:selectedRowIndex.row]];
        [[segue destinationViewController] setNumPage:_numPage]; //perhaps selected rowindex
        [[segue destinationViewController] setResponse:_response];
    }
}


@end
