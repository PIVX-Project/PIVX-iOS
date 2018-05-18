//
//  WOCBuyingWizardHomeViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCBuyingWizardHomeViewController.h"
#import "WOCLocationManager.h"
#import "WOCBuyingWizardZipCodeViewController.h"
#import "WOCBuyingWizardPaymentCenterViewController.h"
#import "WOCBuyingWizardInputAmountViewController.h"
#import "WOCConstants.h"
#import "BRAppDelegate.h"
#import "BRRootViewController.h"
#import "MBProgressHUD.h"
#import "APIManager.h"
#import "WOCAlertController.h"

@interface WOCBuyingWizardHomeViewController ()

@property (strong, nonatomic) NSString *zipCode;

@end

@implementation WOCBuyingWizardHomeViewController

- (void)viewDidLoad {
    
    self.isBackButtonRequire = YES;
    
    [super viewDidLoad];
    
    [self.defaults removeObjectForKey:WOCUserDefaultsLocalLocationLatitude];
    [self.defaults removeObjectForKey:WOCUserDefaultsLocalLocationLongitude];
    
    [[NSNotificationCenter defaultCenter] removeObserver:WOCNotificationObserverNameBuyDashStep1];
    [[NSNotificationCenter defaultCenter] removeObserver:WOCNotificationObserverNameBuyDashStep2];
    [[NSNotificationCenter defaultCenter] removeObserver:WOCNotificationObserverNameBuyDashStep4];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLogoutButton) name:WOCNotificationObserverNameBuyDashStep1 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openBuyDashStep2) name:WOCNotificationObserverNameBuyDashStep2 object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(findZipCode) name:WOCNotificationObserverNameBuyDashStep4 object:nil];
    
    [self setShadowOnButton:self.locationButton];
    [self setShadowOnButton:self.noThanksButton];
    [self setButtonColor:self.locationButton];
    self.informationLable.textColor =  WOCTHEMECOLOR;
    [self.orderListButton setTitleColor:WOCTHEMECOLOR forState:UIControlStateNormal];
     [self.orderListButton setTitleColor:WOCTHEMECOLOR forState:UIControlStateSelected];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setLogoutButton];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.locationButton setUserInteractionEnabled:YES];
}

- (void) setLogoutButton {
    
    NSString *token = [self.defaults valueForKey:WOCUserDefaultsAuthToken];
    
    if (token != nil && (![token isEqualToString:@"(null)"])) {
        NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
        NSString *loginPhone = [NSString stringWithFormat:@"Your wallet is signed into Wall of Coins using your mobile number %@",phoneNo];
        self.descriptionLabel.text = loginPhone;
        [self.signoutButton setTitle:@"SIGN OUT" forState:UIControlStateNormal];
        [self.signoutView setHidden:NO];
        [self.orderListButton setHidden:NO];
    }
    else {
        NSString *loginPhone = [NSString stringWithFormat:@"Do you already have an order?"];
        self.descriptionLabel.text = loginPhone;
        [self.signoutButton setTitle:@"SIGN IN HERE" forState:UIControlStateNormal];
        [self.orderListButton setHidden:YES];
        [self.signoutView setHidden:NO];
    }
    
    [self setShadowOnButton:self.signoutButton];
    [self setShadowOnButton:self.orderListButton];
}

- (void) openBuyDashStep2 {
    [self push:@"WOCBuyingWizardZipCodeViewController"];
}

- (void) openBuyDashStep3 {
    [self push:@"WOCBuyingWizardPaymentCenterViewController"];
}

- (void) openBuyDashStep4 {
    WOCBuyingWizardInputAmountViewController *inputAmountViewController = (WOCBuyingWizardInputAmountViewController*)[self getViewController:@"WOCBuyingWizardInputAmountViewController"];
    inputAmountViewController.zipCode = self.zipCode;
    [self pushViewController:inputAmountViewController animated:YES];
}

- (void)back:(id)sender {
    [self backToRoot];
}

- (void)showAlert {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:@"Are you in the USA?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refereshToken];
        [self openBuyDashStep2];
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self refereshToken];
        [self openBuyDashStep3];
       
    }];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)findZipCode {
    
    [self.locationButton setUserInteractionEnabled:YES];
    
    // Your location from latitude and longitude
    NSString *latitude = [self.defaults valueForKey:WOCUserDefaultsLocalLocationLatitude];
    NSString *longitude = [self.defaults valueForKey:WOCUserDefaultsLocalLocationLongitude];
    
    if (latitude != nil && longitude != nil) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude doubleValue] longitude:[longitude doubleValue]];
        MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.navigationController.topViewController.view animated:YES];

        // Call the method to find the address
        [self getAddressFromLocation:location completionHandler:^(NSMutableDictionary *placeDetail) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            
            APILog(@"address informations : %@", placeDetail);
            APILog(@"ZIP code : %@", [placeDetail valueForKey:@"ZIP"]);
            
            [self.defaults setObject:[placeDetail valueForKey:WOCApiBodyCountryCode] forKey:WOCApiBodyCountryCode];
            [self.defaults synchronize];
            self.zipCode = [placeDetail valueForKey:@"ZIP"];
            [self openBuyDashStep4];
        }
        failureHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            [self.defaults removeObjectForKey:WOCApiBodyCountryCode];
            APILog(@"Error : %@", error);
        }];
    }
    else {
        
        [self.defaults removeObjectForKey:WOCApiBodyCountryCode];
        [[WOCLocationManager sharedInstance] startLocationService];
    }
}

- (void)getAddressFromLocation:(CLLocation *)location completionHandler:(void (^)(NSMutableDictionary *placemark))completionHandler failureHandler:(void (^)(NSError *error))failureHandler {
    
    NSMutableDictionary *d = [NSMutableDictionary new];
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (failureHandler && (error || placemarks.count == 0)) {
            failureHandler(error);
        }
        else {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            if(completionHandler) {
                
                completionHandler([NSMutableDictionary dictionaryWithDictionary:placemark.addressDictionary]);
            }
        }
    }];
}

// MARK: - API
- (void)signOut:(NSString*)phone {
    
    [self signOutWOC];
}
- (IBAction)onOrderListClick:(id)sender {
    
    [self getOrderList];
}

// MARK: - IBAction
- (IBAction)onBackButtonClick:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController.navigationBar setHidden:NO];
    });
}

- (IBAction)onFindLocationButtonClick:(id)sender {
    
    [self refereshToken];
    [self.defaults removeObjectForKey:WOCApiBodyCountryCode];
    [self.defaults synchronize];
    if ([[WOCLocationManager sharedInstance] locationServiceEnabled]) {
        [self findZipCode];
        [self.locationButton setUserInteractionEnabled:NO];
    }
    else {
        // Enable Location services
        [[WOCLocationManager sharedInstance] startLocationService];
        [self.locationButton setUserInteractionEnabled:NO];
    }
}

- (IBAction)noThanksButtonClick:(id)sender {
    [self.defaults removeObjectForKey:WOCApiBodyCountryCode];
    [self.defaults synchronize];
    [self showAlert];
}

- (IBAction)onSignOutButtonClick:(id)sender {
   
    UIButton * btn = (UIButton*) sender;
    if (btn != nil) {
        if ([btn.titleLabel.text isEqualToString:@"SIGN IN HERE"]) {
            [self push:@"WOCSignInViewController"];
        }
        else {
           [self signOutWOC];
        }
    }
    [self performSelector:@selector(setLogoutButton) withObject:nil afterDelay:1.0];
}
@end
