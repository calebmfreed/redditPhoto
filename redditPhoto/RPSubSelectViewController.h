//
//  RPSubSelectViewController.h
//  redditPhoto
//
//  Created by Caleb Freed on 12/7/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPViewController.h"

@interface RPSubSelectViewController : UITableViewController{
    int returnedNum;
}

@property (nonatomic, strong) NSMutableArray *subredditList;
@property (nonatomic, strong) NSMutableDictionary *pages;

@end
