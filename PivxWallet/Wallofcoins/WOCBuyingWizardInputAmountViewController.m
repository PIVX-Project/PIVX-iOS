//
//  WOCBuyingWizardInputAmountViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCBuyingWizardInputAmountViewController.h"
#import "WOCBuyingWizardOfferListViewController.h"
#import "WOCConstants.h"
#import "APIManager.h"
#import "WOCLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "BRWalletManager.h"
#import "WOCAlertController.h"
#import "BRAppDelegate.h"


static const int dashTextFieldTag = 101;
static const int dollarTextFieldTag = 102;

@interface WOCBuyingWizardInputAmountViewController () <UITextFieldDelegate>

@end

@implementation WOCBuyingWizardInputAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setShadowOnButton:self.offerButton];
    self.dashTextField.text = [NSString stringWithFormat:@"to acquire %@ (%@) (1,000,000 %@ = 1 %@)",WOCCurrency,WOCCurrencySymbol,WOCCurrencyMinorSpecial,WOCCurrencySpecial];
    self.dashTextField.delegate = self;
    self.dollarTextField.delegate = self;
    [self.dashTextField setUserInteractionEnabled:NO];
    self.line1HeightConstant.constant = 1;
    self.line2HeightConstant.constant = 2;
    [self.dollarTextField becomeFirstResponder];
}

// MARK: - IBAction

- (IBAction)onGetOffersButtonClick:(id)sender {
    
    NSString *dollarString = [self.dollarTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([dollarString length] > 0 && [dollarString intValue] != 0) {
        if ([dollarString intValue] >= 5) {
            if ([dollarString intValue] <10000000) {
                if ((self.zipCode != nil && [self.zipCode length] > 0) || (self.bankId != nil && [self.bankId length] > 0)) {
                    if ([self.bankId length] > 0) {
                        [self sendUserData:dollarString zipCode:@"" bankId:self.bankId];
                    }
                    else if ([self.zipCode length] > 0) {
                        [self sendUserData:dollarString zipCode:self.zipCode bankId:@""];
                    }
                }
                else {
                    [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"zipCode or bankId is empty." viewController:self.navigationController.visibleViewController];
                }
            }
            else {
                [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Amount must be less than $100000." viewController:self.navigationController.visibleViewController];
            }
        }
        else {
            [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Amount must be more than $5." viewController:self.navigationController.visibleViewController];
        }
    }
    else {
        [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Enter amount." viewController:self.navigationController.visibleViewController];
    }
}

// MARK: - API
- (void)sendUserData:(NSString*)amount zipCode:(NSString*)zipCode bankId:(NSString*)bankId {
    
    if (self.dashTextField != nil) {
        [self.dashTextField resignFirstResponder];
    }
    if (self.dollarTextField != nil) {
        [self.dollarTextField resignFirstResponder];
    }
    
    BRWalletManager *manager = [BRWalletManager sharedInstance];
    NSString *cryptoAddress = manager.wallet.receiveAddress;
    APILog(@"cryptoAddress = %@",cryptoAddress);
    
    NSDictionary *params = @{
                             WOCApiBodyCryptoAmount: @"0",
                             WOCApiBodyUsdAmount: amount,
                             WOCApiBodyCrypto: WOCCryptoCurrency,
                             WOCApiBodyCryptoAddress:cryptoAddress,
                             WOCApiBodyJsonParameter: @"YES"
                             };
    
    //Receive Crypto Currency Address...
    NSString *latitude = [self.defaults valueForKey:WOCUserDefaultsLocalLocationLatitude];
    NSString *longitude = [self.defaults valueForKey:WOCUserDefaultsLocalLocationLongitude];
    
    if (latitude == nil && longitude == nil) {
        latitude = @"";
        longitude = @"";
    }
   
    if (latitude.length > 0 && longitude.length > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
        [dict setObject:@{WOCApiBodyLatitude:latitude ,
                          WOCApiBodyLongitude:longitude } forKey:WOCApiBodyBrowserLocation];
        params = (NSDictionary*)dict;
    }
    
    if (zipCode != nil && zipCode.length > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
        [dict setObject:zipCode forKey:WOCApiBodyZipCode];
        params = (NSDictionary*)dict;
    }
    
    if (bankId != nil && bankId.length > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
        [dict setObject:bankId forKey:WOCApiBodyBank];
        params = (NSDictionary*)dict;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    
    if (bankId == nil || bankId.length == 0) {
        NSString *countryCodeFromLatLong = [self.defaults objectForKey:WOCApiBodyCountryCode];
        
        if (countryCodeFromLatLong == nil) {
            NSString *countryCode = [[NSLocale currentLocale] objectForKey: NSLocaleCountryCode];
            [dict setObject:countryCode.lowercaseString forKey:WOCApiBodyCountry];
        }
        else {
            [dict setObject:countryCodeFromLatLong.lowercaseString forKey:WOCApiBodyCountry];
        }
    }
    //[dict setObject:@"us" forKey:WOCApiBodyCountry];

    params = (NSDictionary*)dict;
    
    [[APIManager sharedInstance] discoverInfo:params response:^(id responseDict, NSError *error) {
        if (error == nil) {
            NSDictionary *dictionary = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)responseDict];
            
            if ([dictionary valueForKey:@"id"] != nil) {
                WOCBuyingWizardOfferListViewController *offerListViewController = (WOCBuyingWizardOfferListViewController*)[self getViewController:@"WOCBuyingWizardOfferListViewController"];;
                offerListViewController.discoveryId = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"id"]];
                offerListViewController.amount = self.dollarTextField.text;
                [self pushViewController:offerListViewController animated:YES];
            }
            else {
                [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Error in getting offers. Please try after some time." viewController:self.navigationController.visibleViewController];
            }
        }
        else {
            
            [[WOCAlertController sharedInstance] alertshowWithError:error viewController:self.navigationController.visibleViewController];
        }
    }];
}

// MARK: - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == dashTextFieldTag) {
        self.line1HeightConstant.constant = 2;
        self.line2HeightConstant.constant = 1;
    }
    else {
        self.line1HeightConstant.constant = 1;
        self.line2HeightConstant.constant = 2;
    }
}

@end

