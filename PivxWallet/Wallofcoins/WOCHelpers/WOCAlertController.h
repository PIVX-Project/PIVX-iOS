//
//  WOCAlertController.h
//  Wallofcoins
//
//  Created by Genitrust on 02/02/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WOCAlertController : NSObject

+ (WOCAlertController *)sharedInstance;

- (void)alertshowWithTitle:(NSString*)title message:(NSString*)message viewController:(UIViewController*)viewController;
- (void)alertshowWithError:(NSError*)error viewController:(UIViewController*)viewController;

@end
