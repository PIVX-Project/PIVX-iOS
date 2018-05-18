//
//  WOCSellingCreatePasswordViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
@interface WOCSellingCreatePasswordViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *purchaseCode;
@property (strong, nonatomic) NSString *offerId;
@property (strong, nonatomic) NSString *holdId;
@property (strong, nonatomic) NSString *phoneNo;
@property (strong, nonatomic) NSString *emailId;
@property (strong, nonatomic) NSString *deviceCode;
@property (strong, nonatomic) NSString *deviceName;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UITextField *purchaseCodeTextfield;
@property (weak, nonatomic) IBOutlet UIButton *confirmVarificationCodeButton;
- (IBAction)onConfirmVerificationCode:(UIButton *)sender;
- (IBAction)onResendCodeButtonClick:(UIButton *)sender;

@end
