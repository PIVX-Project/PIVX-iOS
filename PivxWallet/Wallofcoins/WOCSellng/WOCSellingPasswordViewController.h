//
//  WOCPasswordViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 27/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
@interface WOCSellingPasswordViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *offerId;
@property (strong, nonatomic) NSString *phoneNo;

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *WOCLinkLabel;
@property (weak, nonatomic) IBOutlet UIButton *WOCLinkButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

- (IBAction)onLinkButtonClick:(id)sender;
- (IBAction)onLoginButtonClick:(id)sender;
- (IBAction)onForgotPasswordButtonClick:(id)sender;
- (IBAction)onCloseButtonClick:(id)sender;

@end
