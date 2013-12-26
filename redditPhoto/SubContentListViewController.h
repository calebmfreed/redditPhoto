//
//  SubContentListViewController.h
//  redditPhoto
//
//  Created by Caleb Freed on 12/25/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPViewController.h"
#import "AFNetworking.h"

@class SubContentListViewController;
@protocol SubContentListDelegate <NSObject>

-(void) SubContentListDone:(SubContentListViewController*)controller;

@end


@interface SubContentListViewController : UITableViewController
{
    BOOL loaded;
}
@property (strong, nonatomic) id <SubContentListDelegate> delegate;
@property (nonatomic) int numPage;
@property (strong, nonatomic) NSString *subReddit;
@property (strong, nonatomic) NSDictionary *response;
@property (strong, nonatomic) NSDictionary *titles;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *wheels;



@end
