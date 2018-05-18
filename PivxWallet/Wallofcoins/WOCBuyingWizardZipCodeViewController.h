//
//  WOCBuyingWizardZipCodeViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
//WOCBuyingWizardZipCodeViewController
// Enter ZipCode
@interface WOCBuyingWizardZipCodeViewController : WOCBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (assign, nonatomic) BOOL isZipCodeBlank;
@property (weak, nonatomic) IBOutlet UILabel *informationLable;

- (IBAction)onNextButtonClick:(id)sender;

@end
