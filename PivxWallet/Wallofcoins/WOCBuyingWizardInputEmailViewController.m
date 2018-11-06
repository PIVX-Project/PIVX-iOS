//
//  WOCBuyingWizardInputEmailViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCBuyingWizardInputEmailViewController.h"
#import "WOCBuyingWizardInputPhoneNumberViewController.h"
#import "WOCAlertController.h"
#import "WOCConstants.h"

@interface WOCBuyingWizardInputEmailViewController ()

@end

@implementation WOCBuyingWizardInputEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShadowOnButton:self.nextButton];
    [self.doNotSendEmailButton setTitleColor:WOCTHEMECOLOR forState:UIControlStateNormal];
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

- (IBAction)onDoNotSendMeEmailButtonClicked:(id)sender {
    WOCBuyingWizardInputPhoneNumberViewController *inputPhoneNumberViewController = [self getViewController:@"WOCBuyingWizardInputPhoneNumberViewController"];
    inputPhoneNumberViewController.offerId = self.offerId;
    inputPhoneNumberViewController.emailId = @"";
    [self pushViewController:inputPhoneNumberViewController animated:YES];
}

- (IBAction)onNextButtonClicked:(id)sender {
    
    NSString *emailStr = [self.emailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([emailStr length] == 0) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Alert" message:@"Enter email." viewController:self.navigationController.visibleViewController];
    }
    else if (![self validateEmailWithString:emailStr]) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Alert" message:@"Enter valid email." viewController:self.navigationController.visibleViewController];
    }
    else {

        WOCBuyingWizardInputPhoneNumberViewController *inputPhoneNumberViewController = [self getViewController:@"WOCBuyingWizardInputPhoneNumberViewController"];
        inputPhoneNumberViewController.offerId = self.offerId;
        inputPhoneNumberViewController.emailId = emailStr;
        [self pushViewController:inputPhoneNumberViewController animated:YES];
    }
}

@end

