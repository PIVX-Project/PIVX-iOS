//
//  WOCBuyingSummaryViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
@interface WOCBuyingSummaryViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *phoneNo;
@property (strong, nonatomic) NSArray *orders;
@property (assign, nonatomic) BOOL isFromSend;
@property (assign, nonatomic) BOOL isHideSuccessAlert;
@property (weak, nonatomic) IBOutlet UITextView *instructionTextField;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UITableView *buyingSummaryTableView;
@property (weak, nonatomic) IBOutlet UIButton *buyMoreDashButton;

- (IBAction)onBuyMoreDashButtonClick:(id)sender;
- (void)displayAlert;

@end
