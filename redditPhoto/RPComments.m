//
//  RPComments.m
//  redditPhoto
//
//  Created by Caleb Freed on 12/14/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "RPComments.h"
#import "AFNetworking.h"

@interface RPComments ()

@end

@implementation RPComments

-(void) viewWillDisappear:(BOOL)animated
{
    loaded = NO;
    [[self delegate] commentsViewDidFinish:self];

}

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
    loaded = NO;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:_commentURL  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary * tempDict = (NSDictionary *)responseObject;
        _commentArray = responseObject;
        loaded = YES;
        [self.tableView reloadData];
        //NSLog(@"single reponse, %@", [[[_response objectForKey:@"data"]objectForKey:@"children"]objectAtIndex:0]);
        //NSLog(@"again single reponse, %@", tempDict[@"data"][@"children"][0][@"data"]);
        //First top rated comment is at [@"Children"][0], next at [1], etc,
        //Example:
        //        {
        //        kind: "Listing",
        //        data: {
        //        modhash: "",
        //        children: [
        //            {
        //            kind: "t1",
        //            data: {
        //            subreddit_id: "t5_2qt55",
        //            banned_by: null,
        //            subreddit: "gifs",
        //            likes: null,
        //            replies: {
        //            kind: "Listing",
        //            data: {}
        //            },
        //            saved: false,
        //                id: "ce1nxe0",
        //            gilded: 0,
        //            author: "Imiod",
        //            parent_id: "t3_1svjl7",
        //            approved_by: null,
        //            body: "I will pay good money for this shit.",
        //            edited: false,
        //            author_flair_css_class: null,
        //            downs: 260,
        //            body_html: "&lt;div class="md"&gt;&lt;p&gt;I will pay good money for this shit.&lt;/p&gt; &lt;/div&gt;",
        //            link_id: "t3_1svjl7",
        //            score_hidden: false,
        //            name: "t1_ce1nxe0",
        //            created: 1387074259,
        //            author_flair_text: null,
        //            created_utc: 1387045459,
        //            distinguished: null,
        //            num_reports: null,
        //            ups: 1371
        //            }
        //            },
        //            {
        //            kind: "t1",
        //            data: {
        //            subreddit_id: "t5_2qt55",
        //            banned_by: null,
        //            subreddit: "gifs",
        //            likes: null,
        //            replies: {
        //            kind: "Listing",
        //            data: {}
        //            },
        //            saved: false,
        //                id: "ce1o1i0",
        //            gilded: 0,
        //            author: "Jace_the_mind",
        //            parent_id: "t3_1svjl7",
        //            approved_by: null,
        //            body: "If you ever see these you need to buy one. They often cone with your choice of seasoning too. Ranch, BBQ, cheesy garlic, etc... They are amazing. Generally, I see them at the fair and at water parks.",
        //            edited: false,
        //            author_flair_css_class: null,
        //            downs: 55,
        //            body_html: "&lt;div class="md"&gt;&lt;p&gt;If you ever see these you need to buy one. They often cone with your choice of seasoning too.&lt;/p&gt; &lt;p&gt;Ranch, BBQ, cheesy garlic, etc...&lt;/p&gt; &lt;p&gt;They are amazing. Generally, I see them at the fair and at water parks.&lt;/p&gt; &lt;/div&gt;",
        //            link_id: "t3_1svjl7",
        //            score_hidden: false,
        //            name: "t1_ce1o1i0",
        //            created: 1387074581,
        //            author_flair_text: null,
        //            created_utc: 1387045781,
        //            distinguished: null,
        //            num_reports: null,
        //            ups: 249
        //            }
        //            },
        //First big comment
        NSLog(@"comments: %@", _commentArray[1][@"data"][@"children"][0][@"data"][@"body"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CGSize maxSize = CGSizeMake(100.0,100.0);
    CGSize cellSize = [_commentArray[1][@"data"][@"children"][indexPath.row][@"data"][@"body"]
                       sizeWithFont:[UIFont systemFontOfSize:15]
                       constrainedToSize:maxSize
                       lineBreakMode:UILineBreakModeWordWrap];
    return cellSize.height;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_commentArray[1][@"data"][@"children"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"comment";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(loaded == YES)
    {
        cell.textLabel.text = _commentArray[1][@"data"][@"children"][indexPath.row][@"data"][@"body"];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 3;

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