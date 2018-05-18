//
//  WOCSellingWizardPaymentCenterViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingWizardPaymentCenterViewController.h"
#import "WOCSellingWizardInputAmountViewController.h"
#import "APIManager.h"
#import "WOCAlertController.h"
#import "WOCSellingAddNewBankViewController.h"
@interface WOCSellingWizardPaymentCenterViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *paymentCenters;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSString *bankId;

@end

@implementation WOCSellingWizardPaymentCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShadowOnButton:self.nextButton];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.paymentCenterTextfield.inputView = self.pickerView;
    
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

- (IBAction)onNextButtonClick:(id)sender {
    
    if ([self.bankId length] > 0) {
        WOCSellingWizardInputAmountViewController *inputAmountViewController = (WOCSellingWizardInputAmountViewController*)[self getViewController:@"WOCSellingWizardInputAmountViewController"];;
        inputAmountViewController.bankId = self.bankId;
        NSString *bankInfo = [NSString stringWithFormat:@"%@ (-%@)",self.paymentCenterTextfield.text,self.bankId];
        [self.defaults setObject:bankInfo forKey:WOCUserDefaultsLocalBankInfo];
        [self.defaults synchronize];
        
        [self.defaults setObject:self.paymentCenterTextfield.text forKey:WOCUserDefaultsLocalBankName];
        [self.defaults synchronize];
        
        [self.defaults setObject:self.bankId forKey:WOCUserDefaultsLocalBankAccount];
        [self.defaults synchronize];
        
        [self pushViewController:inputAmountViewController animated:YES];
        return;
    }
    else {
        [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Select payment center." viewController:self.navigationController.visibleViewController];
    }
}

- (IBAction)onUseNewAccountButtonClick:(id)sender {
    
    WOCSellingAddNewBankViewController *addNewBankViewController = (WOCSellingAddNewBankViewController*)[self getViewController:@"WOCSellingAddNewBankViewController"];
    [self pushViewController:addNewBankViewController animated:YES];
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
    self.paymentCenterTextfield.text = self.paymentCenters[row][@"name"];
    self.bankId = [NSString stringWithFormat:@"%@",self.paymentCenters[row][@"id"]];
}

@end

