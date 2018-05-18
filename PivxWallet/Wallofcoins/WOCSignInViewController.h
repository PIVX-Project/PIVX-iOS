//
//  WOCBuyingWizardOfferListViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
@interface WOCSignInViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *discoveryId;
@property (strong, nonatomic) NSString *amount;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *sighInButton;

@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITableView *numberListingTableView;

- (IBAction)onExistingAccoutButtonClick:(id)sender;
- (IBAction)onSignUpButtonClick:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeighConstrain;

@end
