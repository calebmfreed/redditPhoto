//
//  RPViewController.m
//  redditPhoto
//
//  Created by Caleb Freed on 12/7/13.
//  Copyright (c) 2013 Caleb Freed. All rights reserved.
//

#import "RPViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"
#import "TFHpple.h"


static NSString *const BaseURLString = @"http://www.reddit.com/";


@interface RPViewController ()

@end

@implementation RPViewController
@synthesize numPage;

-(void) viewWillDisappear:(BOOL)animated{
    [[self delegate] RPViewControllerDidFinish:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _webView.delegate = self;
    self.view.backgroundColor = [UIColor grayColor];
    //[self loadDataFromHtml:nil];
//    NSURL *url = [NSURL URLWithString:@"http://ereydaysexy.tumblr.com/post/69045795593"];
//    NSString *webData= [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
//    NSLog(@"%@",webData);
//    NSDictionary * website = (NSDictionary*) webData;
//    NSLog(@"Website attempt: %@", website);
    
//    NSString *fullURL = @"http://www.reddit.com/r/yogapants";
//    NSURL *thing = [NSURL URLWithString:fullURL];
//    NSURLRequest *requestObj = [NSURLRequest requestWithURL:thing];
//    [_webView loadRequest:requestObj];
//    UIScrollView *scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, 350, 150)];
//    scrollview.showsVerticalScrollIndicator=YES;
//    scrollview.scrollEnabled=YES;
//    scrollview.userInteractionEnabled=YES;
//    scrollview.contentSize = CGSizeMake(350,150);
//    scrollview.backgroundColor = [UIColor grayColor];
//    [self.view addSubview:scrollview];
//    [scrollview addSubview:_pic];
//
    self.navigationItem.title = _subReddit;
    self.navigationItem.backBarButtonItem.title = @"Subreddits";
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;

//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    UISwipeGestureRecognizer *mSwipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSomething:)];
    
    [mSwipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [[self view] addGestureRecognizer:mSwipeLeftRecognizer];
    UISwipeGestureRecognizer *mSwipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSomething:)];
    mSwipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSomething:)];
    [mSwipeRightRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:mSwipeRightRecognizer];
    
    [_webView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:mSwipeRightRecognizer];
    [_webView.scrollView.panGestureRecognizer requireGestureRecognizerToFail:mSwipeLeftRecognizer];

	// Do any additional setup after loading the view, typically from a nib.
    // 1
    [_busy setHidesWhenStopped: YES];
    [_busy startAnimating];
    NSString *subUrl = [NSString stringWithFormat:@"%@/r/%@/.json?limit=100&", BaseURLString, _subReddit];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:subUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary * tempDict = (NSDictionary *)responseObject;
        _response = tempDict[@"data"];
        //NSLog(@"single reponse, %@", [[[_response objectForKey:@"data"]objectForKey:@"children"]objectAtIndex:0]);
        //NSLog(@"again single reponse, %@", tempDict[@"data"][@"children"][0][@"data"]);
        
        [self loadPicture:numPage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
//    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
//    doubleTapRecognizer.numberOfTapsRequired = 2;
//    doubleTapRecognizer.numberOfTouchesRequired = 1;
//    [self.scrollWindow addGestureRecognizer:doubleTapRecognizer];
//    
//    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
//    twoFingerTapRecognizer.numberOfTapsRequired = 1;
//    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
//    [self.scrollWindow addGestureRecognizer:twoFingerTapRecognizer];
}



- (IBAction)doSomething:(UISwipeGestureRecognizer *)recognizer{
    NSLog(@"%i",numPage);
    //[self loadPicture:numPage];
    //numPage++;
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"LEFT");
        numPage++;
        [_busy startAnimating];
        [self loadPicture:numPage];
        
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"Right");
        if(numPage > 0)
        {
            [_busy startAnimating];
            numPage--;
            [self loadPicture:numPage];

        }
        
    }

}

- (void)loadPicture:(int)num{

    NSDictionary * tempDict = _response[@"children"][num][@"data"];
    _picTitle.text = tempDict[@"title"];
    //self.navigationController.title = tempDict[@"title"];

    NSLog(@"Huh: %@",tempDict);

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:tempDict[@"url"]]];
    if([[request.URL.absoluteString substringFromIndex:[request.URL.absoluteString length]-3] isEqualToString:@"gif"])
    {
        [_webView setHidden:NO];
        [_webView loadRequest:request];
        [_busy stopAnimating];
    }
    else if([[request.URL.absoluteString substringWithRange:NSMakeRange(7, 11)] isEqualToString:@"imgur.com/a"])
    {
        [_webView setHidden:NO];
        [_webView loadRequest:request];
        [_busy stopAnimating];
    }
    else if([[request.URL.absoluteString substringWithRange:NSMakeRange(7, 11)] isEqualToString:@"imgur.com/g"])
    {
        [_webView setHidden:NO];
        [_webView loadRequest:request];
        [_busy stopAnimating];
    }
    else{
        typeof(self) __weak weakSelf = self;

        [_pic setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
            typeof(weakSelf) __strong strongSelf = weakSelf;

            NSLog(@"Success!!!!!");
            [strongSelf.pic setImage:image];
            [strongSelf.webView setHidden:YES];
            [strongSelf.busy stopAnimating];
//        strongSelf.pic = [[UIImageView alloc] initWithImage:image];
//        strongSelf.pic.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
//        [strongSelf.scrollWindow addSubview:strongSelf.pic];
//        strongSelf.scrollWindow.contentSize = image.size;
//        CGRect scrollViewFrame = strongSelf.scrollWindow.frame;
//        CGFloat scaleWidth = scrollViewFrame.size.width / strongSelf.scrollWindow.contentSize.width;
//        CGFloat scaleHeight = scrollViewFrame.size.height / strongSelf.scrollWindow.contentSize.height;
//        CGFloat minScale = MIN(scaleWidth, scaleHeight);
//        strongSelf.scrollWindow.minimumZoomScale = minScale;
//        
//        // 5
//        strongSelf.scrollWindow.maximumZoomScale = 1.0f;
//        strongSelf.scrollWindow.zoomScale = minScale;
//        
//        // 6
//        [strongSelf centerScrollViewContents];
        


        ;}
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
            typeof(weakSelf) __strong strongSelf = weakSelf;
            NSLog(@"First image fail html");

            NSString *possibleImgurLink = request.URL.absoluteString;
            if([possibleImgurLink rangeOfString:@"imgur"].length != 0)
            {
                NSLog(@"Trying IMGUR link");
                possibleImgurLink = [possibleImgurLink stringByAppendingString:@".jpg"];
                NSLog(@"The imgur link is: %@", possibleImgurLink);
                NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:possibleImgurLink]];
                [strongSelf.pic setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                    typeof(weakSelf) __strong strongSelf = weakSelf;

                    NSLog(@"Success!!!!!");
                    [strongSelf.pic setImage:image];
                    [strongSelf.webView setHidden:YES];
                    [strongSelf.busy stopAnimating];

                    ;} failure:NULL];
                
            }

            else{
                [strongSelf.webView loadRequest:request];
                [strongSelf.webView setHidden:NO];
                [strongSelf.busy stopAnimating];
            }
     
     
     
        }];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"WebvieFinishedLoading");
    //[_webView setHidden:NO];
    //[_busy stopAnimating];


}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webview load failed");
}
- (IBAction)goBack:(id)sender {
}

- (IBAction)goNext:(id)sender {
}

- (NSString*)loadDataFromHtml:(NSURLRequest*)urlrequest {
    //NSURL *url = [NSURL URLWithString:@"http://imgur.com/QEVf3xF"];
    NSData *data = [NSData dataWithContentsOfURL:urlrequest.URL];
    
    TFHpple *parser = [TFHpple hppleWithHTMLData:data];
    
    //NSString *XpathQueryStringTitle = @"//div[@id='image']/div/img";
    NSString *XpathQueryStringTitle = @"//meta[@property='og:image']";
    

    NSArray *nodes = [parser searchWithXPathQuery:XpathQueryStringTitle];
    
    NSString *src;
    //NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (TFHppleElement *element in nodes) {
//        HtmlData *htmlData = [[HtmlData alloc]init];
//        [dataArray addObject:htmlData];
//        htmlData.title = [[element firstChild]content];
//        htmlTitle = htmlData.title;
//        htmlTitle = [htmlTitle substringToIndex:6];
//        htmlTitle = [htmlTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
        //src = [element objectForKey:@"src"];
        src = [element objectForKey:@"content"];
    }
//    if(src == NULL)
//    {
//        NSLog(@"SRC was null");
//        XpathQueryStringTitle = @"//div[@id='image']/div[@class]/a";
//        nodes = [parser searchWithXPathQuery:XpathQueryStringTitle];
//        NSLog(@"nodes:%@", nodes);
//        for (TFHppleElement *element in nodes){
//            
//            
//            src = [element objectForKey:@"href"];
//            src = [src substringFromIndex:2];
//           NSLog(@"src: %@",src);
//        }
//        return src;
//    }
    return src;
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.scrollWindow.bounds.size;
    CGRect contentsFrame = self.pic.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.pic.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:self.pic];
    
    // 2
    CGFloat newZoomScale = self.scrollWindow.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollWindow.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.scrollWindow.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.scrollWindow zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer {
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollWindow.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollWindow.minimumZoomScale);
    [self.scrollWindow setZoomScale:newZoomScale animated:YES];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    // Return the view that you want to zoom
    return self.pic;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
