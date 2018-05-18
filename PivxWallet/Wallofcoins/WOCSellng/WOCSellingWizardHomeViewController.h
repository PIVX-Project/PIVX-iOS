//
//  WOCSellingWizardHomeViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"


//WOCSellingWizardHomeViewController
// Find My Location Screen
@interface WOCSellingWizardHomeViewController : WOCBaseViewController

@property (weak, nonatomic) IBOutlet UIView *signoutView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (weak, nonatomic) IBOutlet UIButton *orderListButton;
@property (weak, nonatomic) IBOutlet UIButton *sellYourCryptoButton;
@property (assign, nonatomic) BOOL isFromSend;

- (void)setLogoutButton;
- (IBAction)onBackButtonClick:(id)sender;
- (IBAction)onSignOutButtonClick:(id)sender;
- (IBAction)onSellYourCryptoButtonClick:(id)sender;

@end
