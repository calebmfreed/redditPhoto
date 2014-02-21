//
//  addSubViewController.m
//  redditPhoto
//
//  Created by Caleb Freed on 12/13/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "addSubViewController.h"

@interface addSubViewController ()

@end

@implementation addSubViewController

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
    _passSub = [[NSString alloc]init];
    self.suggested.dataSource = self;
    self.suggested.delegate = self;
    _done.layer.cornerRadius = 10;
    _done.clipsToBounds = YES;
    _suggestedSubs = @[@"wtf", @"funny", @"pics", @"adviceanimals", @"mobilewallpapers", @"america"];
    NSLog(@"%@", _suggestedSubs);
    
	// Do any additional setup after loading the view.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_suggestedSubs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"sub";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [_suggestedSubs objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _passSub = [_suggestedSubs objectAtIndex:indexPath.row];
    NSLog(@"Selected: %@",_passSub);
    
    [[self delegate] AddViewControllerDidFinish:self];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Suggested Subreddits";
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done:(id)sender {
    [_textfield resignFirstResponder];
    _passSub = [[NSString alloc]init];
    NSLog(@"%@", _textfield.text);
    _passSub = _textfield.text;
    [[self delegate] AddViewControllerDidFinish:self];

}
@end
