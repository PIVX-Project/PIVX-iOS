//
//  WOCBuyingWizardInputVarificationCodeViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCBuyingWizardInputVarificationCodeViewController.h"
#import "WOCBuyingInstructionsViewController.h"
#import "WOCBuyingSummaryViewController.h"
#import "APIManager.h"
#import "WOCConstants.h"
#import "WOCAlertController.h"
#import "BRRootViewController.h"
#import "BRAppDelegate.h"
#import "MBProgressHUD.h"

@interface WOCBuyingWizardInputVarificationCodeViewController () <UITextFieldDelegate>

@end

@implementation WOCBuyingWizardInputVarificationCodeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setShadowOnButton:self.purchaseCodeButton];
    
    if (self.purchaseCode != nil) {
        self.purchaseCodeTextField.text = REMOVE_NULL_VALUE(self.purchaseCode);
    }
    else {
        self.purchaseCodeTextField.text = @"";
    }
    self.purchaseCodeTextField.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if(textField.text.length == 4 && string.length == 1) {
        [self performSelector:@selector(onConfirmPurchaseCodeButtonClick:) withObject:self afterDelay:1.0];
    }
    return YES;
}

// MARK: - IBAction

- (IBAction)onConfirmPurchaseCodeButtonClick:(id)sender {
    
    NSString *txtCode = [self.purchaseCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([txtCode length] == 5) {
        WOCBuyingInstructionsViewController *buyingInstructionsViewController = [self getViewController:@"WOCBuyingInstructionsViewController"];
        buyingInstructionsViewController.purchaseCode = txtCode;
        buyingInstructionsViewController.holdId = self.holdId;
        buyingInstructionsViewController.phoneNo = self.phoneNo;
        [self pushViewController:buyingInstructionsViewController animated:YES];
    }
    else if ([txtCode length] == 0) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:@"Enter Purchase Code" viewController:self.navigationController.visibleViewController];
    }
    else if ([txtCode length] != 5) {
         [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:@"Enter Valid Purchase Code" viewController:self.navigationController.visibleViewController];
    }
}
@end

