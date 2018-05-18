//
//  WOCBuyingWizardInputEmailViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingWizardInputEmailViewController.h"
#import "WOCSellingWizardInputPhoineNumberViewController.h"
#import "WOCAlertController.h"
#import "WOCConstants.h"
#import "WOCSellingWizardPaymentCenterViewController.h"

@interface WOCSellingWizardInputEmailViewController ()

@end

@implementation WOCSellingWizardInputEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShadowOnButton:self.nextButton];
    
    if ([self.defaults objectForKey:WOCUserDefaultsLocalEmail] != nil) {
        NSString *emailStr = [self.defaults objectForKey:WOCUserDefaultsLocalEmail];
        self.emailTextField.text = emailStr;
    }
}

- (BOOL)validateEmailWithString:(NSString*)checkString {
    
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

// MARK: - IBAction

- (IBAction)onDoNotSendMeEmailButtonClick:(id)sender {
    
    [self.defaults removeObjectForKey:WOCUserDefaultsLocalEmail];
    
    WOCSellingWizardPaymentCenterViewController *paymentCenterViewController = [self getViewController:@"WOCSellingWizardPaymentCenterViewController"];
    [self pushViewController:paymentCenterViewController animated:YES];
}

- (IBAction)onNextButtonClick:(id)sender {
    
    NSString *emailStr = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([emailStr length] == 0) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Alert" message:@"Enter email." viewController:self.navigationController.visibleViewController];
    }
    else if (![self validateEmailWithString:emailStr]) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Alert" message:@"Enter valid email." viewController:self.navigationController.visibleViewController];
    }
    else {

        [self.defaults setObject:emailStr forKey:WOCUserDefaultsLocalEmail];
        WOCSellingWizardPaymentCenterViewController *paymentCenterViewController = [self getViewController:@"WOCSellingWizardPaymentCenterViewController"];
        [self pushViewController:paymentCenterViewController animated:YES];
    }
}
@end

