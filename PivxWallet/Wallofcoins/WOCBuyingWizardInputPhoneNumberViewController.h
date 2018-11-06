//
//  WOCBuyingWizardInputPhoneNumberViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
//WOCBuyingWizardInputPhoneNumberViewController
// Enter Phone Number Screen
@interface WOCBuyingWizardInputPhoneNumberViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *offerId;
@property (strong, nonatomic) NSString *emailId;
@property (assign, nonatomic) BOOL isActiveHoldChecked;
@property (assign, nonatomic) BOOL isForLoginOny;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

- (IBAction)onNextButtonClicked:(id)sender;

@end
