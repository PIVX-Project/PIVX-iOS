//
//  WOCBuyingWizardHomeViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
//WOCBuyingWizardHomeViewController
// Find My Location Screen
@interface WOCBuyingWizardHomeViewController : WOCBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@property (weak, nonatomic) IBOutlet UIButton *noThanksButton;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *signoutButton;
@property (weak, nonatomic) IBOutlet UIView *signoutView;
@property (weak, nonatomic) IBOutlet UIButton *orderListButton;
@property (assign, nonatomic) BOOL isFromSend;
@property (weak, nonatomic) IBOutlet UILabel *informationLable;

- (void)setLogoutButton;
- (IBAction)onBackButtonClick:(id)sender;
- (IBAction)onFindLocationButtonClick:(id)sender;
- (IBAction)noThanksButtonClick:(id)sender;
- (IBAction)onSignOutButtonClick:(id)sender;

@end
