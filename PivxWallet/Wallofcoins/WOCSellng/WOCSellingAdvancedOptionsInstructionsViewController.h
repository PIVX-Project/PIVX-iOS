//
//  WOCSellingAdvancedOptionsInstructionsViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"

// Enter Phone Number Screen
@interface WOCSellingAdvancedOptionsInstructionsViewController : WOCBaseViewController
@property (assign, nonatomic) BOOL isBeforeCreateAd;
@property (weak, nonatomic) IBOutlet UITextField *maxLimitTextfield;
@property (weak, nonatomic) IBOutlet UITextField *minLimitTextfield;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)onSaveButtonClick:(id)sender;
- (void)loadVarificationScreen;
- (void)setupUI;
@end
