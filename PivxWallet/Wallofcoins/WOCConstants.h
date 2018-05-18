//
//  WOCConstants.h
//  Wallofcoins
//
//  Created by Genitrust on 24/01/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#ifndef WOCConstants_h
#define WOCConstants_h

#define SHOW_LOGS NO

#ifdef SHOW_LOGS
#define APILog(x, ...) //NSLog(@"\n\n%s %d: \n" x, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define APILog(x, ...)
#endif
#define Str(str) (str != [NSNull null])?str:@""
#define ALERT_TITLE [NSString stringWithFormat:@"%@ Wallet",WOCCurrency]

#define REMOVE_NULL_VALUE(value) (value == nil)?@"":(![value isEqual:[NSNull null]])?value:@""

//static const BOOL isProduction = NO; //  IF TESTNET SET DASH_TESTNET = 1
static const BOOL isProduction = YES; //  IF MAINNET SET DASH_TESTNET = 0

#define BASE_URL_PRODUCTION @"https://wallofcoins.com"
#define BASE_URL_DEVELOPMENT @"https://wallofcoins.com"
#define API_FOLDER @"api"
#define API_VERSION @"v1"

#define API_DATE_FORMAT @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ"
#define LOCAL_DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"

#define WOCApiBodyDeviceName_IOS [NSString stringWithFormat:@"%@ Wallet (iOS)",WOCCurrency]

#pragma mark - USER DEFAULT KEYS

static NSString * const WOCUserDefaultsAuthToken = @"WOCUserDefaultsAuthToken";
static NSString * const WOCUserDefaultsLocalLocationLatitude = @"WOCUserDefaultLocalLocationLatitude";
static NSString * const WOCUserDefaultsLocalLocationLongitude = @"WOCUserDefaultLocalLocationLongitude";
static NSString * const WOCUserDefaultsLocalDeviceCode = @"WOCUserDefaultsLocalDeviceCode";
static NSString * const WOCUserDefaultsLocalDeviceId = @"WOCUserDefaultsLocalDeviceId";
static NSString * const WOCUserDefaultsLocalCountryCode = @"WOCUserDefaultLocalCountryCode";
static NSString * const WOCUserDefaultsLaunchStatus = @"WOCUserDefaultsLaunchStatus";
static NSString * const WOCUserDefaultsLocalDeviceInfo = @"WOCUserDefaultsLocalDeviceInfo";
static NSString * const WOCUserDefaultsLocalPhoneNumber = @"WOCUserDefaultsLocalPhoneNumber";
static NSString * const WOCUserDefaultsLocalEmail = @"WOCUserDefaultsLocalEmail";
static NSString * const WOCUserDefaultsLocalBankInfo = @"WOCUserDefaultsLocalBankInfo";
static NSString * const WOCUserDefaultsLocalBankName = @"WOCUserDefaultsLocalBankName";
static NSString * const WOCUserDefaultsLocalBankAccount = @"WOCUserDefaultsLocalBankAccount";
static NSString * const WOCUserDefaultsLocalBankAccountNumber = @"WOCUserDefaultsLocalBankAccountNumber";
static NSString * const WOCUserDefaultsLocalPrice = @"WOCUserDefaultsLocalPrice";
static NSString * const WOCUserDefaultsLocalMinDeposit = @"WOCUserDefaultsLocalMinDeposit";
static NSString * const WOCUserDefaultsLocalMaxDeposit = @"WOCUserDefaultsLocalMaxDeposit";

#pragma mark - NOTIFICATION OBSERVER NAME

static NSString * const WOCNotificationObserverNameBuyDashStep1 = @"WOCNotificationObserverNameBuyDashStep1";
static NSString * const WOCNotificationObserverNameBuyDashStep2 = @"WOCNotificationObserverNameBuyDashStep2";
static NSString * const WOCNotificationObserverNameBuyDashStep4 = @"WOCNotificationObserverNameBuyDashStep4";
static NSString * const WOCNotificationObserverNameBuyDashStep8 = @"WOCNotificationObserverNameBuyDashStep8";

#pragma mark - API PARAMETERS KEYS

static NSString * const WOCApiHeaderContentType = @"Content-Type";
static NSString * const WOCApiHeaderPublisherId = @"X-Coins-Publisher";
static NSString * const WOCApiHeaderToken = @"X-Coins-Api-Token";
static NSString * const WOCApiBodyCryptoAmount = @"cryptoAmount";
static NSString * const WOCApiBodyUsdAmount = @"usdAmount";
static NSString * const WOCApiBodyCrypto = @"crypto";
static NSString * const WOCApiBodyCryptoAddress = @"cryptoAddress";
static NSString * const WOCApiBodyBank = @"bank";
static NSString * const WOCApiBodyZipCode = @"zipCode";
static NSString * const WOCApiBodyOffer = @"offer";
static NSString * const WOCApiBodyDeviceName = @"deviceName";
static NSString * const WOCApiBodyDeviceCode = @"deviceCode";
static NSString * const WOCApiBodyDeviceId = @"deviceId";
static NSString * const WOCApiBodyCode = @"code";
static NSString * const WOCApiBodyName = @"name";
static NSString * const WOCApiBodyPhoneNumber = @"phone";
static NSString * const WOCApiBodyEmail = @"email";
static NSString * const WOCApiBodyJsonParameter = @"JSONPara";
static NSString * const WOCApiBodyVerificationCode = @"verificationCode";
static NSString * const WOCApiBodyPassword = @"password";
static NSString * const WOCApiBodyLatitude = @"latitude";
static NSString * const WOCApiBodyLongitude = @"longitude";
static NSString * const WOCApiBodyBrowserLocation = @"browserLocation";
static NSString * const WOCApiBodyCountry = @"country";
static NSString * const WOCApiBodyCountryCode = @"CountryCode";

#pragma mark - API PARAMETERS KEYS

static NSString * const WOCApiResponseToken = @"token";
static NSString * const WOCApiResponseId = @"id";
static NSString * const WOCApiResponseDeviceId = @"deviceId";
static NSString * const WOCApiResponsePurchaseCde = @"__PURCHASE_CODE";
static NSString * const WOCApiResponseHolds = @"holds";
static NSString * const WOCApiResponseHoldsStatus = @"status";

#pragma mark - OTHER
static NSString * const WOCBuyingStoryboard = @"buyDash";
static NSString * const WOCsellingStoryboard = @"wocSell";

///*
 static NSString * const WOCPublisherId = @"46";
 static NSString * const WOCCurrency = @"PIV";
 static NSString * const WOCCurrencySpecial = @"ⱣIV";
 static NSString * const WOCCurrencyMinorSpecial = @"µⱣiv";
 static NSString * const WOCCurrencySymbol = @"Ᵽ";
 static NSString * const WOCCurrencySymbolMinor = @"µⱣiv";
 static NSString * const WOCCryptoCurrencySmall = @"uPiv";
 static NSString * const WOCCryptoCurrency = @"PIVX";
 #define WOCTHEMECOLOR [UIColor colorWithRed:85.0/255.0 green:71.0/255.0 blue:108.0/255.0 alpha:1.0]
//*/

#endif
