//
//  WOCBuyingWizardInputAmountViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
//WOCBuyingWizardInputAmountViewController
// Get Offer with Amount 
@interface WOCBuyingWizardInputAmountViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *bankId;
@property (strong, nonatomic) NSString *zipCode;

@property (weak, nonatomic) IBOutlet UITextField *dashTextField;
@property (weak, nonatomic) IBOutlet UITextField *dollarTextField;
@property (weak, nonatomic) IBOutlet UIView *line1View;
@property (weak, nonatomic) IBOutlet UIView *line2View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line1HeightConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *line2HeightConstant;
@property (weak, nonatomic) IBOutlet UIButton *offerButton;

- (IBAction)onGetOffersButtonClick:(id)sender;

@end
