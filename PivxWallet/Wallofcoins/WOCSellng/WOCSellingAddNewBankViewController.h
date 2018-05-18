//
//  WOCSellingWizardPaymentCenterViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
@interface WOCSellingAddNewBankViewController : WOCBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *txtPaymentCenter;
@property (weak, nonatomic) IBOutlet UITextField *txtAccoutName;
@property (weak, nonatomic) IBOutlet UITextField *txtAccoutNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtConfirmAccoutNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

- (IBAction)nextStepClicked:(id)sender;
- (IBAction)useMostRecentBankAccoutClick:(id)sender;

@end

