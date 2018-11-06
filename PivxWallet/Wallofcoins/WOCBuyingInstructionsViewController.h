//
//  WOCBuyingInstructionsViewController.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOCBaseViewController.h"
@interface WOCBuyingInstructionsViewController : WOCBaseViewController

@property (strong, nonatomic) NSString *purchaseCode;
@property (strong, nonatomic) NSString *holdId;
@property (strong, nonatomic) NSString *offerId;
@property (strong, nonatomic) NSString *phoneNo;
@property (strong, nonatomic) NSDictionary *orderDict;
@property (assign, nonatomic) BOOL isFromSend;
@property (assign, nonatomic) BOOL isFromOffer;

@property (weak, nonatomic) IBOutlet UIImageView *bankImageView;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkLocationButton;

@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashDepositLabel;
@property (weak, nonatomic) IBOutlet UILabel *depositDueLabel;
@property (weak, nonatomic) IBOutlet UIButton *depositFinishedButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelOrderButton;

@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UITextView *instructionTextField;
@property (weak, nonatomic) IBOutlet UIButton *wallOfCoinsButton;
@property (weak, nonatomic) IBOutlet UILabel *loginPhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (weak, nonatomic) IBOutlet UIButton *showOnMapNearbyButton;
@property (weak, nonatomic) IBOutlet UILabel *orderDetailFirstLable;

- (IBAction)onShowMapButtonClicked:(id)sender;
- (IBAction)onDepositFinishedButtonClicked:(id)sender;
- (IBAction)onCancelOrderButtonClicked:(id)sender;
- (IBAction)onWallOfCoinsButtonClicked:(id)sender;
- (IBAction)onSignOutButtonClicked:(id)sender;
- (void)captureHold:(NSString*)purchaseCode holdId:(NSString*)holdId ;
- (void)deleteHold:(NSString*)holdId count:(NSUInteger)count;

@end
