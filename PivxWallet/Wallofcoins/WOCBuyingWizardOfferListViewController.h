//
//  WOCBuyingWizardOfferListViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
//WOCBuyingWizardOfferListViewController
// Offer List ViewController
@interface WOCBuyingWizardOfferListViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *discoveryId;
@property (strong, nonatomic) NSString *amount;

@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITableView *offerListTableView;
@property (weak, nonatomic) IBOutlet UILabel *informationLable;

- (IBAction)onOrderButtonClicked:(id)sender;
- (NSIndexPath*)getIndexPathfromTag:(NSInteger)tag;

@end
