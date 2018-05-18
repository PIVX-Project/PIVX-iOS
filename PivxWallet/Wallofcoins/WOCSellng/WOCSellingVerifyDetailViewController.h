//
//  WOCSellingVerifyDetailViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"

// Enter Phone Number Screen
@interface WOCSellingVerifyDetailViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *accountInformation;
@property (strong, nonatomic) NSString *currentPrice;
@property (weak, nonatomic) IBOutlet UITextField *accountCodeTextfield;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *currentPriceTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (strong, nonatomic) NSString *offerId;
@property (strong, nonatomic) NSString *emailId;
@property (assign, nonatomic) BOOL isActiveHoldChecked;
@property (assign, nonatomic) BOOL isForLoginOny;
@property (weak, nonatomic) IBOutlet UITextField *confirmEmailTextfield;

- (IBAction)onNextButtonClick:(id)sender;
@end
