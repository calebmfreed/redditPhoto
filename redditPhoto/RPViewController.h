//
//  RPViewController.h
//  redditPhoto
//
//  Created by Caleb Freed on 12/7/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RPSubSelectViewController.h"

@class RPViewController;

@protocol RPViewControllerDelegate
- (void)RPViewControllerDidFinish:(RPViewController*)controller;
@end

@interface RPViewController : UIViewController <UIGestureRecognizerDelegate, UIWebViewDelegate>

- (IBAction)doSomething:(UISwipeGestureRecognizer *)recognizer;
- (void)centerScrollViewContents;
- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer;
- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer;

@property (strong, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;

@property (strong, nonatomic) NSString * permLink;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollWindow;
@property (nonatomic) int numPage;
@property (weak, nonatomic) id <RPViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *picTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSDictionary *response;
@property (strong, nonatomic) NSString *subReddit;
- (IBAction)goBack:(id)sender;
- (IBAction)goNext:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *busy;
@property (weak, nonatomic) NSString *commentUrl;

- (NSString*)loadDataFromHtml:(NSURLRequest*)urlrequest;

@end
