//
//  WOCSellingWizardInputEmailViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
//WOCSellingWizardInputEmailViewController

// Enter Email Address Screen
@interface WOCSellingWizardInputEmailViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *offerId;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

- (IBAction)onDoNotSendMeEmailButtonClick:(id)sender;
- (IBAction)onNextButtonClick:(id)sender;

@end
