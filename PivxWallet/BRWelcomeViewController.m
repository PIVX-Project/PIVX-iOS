//
//  BRWelcomeViewController.m
//  BreadWallet
//
//  Created by Aaron Voisine on 7/8/13.
//  Copyright (c) 2013 Aaron Voisine <voisine@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "BRWelcomeViewController.h"
#import "BRRootViewController.h"
#import "BRWalletManager.h"
#import "BREventManager.h"
#import "pivxwallet-Swift.h"


@interface BRWelcomeViewController ()

@property (nonatomic, strong) IBOutlet UIButton *newwalletButton, *recoverButton;

@end


@implementation BRWelcomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    self.newwalletButton.titleLabel.adjustsLetterSpacingToFitWidth = YES;
    self.recoverButton.titleLabel.adjustsLetterSpacingToFitWidth = YES;
#pragma clang diagnostic pop

}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(BOOL)prefersStatusBarHidden {
    return FALSE;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIColor *color = [UIColor rgb:85 green:71 blue:108 alpha:1];
    [Utils changeStatusBackgroundColorWithColor:color];
    [self.navigationController setNavigationBarHidden:TRUE animated:true];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [BREventManager saveEvent:@"welcome:shown"];

    dispatch_async(dispatch_get_main_queue(), ^{ // animation sometimes doesn't work if run directly in viewDidAppear
#if SNAPSHOT
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.navigationItem.titleView.hidden = NO;
        self.navigationItem.titleView.alpha = 1.0;
        return;
#endif

        if (! [BRWalletManager sharedInstance].noWallet) { // sanity check
            [self.navigationController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
    });
}

// MARK: IBAction

- (IBAction)start:(id)sender
{
    [BREventManager saveEvent:@"welcome:new_wallet"];
    
    UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"GenerateViewController"];
    
    [self.navigationController pushViewController:c animated:YES];
}

- (IBAction)recover:(id)sender
{
    [BREventManager saveEvent:@"welcome:recover_wallet"];

    UIViewController *c = [self.storyboard instantiateViewControllerWithIdentifier:@"RecoverViewController"];

    [self.navigationController pushViewController:c animated:YES];
}

@end
