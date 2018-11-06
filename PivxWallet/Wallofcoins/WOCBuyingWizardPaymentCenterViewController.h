//
//  WOCBuyingWizardPaymentCenterViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
//WOCBuyingWizardPaymentCenterViewController

@interface WOCBuyingWizardPaymentCenterViewController : WOCBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *paymentCenterTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *informationLable;

- (IBAction)onNextButtonClick:(id)sender;

@end
