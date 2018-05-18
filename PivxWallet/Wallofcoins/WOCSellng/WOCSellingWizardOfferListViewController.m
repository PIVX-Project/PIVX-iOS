//
//  WOCSellingWizardOfferListViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCSellingWizardOfferListViewController.h"
#import "WOCSellingWizardInputEmailViewController.h"
#import "WOCSellingInstructionsViewController.h"
#import "WOCSellingSummaryViewController.h"
#import "BRRootViewController.h"
#import "BRAppDelegate.h"
#import "WOCOfferCell.h"
#import "APIManager.h"
#import "BRWalletManager.h"
#import "WOCAlertController.h"
#import "MBProgressHUD.h"
#import "WOCSellingWizardHomeViewController.h"
#import "WOCAsyncImageView.h"

@interface WOCSellingWizardOfferListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray *offers;
@property (strong, nonatomic) NSMutableDictionary *offersDict;

@property (assign, nonatomic) BOOL incremented;
@property (assign, nonatomic) BOOL isExtendedSearch;
@end

@implementation WOCSellingWizardOfferListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.instructionLabel.text = [NSString stringWithFormat:@"Below are offers for at least $%@. You must click the ORDER button before you receive instructions to pay at the Cash Payment center.",self.amount];
    [self getOffers];
}

- (void)pushToStep6:(NSInteger)sender {
    
    NSIndexPath *indexPath = [self getIndexPathfromTag:sender];
    NSString *key = self.offersDict.allKeys[indexPath.section];
    NSArray *offerArray = self.offersDict[key];
    NSDictionary *offerDict = offerArray[indexPath.row];
    WOCSellingWizardInputEmailViewController *inputEmailViewController = (WOCSellingWizardInputEmailViewController*)[self getViewController:@"WOCSellingWizardInputEmailViewController"];
    inputEmailViewController.offerId = [NSString stringWithFormat:@"%@",[offerDict valueForKey:@"id"]];
    [self pushViewController:inputEmailViewController animated:YES];
}

// MARK: - API

- (void)getOffers {
    
    self.offersDict = [NSMutableDictionary dictionaryWithCapacity:0];
    if (self.discoveryId != nil && [self.discoveryId length] > 0) {
        
         MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.navigationController.topViewController.view animated:YES];
        
        [[APIManager sharedInstance] discoveryInputs:self.discoveryId response:^(id responseDict, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hideAnimated:YES];
            });
            
            if (error == nil) {
                
                NSDictionary *responseDictionary = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)responseDict];
                
                if ([[responseDictionary valueForKey:@"isExtendedSearch"] boolValue]) {
                    self.isExtendedSearch = YES;
                    
                    self.instructionLabel.text = [NSString stringWithFormat:@"Most Convenient Options While $%@ is not available, we gathered the closest options.You must click the ORDER button before you receive instructions to pay at the Cash Payment center.",self.amount];
                }
                else {
                    self.isExtendedSearch = NO;
                    
                    if ([[responseDictionary valueForKey:@"incremented"] boolValue]) {
                        self.incremented = YES;
                        self.instructionLabel.text = [NSString stringWithFormat:@"Below are offers for at least $%@. You must click the ORDER button before you receive instructions to pay at the Cash Payment center.",self.amount];
                    }
                    else {
                        self.incremented = NO;
                        self.instructionLabel.text = [NSString stringWithFormat:@"Below are offers for $%@. You must click the ORDER button before you receive instructions to pay at the Cash Payment center.",self.amount];
                    }
                }
                
                if ([responseDictionary valueForKey:@"singleDeposit"] != nil) {
                    
                    if ([[responseDictionary valueForKey:@"singleDeposit"] isKindOfClass:[NSArray class]] ) {
                        
                        NSArray *offersArray = [[NSArray alloc] initWithArray:(NSArray*)[responseDictionary valueForKey:@"singleDeposit"]];
                        self.offers = [[NSArray alloc] initWithArray:offersArray];
                        if (offersArray.count > 0) {
                            self.offersDict[@""] = offersArray;
                        }
                    }
                }
                
                if ([responseDictionary valueForKey:@"doubleDeposit"] != nil) {
                    
                    if ([[responseDictionary valueForKey:@"doubleDeposit"] isKindOfClass:[NSArray class]] ) {
                        
                        NSArray *offersArray = [[NSArray alloc] initWithArray:(NSArray*)[responseDictionary valueForKey:@"doubleDeposit"]];
                        NSArray *doubleOffer = [self getOffersFromDoubleDeposit:offersArray];
                        if (doubleOffer.count > 0) {
                            if (self.isExtendedSearch) {
                                NSString *key = [NSString stringWithFormat:@"Best Value options: more %@ for under $%@ cash.",WOCCurrency,self.amount];
                               self.offersDict[key] = doubleOffer;
                            }
                            else {
                                NSString *key = [NSString stringWithFormat:@"Best Value options: more %@ for $%@ cash.",WOCCurrency,self.amount];
                                self.offersDict[key] = doubleOffer;
                            }
                        }
                    }
                }
                
                if ([responseDictionary valueForKey:@"multipleBanks"] != nil) {
                    
                    if ([[responseDictionary valueForKey:@"multipleBanks"] isKindOfClass:[NSArray class]] ) {
                        
                        NSArray *offersArray = [[NSArray alloc] initWithArray:(NSArray*)[responseDictionary valueForKey:@"multipleBanks"]];
                        NSArray *multipleBankOffer = [self getOffersFromDoubleDeposit:offersArray]; NSArray *doubleOffer = [self getOffersFromDoubleDeposit:offersArray];
                        if (multipleBankOffer.count > 0) {
                            if (self.isExtendedSearch) {
                                NSString *key = [NSString stringWithFormat:@"Best Value options: more %@ for under $%@ cash from multiple banks.",WOCCurrency,self.amount];
                                self.offersDict[key] = multipleBankOffer;
                            }
                            else {
                                NSString *key = [NSString stringWithFormat:@"Best Value options: more %@ for $%@ cash from multiple banks.",WOCCurrency,self.amount];
                                self.offersDict[key] = multipleBankOffer;
                            }
                        }
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                  [self.offerListtTableView reloadData];
                });
                
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

- (NSArray*)getOffersFromDoubleDeposit:(NSArray*)doubleDepositOffers
{
    NSMutableArray *signleDepositOfferArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *offerDictionary in doubleDepositOffers)
    {
        NSMutableDictionary *reviceOfferDict = [[NSMutableDictionary alloc] initWithCapacity:0];
        reviceOfferDict[@"deposit"] = @{
                                     @"currency": REMOVE_NULL_VALUE(offerDictionary[@"totalDeposit"][@"currency"]),
                                     @"amount": REMOVE_NULL_VALUE(offerDictionary[@"totalDeposit"][@"amount"])
                                     };
        reviceOfferDict[@"id"] = offerDictionary[@"id"];

        if (offerDictionary[@"firstOffer"] != nil) {
            NSDictionary *firstOfferDict = offerDictionary[@"firstOffer"];
            
            reviceOfferDict[@"crypto"] = firstOfferDict[@"crypto"];
            reviceOfferDict[@"amount"] = @{
                                        @"DASH" : REMOVE_NULL_VALUE(firstOfferDict[@"amount"][@"DASH"]),
                                        @"dots" : REMOVE_NULL_VALUE(firstOfferDict[@"amount"][@"dots"]),
                                        @"bits" : REMOVE_NULL_VALUE(firstOfferDict[@"amount"][@"bits"]),
                                        @"BTC" : REMOVE_NULL_VALUE(firstOfferDict[@"amount"][@"BTC"])
                                        };
            reviceOfferDict[@"discoveryId"] = REMOVE_NULL_VALUE(firstOfferDict[@"discoveryId"]);
            reviceOfferDict[@"distance"] =  REMOVE_NULL_VALUE(firstOfferDict[@"distance"]);
            reviceOfferDict[@"address"] =  REMOVE_NULL_VALUE(firstOfferDict[@"address"] );
            reviceOfferDict[@"state"] = REMOVE_NULL_VALUE(firstOfferDict[@"state"]) ;
            reviceOfferDict[@"bankName"] = REMOVE_NULL_VALUE(firstOfferDict[@"bankName"]) ;
            reviceOfferDict[@"bankLogo"] =  REMOVE_NULL_VALUE(firstOfferDict[@"bankLogo"]) ;
            reviceOfferDict[@"bankIcon"] = REMOVE_NULL_VALUE(firstOfferDict[@"bankIcon"]) ;
            reviceOfferDict[@"bankLocationUrl"] =  REMOVE_NULL_VALUE(firstOfferDict[@"bankLocationUrl"]);
            reviceOfferDict[@"city"] = REMOVE_NULL_VALUE(firstOfferDict[@"city"]);
            
            
            if (offerDictionary[@"secondOffer"] != nil) {
                NSDictionary *secondOffer = offerDictionary[@"secondOffer"];
                if (![REMOVE_NULL_VALUE(firstOfferDict[@"bankName"]) isEqualToString:REMOVE_NULL_VALUE(secondOffer[@"bankName"])]) {
                    reviceOfferDict[@"isMultipleBank"] = @YES;
                    reviceOfferDict[@"otherBankName"] = REMOVE_NULL_VALUE(secondOffer[@"bankName"]);
                    reviceOfferDict[@"otherBankLogo"] = REMOVE_NULL_VALUE(secondOffer[@"bankLogo"]);
                }
                
                NSDictionary *amountDict = firstOfferDict[@"amount"];
                NSDictionary *secondAmountDict = offerDictionary[@"secondOffer"];
                
                NSNumber *firstOfferMinorNumber = [NSNumber numberWithFloat:[NSString stringWithFormat:@"%@",[REMOVE_NULL_VALUE(firstOfferDict[@"amount"][WOCCryptoCurrencySmall]) stringByReplacingOccurrencesOfString:@"," withString:@""]].floatValue];
                
                NSNumber *secondOfferMinorNumber = [NSNumber numberWithFloat:[NSString stringWithFormat:@"%@",[REMOVE_NULL_VALUE(secondOffer[@"amount"][WOCCryptoCurrencySmall]) stringByReplacingOccurrencesOfString:@"," withString:@""]].floatValue];
                
                NSNumber *totoalMinorNumber =  [NSNumber numberWithFloat:(firstOfferMinorNumber.longLongValue + secondOfferMinorNumber.floatValue)] ;
                
                NSString *totalMinorStr = [self getCryptoPrice:totoalMinorNumber];
                APILog(@"totalMinorStr = %@",totalMinorStr);
                
                NSNumber *firstOfferMajorNumber = [NSNumber numberWithFloat:[NSString stringWithFormat:@"%@",[REMOVE_NULL_VALUE(firstOfferDict[@"amount"][WOCCryptoCurrency]) stringByReplacingOccurrencesOfString:@"," withString:@""]].floatValue];
                
                NSNumber *secondOfferMajorNumber = [NSNumber numberWithFloat:[NSString stringWithFormat:@"%@",[REMOVE_NULL_VALUE(secondOffer[@"amount"][WOCCryptoCurrency]) stringByReplacingOccurrencesOfString:@"," withString:@""]].floatValue];
                
                NSNumber *totoalMajorNumber =  [NSNumber numberWithFloat:(firstOfferMajorNumber.longLongValue + secondOfferMajorNumber.floatValue)] ;
                
                NSString *totalMajorStr = [self getCryptoPrice:totoalMajorNumber];
                APILog(@"totalMajorStr = %@",totalMajorStr);

                reviceOfferDict[@"amount"] = @{
                                            WOCCryptoCurrency : totalMajorStr,
                                            WOCCryptoCurrencySmall : totalMinorStr,
                                            @"bits" : [NSNumber numberWithFloat:([amountDict[@"bits"] floatValue] + [secondAmountDict[@"bits"] floatValue])],
                                            @"BTC" : [NSNumber numberWithFloat:([amountDict[@"BTC"] floatValue] + [secondAmountDict[@"BTC"] floatValue])]
                                            };
            }
            
            [signleDepositOfferArray addObject:reviceOfferDict];
        }
    }
    return (NSArray*)signleDepositOfferArray;
}

- (void)getOrders:(NSInteger)sender {
    
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.navigationController.topViewController.view animated:YES];
    
    NSDictionary *params = @{
                            };
    
    [[APIManager sharedInstance] getOrders:nil response:^(id responseDict, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [hud hideAnimated:YES];
        });
        
        NSString *phoneNo = [[NSUserDefaults standardUserDefaults] valueForKey:WOCUserDefaultsLocalPhoneNumber];

        if (error == nil) {
            if ([responseDict isKindOfClass:[NSArray class]]) {
                NSArray *orders = [[NSArray alloc] initWithArray:(NSArray*)responseDict];
                if (orders.count > 0) {
                    NSPredicate *wdvPredicate = [NSPredicate predicateWithFormat:@"status == 'WD'"];
                    NSArray *wdArray = [orders filteredArrayUsingPredicate:wdvPredicate];
                    if (wdArray.count > 0) {
                        NSDictionary *orderDict = (NSDictionary*)[wdArray objectAtIndex:0];
                        NSString *status = [NSString stringWithFormat:@"%@",[orderDict valueForKey:@"status"]];
                        if ([status isEqualToString:@"WD"]) {
                            WOCSellingInstructionsViewController *instructionsViewController = [self getViewController:@"WOCSellingInstructionsViewController"];
                            instructionsViewController.phoneNo = phoneNo;
                            instructionsViewController.isFromSend = YES;
                            instructionsViewController.isFromOffer = NO;
                            instructionsViewController.orderDict = orderDict;
                            [self pushViewController:instructionsViewController animated:YES];
                            return ;
                        }
                    }
                }
            }
            
            WOCSellingInstructionsViewController *instructionsViewController = [self getViewController:@"WOCSellingInstructionsViewController"];
            instructionsViewController.phoneNo = phoneNo;
            instructionsViewController.isFromSend = NO;
            instructionsViewController.isFromOffer = YES;
            
            NSIndexPath *indexPath = [self getIndexPathfromTag:sender];
            NSString *key = self.offersDict.allKeys[indexPath.section];
            NSArray *offerArray = self.offersDict[key];
            NSDictionary *offerDict = offerArray[indexPath.row];
            
            instructionsViewController.offerId = [NSString stringWithFormat:@"%@",[offerDict valueForKey:WOCApiResponseId]];
            [self pushViewController:instructionsViewController animated:YES];
        }
        else {
            [self refereshToken];
        }
    }];
}

// MARK: - IBAction

- (IBAction)orderClicked:(id)sender {
    
    NSString *token = [self.defaults valueForKey:WOCUserDefaultsAuthToken];
    if (token != nil && (![token isEqualToString:@"(null)"])) {
        [self getOrders:[sender tag]];
    }
    else {
        [self pushToStep6:[sender tag]];
    }
}

- (IBAction)checkLocationClicked:(id)sender {
    
    NSIndexPath *indexPath = [self getIndexPathfromTag:[sender tag]];
    NSString *key = self.offersDict.allKeys[indexPath.section];
    NSArray *offerArray = self.offersDict[key];
    NSDictionary *offerDict = offerArray[indexPath.row];
    
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.offersDict.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    NSString *key = self.offersDict.allKeys[section];
    NSArray *offerArray = self.offersDict[key];
    return offerArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    static const NSInteger IMAGE_VIEW_TAG = 98;
    static const NSInteger OTHER_IMAGE_VIEW_TAG = 99;
    NSString *cellIdentifier = @"offerCell";
    WOCOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIView *cellView = cell.bankImageView.superview;
    
    WOCAsyncImageView *imageView = (WOCAsyncImageView *)[cellView viewWithTag:IMAGE_VIEW_TAG];
    WOCAsyncImageView *otherImageView = (WOCAsyncImageView *)[cellView viewWithTag:OTHER_IMAGE_VIEW_TAG];
    
    if (imageView == nil) {
        imageView = [[WOCAsyncImageView alloc] initWithFrame:cell.bankImageView.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.image = [UIImage imageNamed:@"ic_account_balance_black"];
        imageView.tag = IMAGE_VIEW_TAG;
        [cellView addSubview:imageView];
    }
    
    if (otherImageView == nil) {
        
        otherImageView = [[WOCAsyncImageView alloc] initWithFrame:cell.otherBankImageView.frame];
        otherImageView.contentMode = UIViewContentModeScaleAspectFill;
        otherImageView.clipsToBounds = YES;
        otherImageView.image = [UIImage imageNamed:@"ic_account_balance_black"];
        otherImageView.tag = OTHER_IMAGE_VIEW_TAG;
        [cellView addSubview:otherImageView];
        otherImageView.hidden = YES;
    }
    
    cell.bankImageView.hidden = YES;
    cell.otherBankImageView.hidden = YES;
    otherImageView.hidden = YES;
    imageView.hidden = NO;
    
    //get image view
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
    [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:otherImageView];
    
    NSString *key = self.offersDict.allKeys[indexPath.section];
    NSArray *offerArray = self.offersDict[key];
    
    NSDictionary *offerDict = offerArray[indexPath.row];
    if (self.incremented || self.isExtendedSearch) {
        cell.dollarLabel.hidden = NO;
    }
    else {
        cell.dollarLabel.hidden = NO;
    }
    
    NSString *dashAmount = [NSString stringWithFormat:@"%@ %@",WOCCurrencySymbol,REMOVE_NULL_VALUE([[offerDict valueForKey:@"amount"] valueForKey:WOCCryptoCurrency])];
    NSString *bits = [NSString stringWithFormat:@"(%@ %@)",WOCCurrencySymbolMinor,REMOVE_NULL_VALUE([[offerDict valueForKey:@"amount"] valueForKey:WOCCryptoCurrencySmall])];
    NSString *dollarAmount = [NSString stringWithFormat:@"Pay $%@",REMOVE_NULL_VALUE([[offerDict valueForKey:@"deposit"] valueForKey:@"amount"])];
    NSString *bankName = [NSString stringWithFormat:@"%@",REMOVE_NULL_VALUE([offerDict valueForKey:@"bankName"])];
    NSString *bankAddress = [NSString stringWithFormat:@"%@",REMOVE_NULL_VALUE([offerDict valueForKey:@"address"])];
    NSString *bankLocationUrl = [NSString stringWithFormat:@"%@",REMOVE_NULL_VALUE([offerDict valueForKey:@"bankLocationUrl"])];
    NSString *bankLogo = [NSString stringWithFormat:@"%@",REMOVE_NULL_VALUE([offerDict valueForKey:@"bankLogo"])];
    NSString *bankIcon = [NSString stringWithFormat:@"%@",REMOVE_NULL_VALUE([offerDict valueForKey:@"bankIcon"])];
    NSString *otherbankLogo = [NSString stringWithFormat:@"%@",REMOVE_NULL_VALUE([offerDict valueForKey:@"otherBankLogo"])];

    cell.locationLabel.font = [UIFont systemFontOfSize:12];
    cell.dashTitleLabel.text = dashAmount;
    cell.dashSubTitleLabel.text = bits;
    cell.dollarLabel.text = dollarAmount;
    cell.bankNameLabel.text = bankName;
    cell.locationLabel.text = bankAddress;
    
    if (bankLocationUrl.length > 0) {
        cell.locationButton.hidden = NO;
        cell.locationButton.tag = indexPath.section * 100000 + indexPath.row;
        [cell.locationButton addTarget:self action:@selector(checkLocationClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (offerDict[@"isMultipleBank"] != nil) {
        
        BOOL isMultipleBank = [offerDict valueForKey:@"isMultipleBank"];
        
        if (isMultipleBank) {
            bankAddress = [offerDict valueForKey:@"otherBankName"];
            cell.locationLabel.font = cell.bankNameLabel.font;
        }
    
        
        if ([otherbankLogo length] > 0) {
            otherImageView.hidden = NO;
            //load the image
            otherImageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",otherbankLogo]];
        }
    }
   
    
    //bankLogo
    if ([bankLogo length] > 0) {
        
        imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",bankLogo]];
    }
    else if ([bankIcon length] > 0) {
        
        imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",bankIcon]];
        
        cell.bankImageView.image = [UIImage imageNamed:@"ic_account_balance_black"];
    }
    
    cell.orderButton.tag = indexPath.section * 100000 + indexPath.row;
    [cell.orderButton addTarget:self action:@selector(orderClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

// MARK: - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *key = self.offersDict.allKeys[indexPath.section];
    NSArray *offerArray = self.offersDict[key];
    NSDictionary *offerDict = offerArray[indexPath.row];
    if (offerDict[@"isMultipleBank"] != nil) {
        BOOL isMultipleBank = [offerDict valueForKey:@"isMultipleBank"];
        if (isMultipleBank) {
            return 150.0;
        }
    }
    return 125.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    float height = 20.0;
    if (section > 0) {
        height = 50.0;
    }
    NSString *key = self.offersDict.allKeys[section];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.frame.size.width, height)];
    UILabel *lblHeader = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, headerView.frame.size.width-20.0, height)];
    lblHeader.text = key;
    lblHeader.numberOfLines = 2.0;
    lblHeader.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    lblHeader.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:lblHeader];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0){
        return 50.0;
    }
    return 20.0;
}

- (NSIndexPath*)getIndexPathfromTag:(NSInteger)tag {
    
    int row = tag % 100000;
    int section = tag / 100000;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return indexPath;
}
@end

