//
//  WOCLocationManager.h
//  Wallofcoins
//
//  Created by Genitrust on 23/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WOCLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *lastLocation;

+ (WOCLocationManager *)sharedInstance;

- (void)startLocationService;
- (BOOL)locationServiceEnabled;
- (CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr;

@end
