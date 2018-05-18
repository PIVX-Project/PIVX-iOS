//
//  WOCSellingWizardOfferListViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"

//WOCSellingWizardOfferListViewController

// Offer List ViewController
@interface WOCSellingWizardOfferListViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *discoveryId;
@property (strong, nonatomic) NSString *amount;

@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITableView *offerListtTableView;

- (IBAction)orderClicked:(id)sender;
- (NSIndexPath*)getIndexPathfromTag:(NSInteger)tag;
@end
