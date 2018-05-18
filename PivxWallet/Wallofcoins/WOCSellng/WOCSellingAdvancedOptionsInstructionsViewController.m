//
//  WOCSellingAdvancedOptionsInstructionsViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingAdvancedOptionsInstructionsViewController.h"
#import "WOCSellingVerifyDetailViewController.h"
#import "WOCSellingAdsInstructionsViewController.h"

@interface WOCSellingAdvancedOptionsInstructionsViewController ()

@end

@implementation WOCSellingAdvancedOptionsInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShadowOnButton:self.saveButton];
    
    NSString *minDeposit = [self.defaults objectForKey:WOCUserDefaultsLocalMinDeposit];
    if (minDeposit != nil && minDeposit.length > 0){
        self.minLimitTextfield.text = minDeposit;
    }
    
    NSString *maxDeposit = [self.defaults objectForKey:WOCUserDefaultsLocalMaxDeposit];
    if (maxDeposit != nil && maxDeposit.length > 0){
        self.maxLimitTextfield.text = maxDeposit;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self setupUI];
}

- (void)setupUI {
    
    self.isBeforeCreateAd = [self.defaults boolForKey:@"isBeforeCreateAd"];
    if (self.isBeforeCreateAd == YES) {
        [self.saveButton setTitle:@"NEXT" forState:UIControlStateNormal];
    }
    else {
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    }
}

// MARK: - IBAction
- (IBAction)onSaveButtonClick:(id)sender {
    
    if ([self.minLimitTextfield.text length] == 0) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Alert" message:@"Enter minimum deposit limit." viewController:self.navigationController.visibleViewController];
    }
    else if ([self.maxLimitTextfield.text length] == 0) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Alert" message:@"Enter maximum deposit limit." viewController:self.navigationController.visibleViewController];
    }
    else {
        
        [self.defaults setObject:self.minLimitTextfield.text forKey:WOCUserDefaultsLocalMinDeposit];
        [self.defaults synchronize];
        
        [self.defaults setObject:self.maxLimitTextfield.text forKey:WOCUserDefaultsLocalMaxDeposit];
        [self.defaults synchronize];
        
        if (self.isBeforeCreateAd) {
            [self loadVarificationScreen];
        }
        else {
            WOCSellingAdsInstructionsViewController *myViewController = [self getViewController:@"WOCSellingAdsInstructionsViewController"];
            [self pushViewController:myViewController animated:YES];
        }
    }
}

- (void)loadVarificationScreen {
    WOCSellingVerifyDetailViewController *verifyDetailViewController = (WOCSellingVerifyDetailViewController*)[self getViewController:@"WOCSellingVerifyDetailViewController"];
    [self pushViewController:verifyDetailViewController animated:YES];
}
@end

