//
//  WOCBaseViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 27/02/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCBaseViewController.h"
#import "WOCBuyingInstructionsViewController.h"
#import "WOCBuyingSummaryViewController.h"
#import "WOCBuyingWizardHomeViewController.h"

@interface WOCBaseViewController ()

@end

@implementation WOCBaseViewController

+ (instancetype) sharedInstance {
    static dispatch_once_t pred = 0;
    static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setWocDeviceCode];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString * storyboardName = [self.storyboard valueForKey:@"name"];
    
    if ([storyboardName isEqualToString:WOCBuyingStoryboard]) {
        self.title = [NSString stringWithFormat:@"buy %@ with cash",WOCCurrency];
    }
    else {
        self.title = [NSString stringWithFormat:@"sell %@ for cash",WOCCurrency];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.title = @"";
}

- (IBAction)onSignOutButtonClick:(id)sender {
    [self signOutWOC];
}

- (void)setWocDeviceCode {
    //store deviceCode in userDefault
    int launched = [self.defaults integerForKey:WOCUserDefaultsLaunchStatus];
    if (launched == 0) {
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [self.defaults setValue:uuid forKey:WOCUserDefaultsLocalDeviceCode];
        [self.defaults setInteger:1 forKey:WOCUserDefaultsLaunchStatus];
        [self.defaults synchronize];
    }
}

- (NSString *)wocDeviceCode {
    NSString *deviceCode = @"";
    
    if ([self.defaults valueForKey:WOCUserDefaultsLocalDeviceCode] != nil) {
        deviceCode = [self.defaults valueForKey:WOCUserDefaultsLocalDeviceCode];
    }
    return deviceCode;
}

- (void)storeDeviceInfoLocally {
    
    if ([self.defaults objectForKey:WOCUserDefaultsLocalPhoneNumber] != nil) {
        if ([self.defaults objectForKey:WOCUserDefaultsLocalDeviceId] != nil) {
            NSString * phoneNumber = [self.defaults objectForKey:WOCUserDefaultsLocalPhoneNumber];
            NSString * deviceID = [self.defaults objectForKey:WOCUserDefaultsLocalDeviceId];
            
            NSMutableDictionary *localDeiveDict =  [NSMutableDictionary dictionaryWithCapacity:0];
            if ([self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo] != nil) {
                localDeiveDict = [NSMutableDictionary dictionaryWithDictionary:[self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo]];
            }
            
            localDeiveDict[phoneNumber] = [NSString stringWithFormat:@"%@",deviceID];
            if (localDeiveDict != nil) {
                [self.defaults setObject:localDeiveDict forKey:WOCUserDefaultsLocalDeviceInfo];
                [self.defaults synchronize];
            }
        }
    }
    
    APILog(@"Device info %@",[self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo]);
}

- (void)clearLocalStorage
{
    [self.defaults removeObjectForKey:WOCUserDefaultsAuthToken];
    [self.defaults removeObjectForKey:WOCUserDefaultsLocalPhoneNumber];
    [self.defaults removeObjectForKey:WOCUserDefaultsLocalDeviceId];
    [self.defaults synchronize];
}

- (NSString*)getDeviceIDFromPhoneNumber:(NSString*)phoneNo {
    
    if ([self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo] != nil) {
        if ([[self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *deviceInfoDict = [NSMutableDictionary dictionaryWithDictionary:[self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo]];
            if (deviceInfoDict[phoneNo] != nil) {
                NSString *deviceId = deviceInfoDict[phoneNo];
                if (deviceId != nil) {
                    if (deviceId.length > 0) {
                        if (![deviceId isEqualToString:@"(null)"]) {
                            return  deviceId;
                        }
                    }
                }
            }
        }
    }
    return nil;
}

- (void)refereshToken {
    
    if ([self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo] != nil) {
        if ([[self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *deviceInfoDict = [NSMutableDictionary dictionaryWithDictionary:[self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo]];
            NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
            if (phoneNo != nil) {
                if (deviceInfoDict[phoneNo] != nil) {
                    NSString *deviceId = deviceInfoDict[phoneNo];
                    if (deviceId != nil) {
                        if (deviceId.length > 0 && (![deviceId isEqualToString:@"(null)"])) {
                            [self.defaults setObject:deviceId forKey:WOCUserDefaultsLocalDeviceId];
                            [self.defaults synchronize];
                            [self.defaults setObject:deviceInfoDict forKey:WOCUserDefaultsLocalDeviceInfo];
                            [self.defaults synchronize];
                            [self loginWOC];
                            return;
                        }
                        else {
                            [self.defaults removeObjectForKey:WOCUserDefaultsLocalPhoneNumber];
                            [self.defaults removeObjectForKey:WOCUserDefaultsLocalDeviceId];
                            
                            [deviceInfoDict removeObjectForKey:phoneNo];
                            [self.defaults setObject:deviceInfoDict forKey:WOCUserDefaultsLocalDeviceInfo];
                            [self.defaults synchronize];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                UIAlertController *alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Error while login with phone number. please try to login again." preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [self loginWOC];
                                }];
                                
                                [alert addAction:okAction];
                                
                                [self presentViewController:alert animated:YES completion:nil];
                            });
                        }
                    }
                }
            }
        }
    }
}

- (void)backToMainView {
    
    [super backToMainView];
    [self storeDeviceInfoLocally];
}
// MARK: - API
// Will call SignOut API then Store phone number with Device ID in Local storage and Backto Main View

- (void)loginWOC {
    
    NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
    NSString *deviceCode = [self.defaults valueForKey:WOCUserDefaultsLocalDeviceCode];
    NSString *deviceId = [self.defaults valueForKey:WOCUserDefaultsLocalDeviceId];
    NSString *token = [self.defaults valueForKey:WOCUserDefaultsAuthToken];
    
    NSDictionary *params = @{
                             WOCApiBodyDeviceCode: deviceCode
                             };
    
    if (deviceId != nil && (![deviceId isEqualToString:@"(null)"])) {
        
        params = @{
                   WOCApiBodyDeviceCode: deviceCode,
                   WOCApiBodyDeviceId: deviceId,
                   WOCApiBodyJsonParameter: @"YES"
                   };
        
        [[APIManager sharedInstance] login:params phone:phoneNo response:^(id responseDict, NSError *error) {
            
            if (error == nil) {
                NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)responseDict];
                [self.defaults setValue:[responseDictionary valueForKey:WOCApiResponseToken] forKey:WOCUserDefaultsAuthToken];
                [self.defaults setValue:phoneNo forKey:WOCUserDefaultsLocalPhoneNumber];
                [self.defaults setValue:[NSString stringWithFormat:@"%@",[responseDictionary valueForKey:WOCApiBodyDeviceId]] forKey:WOCUserDefaultsLocalDeviceId];
                [self.defaults synchronize];
                [self storeDeviceInfoLocally];
            }
            else {
                [self.defaults removeObjectForKey:WOCUserDefaultsAuthToken];
                [self.defaults removeObjectForKey:WOCUserDefaultsLocalPhoneNumber];
                [self.defaults removeObjectForKey:WOCUserDefaultsLocalDeviceId];
                //[self.defaults setValue:phoneNo forKey:WOCUserDefaultsLocalPhoneNumber];
                [self.defaults synchronize];
                
                NSString *title = ALERT_TITLE;
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"SIGN IN for the device is hidden" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self backToMainView];
                    }];
                    
                    [alert addAction:okAction];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                });
            }
        }];
    }
}

- (void)signOutWOC {
    
    NSString * phoneNumber = [self.defaults objectForKey:WOCUserDefaultsLocalPhoneNumber];
    
    if (phoneNumber != nil) {
        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.navigationController.topViewController.view animated:YES];
        
        NSDictionary *params = @{
                                 };
        
        [[APIManager sharedInstance] signOut:nil phone:phoneNumber response:^(id responseDict, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            
            if (error != nil) {
                [[WOCAlertController sharedInstance] alertshowWithError:error viewController:self.navigationController.visibleViewController];
            }
            
            [self backToMainView];
            [self clearLocalStorage];
            
        }];
    }
    else {
        [self backToMainView];
        [self clearLocalStorage];
    }
}

- (void)pushToWOCRoot {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString * storyboardName = [self.storyboard valueForKey:@"name"];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
        UINavigationController *navController = (UINavigationController*) [storyboard instantiateViewControllerWithIdentifier:@"wocNavigationController"];
        
        if ([storyboardName isEqualToString:WOCBuyingStoryboard]) {
            WOCBuyingWizardHomeViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WOCBuyingWizardHomeViewController"];// Or any VC with Id
            vc.isFromSend = YES;
            [navController.navigationBar setTintColor:[UIColor whiteColor]];
            BRAppDelegate *appDelegate = (BRAppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.window.rootViewController = navController;
        }
    });
}

// MARK: - WallofCoins API

- (void)getOrderList {
    
    NSString * storyboardName = [self.storyboard valueForKey:@"name"];
    
    if ([storyboardName isEqualToString:WOCBuyingStoryboard]) {
        [[APIManager sharedInstance] getOrders:nil response:^(id responseDict, NSError *error) {
            [self loadOrdersWithResponse:responseDict withError:error];
        }];
    }
    else {
        [self getIncomingList];
    }
}

- (void)getIncomingList {
    
    [[APIManager sharedInstance] getIncomingOrders:nil response:^(id responseDict, NSError *error) {
        
        [self loadOrdersWithResponse:responseDict withError:error];
    }];
}

- (void)loadOrdersWithResponse:(id)responseDict withError: (NSError *)error
{
    NSString * storyboardName = [self.storyboard valueForKey:@"name"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error == nil) {
            if ([responseDict isKindOfClass:[NSArray class]]) {
                NSString *phoneNo = [[NSUserDefaults standardUserDefaults] valueForKey:WOCUserDefaultsLocalPhoneNumber];
                
                NSArray *orders = [[NSArray alloc] initWithArray:(NSArray*)responseDict];
                if (orders.count > 0) {
                    NSPredicate *wdvPredicate = [NSPredicate predicateWithFormat:@"status == 'WD'"];
                    NSArray *wdArray = [orders filteredArrayUsingPredicate:wdvPredicate];
                    if (wdArray.count > 0) {
                        NSDictionary *orderDict = (NSDictionary*)[wdArray objectAtIndex:0];
                        NSString *status = [NSString stringWithFormat:@"%@",[orderDict valueForKey:@"status"]];
                        if ([status isEqualToString:@"WD"]) {
                            if ([storyboardName isEqualToString:WOCBuyingStoryboard]) {
                                WOCBuyingInstructionsViewController *buyingInstructionsViewController = [self getViewController:@"WOCBuyingInstructionsViewController"];
                                buyingInstructionsViewController.phoneNo = phoneNo;
                                buyingInstructionsViewController.isFromSend = YES;
                                buyingInstructionsViewController.isFromOffer = NO;
                                buyingInstructionsViewController.orderDict = orderDict;
                                [self pushViewController:buyingInstructionsViewController animated:YES];
                            }
                        }
                    }
                    else {
                        
                        if ([storyboardName isEqualToString:WOCBuyingStoryboard]) {
                            WOCBuyingSummaryViewController *buyingInstructionsViewController = [self getViewController:@"WOCBuyingSummaryViewController"];
                            buyingInstructionsViewController.phoneNo = phoneNo;
                            buyingInstructionsViewController.orders = orders;
                            buyingInstructionsViewController.isFromSend = YES;
                            [self pushViewController:buyingInstructionsViewController animated:YES];
                        }
                    }
                }
                else {
                    if ([storyboardName isEqualToString:WOCBuyingStoryboard]) {
                        WOCBuyingSummaryViewController *buyingSummaryViewController = [self getViewController:@"WOCBuyingSummaryViewController"];
                        buyingSummaryViewController.phoneNo = phoneNo;
                        buyingSummaryViewController.orders = orders;
                        buyingSummaryViewController.isFromSend = YES;
                        buyingSummaryViewController.isHideSuccessAlert = YES;
                        [self pushViewController:buyingSummaryViewController animated:YES];
                    }
                }
            }
            else {
                [self backToMainView];
            }
        }
        else {
            [self refereshToken];
        }
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
