//
//  WOCHoldIssueViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 21/02/18.
//  Copyright © 2018 Aaron Voisine. All rights reserved.
//

#import "WOCHoldIssueViewController.h"

@interface WOCHoldIssueViewController ()

@end

@implementation WOCHoldIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openSite:(NSURL*)url {
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            APILog(@"URL opened...");
        }];
    }
}

// MARK: - IBAction
- (IBAction)onSignInButtonClick:(id)sender {
    if (self.phoneNo != nil) {
        [self openSite:[NSURL URLWithString:[NSString stringWithFormat:@"https://wallofcoins.com/signin/%@/",self.phoneNo]]];
    }
}

@end
