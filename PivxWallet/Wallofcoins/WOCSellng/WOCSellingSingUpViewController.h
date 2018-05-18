//
//  WOCSellingSingUpViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"

// Enter Phone Number Screen
@interface WOCSellingSingUpViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *offerId;
@property (strong, nonatomic) NSString *emailId;
@property (assign, nonatomic) BOOL isActiveHoldChecked;
@property (assign, nonatomic) BOOL isForLoginOny;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

- (IBAction)onNextButtonClick:(id)sender;

@end
