//
//  RPViewController.h
//  redditPhoto
//
//  Created by Caleb Freed on 12/7/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RPViewController : UIViewController <UIGestureRecognizerDelegate>
{
    int numPage;
}
- (IBAction)doSomething:(UISwipeGestureRecognizer *)recognizer;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (strong, nonatomic) NSDictionary *response;
- (IBAction)goBack:(id)sender;
- (IBAction)goNext:(id)sender;

- (NSString*)loadDataFromHtml:(NSURLRequest*)urlrequest;

@end
