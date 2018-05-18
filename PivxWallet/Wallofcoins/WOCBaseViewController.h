//
//  WOCBaseViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 27/02/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCDefaultBaseViewController.h"

@interface WOCBaseViewController : WOCDefaultBaseViewController

- (IBAction)onSignOutButtonClick:(id)sender;

- (void)loginWOC;
- (void)signOutWOC;
- (void)refereshToken;
- (void)pushToWOCRoot;
- (void)getOrderList;
- (void)backToMainView;
- (void)setWocDeviceCode;
- (void)clearLocalStorage;
- (void)storeDeviceInfoLocally;

- (NSString *)wocDeviceCode;
- (NSString*)getDeviceIDFromPhoneNumber:(NSString*)phoneNo;
@end
