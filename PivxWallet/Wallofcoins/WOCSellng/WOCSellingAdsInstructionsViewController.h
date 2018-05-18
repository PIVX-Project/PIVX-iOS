//
//  WOCSellingAdsInstructionsViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"

// Enter Phone Number Screen
@interface WOCSellingAdsInstructionsViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *accountInformation;
@property (strong, nonatomic) NSString *currentPrice;
@property (strong, nonatomic) NSString *AdvertiseId;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *accountNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *accountNumberTextfield;
@property (weak, nonatomic) IBOutlet UITextField *availableCryptoTextfield;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *currentPriceTextfield;
@property (weak, nonatomic) IBOutlet UIButton *editYourCurrentRateButton;
@property (strong, nonatomic) IBOutlet UIButton *advancedOptionsButton;
- (IBAction)onEditYourCurrentRateButtonClick:(UIButton *)sender;
- (IBAction)backToHomeScreenAction:(id)sender;
- (IBAction)onAdvancedOptionsButtonClick:(UIButton *)sender;

@end
