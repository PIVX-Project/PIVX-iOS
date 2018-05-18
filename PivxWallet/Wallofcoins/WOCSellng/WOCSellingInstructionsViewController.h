//
//  WOCSellingInstructionsViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
@interface WOCSellingInstructionsViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *purchaseCode;
@property (strong, nonatomic) NSString *holdId;
@property (strong, nonatomic) NSString *offerId;
@property (strong, nonatomic) NSString *phoneNo;
@property (strong, nonatomic) NSDictionary *orderDict;
@property (assign, nonatomic) BOOL isFromSend;
@property (assign, nonatomic) BOOL isFromOffer;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lblBankName;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckLocation;

@property (weak, nonatomic) IBOutlet UILabel *lblAccountName;
@property (weak, nonatomic) IBOutlet UILabel *lblAccountNo;
@property (weak, nonatomic) IBOutlet UILabel *lblCashDeposit;
@property (weak, nonatomic) IBOutlet UILabel *lblDepositDue;
@property (weak, nonatomic) IBOutlet UIButton *btnDepositFinished;
@property (weak, nonatomic) IBOutlet UIButton *btnCancelOrder;

@property (weak, nonatomic) IBOutlet UILabel *lblInstructions;
@property (weak, nonatomic) IBOutlet UITextView *txtInstruction;
@property (weak, nonatomic) IBOutlet UIButton *btnWallOfCoins;
@property (weak, nonatomic) IBOutlet UILabel *lblLoginPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnSignOut;

- (IBAction)showMapClicked:(id)sender;
- (IBAction)depositFinishedClicked:(id)sender;
- (IBAction)cancelOrderClicked:(id)sender;
- (IBAction)wallOfCoinsClicked:(id)sender;
- (IBAction)onSignOutButtonClick:(id)sender;
- (void)captureHold:(NSString*)purchaseCode holdId:(NSString*)holdId ;
- (void)deleteHold:(NSString*)holdId count:(NSUInteger)count;

@end
