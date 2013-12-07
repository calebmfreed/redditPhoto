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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self loadDataFromHtml:nil];
//    NSURL *url = [NSURL URLWithString:@"http://ereydaysexy.tumblr.com/post/69045795593"];
//    NSString *webData= [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
//    NSLog(@"%@",webData);
//    NSDictionary * website = (NSDictionary*) webData;
//    NSLog(@"Website attempt: %@", website);
    
    NSString *fullURL = @"http://www.reddit.com/r/yogapants";
    NSURL *thing = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:thing];
    [_webView loadRequest:requestObj];
    
    UISwipeGestureRecognizer *mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSomething:)];
    
    [mSwipeUpRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
    
    mSwipeUpRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(doSomething:)];
    [mSwipeUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:mSwipeUpRecognizer];
	// Do any additional setup after loading the view, typically from a nib.
    // 1
    NSString *subUrl = [NSString stringWithFormat:@"%@/r/yogapants/.json?limit=100&", BaseURLString];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:subUrl  parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSDictionary * tempDict = (NSDictionary *)responseObject;
        _response = tempDict[@"data"];
        //NSLog(@"single reponse, %@", [[[_response objectForKey:@"data"]objectForKey:@"children"]objectAtIndex:0]);
        //NSLog(@"again single reponse, %@", tempDict[@"data"][@"children"][0][@"data"]);
        numPage = 0;
        [self loadPicture:numPage];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}



- (IBAction)doSomething:(UISwipeGestureRecognizer *)recognizer{
    NSLog(@"%i",numPage);
    //[self loadPicture:numPage];
    //numPage++;
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"LEFT");
        numPage++;
        [self loadPicture:numPage];
        
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"Right");
        if(numPage > 1)
        {
            numPage--;
            [self loadPicture:numPage];

        }
        
    }

}

- (void)loadPicture:(int)num{
    NSDictionary * tempDict = _response[@"children"][num][@"data"];
    NSLog(@"Huh: %@",tempDict);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:tempDict[@"url"]]];
    [_pic setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
        NSLog(@"Success!!!!!");
        [_pic setImage:image];
        ;}
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
            NSString *temp = [self loadDataFromHtml:request];
            NSLog(@"%@", [temp substringFromIndex:2]);
            NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:temp]];
            [_pic setImageWithURLRequest:request2 placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
                NSLog(@"Success!!!!!");
                [_pic setImage:image];
                [_webView loadRequest:request];
                ;}
                                 failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
                                     NSLog(@"Wasn't tumbler");
                                 }
             
             
             
             ];
        }
     
     
     
     ];
    [_webView loadRequest:request];
}

- (IBAction)goBack:(id)sender {
}

- (IBAction)goNext:(id)sender {
}

- (NSString*)loadDataFromHtml:(NSURLRequest*)urlrequest {
    //NSURL *url = [NSURL URLWithString:@"http://ereydaysexy.tumblr.com/post/69045795593"];
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

        NSLog(@"%@",[element objectForKey:@"content"]);
        //src = [element objectForKey:@"src"];
        src = [element objectForKey:@"content"];
    }
    return src;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
