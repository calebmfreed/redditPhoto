//
//  addSubViewController.h
//  redditPhoto
//
//  Created by Caleb Freed on 12/13/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
@class addSubViewController;

@protocol AddSubDelegate
- (void)AddViewControllerDidFinish:(addSubViewController*)controller;
@end

@interface addSubViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textfield;

@property (weak, nonatomic) IBOutlet UITableView *suggested;
@property (strong, nonatomic) id <AddSubDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *done;
@property (strong, nonatomic) NSString *passSub;
@property (strong, nonatomic) NSArray *suggestedSubs;
- (IBAction)done:(id)sender;

@end
