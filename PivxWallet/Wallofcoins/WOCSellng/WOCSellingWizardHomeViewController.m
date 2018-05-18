//
//  WOCSellingWizardHomeViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingWizardHomeViewController.h"
#import "WOCLocationManager.h"
#import "WOCSellingWizardZipCodeViewController.h"
#import "WOCSellingWizardPaymentCenterViewController.h"
#import "WOCSellingWizardInputAmountViewController.h"
#import "WOCConstants.h"
#import "BRAppDelegate.h"
#import "BRRootViewController.h"
#import "MBProgressHUD.h"
#import "APIManager.h"
#import "WOCAlertController.h"
#import "WOCSellingWizardInputEmailViewController.h"
#import "WOCSellingWizardInputPhoineNumberViewController.h"

@interface WOCSellingWizardHomeViewController ()

@property (strong, nonatomic) NSString *zipCode;

@end

@implementation WOCSellingWizardHomeViewController

- (void)viewDidLoad {
    
    self.isBackButtonRequire = YES;
    
    [super viewDidLoad];
    
    [self.defaults removeObjectForKey:WOCUserDefaultsLocalLocationLatitude];
    [self.defaults removeObjectForKey:WOCUserDefaultsLocalLocationLongitude];
    
    [[NSNotificationCenter defaultCenter] removeObserver:WOCNotificationObserverNameBuyDashStep1];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLogoutButton) name:WOCNotificationObserverNameBuyDashStep1 object:nil];
    
    [self.sellYourCryptoButton setTitle:[NSString stringWithFormat:@"SELL YOUR %@",WOCCurrencySpecial] forState:UIControlStateNormal];
    [self setShadowOnButton:self.sellYourCryptoButton];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self setLogoutButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
}

- (void)setLogoutButton {
    
    NSString *token = [self.defaults valueForKey:WOCUserDefaultsAuthToken];
    
    if (token != nil && (![token isEqualToString:@"(null)"])) {
        NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
        NSString *loginPhone = [NSString stringWithFormat:@"Your wallet is signed into Wall of Coins using your mobile number %@",phoneNo];
        self.descriptionLabel.text = loginPhone;
        [self.signOutButton setTitle:@"SIGN OUT" forState:UIControlStateNormal];
        self.signoutView.hidden = NO;
        self.orderListButton.hidden = NO;
    }
    else {
        NSString *loginPhone = [NSString stringWithFormat:@"Do you already have an order?"];
        self.descriptionLabel.text = loginPhone;
        [self.signOutButton setTitle:@"SIGN IN HERE" forState:UIControlStateNormal];
        self.signoutView.hidden = NO;
        self.orderListButton.hidden = YES;
    }
    
    [self setShadowOnButton:self.signOutButton];
    [self setShadowOnButton:self.orderListButton];
}

- (void)back:(id)sender {
    
    [self backToRoot];
}

// MARK: - API
- (void)signOut:(NSString*)phone {
    
    [self signOutWOC];
}

- (IBAction)onOrderListClick:(id)sender {
    
    [self getOrderList];
}

// MARK: - IBAction

- (IBAction)onBackButtonClick:(id)sender {
    APILog(@"onBackButtonClick");
    [self backToRoot];
}

- (IBAction)onSignOutButtonClick:(id)sender {
   
    UIButton * btn = (UIButton*) sender;
    if (btn != nil) {
        if ([btn.titleLabel.text isEqualToString:@"SIGN IN HERE"]) {
            [self push:@"WOCSellingSignInViewController"];
        }
        else {
           [self signOutWOC];
        }
    }
    [self performSelector:@selector(setLogoutButton) withObject:nil afterDelay:1.0];
}

- (IBAction)onSellYourCryptoButtonClick:(id)sender {
    
    [self refereshToken];
    NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
    
    if (phoneNo == nil || phoneNo.length == 0)
    {
        WOCSellingWizardInputPhoineNumberViewController *inputPhoneNumberViewController = [self getViewController:@"WOCSellingWizardInputPhoineNumberViewController"];
        inputPhoneNumberViewController.offerId = @"";
        inputPhoneNumberViewController.emailId = @"";
        [self pushViewController:inputPhoneNumberViewController animated:YES];
    }
    else {
        WOCSellingWizardInputEmailViewController *inputEmailViewController = [self getViewController:@"WOCSellingWizardInputEmailViewController"];
        [self pushViewController:inputEmailViewController animated:YES];
    }
}
@end
