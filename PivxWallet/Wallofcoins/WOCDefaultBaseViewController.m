//
//  WOCBaseViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 27/02/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCDefaultBaseViewController.h"

#define MAIN_VIEWCONTROLLER @"WOCBuyingWizardHomeViewController"
#define MAIN_VIEWCONTROLLER_SELL @"WOCSellingWizardHomeViewController"

@interface WOCDefaultBaseViewController ()

@end

@implementation WOCDefaultBaseViewController

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
    
    self.defaults = [NSUserDefaults standardUserDefaults];
   
    APILog(@"------------> You are In %@",[super class]);
    
    if (self.isBackButtonRequire) {
      
        if ([self.navigationController.visibleViewController isKindOfClass:NSClassFromString(MAIN_VIEWCONTROLLER)] || [self.navigationController.visibleViewController isKindOfClass:NSClassFromString(MAIN_VIEWCONTROLLER_SELL)]) {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToRoot)];
        }
        else {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backToMainView)];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *token = [self.defaults valueForKey:WOCUserDefaultsAuthToken];
    
    if (token != nil && (![token isEqualToString:@"(null)"])) {
        NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
        NSString *loginPhone = [NSString stringWithFormat:@"Your wallet is signed into Wall of Coins using your mobile number %@",phoneNo];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)setShadowOnView:(UIView *)view {
    
    view.layer.cornerRadius = 3.0;
    view.layer.masksToBounds = YES;
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 1);
    view.layer.shadowRadius = 1;
    view.layer.shadowOpacity = 1;
    view.layer.masksToBounds = NO;
}


- (void)setShadowOnButton:(UIButton *)button {
    
    button.layer.cornerRadius = 3.0;
    button.layer.masksToBounds = YES;
    button.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    button.layer.shadowOffset = CGSizeMake(0, 1);
    button.layer.shadowRadius = 1;
    button.layer.shadowOpacity = 1;
    button.layer.masksToBounds = NO;
}
- (void)setButtonColor:(UIButton *)button {
    button.backgroundColor = WOCTHEMECOLOR;
}
- (BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void)showAlertWithText:(NSString*)alertText {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:ALERT_TITLE message:alertText preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:okayAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (NSString*)getCryptoPrice:(NSNumber*)number
{
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    [numFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numFormatter setAlwaysShowsDecimalSeparator:YES];
    [numFormatter setUsesGroupingSeparator:YES];
    [numFormatter setMinimumFractionDigits:2];
    [numFormatter setMaximumFractionDigits:2];
    [numFormatter setGroupingSeparator:@","];
    [numFormatter setGroupingSize:3];
    NSString *numberStr = [numFormatter stringFromNumber:number];
    return numberStr;
}

- (void)pushViewControllerStr:(NSString*)viewControllerStr {
    
    NSString * storyboardName = [self.storyboard valueForKey:@"name"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    id pushViewController = [storyboard instantiateViewControllerWithIdentifier:viewControllerStr];
    if (pushViewController != nil) {
        if ([pushViewController isKindOfClass:NSClassFromString(viewControllerStr)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                 if (![self.navigationController.visibleViewController isKindOfClass:NSClassFromString(viewControllerStr)]) {
                     [self.navigationController pushViewController:pushViewController animated:YES];
                 }
            });
        }
    }
}
// MARK: - BACK Funcations
- (void)backToRoot {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BRRootViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [nav.navigationBar setTintColor:[UIColor whiteColor]];
        
        UIPageControl.appearance.pageIndicatorTintColor = [UIColor lightGrayColor];
        UIPageControl.appearance.currentPageIndicatorTintColor = [UIColor blueColor];
        
        BRAppDelegate *appDelegate = (BRAppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.window.rootViewController = nav;
    });
}

- (void)backToMainView {
    
    NSString * storyboardName = [self.storyboard valueForKey:@"name"];
    if ([storyboardName isEqualToString:WOCBuyingStoryboard]) {
        [self push:MAIN_VIEWCONTROLLER];
    }
    else {
        [self push:MAIN_VIEWCONTROLLER_SELL];
    }
}

- (id)getViewController:(NSString*)viewControllerStr  {
    
    NSString * storyboardName = [self.storyboard valueForKey:@"name"];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    return  [storyboard instantiateViewControllerWithIdentifier:viewControllerStr];
}

- (void)push:(NSString*)viewControllerStr {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![self.navigationController.visibleViewController isKindOfClass:NSClassFromString(viewControllerStr)]) {
            BOOL mainViewFound = NO;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(viewControllerStr)]) {
                    mainViewFound = YES;
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
            
            if (!mainViewFound) {
                [self pushViewControllerStr:viewControllerStr];
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:WOCNotificationObserverNameBuyDashStep1 object:nil];
            });
        }
    });
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![self.navigationController.visibleViewController isKindOfClass:[viewController class]]) {
            BOOL mainViewFound = NO;
            for (UIViewController *vc in self.navigationController.viewControllers) {
                
                if ([vc isKindOfClass:[viewController class]]) {
                    mainViewFound = YES;
                    [self.navigationController popToViewController:vc animated:animated];
                }
            }
            
            if (!mainViewFound) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (![self.navigationController.visibleViewController isKindOfClass:[viewController class]]) {
                        [self.navigationController pushViewController:viewController animated:animated];
                    }
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:WOCNotificationObserverNameBuyDashStep1 object:nil];
            });
        }
    });
}

- (void)back {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController.navigationBar setHidden:NO];
    });
}

// MARK: - IBAction

- (IBAction)onBackButtonClick:(id)sender {
    [self back];
}

- (IBAction)onBackToMainViewButtonClick:(id)sender {
    [self backToMainView];
}

- (IBAction)onSignOutButtonClick:(id)sender {
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

