//
//  APIManager.h
//  Wallofcoins
//
//  Created by Genitrust on 01/12/18.
//  Copyright (c) 2018 Wallofcoins. All rights reserved.
//

#import "WOCConstants.h"

@interface APIManager : NSObject

@property (nonatomic, strong) NSDate *lastMarketInfoCheck;

+ (instancetype)sharedInstance;

- (void)testAPI;
- (void)getAvailablePaymentCenters:(void (^)(id responseDict, NSError *error))completionBlock ;
- (void)makeAPIRequestWithURL:(NSString*)apiURL methord:(NSString*)httpMethord parameter:(id)parameter header:(NSDictionary*)header andCompletionBlock:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)discoverInfo:(NSDictionary*)params response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)discoveryInputs:(NSString*)dicoverId response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)createHold:(NSDictionary*)params response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)captureHold:(NSDictionary*)params holdId:(NSString *)holdId response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)confirmDeposit:(NSString *)orderId response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)cancelOrder:(NSString *)orderId response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)getOrders:(NSDictionary*)params response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)authorizeDevice:(NSDictionary*)params phone:(NSString*)phoneNo response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)login:(NSDictionary*)params phone:(NSString*)phoneNo response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)signOut:(NSDictionary*)params phone:(NSString*)phoneNo response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)getDevice:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)registerDevice:(NSDictionary*)params response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)deleteHold:(NSString*)holdId response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)getHold:(void (^)(id responseDict, NSError *error))completionBlock;

- (void)getIncomingOrders:(NSDictionary*)params response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)confirmDepositForIncomingOrdersId:(NSString*)orderId response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)invalidateDepositForIncomingOrdersId:(NSString*)orderId response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)registerUser:(NSDictionary*)params response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)resetPassword:(NSDictionary*)params phone:(NSString*)phoneNo response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)createAd:(NSDictionary*)params response:(void (^)(id responseDict, NSError *error))completionBlock;

- (void)getAllAds:(NSDictionary*)params response:(void (^)(id responseDict, NSError *error))completionBlock;
- (void)getDetailFromADId:(NSString*)AdvertiseId response:(void (^)(id responseDict, NSError *error))completionBlock;
@end
