//
//  WOCSellingVerifyDetailViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingAdsInstructionsViewController.h"
#import "WOCSellingAdvancedOptionsInstructionsViewController.h"
#import "BRAppDelegate.h"
#import "APIManager.h"
#import "WOCConstants.h"


@interface WOCSellingAdsInstructionsViewController ()

@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *purchaseCode;
@property (strong, nonatomic) NSString *holdId;
@property (strong, nonatomic) NSString *deviceName;
@end

@implementation WOCSellingAdsInstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShadowOnButton:self.editYourCurrentRateButton];
    
    if (self.accountInformation != nil && self.accountInformation.length > 0) {
        self.bankNameTextfield.text = self.accountInformation;
    }
    
//    if (self.currentPrice != nil && self.currentPrice.length > 0){
//        self.txtCurrentPrice.text = self.currentPrice;
//    }
    
    self.availableCryptoTextfield.text = [NSString stringWithFormat:@"%@ 0.000",WOCCurrencySymbol];
    
    NSString *emailAddress = [self.defaults objectForKey:WOCUserDefaultsLocalEmail];
    if (emailAddress != nil && emailAddress.length > 0) {
        self.txtEmail.text = emailAddress;
    }
    
    NSString *bankAccountInfo = [self.defaults objectForKey:WOCUserDefaultsLocalBankInfo];
    if (bankAccountInfo != nil && bankAccountInfo.length > 0) {
        self.bankNameTextfield.text = bankAccountInfo;
    }
    
    NSString *bankAccount = [self.defaults objectForKey:WOCUserDefaultsLocalBankAccountNumber];
    if (bankAccount != nil && bankAccount.length > 0) {
        self.accountNumberTextfield.text = bankAccount;
    }
    
    NSString *bankName = [self.defaults objectForKey:WOCUserDefaultsLocalBankName];
    if (bankName != nil && bankName.length > 0) {
        self.accountNameTextfield.text = bankName;
    }
    
    NSString *currentPrice = [self.defaults objectForKey:WOCUserDefaultsLocalPrice];
    if (currentPrice != nil && currentPrice.length > 0) {
        self.currentPriceTextfield.text = [NSString stringWithFormat:@"$ %@",currentPrice];
    }
    self.accountNumberTextfield.userInteractionEnabled = NO;
    self.accountNameTextfield.userInteractionEnabled = NO;
    self.bankNameTextfield.userInteractionEnabled = NO;
    self.availableCryptoTextfield.userInteractionEnabled = NO;
    self.currentPriceTextfield.userInteractionEnabled = NO;
    self.txtEmail.userInteractionEnabled = NO;
    [self loadAdData];
}

- (void)loadAdData
{
    if (self.AdvertiseId != nil && self.AdvertiseId.length > 0) {
        [[APIManager sharedInstance] getDetailFromADId:self.AdvertiseId  response:^(id responseDict, NSError *error) {
            APILog(@"responseDict = %@",responseDict);
            
            self.bankNameTextfield.text = self.accountInformation;
            self.availableCryptoTextfield.text = [NSString stringWithFormat:@"%@ 0.000",WOCCurrencySymbol];
            
            //self.txtEmail.text = REMOVE_NULL_VALUE(responseDict[@""]);
            self.bankNameTextfield.text = REMOVE_NULL_VALUE(responseDict[@""]);
            self.accountNumberTextfield.text = REMOVE_NULL_VALUE(responseDict[@""]);
            self.accountNameTextfield.text = REMOVE_NULL_VALUE(responseDict[@""]);
            self.currentPriceTextfield.text = [NSString stringWithFormat:@"$ %@",REMOVE_NULL_VALUE(responseDict[@"currentPrice"])];
           
            /*
             balance = "0.00000000";
             buyCurrency = USD;
             currentPrice = "1.20";
             dynamicPrice = 0;
             fundingAddress = "(Not Available - Needs Verification)";
             id = 90;
             maxPayment = 0;
             minPayment = 0;
             onHold = "0.00000000";
             primaryMarket = "<null>";
             publicBalance = "0.00000000";
             published = 0;
             secondaryMarket = "<null>";
             sellCrypto = DASH;
             sellerFee = "<null>";
             userEnabled = 1;
             verified = 0;
             */
        }];
    }
}

- (IBAction)onAdvancedOptionsButtonClick:(id)sender
{
    [self.defaults setBool:NO forKey:@"isBeforeCreateAd"];
    [self.defaults synchronize];
    
    WOCSellingAdvancedOptionsInstructionsViewController *sellingAdvancedOptionsInstructionsViewController = [self getViewController:@"WOCSellingAdvancedOptionsInstructionsViewController"];
    [self pushViewController:sellingAdvancedOptionsInstructionsViewController animated:YES];
    [sellingAdvancedOptionsInstructionsViewController setupUI];
}

- (IBAction)onEditYourCurrentRateButtonClick:(UIButton *)sender {
    APILog(@"Edit Your current rate button clicked");
}

- (IBAction)backToHomeScreenAction:(id)sender {
    [self backToMainView];
}

@end

