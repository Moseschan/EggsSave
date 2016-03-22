//
//  AboutViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"关于我们";
    
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"about.html" withExtension:nil];
//    NSURL *url = [NSURL URLWithString:@"http://www.brss.cn/mobile"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    
    [self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
