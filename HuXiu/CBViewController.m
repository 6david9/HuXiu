//
//  CBViewController.m
//  HuXiu
//
//  Created by ly on 13-6-29.
//  Copyright (c) 2013年 Lei Yan. All rights reserved.
//

#import "CBViewController.h"
#import "CBContentViewController.h"
#import "CBRssParser.h"
#import "CBItem.h"
#import "AFNetworking.h"

#define RssFilePath    PathForXMLResource(@"0")

@interface CBViewController ()

@end

@implementation CBViewController
{
    UIImage *placeHolder;
}

#define ShowAlerViewWithMessage(msg) \
    [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil \
        cancelButtonTitle:NSLocalizedString(@"好", @"OK") otherButtonTitles:nil] show];

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    placeHolder = [UIImage imageNamed:@"1.jpeg"];
    self.title = @"虎嗅";

    [self.activityIndicator startAnimating];
    
//    http://www.huxiu.com/rss/0.xml
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:URLFromString(@"http://www.huxiu.com/")];
    [client getPath:@"rss/0.xml" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *rss = nil;
        if ([responseObject isKindOfClass:[NSData class]]) {
            rss = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        } else {
            rss = (NSString *)responseObject;
        }
        
        CBRssParser *parser = [[CBRssParser alloc] initWithRssFile:rss];
        parser.delegate = self;
        [parser parse];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.activityIndicator stopAnimating];
        
        ShowAlerViewWithMessage( [error description] );
    }];
}

- (void)CBRssParser:(CBRssParser *)parser didParseWithResult:(id)result
{
    _items = result;
    [self.activityIndicator stopAnimating];
    [self.tableview reloadData];
}

#pragma mark - Table data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if ( !cell ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    CBItem *item = self.items[indexPath.row];
    
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.shortDesc;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [cell.imageView setImageWithURL:item.imageURL placeholderImage:placeHolder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBItem *item = [self.items objectAtIndex:indexPath.row];
    
    CBContentViewController *contentViewController = [[CBContentViewController alloc] initWithNibName:@"CBContentViewController" bundle:nil];
    contentViewController.requestURL = item.link;
    [self.navigationController pushViewController:contentViewController animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
