//
//  WOCLocationManager.m
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCLocationManager.h"
#import "WOCConstants.h"

@implementation WOCLocationManager

+ (WOCLocationManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static WOCLocationManager *locationManager;
    
    dispatch_once(&onceToken, ^{
        locationManager = [[WOCLocationManager alloc] init];
    });
    
    return locationManager;
}

- (void)startLocationService {
    self.manager = [[CLLocationManager alloc] init];
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    self.manager.delegate = self;
    
    if ([self.manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.manager requestWhenInUseAuthorization];
    }
    [self.manager startUpdatingLocation];
}

- (BOOL)locationServiceEnabled {
    if ([CLLocationManager locationServicesEnabled]) {
        switch ([CLLocationManager authorizationStatus]) {
            case kCLAuthorizationStatusAuthorizedWhenInUse :
                return YES;
                break;
            default:
                return NO;
                break;
        }
    }
    else {
        return NO;
    }
}

- (CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

- (void)openStep4 {
    if (self.lastLocation != nil) {
        [[NSNotificationCenter defaultCenter] postNotificationName:WOCNotificationObserverNameBuyDashStep4 object:nil];
    }
}

- (void)showLocationAlertPopup {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:[NSString stringWithFormat:@"Allow \"%@\" to Access Your Location While You Use the App?",WOCCurrency] message:@"Your current location will be used to show you birds nearby."preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesButton = [UIAlertAction
                                actionWithTitle:@"Don't Allow"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                }];
    
    UIAlertAction *noButton = [UIAlertAction
                               actionWithTitle:@"Allow"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                   
                                   if ([[UIApplication sharedApplication] canOpenURL:settingsURL]) {
                                       [[UIApplication sharedApplication] openURL:settingsURL options:@{} completionHandler:nil];
                                   }
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alert animated:YES completion:nil];
}

// MARK: - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if ([locations count]) {
        self.lastLocation = [locations lastObject];
        
        if ([NSString stringWithFormat:@"%f",self.lastLocation.coordinate.latitude] != nil) {
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",self.lastLocation.coordinate.latitude] forKey:WOCUserDefaultsLocalLocationLatitude];
            [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%f",self.lastLocation.coordinate.longitude] forKey:WOCUserDefaultsLocalLocationLongitude];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:WOCNotificationObserverNameBuyDashStep2 object:nil];
        
    } else if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        
        [self performSelector:@selector(openStep4) withObject:nil afterDelay:2.0];
    }
}

@end

