//
//  WOCBuyingWizardOfferListViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSignInViewController.h"
#import "WOCBuyingWizardInputPhoneNumberViewController.h"
#import "WOCBuyingInstructionsViewController.h"
#import "WOCBuyingSummaryViewController.h"
#import "BRRootViewController.h"
#import "BRAppDelegate.h"
#import "WOCOfferCell.h"
#import "APIManager.h"
#import "BRWalletManager.h"
#import "WOCAlertController.h"
#import "MBProgressHUD.h"
#import "WOCBuyingWizardHomeViewController.h"

@interface WOCSignInViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *offers;
@property (assign) BOOL incremented;

@end

@implementation WOCSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.instructionLabel.text = [NSString stringWithFormat:@"Below are offers for at least $%@. You must click the ORDER button before you receive instructions to pay at the Cash Payment center.",self.amount];
     [self setShadowOnButton:self.signupButton];
     [self setShadowOnButton:self.sighInButton];
    [self.signupButton setTitleColor:WOCTHEMECOLOR forState:UIControlStateNormal];
    [self.sighInButton setTitleColor:WOCTHEMECOLOR forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
     [self getLocalDevices];
     self.title = @"SignIN";
}

- (void)getLocalDevices {
    
    if ([self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo] != nil) {
        
        if ([[self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo] isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *deviceInfoDict = [NSMutableDictionary dictionaryWithDictionary:[self.defaults objectForKey:WOCUserDefaultsLocalDeviceInfo]];
            if (deviceInfoDict != nil) {
                self.offers = deviceInfoDict.allKeys;
                 [self.numberListingTableView reloadData];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushToStep7:(NSInteger)sender {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender inSection:0];
    NSString *phoneNumber = self.offers[indexPath.row];
    APILog(@"phoneNumber = %@",phoneNumber);
    
    [self.defaults setObject:phoneNumber forKey:WOCUserDefaultsLocalPhoneNumber];
    [self.defaults synchronize];
    [self refereshToken];
    [self performSelector:@selector(backToMainView) withObject:nil afterDelay:2.0];
}

// MARK: - API
- (void)getOffers {
    if (self.discoveryId != nil && [self.discoveryId length] > 0) {
        [[APIManager sharedInstance] discoveryInputs:self.discoveryId response:^(id responseDict, NSError *error) {
            if (error == nil) {
                NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)responseDict];
                
                if ([[responseDictionary valueForKey:@"singleDeposit"] isKindOfClass:[NSArray class]]) {
                    NSArray *offersArray = [[NSArray alloc] initWithArray:(NSArray*)[responseDictionary valueForKey:@"singleDeposit"]];
                    self.offers = [[NSArray alloc] initWithArray:offersArray];
                    
                    if ([[responseDictionary valueForKey:@"incremented"] boolValue]) {
                        self.incremented = true;
                        self.instructionLabel.text = [NSString stringWithFormat:@"Below are offers for at least $%@. You must click the ORDER button before you receive instructions to pay at the Cash Payment center.",self.amount];
                    }
                    else {
                        self.incremented = false;
                        self.instructionLabel.text = [NSString stringWithFormat:@"Below are offers for $%@. You must click the ORDER button before you receive instructions to pay at the Cash Payment center.",self.amount];
                    }
                }
                [self.numberListingTableView reloadData];
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error.userInfo != nil) {
                        if (error.userInfo[@"detail"] != nil) {
                            [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:error.userInfo[@"detail"]  viewController:self.navigationController.visibleViewController];
                        }
                        else {
                            [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:error.localizedDescription viewController:self.navigationController.visibleViewController];
                        }
                    }
                    else {
                        [[WOCAlertController sharedInstance] alertshowWithTitle:@"Error" message:error.localizedDescription viewController:self.navigationController.visibleViewController];
                    }
                });
            }
        }];
    }
}

- (void)getOrders:(NSInteger)sender {
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.navigationController.topViewController.view animated:YES];
    
    NSDictionary *params = @{
                            };
    
    [[APIManager sharedInstance] getOrders:nil response:^(id responseDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [hud hideAnimated:YES];
        });
        
        if (error == nil) {
            if ([responseDict isKindOfClass:[NSArray class]]) {
                NSArray *orders = [[NSArray alloc] initWithArray:(NSArray*)responseDict];
                if (orders.count > 0) {
                    NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
                    NSPredicate *wdvPredicate = [NSPredicate predicateWithFormat:@"status == 'WD'"];
                    NSArray *wdArray = [orders filteredArrayUsingPredicate:wdvPredicate];
                    NSDictionary *orderDict = (NSDictionary*)[orders objectAtIndex:0];
                    NSString *status = [NSString stringWithFormat:@"%@",[orderDict valueForKey:@"status"]];
                    
                    if ([status isEqualToString:@"WD"]) {
                        WOCBuyingInstructionsViewController *buyingInstructionsViewController = [self getViewController:@"WOCBuyingInstructionsViewController"];
                        buyingInstructionsViewController.phoneNo = phoneNo;
                        buyingInstructionsViewController.isFromSend = YES;
                        buyingInstructionsViewController.isFromOffer = NO;
                        buyingInstructionsViewController.orderDict = (NSDictionary*)[orders objectAtIndex:0];
                        [self pushViewController:buyingInstructionsViewController animated:YES];
                    }
                    else if (orders.count > 0) {
                        WOCBuyingSummaryViewController *buyingSummaryViewController = [self getViewController:@"WOCBuyingSummaryViewController"];
                        buyingSummaryViewController.phoneNo = phoneNo;
                        buyingSummaryViewController.orders = orders;
                        buyingSummaryViewController.isFromSend = YES;
                        [self pushViewController:buyingSummaryViewController animated:YES];
                    }
                    else {
                        [self backToMainView];
                    }
                }
                else {
                    NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
                    WOCBuyingInstructionsViewController *buyingInstructionsViewController = [self getViewController:@"WOCBuyingInstructionsViewController"];
                    buyingInstructionsViewController.phoneNo = phoneNo;
                    buyingInstructionsViewController.isFromSend = NO;
                    buyingInstructionsViewController.isFromOffer = YES;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender inSection:0];
                    NSDictionary *offerDict = self.offers[indexPath.row];
                    buyingInstructionsViewController.offerId = [NSString stringWithFormat:@"%@",[offerDict valueForKey:WOCApiResponseId]];
                    [self pushViewController:buyingInstructionsViewController animated:YES];
                }
            }
            else {
                NSString *phoneNo = [self.defaults valueForKey:WOCUserDefaultsLocalPhoneNumber];
                WOCBuyingInstructionsViewController *buyingInstructionsViewController = [self getViewController:@"WOCBuyingInstructionsViewController"];
                buyingInstructionsViewController.phoneNo = phoneNo;
                buyingInstructionsViewController.isFromSend = NO;
                buyingInstructionsViewController.isFromOffer = YES;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender inSection:0];
                NSDictionary *offerDict = self.offers[indexPath.row];
                buyingInstructionsViewController.offerId = [NSString stringWithFormat:@"%@",[offerDict valueForKey:WOCApiResponseId]];
                [self pushViewController:buyingInstructionsViewController animated:YES];
            }
        }
        else {
            [self pushToStep1];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[WOCAlertController sharedInstance] alertshowWithTitle:@"Alert" message:@"Token expired." viewController:self];
            });
        }
    }];
}

- (void)pushToStep1 {
    [self backToMainView];
}

// MARK: - IBAction
- (void)signInPhoneButtonClick:(UIButton *)sender {
    NSString *token = [self.defaults valueForKey:WOCUserDefaultsAuthToken];
    if (token != nil && (![token isEqualToString:@"(null)"])) {
        [self getOrderList];
    }
    else {
        [self pushToStep7:[sender tag]];
    }
}

- (IBAction)onExistingAccoutButtonClick:(id)sender {
    WOCBuyingWizardInputPhoneNumberViewController *buyingWizardInputPhoneNumberViewController = [self getViewController:@"WOCBuyingWizardInputPhoneNumberViewController"];
    buyingWizardInputPhoneNumberViewController.isForLoginOny = YES;
    [self pushViewController:buyingWizardInputPhoneNumberViewController animated:YES];
}

- (IBAction)onSignUpButtonClick:(id)sender {
    NSURL *url = [NSURL URLWithString:@"https://wallofcoins.com/signup/"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (IBAction)checkLocationClicked:(id)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSDictionary *offerDict = self.offers[indexPath.row];
    if (![[offerDict valueForKey:@"bankLocationUrl"] isEqual:[NSNull null]]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[offerDict valueForKey:@"bankLocationUrl"]]];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                APILog(@"URL opened!");
            }];
        }
    }
}

// MARK: - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.offers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WOCOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerCell"];
    cell.backgroundColor = [UIColor clearColor];
    NSString *phoneNumber = self.offers[indexPath.row];
    [cell.orderButton setTitle:[NSString stringWithFormat:@"SIGN IN: %@",phoneNumber] forState:UIControlStateNormal];
    [cell.orderButton setTitle:@"" forState:UIControlStateSelected];
    [cell.orderButton addTarget:self action:@selector(signInPhoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.orderButton.tag = indexPath.row;
    [cell.orderButton setTitleColor:WOCTHEMECOLOR forState:UIControlStateNormal];
    
    return cell;
}

// MARK: - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

@end

