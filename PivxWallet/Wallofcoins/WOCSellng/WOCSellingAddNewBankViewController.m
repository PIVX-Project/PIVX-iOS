//
//  WOCSellingWizardPaymentCenterViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingAddNewBankViewController.h"
#import "WOCSellingWizardInputAmountViewController.h"
#import "APIManager.h"
#import "WOCAlertController.h"
#import "WOCSellingWizardPaymentCenterViewController.h"

@interface WOCSellingAddNewBankViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *paymentCenters;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSString *bankId;

@end

@implementation WOCSellingAddNewBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShadowOnButton:self.btnNext];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.txtPaymentCenter.inputView = self.pickerView;
    
    [self getPaymentCenters];
}

// MARK: - API

- (void)getPaymentCenters {
    
    [[APIManager sharedInstance] getAvailablePaymentCenters:^(id responseDict, NSError *error) {
        if (error == nil) {
            if ([responseDict isKindOfClass:[NSArray class]]) {
                NSArray *responseArray = [[NSArray alloc] initWithArray:(NSArray *)responseDict];
                NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
                self.paymentCenters = [responseArray sortedArrayUsingDescriptors:@[sort]];
                [self.pickerView reloadAllComponents];
            }
        }
    }];
}

// MARK: - IBAction

- (IBAction)nextStepClicked:(id)sender {
    
    if ([self.bankId length] > 0 && self.txtAccoutName.text.length > 0
        && self.txtAccoutNumber.text.length > 0
        && self.txtConfirmAccoutNumber.text.length > 0 && [self.txtAccoutNumber.text isEqualToString:self.txtConfirmAccoutNumber.text]) {
        WOCSellingWizardInputAmountViewController *inputAmountViewController = (WOCSellingWizardInputAmountViewController*)[self getViewController:@"WOCSellingWizardInputAmountViewController"];;
        inputAmountViewController.bankId = self.bankId;
        
        NSString *bankInfo = [NSString stringWithFormat:@"%@ (-%@)",self.txtPaymentCenter.text,self.bankId];
        [self.defaults setObject:bankInfo forKey:WOCUserDefaultsLocalBankInfo];
        [self.defaults synchronize];
        
        [self.defaults setObject:self.txtAccoutName.text forKey:WOCUserDefaultsLocalBankName];
        [self.defaults synchronize];
        
        [self.defaults setObject:self.txtConfirmAccoutNumber.text forKey:WOCUserDefaultsLocalBankAccountNumber];
        [self.defaults synchronize];
        
        [self.defaults setObject:self.bankId forKey:WOCUserDefaultsLocalBankAccount];
        [self.defaults synchronize];
        
        [self pushViewController:inputAmountViewController animated:YES];
        return;
    }
    else {
        
        if ([self.bankId length] == 0 ) {
            [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Select payment center." viewController:self.navigationController.visibleViewController];
        }
        else if (self.txtAccoutName.text.length == 0) {
            
            [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Please enter account name." viewController:self.navigationController.visibleViewController];
        }
        else if (self.txtAccoutNumber.text.length == 0) {
            
            [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Please enter account number." viewController:self.navigationController.visibleViewController];
        }
        else if (self.txtConfirmAccoutNumber.text.length == 0) {
            
            [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Please enter confirm account number." viewController:self.navigationController.visibleViewController];
        }
        else if (![self.txtAccoutNumber.text isEqualToString:self.txtConfirmAccoutNumber.text]) {
            [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Account number and confirm account number not matched." viewController:self.navigationController.visibleViewController];
        }
    }
}

// MARK: UIPickerView Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    return self.paymentCenters.count;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.paymentCenters[row][@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.txtPaymentCenter.text = self.paymentCenters[row][@"name"];
    self.bankId = [NSString stringWithFormat:@"%@",self.paymentCenters[row][@"id"]];
}

- (IBAction)useMostRecentBankAccoutClick:(id)sender {
    WOCSellingWizardPaymentCenterViewController *paymentCenterViewController = (WOCSellingWizardPaymentCenterViewController*)[self getViewController:@"WOCSellingWizardPaymentCenterViewController"];
    [self pushViewController:paymentCenterViewController animated:YES];
}
@end

