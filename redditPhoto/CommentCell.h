//
//  CommentCell.h
//  redditPhoto
//
//  Created by Caleb Freed on 12/14/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *commentWords;
@property (weak, nonatomic) IBOutlet UILabel *downs;
@property (weak, nonatomic) IBOutlet UILabel *ups;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UITextView *commentWords;

@end
