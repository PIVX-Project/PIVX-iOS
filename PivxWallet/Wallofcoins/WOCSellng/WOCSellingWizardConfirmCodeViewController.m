//
//  WOCSellingWizardConfirmCodeViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingWizardConfirmCodeViewController.h"
#import "WOCSellingAdsInstructionsViewController.h"
#import "WOCSellingSummaryViewController.h"
#import "APIManager.h"
#import "WOCConstants.h"
#import "WOCAlertController.h"
#import "BRRootViewController.h"
#import "BRAppDelegate.h"
#import "MBProgressHUD.h"

@interface WOCSellingWizardConfirmCodeViewController () <UITextFieldDelegate>

@end

@implementation WOCSellingWizardConfirmCodeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setShadowOnButton:self.confirmVarificationCodeButton];
    
    NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
    
    self.descriptionLabel.text = [NSString stringWithFormat:@"The Mobile phone %@ will receive a verification code within 10 seconds.When you receive the code, input it below.",phoneNo];
    if (self.purchaseCode != nil) {
        self.confirmCodeTextfield.text = REMOVE_NULL_VALUE(self.purchaseCode);
    } else {
        self.confirmCodeTextfield.text = @"";
    }
    self.confirmCodeTextfield.delegate = self;
    [self.confirmCodeTextfield becomeFirstResponder] ;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField.text.length == 4 && string.length == 1)
    {
        [self performSelector:@selector(onConfirmVarificationCodeClicked:) withObject:self afterDelay:1.0];
    }
    return YES;
}

// MARK: - IBAction

- (IBAction)onConfirmVarificationCodeClicked:(id)sender {
    
    NSString *txtCode = [self.confirmCodeTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([txtCode length] == 5) {
    
        NSString *emailAddress = REMOVE_NULL_VALUE([self.defaults objectForKey:WOCUserDefaultsLocalEmail]);
        NSString *bankAccountInfo = REMOVE_NULL_VALUE([self.defaults objectForKey:WOCUserDefaultsLocalBankInfo]);
        NSString *bankAccountID = REMOVE_NULL_VALUE([self.defaults objectForKey:WOCUserDefaultsLocalBankAccount]);
        NSString *bankAccount = REMOVE_NULL_VALUE([self.defaults objectForKey:WOCUserDefaultsLocalBankAccountNumber]);
        NSString *bankName = REMOVE_NULL_VALUE([self.defaults objectForKey:WOCUserDefaultsLocalBankName]);
        NSString *currentPrice = REMOVE_NULL_VALUE([self.defaults objectForKey:WOCUserDefaultsLocalPrice]);
        NSString *deviceCode = REMOVE_NULL_VALUE([self.defaults valueForKey:WOCUserDefaultsLocalDeviceCode]);
        NSString *deviceId = REMOVE_NULL_VALUE([self.defaults valueForKey:WOCUserDefaultsLocalDeviceId]);
        NSString *token = REMOVE_NULL_VALUE([self.defaults valueForKey:WOCUserDefaultsAuthToken]);
        NSString *phoneNumber = REMOVE_NULL_VALUE([self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber]);
        NSString *phoneCode = REMOVE_NULL_VALUE([self.defaults valueForKey:WOCUserDefaultsLocalCountryCode]);
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",phoneCode] withString:@""];
        phoneCode = [phoneCode stringByReplacingOccurrencesOfString:@"+" withString:@""];

        NSDictionary *params = @{
                                 WOCApiBodyDeviceCode: deviceCode
                                 };
        
        if (deviceId != nil) {
            
            params = @{
                       WOCApiBodyPhoneNumber:phoneNumber,
                       WOCApiBodyEmail:emailAddress,
                       @"phoneCode": phoneCode,
                       @"bankBusiness": bankAccountID,
                       @"sellCrypto": WOCCryptoCurrency,
                       @"userEnabled": @"true",
                       @"dynamicPrice": @"false",
                       @"currentPrice": currentPrice,
                       @"name": bankName,
                       @"number":  bankAccount,
                       @"number2": bankAccount,
                       WOCApiBodyDeviceCode: deviceCode,
                       WOCApiBodyDeviceId: deviceId,
                       WOCApiBodyJsonParameter: @"YES"
                       };
            [[APIManager sharedInstance] createAd:params response:^(id responseDict, NSError *error) {
                
                if (error == nil) {
                   
                }
                
                WOCSellingAdsInstructionsViewController *adsInstructionsViewController = [self getViewController:@"WOCSellingAdsInstructionsViewController"];
                adsInstructionsViewController.AdvertiseId = @"90";
                [self pushViewController:adsInstructionsViewController animated:YES];
            }];
        }
    }
    else if ([txtCode length] == 0 ) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:@"Enter Purchase Code" viewController:self.navigationController.visibleViewController];
    }
    else if ([txtCode length] != 5 ) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:@"Enter Valid Purchase Code" viewController:self.navigationController.visibleViewController];
    }
}

@end

