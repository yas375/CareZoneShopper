//
//  CZSNetworkEngine.h
//  CareZoneShopper
//
//  Created by Victor Ilyukevich on 16.10.12.
//  Copyright (c) 2012 Victor Ilyukevich. All rights reserved.
//

#import "MKNetworkEngine.h"

#pragma mark - Responses
typedef void (^CZSListResponseBlock)(NSArray *);


@interface CZSNetworkEngine : MKNetworkEngine

+ (CZSNetworkEngine *)sharedEngine;

- (MKNetworkOperation *)listOfItemsWithCompletion:(CZSListResponseBlock)completionBlock
                                          onError:(MKNKErrorBlock)errorBlock;

@end
