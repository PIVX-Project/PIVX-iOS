//
//  BRPivxUtils.m
//  pivxwallet
//
//  Created by furszy on 12/16/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

#import "BRPivxUtils.h"
#import "NSString+Dash.h"
#import "NSString+Bitcoin.h"

@implementation BRPivxUtils

+ (BOOL)isValidAdress:(NSString*)address{
    
    if (address.length > 35) return NO;
    
    NSData *d = address.base58checkToData;
    
    if (d.length != 21) return NO;
    
    uint8_t version = *(const uint8_t *)d.bytes;
    
#if DASH_TESTNET
    return (version == DASH_PUBKEY_ADDRESS_TEST || version == DASH_SCRIPT_ADDRESS_TEST) ? YES : NO;
#endif
    
    return (version == DASH_PUBKEY_ADDRESS || version == DASH_SCRIPT_ADDRESS) ? YES : NO;
}

@end
