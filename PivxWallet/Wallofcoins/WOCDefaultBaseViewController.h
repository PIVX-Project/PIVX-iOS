//
//  WOCBaseViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 27/02/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCConstants.h"
#import "BRAppDelegate.h"
#import "BRRootViewController.h"
#import "MBProgressHUD.h"
#import "APIManager.h"
#import "WOCAlertController.h"

@interface WOCDefaultBaseViewController : UIViewController

@property (strong, nonatomic) NSUserDefaults *defaults;
@property (assign, nonatomic) BOOL isBackButtonRequire;

+ (instancetype) sharedInstance;

- (void)back;
- (void)backToRoot;
- (void)backToMainView;
- (void)push:(NSString*)viewControllerStr ;
- (void)clearLocalStorage;

- (id)getViewController:(NSString*)viewControllerStr;
- (void)pushViewControllerStr:(NSString*)viewControllerStr;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

- (NSString*)getCryptoPrice:(NSNumber*)number;

- (IBAction)onBackButtonClick:(id)sender;
- (IBAction)onSignOutButtonClick:(id)sender;
- (IBAction)onBackToMainViewButtonClick:(id)sender;
- (BOOL)isValidEmail:(NSString *)checkString;
- (void)setShadowOnView:(UIView *)view;
- (void)setShadowOnButton:(UIButton *)button;
- (void)setButtonColor: (UIButton *)button;

@end
