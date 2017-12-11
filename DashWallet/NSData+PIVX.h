//
//  NSData+PIVX.h
//  dashwallet
//
//  Created by furszy on 12/11/17.
//  Copyright © 2017 Aaron Voisine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IntTypes.h"

@interface NSData_PIVX : NSData

+ (NSData *)dataFromHexString:(NSString *)string;
@end

