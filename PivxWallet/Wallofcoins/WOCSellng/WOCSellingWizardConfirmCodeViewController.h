//
//  WOCSellingWizardConfirmCodeViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"

//WOCSellingWizardConfirmCodeViewController

@interface WOCSellingWizardConfirmCodeViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *purchaseCode;
@property (strong, nonatomic) NSString *offerId;
@property (strong, nonatomic) NSString *holdId;
@property (strong, nonatomic) NSString *phoneNo;
@property (strong, nonatomic) NSString *emailId;
@property (strong, nonatomic) NSString *deviceCode;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmCodeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *confirmVarificationCodeButton;

- (IBAction)onConfirmVarificationCodeClicked:(id)sender;


@end
