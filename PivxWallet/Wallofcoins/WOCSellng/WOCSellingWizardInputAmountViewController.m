//
//  WOCSellingWizardInputAmountViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingWizardInputAmountViewController.h"
#import "WOCSellingWizardOfferListViewController.h"
#import "WOCConstants.h"
#import "APIManager.h"
#import "WOCLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "BRWalletManager.h"
#import "WOCAlertController.h"
#import "BRAppDelegate.h"
#import "WOCSellingVerifyDetailViewController.h"
#import "WOCSellingAdvancedOptionsInstructionsViewController.h"

static const int dashTextField = 101;
static const int dollarTextField = 102;

//#define dashTextField 101
//#define dollarTextField 102

@interface WOCSellingWizardInputAmountViewController () <UITextFieldDelegate>

@end

@implementation WOCSellingWizardInputAmountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShadowOnButton:self.getOffersButton];
    self.titleLabel.text = [NSString stringWithFormat:@"How much do you want per %@?",WOCCurrency];
    self.dashTextfield.text = @"Price Per Coin";
    self.dashTextfield.delegate = self;
    self.dollarTextfield.delegate = self;
    self.dashTextfield.userInteractionEnabled = NO;
    self.line1Height.constant = 1;
    self.line2HeightConstant.constant = 2;
    [self.dollarTextfield becomeFirstResponder];
}

// MARK: - IBAction

- (IBAction)getOffersButtonClick:(id)sender {
    
    NSString *dollarString = [self.dollarTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([dollarString length] > 0 && [dollarString intValue] != 0) {
        
        if ([dollarString intValue] <10000000) {
            
            [self loadVarificationScreen];
            
        }
        else {
            [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Amount must be less than $100000." viewController:self.navigationController.visibleViewController];
        }
    }
    else {
        [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Enter amount." viewController:self.navigationController.visibleViewController];
    }
}

// MARK: - API
- (void)sendUserData:(NSString*)amount zipCode:(NSString*)zipCode bankId:(NSString*)bankId {
    
    if (self.dashTextfield != nil) {
        [self.dashTextfield resignFirstResponder];
    }
    
    if (self.dollarTextfield != nil) {
        [self.dollarTextfield resignFirstResponder];
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
                WOCSellingWizardOfferListViewController *offerListViewController = (WOCSellingWizardOfferListViewController*)[self getViewController:@"WOCSellingWizardOfferListViewController"];;
                offerListViewController.discoveryId = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"id"]];
                offerListViewController.amount = self.dollarTextfield.text;
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


- (void)loadVarificationScreen {
    
    [self.defaults setObject:self.dollarTextfield.text forKey:WOCUserDefaultsLocalPrice];
    [self.defaults synchronize];
    
    [self.defaults setBool:YES forKey:@"isBeforeCreateAd"];
    [self.defaults synchronize];
    
    WOCSellingAdvancedOptionsInstructionsViewController *sellingAdvancedOptionsInstructionsViewController = [self getViewController:@"WOCSellingAdvancedOptionsInstructionsViewController"];
    [self pushViewController:sellingAdvancedOptionsInstructionsViewController animated:YES];
    [sellingAdvancedOptionsInstructionsViewController setupUI];
}

// MARK: - UITextField Delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField.tag == dashTextField) {
        self.line1Height.constant = 2;
        self.line2HeightConstant.constant = 1;
    }
    else {
        self.line1Height.constant = 1;
        self.line2HeightConstant.constant = 2;
    }
}

@end

