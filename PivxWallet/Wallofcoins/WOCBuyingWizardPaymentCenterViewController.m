//
//  WOCBuyingWizardPaymentCenterViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCBuyingWizardPaymentCenterViewController.h"
#import "WOCBuyingWizardInputAmountViewController.h"
#import "APIManager.h"
#import "WOCAlertController.h"

@interface WOCBuyingWizardPaymentCenterViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) NSArray *paymentCenters;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) NSString *bankId;

@end

@implementation WOCBuyingWizardPaymentCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setShadowOnButton:self.nextButton];
    [self setButtonColor:self.nextButton];

    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.paymentCenterTextField.inputView = self.pickerView;
    [self getPaymentCenters];
    self.informationLable.textColor =  WOCTHEMECOLOR;
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
        WOCBuyingWizardInputAmountViewController *inputAmountViewController = (WOCBuyingWizardInputAmountViewController*)[self getViewController:@"WOCBuyingWizardInputAmountViewController"];;
        inputAmountViewController.bankId = self.bankId;
        NSString *bankInfo = [NSString stringWithFormat:@"%@ (-%@)",self.paymentCenterTextField.text,self.bankId];
        [self.defaults setObject:bankInfo forKey:WOCUserDefaultsLocalBankInfo];
        [self.defaults synchronize];
        
        [self.defaults setObject:self.paymentCenterTextField.text forKey:WOCUserDefaultsLocalBankName];
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
    self.paymentCenterTextField.text = self.paymentCenters[row][@"name"];
    self.bankId = [NSString stringWithFormat:@"%@",self.paymentCenters[row][@"id"]];
}

@end

