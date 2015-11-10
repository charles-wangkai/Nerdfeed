//
//  CoursesViewController.m
//  Nerdfeed
//
//  Created by WangKai on 9/29/15.
//  Copyright © 2015 Big Nerd Ranch. All rights reserved.
//

#import "CoursesViewController.h"
#import "WebViewController.h"

@interface CoursesViewController () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, copy) NSArray *courses;

@end

@implementation CoursesViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.navigationItem.title = @"BNR Courses";
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        [self fetchFeed];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.courses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSDictionary *course = self.courses[indexPath.row];
    cell.textLabel.text = course[@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *course = self.courses[indexPath.row];
    NSURL *URL = [NSURL URLWithString:course[@"url"]];
    
    self.webViewController.title = course[@"title"];
    self.webViewController.URL = URL;
    
    if (!self.splitViewController) {
        [self.navigationController pushViewController:self.webViewController animated:YES];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLCredential *cred = [NSURLCredential credentialWithUser:@"BigNerdRanch" password:@"AchieveNerdvana" persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, cred);
}

- (void)fetchFeed {
    NSString *requestString = @"https://bookapi.bignerdranch.com/private/courses.json";
    NSURL *url = [NSURL URLWithString:requestString];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        self.courses = jsonObject[@"courses"];
        
        NSLog(@"%@", self.courses);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [dataTask resume];
}

@end
