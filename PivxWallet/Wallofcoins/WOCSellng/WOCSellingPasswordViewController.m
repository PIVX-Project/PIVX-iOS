//
//  WOCPasswordViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 27/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingPasswordViewController.h"
#import "WOCSellingWizardConfirmCodeViewController.h"
#import "APIManager.h"
#import "WOCConstants.h"
#import "WOCAlertController.h"
#import "MBProgressHUD.h"

@interface WOCSellingPasswordViewController () <UITextViewDelegate>

@end

@implementation WOCSellingPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    
    self.mainView.layer.cornerRadius = 3.0;
    self.mainView.layer.masksToBounds = YES;
    
    [self setShadowOnButton:self.loginButton];
    [self setShadowOnButton:self.forgotPasswordButton];
    
    NSMutableAttributedString *titleString = [[NSMutableAttributedString alloc] initWithString:self.WOCLinkButton.titleLabel.text];
    [titleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(29, 13)];
    [titleString addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:NSMakeRange(29, 13)];
    [self.WOCLinkButton setAttributedTitle:titleString forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - API

- (void)login:(NSString*)phoneNo password:(NSString*)password {
    NSDictionary *params = @{
                             WOCApiBodyPassword: password,
                             WOCApiBodyJsonParameter: @"YES"
                             };
    
    [[APIManager sharedInstance] login:params phone:phoneNo response:^(id responseDict, NSError *error) {
        if (error == nil) {
            NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)responseDict];
            [self.defaults setValue:[responseDictionary valueForKey:WOCApiResponseToken] forKey:WOCUserDefaultsAuthToken];
            [self.defaults setValue:phoneNo forKey:WOCUserDefaultsLocalPhoneNumber];
            [self.defaults synchronize];
            [self storeDeviceInfoLocally];

            [self getDeviceId:phoneNo];
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error.userInfo != nil) {
                    if (error.userInfo[@"detail"] != nil) {
                        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:error.userInfo[@"detail"]  viewController:self];
                    }
                    else {
                        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:error.localizedDescription viewController:self];
                    }
                }
                else {
                    [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:error.localizedDescription viewController:self];
                }
            });
        }
    }];
}

- (void)registerDevice:(NSString*)phoneNo {
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *deviceCode = [self.defaults valueForKey:WOCUserDefaultsLocalDeviceCode];
    NSString *token = [self.defaults valueForKey:WOCUserDefaultsAuthToken];
    
    NSDictionary *params =  @{
                              WOCApiBodyName: WOCApiBodyDeviceName_IOS,
                              WOCApiBodyCode: deviceCode,
                              WOCApiBodyJsonParameter:@"YES"
                              };
    
    [[APIManager sharedInstance] registerDevice:params response:^(id responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [hud hideAnimated:YES];
        });
        
        if (error == nil) {
            NSDictionary *response = (NSDictionary*)responseDict;
            if (response.count > 0) {
                NSString *deviceId = [NSString stringWithFormat:@"%@",[response valueForKey:WOCApiResponseId]];
                [self authorize:phoneNo deviceId:deviceId];
            }
        }
        else {
            [[WOCAlertController sharedInstance] alertshowWithError:error viewController:self.navigationController.visibleViewController];
        }
    }];
}

- (void)getDeviceId:(NSString*)phoneNo {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[APIManager sharedInstance] getDevice:^(id responseDict, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [hud hideAnimated:YES];
            });
            
            if (error == nil) {
                if ([responseDict isKindOfClass:[NSArray class]]) {
                    NSArray *response = (NSArray*)responseDict;
                    if (response.count > 0) {
                        NSDictionary *dictionary = [response lastObject];
                        NSString *deviceId = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"id"]];
                        
                        if (deviceId.length > 0 && (![deviceId isEqualToString:@"(null)"])) {
                            [self.defaults setValue:deviceId forKey:WOCUserDefaultsLocalDeviceId];
                            [self.defaults synchronize];
                            [self authorize:phoneNo deviceId:deviceId];
                        }
                    }
                    else {
                        [self registerDevice:phoneNo];
                    }
                }
                else {
                    [self registerDevice:phoneNo];
                }
            }
            else {
                [self registerDevice:phoneNo];
                //[[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:error.localizedDescription viewController:self.navigationController.visibleViewController];
            }
        }];
    });
}

- (void)authorize:(NSString*)phoneNo deviceId:(NSString*)deviceId {
    
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *deviceCode = [self.defaults valueForKey:WOCUserDefaultsLocalDeviceCode];
    
    NSDictionary *params = @{
                             WOCApiBodyDeviceCode: deviceCode,
                             WOCApiBodyDeviceId: deviceId,
                             WOCApiBodyJsonParameter: @"YES"
                             };
    
    [[APIManager sharedInstance] login:params phone:phoneNo response:^(id responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [hud hideAnimated:YES];
        });
        
        if (error == nil) {
            NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)responseDict];
            [self.defaults setValue:[responseDictionary valueForKey:WOCApiResponseToken] forKey:WOCUserDefaultsAuthToken];
            [self.defaults setValue:phoneNo forKey:WOCUserDefaultsLocalPhoneNumber];
            [self.defaults setValue:[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:WOCApiResponseDeviceId]] forKey:WOCUserDefaultsLocalDeviceId];
            [self.defaults synchronize];
            [self storeDeviceInfoLocally];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:nil];
                //move to step 8
                [[NSNotificationCenter defaultCenter] postNotificationName:WOCNotificationObserverNameBuyDashStep8 object:phoneNo];
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                 [self registerDevice:phoneNo];
            });
        }
    }];
}
// MARK: - IBAction

- (IBAction)onLinkButtonClick:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://wallofcoins.com/"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (IBAction)onLoginButtonClick:(id)sender {
    NSString *password = [self.passwordTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([password length] > 0) {
        [self login:self.phoneNo password:password];
    }
    else {
        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Alert" message:@"Enter password." viewController:self.navigationController.visibleViewController];
    }
}

- (IBAction)onForgotPasswordButtonClick:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://wallofcoins.com/en/forgotPassword/"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (IBAction)onCloseButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

