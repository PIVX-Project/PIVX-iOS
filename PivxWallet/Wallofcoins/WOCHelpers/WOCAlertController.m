//
//  WOCAlertController.m
//  Wallofcoins
//
//  Created by Genitrust on 02/02/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCAlertController.h"

@implementation WOCAlertController

static WOCAlertController *alert = NULL;

+ (WOCAlertController *)sharedInstance {
    if (!alert) {
        alert = [[WOCAlertController alloc] init];
    }
    return alert;
}

- (void)alertshowWithTitle:(NSString*)title message:(NSString*)message viewController:(UIViewController*)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:okAction];
    
    if (viewController != nil) {
        [viewController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)alertshowWithError:(NSError*)error viewController:(UIViewController*)viewController {
    NSString *title = @"Error";
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert;
        if (error.userInfo != nil) {
            if (error.userInfo[@"detail"] != nil) {
                alert = [UIAlertController alertControllerWithTitle:title message:error.userInfo[@"detail"] preferredStyle:UIAlertControllerStyleAlert];
            }
            else {
                alert = [UIAlertController alertControllerWithTitle:title message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            }
        }
        else {
           alert = [UIAlertController alertControllerWithTitle:title message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
        }
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alert addAction:okAction];
        
        if (viewController != nil) {
            [viewController presentViewController:alert animated:YES completion:nil];
        }
    });
}

@end
