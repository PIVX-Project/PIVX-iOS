//
//  WOCBuyingWizardInputEmailViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
//WOCBuyingWizardInputEmailViewController
// Enter Email Address Screen
@interface WOCBuyingWizardInputEmailViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *offerId;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)onDoNotSendMeEmailButtonClicked:(id)sender;
- (IBAction)onNextButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *doNotSendEmailButton;

@end
