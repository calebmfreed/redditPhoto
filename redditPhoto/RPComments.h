//
//  RPComments.h
//  redditPhoto
//
//  Created by Caleb Freed on 12/14/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RPComments;

@protocol CommentDelegate <NSObject>

-(void) commentsViewDidFinish:(RPComments*)controller;

@end

@interface RPComments : UITableViewController{
    BOOL loaded;
}

@property (strong, nonatomic) id <CommentDelegate> delegate;
@property (strong, nonatomic) NSString * commentURL;
@property (strong, nonatomic) NSArray * commentArray;


@end
