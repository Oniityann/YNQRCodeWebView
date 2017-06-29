//
//  ViewController.m
//  YNQRCodeWebViewDemo
//
//  Created by 郑一楠 on 2017/6/29.
//  Copyright © 2017年 zyn. All rights reserved.
//

#import "ViewController.h"
#import "YNQRCodeWebView.h"

@interface ViewController ()

@property (strong, nonatomic) YNQRCodeWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    http://api.8kana.com/androidsociety/content?id=12452
    self.webView = [[YNQRCodeWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.8kana.com/androidsociety/content?id=12452&width=%d", (int)(self.webView.frame.size.width - 7)]]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
