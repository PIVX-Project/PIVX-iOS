//
//  WOCBuyingSummaryViewController.m
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#define WD @"WD"
#define WDV @"WDV"
#define RERR @"RERR"
#define DERR @"DERR"
#define RSD @"RSD"
#define RMIT @"RMIT"
#define UCRV @"UCRV"
#define PAYP @"PAYP"
#define SENT @"SENT"

#define STATUS_WD @"Waiting Deposit"
#define STATUS_WDV @"Waiting Deposit Verification"
#define STATUS_RERR @"Issue with Receipt"
#define STATUS_DERR @"Issue with Deposit"
#define STATUS_RSD @"Reserved for Deposit"
#define STATUS_RMIT @"Remit Address Missing"
#define STATUS_UCRV @"Under Review"
#define STATUS_PAYP @"Done - Pending Delivery"
#define STATUS_SENT @"Done - Units Delivered"

#import "WOCBuyingSummaryViewController.h"
#import "WOCSummaryCell.h"
#import "WOCSignOutCell.h"
#import "WOCBuyingWizardHomeViewController.h"
#import "WOCBuyingWizardInputAmountViewController.h"
#import "APIManager.h"
#import "BRRootViewController.h"
#import "BRAppDelegate.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "WOCAlertController.h"
#import "MBProgressHUD.h"
#import "WOCAsyncImageView.h"

@interface WOCBuyingSummaryViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSArray *wdOrders;
@property (strong, nonatomic) NSArray *otherOrders;

@end

@implementation WOCBuyingSummaryViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigation_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    [self setShadowOnButton:self.buyMoreDashButton];
    [self setAttributedString];
    
    if (self.orders.count == 0) {
        [self reloadOrderTable];
        [self getOrders];
        if (!self.isHideSuccessAlert) {
            [self displayAlert];
        }
    }
    else {
        
        NSPredicate *wdvPredicate = [NSPredicate predicateWithFormat:@"status == 'WD'"];
        NSArray *wdvArray = [self.orders filteredArrayUsingPredicate:wdvPredicate];
        self.wdOrders = [[NSArray alloc] initWithArray:wdvArray];
        
        NSPredicate *otherPredicate = [NSPredicate predicateWithFormat:@"status == 'WDV' || status == 'RERR' || status == 'DERR' || status == 'RSD' || status == 'RMIT' || status == 'UCRV' || status == 'PAYP' || status == 'SENT' || status == 'ACAN'"];
        NSArray *otherArray = [self.orders filteredArrayUsingPredicate:otherPredicate];
        self.otherOrders = [[NSArray alloc] initWithArray:otherArray];
        
        APILog(@"wdvArray count: %lu, otherArray count: %lu",(unsigned long)wdvArray.count,(unsigned long)otherArray.count);
        
         [self reloadOrderTable];
    }
    
    [self.buyMoreDashButton setTitleColor:WOCTHEMECOLOR forState:UIControlStateNormal];
}

- (void)setAttributedString {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"Wall of Coins will verify your payment. This usually takes up to 10 minutes. To expedite your order, take a picture of your receipt and click here to email your receipt to Wall of Coins." attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    [attributedString addAttribute:NSLinkAttributeName
                             value:@"support@wallofcoins.com"
                             range:[[attributedString string] rangeOfString:@"click here"]];
    
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                     NSUnderlineColorAttributeName: [UIColor blackColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    self.instructionTextField.linkTextAttributes = linkAttributes;
    self.instructionTextField.attributedText = attributedString;
    self.instructionTextField.delegate = self;
}

- (void)back:(id)sender {
    
    [self backToMainView];
}

- (NSString*)checkStatus:(NSString*)status {
    
    NSString *string = @"";
    
    if ([status isEqualToString:WD]) {
        string = [NSString stringWithFormat:@"Status: %@",STATUS_WD];
    }
    else if ([status isEqualToString:WDV]) {
        string = [NSString stringWithFormat:@"Status: %@",STATUS_WDV];
    }
    else if ([status isEqualToString:RERR]) {
        string = [NSString stringWithFormat:@"Status: %@",STATUS_RERR];
    }
    else if ([status isEqualToString:DERR]) {
        string = [NSString stringWithFormat:@"Status: %@",STATUS_DERR];
    }
    else if ([status isEqualToString:RMIT]) {
        string = [NSString stringWithFormat:@"Status: %@",STATUS_RMIT];
    }
    else if ([status isEqualToString:UCRV]) {
        string = [NSString stringWithFormat:@"Status: %@",STATUS_UCRV];
    }
    else if ([status isEqualToString:PAYP]) {
        string = [NSString stringWithFormat:@"Status: %@",STATUS_PAYP];
    }
    else if ([status isEqualToString:SENT]) {
        string = [NSString stringWithFormat:@"Status: %@",STATUS_SENT];
    }
    
    return string;
}

- (void)displayAlert {
    
    [[WOCAlertController sharedInstance] alertshowWithTitle:@"" message:[NSString stringWithFormat:@"Thank you for making the payment!\nOnce we verify your payment, we will send the %@ to your wallet!",WOCCurrency] viewController:self];
}

// MARK: - IBAction

- (IBAction)onBuyMoreDashButtonClick:(id)sender {
    [self backToMainView];
}

- (IBAction)onSignOutButtonClick:(id)sender {
    [self signOutWOC];
}

- (IBAction)wallOfCoinsClicked:(id)sender {
    
    NSURL *url = [NSURL URLWithString:@"https://wallofcoins.com"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            APILog(@"URL opened...");
        }];
    }
}

// MARK: - API
- (void)getOrders {
    
    MBProgressHUD *hud  = [MBProgressHUD showHUDAddedTo:self.navigationController.topViewController.view animated:YES];
    
    NSDictionary *params = @{
                            };
    
    [[APIManager sharedInstance] getOrders:nil response:^(id responseDict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [hud hideAnimated:YES];
        });
        
        if (error == nil) {
            if ([responseDict isKindOfClass:[NSArray class]]) {
                NSArray *response = [[NSArray alloc] initWithArray:(NSArray*)responseDict];
                self.orders = response;
                
                NSPredicate *wdvPredicate = [NSPredicate predicateWithFormat:@"status == 'WD'"];
                NSArray *wdvArray = [self.orders filteredArrayUsingPredicate:wdvPredicate];
                self.wdOrders = [[NSArray alloc] initWithArray:wdvArray];
                
                NSPredicate *otherPredicate = [NSPredicate predicateWithFormat:@"status == 'WDV' || status == 'RERR' || status == 'DERR' || status == 'RSD' || status == 'RMIT' || status == 'UCRV' || status == 'PAYP' || status == 'SENT' || status == 'ACAN'"];
                NSArray *otherArray = [self.orders filteredArrayUsingPredicate:otherPredicate];
                self.otherOrders = [[NSArray alloc] initWithArray:otherArray];
                
                APILog(@"wdvArray count: %lu, otherArray count: %lu",(unsigned long)wdvArray.count,(unsigned long)otherArray.count);
            }
        }
        else {
            [[WOCAlertController sharedInstance] alertshowWithError:error viewController:self.navigationController.visibleViewController];
        }
        
        [self reloadOrderTable];

    }];
}

- (void)reloadOrderTable{
    if (self.orders.count > 0) {
        self.instructionTextField.text = @"Wall of Coins will verify your payment. This usually takes up to 10 minutes. To expedite your order, take a picture of your receipt and click here to email your receipt to Wall of Coins.";
    }
    else {
        self.instructionTextField.text = [NSString stringWithFormat:@"You have no order history with %@ for iOS. To see your full order history across all devices, visit %@",WOCCryptoCurrency,BASE_URL_PRODUCTION];
    }
    self.instructionLabel.hidden  = YES;
    self.instructionTextField.hidden  = NO;
    [self.buyingSummaryTableView reloadData];
}
#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return self.wdOrders.count;
    }
    else if (section == 1) {
        return 1;
    }
    else if (section == 2){
        return 1;
    }
    else {
        return self.otherOrders.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        WOCSignOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"linkCell"];
        [cell.signOutButton addTarget:self action:@selector(wallOfCoinsClicked:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else if (indexPath.section == 2) {
        WOCSignOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signOutCell"];
        cell.descriptionLabel.text = [NSString stringWithFormat:@"Your wallet is signed into Wall of Coins using your mobile number %@",self.phoneNo];
        [cell.signOutButton addTarget:self action:@selector(onSignOutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    else {
        static const NSInteger IMAGE_VIEW_TAG = 98;
        NSString *cellIdentifier = @"offerCell";
        
        WOCSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"summaryCell"];
        
        NSDictionary *orderDict = [[NSDictionary alloc] init];
        
        if (indexPath.section == 0) {
            orderDict = self.wdOrders[indexPath.row];
            
            if (![[orderDict valueForKey:@"account"] isEqual:[NSNull null]]) {
                if ([[orderDict valueForKey:@"account"] length] > 16) {
                    cell = [tableView dequeueReusableCellWithIdentifier:@"summaryCell1"];
                    NSArray *accountArr = [NSJSONSerialization JSONObjectWithData:[[orderDict valueForKey:@"account"] dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displaySort" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
                        float aObj1 = [(NSString *)obj1 floatValue];
                        float aObj2 = [(NSString *)obj2 floatValue];
                        return aObj1 > aObj2;
                    }];
                    NSArray *accountArray = [accountArr sortedArrayUsingDescriptors:@[sort]];
                    cell.phoneLabel.hidden = YES;
                    if (accountArray.count > 0) {
                        cell.firstNameLabel.text = [NSString stringWithFormat:@"First Name: %@",REMOVE_NULL_VALUE([[accountArray objectAtIndex:0] valueForKey:@"value"])];
                    }
                    if (accountArray.count > 2) {
                        cell.lastNameLabel.text = [NSString stringWithFormat:@"Last Name: %@",REMOVE_NULL_VALUE([[accountArray objectAtIndex:2] valueForKey:@"value"])];
                    }
                    if (accountArray.count > 3) {
                        cell.birthCountryLabel.text = [NSString stringWithFormat:@"Country of Birth: %@",REMOVE_NULL_VALUE([[accountArray objectAtIndex:3] valueForKey:@"value"])];
                    }
                    if (accountArray.count > 1) {
                        cell.pickupStateLabel.text = [NSString stringWithFormat:@"Pick-up State: %@",REMOVE_NULL_VALUE([[accountArray objectAtIndex:1] valueForKey:@"value"])];
                    }
                }
            }
        }
        else {
            orderDict = self.otherOrders[indexPath.row];
        }
        
        NSString *bankLogo = REMOVE_NULL_VALUE([orderDict valueForKey:@"bankLogo"]);
        NSString *bankIcon = REMOVE_NULL_VALUE([orderDict valueForKey:@"bankIcon"]);
        NSString *bankName = REMOVE_NULL_VALUE([orderDict valueForKey:@"bankName"]);
        NSString *phoneNo = [NSString stringWithFormat:@"%@",REMOVE_NULL_VALUE([[orderDict valueForKey:@"nearestBranch"] valueForKey:@"phone"])];
        float depositAmount = [[orderDict valueForKey:@"payment"] floatValue];
        NSString *totalDash = REMOVE_NULL_VALUE([orderDict valueForKey:@"total"]);
        NSString *status = [NSString stringWithFormat:@"%@",REMOVE_NULL_VALUE([orderDict valueForKey:@"status"])];
        
        UIView *cellView = cell.bankImageView.superview;
        
        WOCAsyncImageView *imageView = (WOCAsyncImageView *)[cellView viewWithTag:IMAGE_VIEW_TAG];
        
        if (imageView == nil) {
            imageView = [[WOCAsyncImageView alloc] initWithFrame:cell.bankImageView.frame];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.image = [UIImage imageNamed:@"ic_account_balance_black"];
            imageView.tag = IMAGE_VIEW_TAG;
            [cellView addSubview:imageView];
        }
        
        cell.bankImageView.hidden = YES;
        imageView.hidden = NO;
        
        //get image view
        //cancel loading previous image for cell
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:imageView];
        //bankLogo
        if ([bankLogo length] > 0) {
            imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",bankLogo]];
        }
        else if ([bankIcon length] > 0) {
            imageView.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",bankIcon]];
            //cell.imgView.image = [UIImage imageNamed:@"ic_account_balance_black"];
        }
        
        cell.nameLabel.text = bankName;
        cell.phoneLabel.text = [NSString stringWithFormat:@"Location's phone #: %@",phoneNo];
        if ([[[orderDict valueForKey:@"nearestBranch"] valueForKey:@"phone"] isEqual:[NSNull null]]) {
            [cell.phoneLabel setHidden:YES];
        }
        cell.cashDepositLabel.text = [NSString stringWithFormat:@"Cash to Deposit: $%.02f",depositAmount];
        
        NSNumber *num = [NSNumber numberWithDouble:([totalDash doubleValue] * 1000000)];
        NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
        [numFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        //[numFormatter setAllowsFloats:YES];
        [numFormatter setAlwaysShowsDecimalSeparator:YES];
        //[numFormatter setDecimalSeparator:@"."];
        [numFormatter setUsesGroupingSeparator:YES];
        [numFormatter setGroupingSeparator:@","];
        [numFormatter setGroupingSize:3];
        NSString *stringNum = [numFormatter stringFromNumber:num];
        cell.totalDashLabel.text = [NSString stringWithFormat:@"Total %@: %@ (%@ %@)",WOCCurrencySpecial,totalDash,stringNum,WOCCurrencySymbolMinor];
        cell.statusLabel.text = [self checkStatus:status];
        
        return cell;
    }
}

// MARK: - UITableView Delegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 3) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.buyingSummaryTableView.frame.size.width, 50)];
        headerView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, headerView.frame.size.width - 30, headerView.frame.size.height - 15)];
        lblTitle.text = @"Order History";
        lblTitle.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.backgroundColor = [UIColor whiteColor];
        lblTitle.layer.cornerRadius = 10.0;
        lblTitle.layer.masksToBounds = YES;
        
        [self setShadowOnView:lblTitle];
        [headerView addSubview:lblTitle];
        return headerView;
    }
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 3) {
        if (self.otherOrders.count > 0) {
            return 50;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1 || indexPath.section == 2) {
        return 110.0;
    }
    else {
        NSDictionary *orderDict = [[NSDictionary alloc] init];
        if (indexPath.section == 0) {
            orderDict = self.wdOrders[indexPath.row];
            if (![[orderDict valueForKey:@"account"] isEqual:[NSNull null]]) {
                if ([[orderDict valueForKey:@"account"] length] > 16) {
                    return 250.0;
                }
            }
        }
        else {
            orderDict = self.otherOrders[indexPath.row];
        }
        return 185.0;
    }
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
  
    if ([[URL absoluteString] hasPrefix:@"support"]) {
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            
            NSDictionary *orderDict = [self.orders objectAtIndex:0];
            [mailController setSubject:[NSString stringWithFormat:@"Order #{%@} - {%@}",[orderDict valueForKey:@"id"],self.phoneNo]];
            [mailController setToRecipients:[NSArray arrayWithObject:@"support@wallofcoins.com"]];
            [mailController setMessageBody:@"" isHTML:NO];
            [self presentViewController:mailController animated:YES completion:nil];
        }
        return NO;
    }
    return YES;
}

#pragma mark - MFMailComposer Delegate
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

