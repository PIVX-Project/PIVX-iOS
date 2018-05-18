//
//  WOCSellingWizardZipCodeViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingWizardZipCodeViewController.h"
#import "WOCSellingWizardPaymentCenterViewController.h"
#import "WOCSellingWizardInputAmountViewController.h"
#import "APIManager.h"
#import "WOCLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
@interface WOCSellingWizardZipCodeViewController ()

@end


@implementation WOCSellingWizardZipCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem.title = @"";
    [self setShadowOnButton:self.btnNext];
}

// MARK: - IBAction

- (IBAction)nextClicked:(id)sender {
    
    [self.defaults removeObjectForKey:WOCApiBodyCountryCode];
    
    [self.defaults synchronize];
    
    NSString *zipCode = [self.txtZipCode.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([zipCode length] == 0) {
        [self push:@"WOCSellingWizardPaymentCenterViewController"];
    }
    else if ([zipCode length] < 5 || [zipCode length] > 6 ) {
        [[WOCAlertController sharedInstance] alertshowWithTitle:ALERT_TITLE message:@"Enter valid zipcode" viewController:self.navigationController.visibleViewController];
    }
    else {
        [self setCountryWithZipCode:zipCode];
        
        WOCSellingWizardInputAmountViewController *inputAmountViewController = (WOCSellingWizardInputAmountViewController*)[self getViewController:@"WOCSellingWizardInputAmountViewController"];;
        inputAmountViewController.zipCode = zipCode;
        [self pushViewController:inputAmountViewController animated:YES];
    }
}

- (void)setCountryWithZipCode:(NSString*)zipCode {
    
    CLGeocoder* geoCoder = [[CLGeocoder alloc] init];
    CNMutablePostalAddress *postalAddress = [[CNMutablePostalAddress alloc] init];
    postalAddress.postalCode = zipCode;
    postalAddress.country = @"us";
    postalAddress.state = @"";
    if (@available(iOS 11.0, *)) {
        [geoCoder geocodePostalAddress:postalAddress completionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0) {
                CLPlacemark* placemark = [placemarks objectAtIndex:0];
                [self.defaults setObject:[placemark ISOcountryCode].lowercaseString forKey:WOCApiBodyCountryCode];
                [self.defaults synchronize];
                APILog(@"%@",[placemark description]);
                APILog(@"======> country code is %@",[placemark ISOcountryCode]);
            }
            else {
                APILog(@"Error in featching Country =");
            }
        }];
    }
    else {
        // Fallback on earlier versions
        [geoCoder geocodeAddressDictionary:@{(NSString*)kABPersonAddressZIPKey : zipCode,(NSString*)kABPersonAddressCountryCodeKey : @"us"}
                         completionHandler:^(NSArray *placemarks, NSError *error) {
                             if ([placemarks count] > 0) {
                                 CLPlacemark* placemark = [placemarks objectAtIndex:0];
                                 
                                 NSString* city = placemark.addressDictionary[(NSString*)kABPersonAddressCityKey];
                                 NSString* state = placemark.addressDictionary[(NSString*)kABPersonAddressStateKey];
                                 NSString* country = placemark.addressDictionary[(NSString*)kABPersonAddressCountryCodeKey];
                                 
                                 [self.defaults setObject:country.lowercaseString forKey:WOCApiBodyCountryCode];
                                 [self.defaults synchronize];
                                 APILog(@"%@",[placemark description]);
                                 APILog(@"======> country code is city [%@] state [%@] country [%@]",city,state,country);
                                 
                             } else {
                                 // Lookup Failed
                                 APILog(@"Error in featching Country =");
                             }
                         }];
    }
}

@end

