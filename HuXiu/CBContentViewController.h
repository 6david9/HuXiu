//
//  CBContentViewController.h
//  HuXiu
//
//  Created by ly on 13-6-29.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import "CBViewController.h"

@interface CBContentViewController : CBViewController <UIWebViewDelegate>


@property (strong, nonatomic) NSURL *requestURL;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
